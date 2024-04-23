Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AD8A148FFE;
	Tue, 23 Apr 2024 21:44:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908644; cv=none; b=PzGdigAf0blXmgglIwesPNy4MTs5GhPeyWl9M1TSHzvyd2H2N0ohkk2o3hU1fMSZ0jB3rz4VD4Ec+RnaIODJOmdqG0gv7dG15QpWA5Q42CAhZRaSCMhQ9vLbq80eBJz4NzFWT23ZCZaKo7NvchC2c2KDKzvchkkFsWAukLiVp9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908644; c=relaxed/simple;
	bh=Um5eHGoHogJmkCmxEJy5Zv+R8RiPE1jyrm6MFGiMc/8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tZnUm6ymBI3HzPuQj3Cic46TyiGK9+vJsMdzTj5XJ8N0gSFdcwtHo5xQLLTtUH99RrdXarNZ/ODwFT7KjO5jBVmx0F7HqnRULxUYV5idxi4hnq0fRuheh18rFyVDYMum/w0aHuicGejU+tWJcILErpK5CLSSzzK5O+L4bYklEC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pTXGozjv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pTXGozjv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2B89C32781;
	Tue, 23 Apr 2024 21:44:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908643;
	bh=Um5eHGoHogJmkCmxEJy5Zv+R8RiPE1jyrm6MFGiMc/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pTXGozjvAtTBEwk4kkeNpS1OjPuDon3IMwhifyiic/7KmJBs41KOe41pdJWUdYrsS
	 KaOjNBAVnQg/gMbKNbMPm5eTRyAze0HKwgy4UEvc44coYlnTjKk0sXMSyeFRyorx3V
	 98El68dEDeRe3jKgOB+rLmnoKGOOkz9K2SBDSpGI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"levi.yun" <yeoreum.yun@arm.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Ingo Molnar <mingo@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Dave Hansen <dave.hansen@linux.intel.com>
Subject: [PATCH 6.6 128/158] sched: Add missing memory barrier in switch_mm_cid
Date: Tue, 23 Apr 2024 14:39:25 -0700
Message-ID: <20240423213859.877247363@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.696477232@linuxfoundation.org>
References: <20240423213855.696477232@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

commit fe90f3967bdb3e13f133e5f44025e15f943a99c5 upstream.

Many architectures' switch_mm() (e.g. arm64) do not have an smp_mb()
which the core scheduler code has depended upon since commit:

    commit 223baf9d17f25 ("sched: Fix performance regression introduced by mm_cid")

If switch_mm() doesn't call smp_mb(), sched_mm_cid_remote_clear() can
unset the actively used cid when it fails to observe active task after it
sets lazy_put.

There *is* a memory barrier between storing to rq->curr and _return to
userspace_ (as required by membarrier), but the rseq mm_cid has stricter
requirements: the barrier needs to be issued between store to rq->curr
and switch_mm_cid(), which happens earlier than:

  - spin_unlock(),
  - switch_to().

So it's fine when the architecture switch_mm() happens to have that
barrier already, but less so when the architecture only provides the
full barrier in switch_to() or spin_unlock().

It is a bug in the rseq switch_mm_cid() implementation. All architectures
that don't have memory barriers in switch_mm(), but rather have the full
barrier either in finish_lock_switch() or switch_to() have them too late
for the needs of switch_mm_cid().

Introduce a new smp_mb__after_switch_mm(), defined as smp_mb() in the
generic barrier.h header, and use it in switch_mm_cid() for scheduler
transitions where switch_mm() is expected to provide a memory barrier.

Architectures can override smp_mb__after_switch_mm() if their
switch_mm() implementation provides an implicit memory barrier.
Override it with a no-op on x86 which implicitly provide this memory
barrier by writing to CR3.

Fixes: 223baf9d17f2 ("sched: Fix performance regression introduced by mm_cid")
Reported-by: levi.yun <yeoreum.yun@arm.com>
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com> # for arm64
Acked-by: Dave Hansen <dave.hansen@linux.intel.com> # for x86
Cc: <stable@vger.kernel.org> # 6.4.x
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: https://lore.kernel.org/r/20240415152114.59122-2-mathieu.desnoyers@efficios.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/barrier.h |    3 +++
 include/asm-generic/barrier.h  |    8 ++++++++
 kernel/sched/sched.h           |   20 ++++++++++++++------
 3 files changed, 25 insertions(+), 6 deletions(-)

--- a/arch/x86/include/asm/barrier.h
+++ b/arch/x86/include/asm/barrier.h
@@ -79,6 +79,9 @@ do {									\
 #define __smp_mb__before_atomic()	do { } while (0)
 #define __smp_mb__after_atomic()	do { } while (0)
 
+/* Writing to CR3 provides a full memory barrier in switch_mm(). */
+#define smp_mb__after_switch_mm()	do { } while (0)
+
 #include <asm-generic/barrier.h>
 
 #endif /* _ASM_X86_BARRIER_H */
--- a/include/asm-generic/barrier.h
+++ b/include/asm-generic/barrier.h
@@ -296,5 +296,13 @@ do {									\
 #define io_stop_wc() do { } while (0)
 #endif
 
+/*
+ * Architectures that guarantee an implicit smp_mb() in switch_mm()
+ * can override smp_mb__after_switch_mm.
+ */
+#ifndef smp_mb__after_switch_mm
+# define smp_mb__after_switch_mm()	smp_mb()
+#endif
+
 #endif /* !__ASSEMBLY__ */
 #endif /* __ASM_GENERIC_BARRIER_H */
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -88,6 +88,8 @@
 # include <asm/paravirt_api_clock.h>
 #endif
 
+#include <asm/barrier.h>
+
 #include "cpupri.h"
 #include "cpudeadline.h"
 
@@ -3500,13 +3502,19 @@ static inline void switch_mm_cid(struct
 		 * between rq->curr store and load of {prev,next}->mm->pcpu_cid[cpu].
 		 * Provide it here.
 		 */
-		if (!prev->mm)                          // from kernel
+		if (!prev->mm) {                        // from kernel
 			smp_mb();
-		/*
-		 * user -> user transition guarantees a memory barrier through
-		 * switch_mm() when current->mm changes. If current->mm is
-		 * unchanged, no barrier is needed.
-		 */
+		} else {				// from user
+			/*
+			 * user->user transition relies on an implicit
+			 * memory barrier in switch_mm() when
+			 * current->mm changes. If the architecture
+			 * switch_mm() does not have an implicit memory
+			 * barrier, it is emitted here.  If current->mm
+			 * is unchanged, no barrier is needed.
+			 */
+			smp_mb__after_switch_mm();
+		}
 	}
 	if (prev->mm_cid_active) {
 		mm_cid_snapshot_time(rq, prev->mm);


