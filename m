Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DC571A6186;
	Tue, 30 Jul 2024 16:25:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356749; cv=none; b=k3jkSxjlt5dxU5S9CF3uHWVLPLH0Oqmbxl7gOK8gJv/rymU5onZmZHQlLPDwtDKqpV1/iBr1O0DemZ1DpTxoB5VTAnU+qONPDjik9Qk7oL95jJPKMnkpweF6gE2l1SjQzGzL4fj6Ujn/cIXmqyIjNOyJy/zs0cRMa6batb/Ay3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356749; c=relaxed/simple;
	bh=JH4s/yhWp/+98X7XYRD9o6f+b8QAekrFQhtvde//lrE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FHSkL8XTVW1QvleZNczTSsQN37L01/XiyD9Eybg/bGaGGHW/s5Ykqu0FC4IPTsStG05hwoJSyzcLw1qUBSfJP8qBdhKOe48Mb6JXZtMjnrqbjfvGY1CM13ZTnhEsoQHESipzNtsbfRVhcEXV7ab6mArTIBMx4NBGUDQWQUUWSso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hTTtjxn6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hTTtjxn6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC4DFC32782;
	Tue, 30 Jul 2024 16:25:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356749;
	bh=JH4s/yhWp/+98X7XYRD9o6f+b8QAekrFQhtvde//lrE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hTTtjxn65PrDTPxlxjhPpaIXqy7IEvZhOfbQocX96T2fFOvZYUR8GIIP9Lu9wBIP0
	 wEwgSF3oSGiZ6hObVxyMXmJkIlb+AjsukGBlAjnjc6pCb/MhKA9OtpjeHNpzIiEU0O
	 28ocfa3omGPVs1dBdv/+o8TqKG+Xs/Lr2v635lgc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Ankur Arora <ankur.a.arora@oracle.com>,
	Chen Yu <yu.c.chen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 183/809] sched/core: Drop spinlocks on contention iff kernel is preemptible
Date: Tue, 30 Jul 2024 17:40:59 +0200
Message-ID: <20240730151731.837995462@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit c793a62823d1ce8f70d9cfc7803e3ea436277cda ]

Use preempt_model_preemptible() to detect a preemptible kernel when
deciding whether or not to reschedule in order to drop a contended
spinlock or rwlock.  Because PREEMPT_DYNAMIC selects PREEMPTION, kernels
built with PREEMPT_DYNAMIC=y will yield contended locks even if the live
preemption model is "none" or "voluntary".  In short, make kernels with
dynamically selected models behave the same as kernels with statically
selected models.

Somewhat counter-intuitively, NOT yielding a lock can provide better
latency for the relevant tasks/processes.  E.g. KVM x86's mmu_lock, a
rwlock, is often contended between an invalidation event (takes mmu_lock
for write) and a vCPU servicing a guest page fault (takes mmu_lock for
read).  For _some_ setups, letting the invalidation task complete even
if there is mmu_lock contention provides lower latency for *all* tasks,
i.e. the invalidation completes sooner *and* the vCPU services the guest
page fault sooner.

But even KVM's mmu_lock behavior isn't uniform, e.g. the "best" behavior
can vary depending on the host VMM, the guest workload, the number of
vCPUs, the number of pCPUs in the host, why there is lock contention, etc.

In other words, simply deleting the CONFIG_PREEMPTION guard (or doing the
opposite and removing contention yielding entirely) needs to come with a
big pile of data proving that changing the status quo is a net positive.

Opportunistically document this side effect of preempt=full, as yielding
contended spinlocks can have significant, user-visible impact.

Fixes: c597bfddc9e9 ("sched: Provide Kconfig support for default dynamic preempt mode")
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Ankur Arora <ankur.a.arora@oracle.com>
Reviewed-by: Chen Yu <yu.c.chen@intel.com>
Link: https://lore.kernel.org/kvm/ef81ff36-64bb-4cfe-ae9b-e3acf47bff24@proxmox.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/admin-guide/kernel-parameters.txt |  4 +++-
 include/linux/spinlock.h                        | 14 ++++++--------
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 27ec49af1bf27..2569e7f19b476 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -4749,7 +4749,9 @@
 			none - Limited to cond_resched() calls
 			voluntary - Limited to cond_resched() and might_sleep() calls
 			full - Any section that isn't explicitly preempt disabled
-			       can be preempted anytime.
+			       can be preempted anytime.  Tasks will also yield
+			       contended spinlocks (if the critical section isn't
+			       explicitly preempt disabled beyond the lock itself).
 
 	print-fatal-signals=
 			[KNL] debug: print fatal signals
diff --git a/include/linux/spinlock.h b/include/linux/spinlock.h
index 3fcd20de6ca88..63dd8cf3c3c2b 100644
--- a/include/linux/spinlock.h
+++ b/include/linux/spinlock.h
@@ -462,11 +462,10 @@ static __always_inline int spin_is_contended(spinlock_t *lock)
  */
 static inline int spin_needbreak(spinlock_t *lock)
 {
-#ifdef CONFIG_PREEMPTION
+	if (!preempt_model_preemptible())
+		return 0;
+
 	return spin_is_contended(lock);
-#else
-	return 0;
-#endif
 }
 
 /*
@@ -479,11 +478,10 @@ static inline int spin_needbreak(spinlock_t *lock)
  */
 static inline int rwlock_needbreak(rwlock_t *lock)
 {
-#ifdef CONFIG_PREEMPTION
+	if (!preempt_model_preemptible())
+		return 0;
+
 	return rwlock_is_contended(lock);
-#else
-	return 0;
-#endif
 }
 
 /*
-- 
2.43.0



