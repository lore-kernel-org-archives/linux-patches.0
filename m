Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 657E21D9A50;
	Wed, 19 Feb 2025 08:33:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954004; cv=none; b=odCCw+5MFZfuPcrAD5LyqPIrtuiQbWbGiRoxx+jO1tEAI3bLzs7vX8rnSbdVnLPOfEPMEY9djocwsiMFsMbtNFhvWRQfD29cIW3j7VOAzPxLrlsSrhv2M3X4lU7gr6sl7AcOfcc1/KN8yhenbNqitda9HbnECj+FlR2PgHI05oc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954004; c=relaxed/simple;
	bh=VC84BO/vcrlJwSS1ibpLXAwWvF4gPcBo7qtdCaylbNs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EprwR9iLN7eX6v9+MBhaLFzl+gJVnagto+Rw2Z/ClSrpsIPjZuJntRLq2bnZZ9pO0fm55pUv246kPh6281io8SaLeJIDLwXVXT+V40cOaqxculA8+YSLzb0ysF7QaznaDx+4nvbqocPpS0VuKo5tTXOPRiLTzbye3SCLBJmMrZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hyGS14Bn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hyGS14Bn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA2A6C4CEE6;
	Wed, 19 Feb 2025 08:33:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954004;
	bh=VC84BO/vcrlJwSS1ibpLXAwWvF4gPcBo7qtdCaylbNs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hyGS14Bn6RXOxZasAyovoGlTjtO2QQQMhH5wofvcpS3did0SEzDfR9OYOPLINz9OH
	 C35mqNzNUipGoZHbUZ1AoCcT0tYnSbGCavKvo5IqCtM8omfw4bj9+BveV6JZKt7rC5
	 CHh5F+2iaNZlpC+e/iXPwa0ZeB9Ixj+M8KBsenqs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuyi Zhou <zhouchuyi@bytedance.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 064/274] sched_ext: Fix the incorrect bpf_list kfunc API in common.bpf.h.
Date: Wed, 19 Feb 2025 09:25:18 +0100
Message-ID: <20250219082612.128534729@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuyi Zhou <zhouchuyi@bytedance.com>

[ Upstream commit 2e2006c91c842c551521434466f9b4324719c9a7 ]

Now BPF only supports bpf_list_push_{front,back}_impl kfunc, not bpf_list_
push_{front,back}.

This patch fix this issue. Without this patch, if we use bpf_list kfunc
in scx, the BPF verifier would complain:

libbpf: extern (func ksym) 'bpf_list_push_back': not found in kernel or
module BTFs
libbpf: failed to load object 'scx_foo'
libbpf: failed to load BPF skeleton 'scx_foo': -EINVAL

With this patch, the bpf list kfunc will work as expected.

Signed-off-by: Chuyi Zhou <zhouchuyi@bytedance.com>
Fixes: 2a52ca7c98960 ("sched_ext: Add scx_simple and scx_example_qmap example schedulers")
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/sched_ext/include/scx/common.bpf.h | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/tools/sched_ext/include/scx/common.bpf.h b/tools/sched_ext/include/scx/common.bpf.h
index 625f5b046776c..9fa64b053ba91 100644
--- a/tools/sched_ext/include/scx/common.bpf.h
+++ b/tools/sched_ext/include/scx/common.bpf.h
@@ -251,8 +251,16 @@ void bpf_obj_drop_impl(void *kptr, void *meta) __ksym;
 #define bpf_obj_new(type) ((type *)bpf_obj_new_impl(bpf_core_type_id_local(type), NULL))
 #define bpf_obj_drop(kptr) bpf_obj_drop_impl(kptr, NULL)
 
-void bpf_list_push_front(struct bpf_list_head *head, struct bpf_list_node *node) __ksym;
-void bpf_list_push_back(struct bpf_list_head *head, struct bpf_list_node *node) __ksym;
+int bpf_list_push_front_impl(struct bpf_list_head *head,
+				    struct bpf_list_node *node,
+				    void *meta, __u64 off) __ksym;
+#define bpf_list_push_front(head, node) bpf_list_push_front_impl(head, node, NULL, 0)
+
+int bpf_list_push_back_impl(struct bpf_list_head *head,
+				   struct bpf_list_node *node,
+				   void *meta, __u64 off) __ksym;
+#define bpf_list_push_back(head, node) bpf_list_push_back_impl(head, node, NULL, 0)
+
 struct bpf_list_node *bpf_list_pop_front(struct bpf_list_head *head) __ksym;
 struct bpf_list_node *bpf_list_pop_back(struct bpf_list_head *head) __ksym;
 struct bpf_rb_node *bpf_rbtree_remove(struct bpf_rb_root *root,
-- 
2.39.5



