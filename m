Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B748D4DA9D7;
	Tue, 13 Oct 2026 12:24:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894300; cv=none; b=ojcdFXuPXqrAEzWOAjNrn+NmlELq6kI5dKncYXFzUqL2aZmJJ1KP4jQnVElnzEaqb/7FJ7dEbKZDYw3xhv9CgTao6A0KVAOlVY30TyLyIkznDJD1m8LIVEnbZk0o4rVo06TJt63Tii+1lX6V1hiIwW4jJgugq8jPl+FdUf6CMuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894300; c=relaxed/simple;
	bh=mqJO4H9wWp1L4/6HPmyqGfyQ8as3iAVcl/TM5Qg9GaE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n0huqzoTO6oQEn2bRJgXRqZwaRfkMTUtH3OlRVByB1MBMSXWyMauclVwMGz7T52M5+o+/vahYdaRE9DbMYJQAYw4yqv7uIseze3QIIH+Zm0T3szavU8MO1AKDybjJTwKxUyivhjJi6443xk7j9gCfZ8W4QDRKni50gz4dUYdk2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JsOafO31; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JsOafO31"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D3FF1F000FF;
	Tue, 13 Oct 2026 12:24:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894299;
	bh=mgO4wTAgq106X8IIVJ0F4pBupy+j8qBEZNuC0xDlPGQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JsOafO31GLP327XinINZ1kvGFyzqv4jd8gSQs2BRxgaZOMWMi9PTOhXkt1o+Jj9aT
	 6LiBj8m3mpuQH6ga68WiUVeGolBMGBkp2tyEfQFlqfse0hFmV/zOQtzTFvIjzDYNhk
	 rWBqCBZeXZ0fuyNeTPiBcOqNk39OK9zXaNMWTqXs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Carlini <npc@anthropic.com>,
	Ning Ding <dingning04@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 513/621] bpf: Keep refcount_acquire nullable for borrowed RCU kptrs
Date: Tue, 13 Oct 2026 13:38:28 +0200
Message-ID: <20261013112933.000665585@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ning Ding <dingning04@gmail.com>

[ Upstream commit dc36739e5cc9f60485418a910b42bc95339218d2 ]

bpf_refcount_acquire() is fallible for a borrowed reference because the
object may have reached a zero refcount. The verifier therefore keeps
KF_RET_NULL on the return value unless the argument is an owning reference.

An RCU-protected load of a local kptr is marked MEM_ALLOC, but it only
receives NON_OWN_REF when the pointee contains a graph node. A refcounted
object without a graph node consequently looks like an owning reference
even though the loaded register has no acquired reference state. If the
program drops the last real reference while remaining in the RCU critical
section, refcount_inc_not_zero() returns NULL while the verifier treats the
result as non-NULL.

Only classify the argument as owning when it is backed by a verifier-tracked
reference. This retains the non-NULL return for pointers from bpf_obj_new(),
bpf_kptr_xchg(), or an earlier successful acquisition, while requiring a
NULL check for borrowed RCU kptrs.

Fixes: 1b12171533a9 ("bpf: Mark direct ld of stashed bpf_{rb,list}_node as non-owning ref")
Reported-by: Nicholas Carlini <npc@anthropic.com>
Suggested-by: Nicholas Carlini <npc@anthropic.com>
Signed-off-by: Ning Ding <dingning04@gmail.com>
[ kkd: Rewrote commit log ]
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Link: https://lore.kernel.org/r/20260904084325.52250-4-memxor@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index e887b6cc2cbae..9ed6a1298a8ec 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -13812,7 +13812,7 @@ static int check_kfunc_args(struct bpf_verifier_env *env, struct bpf_kfunc_call_
 				verbose(env, "arg#%d is neither owning or non-owning ref\n", i);
 				return -EINVAL;
 			}
-			if (!type_is_non_owning_ref(reg->type))
+			if (!type_is_non_owning_ref(reg->type) && reg->ref_obj_id)
 				meta->arg_owning_ref = true;
 
 			rec = reg_btf_record(reg);
-- 
2.53.0



