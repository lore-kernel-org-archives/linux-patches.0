Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C78062D8771;
	Tue, 31 Mar 2026 17:10:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774977014; cv=none; b=jN4EDq/R7scXiktNwDSbVcAgp4PiLGX6eN3IJB3x+L0Hz6JFyT6l3W9Q0GDllA92iz6RXfJlYPqHsDmvoCD5cQOUz1lwWdHsF0D6r9VQ2v27/tTTsLfHaYRnsFDOyxjlSkhh4gT0kiVgv0GO2OLjGvfILDsFo9lF0+/9BGLSw/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774977014; c=relaxed/simple;
	bh=dCPAkk9dWdnT2pLsooDwFLKXpTfoWcc0t0jUz0inFXA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HIM9oSaAcj74NcjIDI6T+212HD7EaHHkHcULs9FvlqmgjXTOgdXQvGhLNWbiArIUEMZL/dbw1wTHxdi9Ogq1kLhFWf6QpZAkF1mAxN80hG1Igvw1blIUZ024hAWoHrurxrywBMNFylUOEPh/Sw6CwlEQEx50H36AfI6MkUQsCi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ru6swv3n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ru6swv3n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CCB9C19423;
	Tue, 31 Mar 2026 17:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774977014;
	bh=dCPAkk9dWdnT2pLsooDwFLKXpTfoWcc0t0jUz0inFXA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ru6swv3nRZrHn02QB1LBktxmi+IS/BGlGdxtpQAyPXHSiReStGXgU80T0ak62mzJm
	 kJs+aKweB0TuZEZVASyLNnIrSOOe33I5t1Q8e0ZOD38bPBRNFW80wDEij2HGn8chat
	 ThEttdMLJPW+OTUug6bfpTkpcfGyJ3e8Htw+Ars8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hao-Yu Yang <naup96721@gmail.com>,
	Eric Dumazet <edumazet@google.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 308/309] futex: Fix UaF between futex_key_to_node_opt() and vma_replace_policy()
Date: Tue, 31 Mar 2026 18:23:31 +0200
Message-ID: <20260331161804.899860648@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
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
index 2e77a6e5c8657..9e7dea6fc0ccd 100644
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
index eb83cff7db8c3..94327574fbbbb 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -485,7 +485,13 @@ void __mpol_put(struct mempolicy *pol)
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
 
 static void mpol_rebind_default(struct mempolicy *pol, const nodemask_t *nodes)
@@ -951,7 +957,7 @@ static int vma_replace_policy(struct vm_area_struct *vma,
 	}
 
 	old = vma->vm_policy;
-	vma->vm_policy = new; /* protected by mmap_lock */
+	WRITE_ONCE(vma->vm_policy, new); /* protected by mmap_lock */
 	mpol_put(old);
 
 	return 0;
-- 
2.53.0



