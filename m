Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCA021170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:00:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C476C433C7;
	Mon, 11 Sep 2023 14:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694440819;
	bh=nI+/mFhPW7+MpvqvY6aiPUN3MWGBSiKxgFCA6dqyc78=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m8jY+XQfrZfnMHvpY3MWnAP9zB3suPWxDfh14ubvh887y9ZRKKNtLsEmBMOrL+U1J
	 5TiIbUwpdhzQl5iJRHKRQXRnhbBQVENvjZ4ipSDAe4OdjwToBMf7EOORLOvTfErt9I
	 Wh8YOd4YcY7c6EndMIuhBR/pE400aGQqz4DUl898=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 169/739] bpf: Fix check_func_arg_reg_off bug for graph root/node
Date: Mon, 11 Sep 2023 15:39:28 +0200
Message-ID: <20230911134655.905699940@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kumar Kartikeya Dwivedi <memxor@gmail.com>

[ Upstream commit 6785b2edf48c6b1c3ea61fe3b0d2e02b8fbf90c0 ]

The commit being fixed introduced a hunk into check_func_arg_reg_off
that bypasses reg->off == 0 enforcement when offset points to a graph
node or root. This might possibly be done for treating bpf_rbtree_remove
and others as KF_RELEASE and then later check correct reg->off in helper
argument checks.

But this is not the case, those helpers are already not KF_RELEASE and
permit non-zero reg->off and verify it later to match the subobject in
BTF type.

However, this logic leads to bpf_obj_drop permitting free of register
arguments with non-zero offset when they point to a graph root or node
within them, which is not ok.

For instance:

struct foo {
	int i;
	int j;
	struct bpf_rb_node node;
};

struct foo *f = bpf_obj_new(typeof(*f));
if (!f) ...
bpf_obj_drop(f); // OK
bpf_obj_drop(&f->i); // still ok from verifier PoV
bpf_obj_drop(&f->node); // Not OK, but permitted right now

Fix this by dropping the whole part of code altogether.

Fixes: 6a3cd3318ff6 ("bpf: Migrate release_on_unlock logic to non-owning ref semantics")
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Link: https://lore.kernel.org/r/20230822175140.1317749-2-memxor@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 903de82dec423..ed49ec0675625 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -7807,17 +7807,6 @@ int check_func_arg_reg_off(struct bpf_verifier_env *env,
 		if (arg_type_is_dynptr(arg_type) && type == PTR_TO_STACK)
 			return 0;
 
-		if ((type_is_ptr_alloc_obj(type) || type_is_non_owning_ref(type)) && reg->off) {
-			if (reg_find_field_offset(reg, reg->off, BPF_GRAPH_NODE_OR_ROOT))
-				return __check_ptr_off_reg(env, reg, regno, true);
-
-			verbose(env, "R%d must have zero offset when passed to release func\n",
-				regno);
-			verbose(env, "No graph node or root found at R%d type:%s off:%d\n", regno,
-				btf_type_name(reg->btf, reg->btf_id), reg->off);
-			return -EINVAL;
-		}
-
 		/* Doing check_ptr_off_reg check for the offset will catch this
 		 * because fixed_off_ok is false, but checking here allows us
 		 * to give the user a better error message.
-- 
2.40.1



