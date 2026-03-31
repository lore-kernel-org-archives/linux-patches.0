Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5F9C317166;
	Tue, 31 Mar 2026 16:46:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975582; cv=none; b=pM/EeiBIcmy75F/S1TqO/7/wWMcTHppWxW6jP963FuuiAkKXxijKRPaCdkZxmCoFvM8NMUDAWb7YdRJlbSYorGVsT6OaAH9sAHPOzwxcwvaCKRqvXfZxA5hm8liFAMqRQpeeBb/MEkres8Es9gWzLfZqL+6D+TYiPw4QM9vB+jg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975582; c=relaxed/simple;
	bh=zWmfolDiKaRDoB0/qYyJN1mJbKSfdpYycPXtgaZVKr0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sm9NNuPEtH9GHHUoWj2YCVVROwxWTyIWHAjXHC21RlxFwQYc2W5fLrg2Tczw5ew0K2KsjtoEAsPfb3rZr524qBF96Dw1nBm1ELKFBfZAhhT2ub7a36aio7gwLJq7BbQ3LtFfYkLFmj2qwW7tJDYLKhQ3/rR8Z6Tp2Dg2b3UZL2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jov641W1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jov641W1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DD3CC19423;
	Tue, 31 Mar 2026 16:46:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975582;
	bh=zWmfolDiKaRDoB0/qYyJN1mJbKSfdpYycPXtgaZVKr0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jov641W1bg1mqFRwk48iZ6BOZvobLhCTXSM51mU8N8YAvsj6upuhizlxTSYy6FDeD
	 ZmcFCHrJVzWJnWA3ysnJ/FCHEPjQrIDAY6nyPwIBLSkSWOD6LJEa9iYZ9XE2C94y1x
	 vu6XOJfiI1srQKCI0ar2vLm+tWwymeVztbjJX5Zk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hao-Yu Yang <naup96721@gmail.com>,
	Eric Dumazet <edumazet@google.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 338/342] futex: Fix UaF between futex_key_to_node_opt() and vma_replace_policy()
Date: Tue, 31 Mar 2026 18:22:51 +0200
Message-ID: <20260331161811.337733893@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hao-Yu Yang <naup96721@gmail.com>

[ Upstream commit 190a8c48ff623c3d67cb295b4536a660db2012aa ]

During futex_key_to_node_opt() execution, vma->vm_policy is read under
speculative mmap lock and RCU. Concurrently, mbind() may call
vma_replace_policy() which frees the old mempolicy immediately via
kmem_cache_free().

This creates a race where __futex_key_to_node() dereferences a freed
mempolicy pointer, causing a use-after-free read of mpol->mode.

[  151.412631] BUG: KASAN: slab-use-after-free in __futex_key_to_node (kernel/futex/core.c:349)
[  151.414046] Read of size 2 at addr ffff888001c49634 by task e/87

[  151.415969] Call Trace:

[  151.416732]  __asan_load2 (mm/kasan/generic.c:271)
[  151.416777]  __futex_key_to_node (kernel/futex/core.c:349)
[  151.416822]  get_futex_key (kernel/futex/core.c:374 kernel/futex/core.c:386 kernel/futex/core.c:593)

Fix by adding rcu to __mpol_put().

Fixes: c042c505210d ("futex: Implement FUTEX2_MPOL")
Reported-by: Hao-Yu Yang <naup96721@gmail.com>
Suggested-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Hao-Yu Yang <naup96721@gmail.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Link: https://patch.msgid.link/20260324174418.GB1850007@noisy.programming.kicks-ass.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/mempolicy.h |  1 +
 kernel/futex/core.c       |  2 +-
 mm/mempolicy.c            | 10 ++++++++--
 3 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/include/linux/mempolicy.h b/include/linux/mempolicy.h
index 0fe96f3ab3ef0..65c732d440d2f 100644
--- a/include/linux/mempolicy.h
+++ b/include/linux/mempolicy.h
@@ -55,6 +55,7 @@ struct mempolicy {
 		nodemask_t cpuset_mems_allowed;	/* relative to these nodes */
 		nodemask_t user_nodemask;	/* nodemask passed by user */
 	} w;
+	struct rcu_head rcu;
 };
 
 /*
diff --git a/kernel/futex/core.c b/kernel/futex/core.c
index cf7e610eac429..31e83a09789e0 100644
--- a/kernel/futex/core.c
+++ b/kernel/futex/core.c
@@ -342,7 +342,7 @@ static int __futex_key_to_node(struct mm_struct *mm, unsigned long addr)
 	if (!vma)
 		return FUTEX_NO_NODE;
 
-	mpol = vma_policy(vma);
+	mpol = READ_ONCE(vma->vm_policy);
 	if (!mpol)
 		return FUTEX_NO_NODE;
 
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 68a98ba578821..74ebf38a7db1a 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -488,7 +488,13 @@ void __mpol_put(struct mempolicy *pol)
 {
 	if (!atomic_dec_and_test(&pol->refcnt))
 		return;
-	kmem_cache_free(policy_cache, pol);
+	/*
+	 * Required to allow mmap_lock_speculative*() access, see for example
+	 * futex_key_to_node_opt(). All accesses are serialized by mmap_lock,
+	 * however the speculative lock section unbound by the normal lock
+	 * boundaries, requiring RCU freeing.
+	 */
+	kfree_rcu(pol, rcu);
 }
 EXPORT_SYMBOL_FOR_MODULES(__mpol_put, "kvm");
 
@@ -1021,7 +1027,7 @@ static int vma_replace_policy(struct vm_area_struct *vma,
 	}
 
 	old = vma->vm_policy;
-	vma->vm_policy = new; /* protected by mmap_lock */
+	WRITE_ONCE(vma->vm_policy, new); /* protected by mmap_lock */
 	mpol_put(old);
 
 	return 0;
-- 
2.53.0



