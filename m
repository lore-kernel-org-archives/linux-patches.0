Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18670143880;
	Tue, 10 Sep 2024 10:37:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964677; cv=none; b=Cb6UAchc2Caz0QG++y4YZB8Q5azI2ES3h58eVOV1NUpnueq4/TTuuAKD7/rxPDGhbSHKzDHsKuSePC0dThYxQsbn+IlIwQ2vGr8CdEYdQM86gJBulczSOeCV8YYo09KQ0fyvNgFIij192RmjIh11HJr9kdwfnsb8g3EmXUK6ICA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964677; c=relaxed/simple;
	bh=A8B4GVGu5DJB8WLuGzgqOtajWzuN5SvJgxxtrotXr54=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=igS09OfBw4f9B/SJ6vItlidHOdJN7JzP/2DCwn5AyzDGOw7iVhLpFPrG6/mhGRT2uuze3EbZuo4A2Y6cydEuJtm82v10xDM47KRV3eVsKzUcUrhXlXMkDo+2lQbxXJnTo90sM233olH0D2aOaIFDrAPzSqCUgG9OJkWjGUHqglI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PnUg3MTR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PnUg3MTR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91F8EC4CEC3;
	Tue, 10 Sep 2024 10:37:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964677;
	bh=A8B4GVGu5DJB8WLuGzgqOtajWzuN5SvJgxxtrotXr54=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PnUg3MTRcrpw1yFq8iMEFZPuaYmSQHZEKBSbiAwckkoHZjm2o5B949NXvEcsSoINg
	 67jlyPrMYMybMtsDz9v6hSqKpsZZYdVlThlv+OSk+xaiMXFwKmwes1YbKfa4YiZPqW
	 IYbCGjLfZT4QpuAMfSLTMV082dBnFfFB/TDW8lvI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrea Parri <parri.andrea@gmail.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	WangYuli <wangyuli@uniontech.com>
Subject: [PATCH 6.6 263/269] membarrier: riscv: Add full memory barrier in switch_mm()
Date: Tue, 10 Sep 2024 11:34:10 +0200
Message-ID: <20240910092617.125910172@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
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

From: Andrea Parri <parri.andrea@gmail.com>

commit d6cfd1770f20392d7009ae1fdb04733794514fa9 upstream.

The membarrier system call requires a full memory barrier after storing
to rq->curr, before going back to user-space.  The barrier is only
needed when switching between processes: the barrier is implied by
mmdrop() when switching from kernel to userspace, and it's not needed
when switching from userspace to kernel.

Rely on the feature/mechanism ARCH_HAS_MEMBARRIER_CALLBACKS and on the
primitive membarrier_arch_switch_mm(), already adopted by the PowerPC
architecture, to insert the required barrier.

Fixes: fab957c11efe2f ("RISC-V: Atomic and Locking Code")
Signed-off-by: Andrea Parri <parri.andrea@gmail.com>
Reviewed-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Link: https://lore.kernel.org/r/20240131144936.29190-2-parri.andrea@gmail.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: WangYuli <wangyuli@uniontech.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 MAINTAINERS                         |    2 +-
 arch/riscv/Kconfig                  |    1 +
 arch/riscv/include/asm/membarrier.h |   31 +++++++++++++++++++++++++++++++
 arch/riscv/mm/context.c             |    2 ++
 kernel/sched/core.c                 |    5 +++--
 5 files changed, 38 insertions(+), 3 deletions(-)
 create mode 100644 arch/riscv/include/asm/membarrier.h

--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13702,7 +13702,7 @@ M:	Mathieu Desnoyers <mathieu.desnoyers@
 M:	"Paul E. McKenney" <paulmck@kernel.org>
 L:	linux-kernel@vger.kernel.org
 S:	Supported
-F:	arch/powerpc/include/asm/membarrier.h
+F:	arch/*/include/asm/membarrier.h
 F:	include/uapi/linux/membarrier.h
 F:	kernel/sched/membarrier.c
 
--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -27,6 +27,7 @@ config RISCV
 	select ARCH_HAS_GCOV_PROFILE_ALL
 	select ARCH_HAS_GIGANTIC_PAGE
 	select ARCH_HAS_KCOV
+	select ARCH_HAS_MEMBARRIER_CALLBACKS
 	select ARCH_HAS_MMIOWB
 	select ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE
 	select ARCH_HAS_PMEM_API
--- /dev/null
+++ b/arch/riscv/include/asm/membarrier.h
@@ -0,0 +1,31 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef _ASM_RISCV_MEMBARRIER_H
+#define _ASM_RISCV_MEMBARRIER_H
+
+static inline void membarrier_arch_switch_mm(struct mm_struct *prev,
+					     struct mm_struct *next,
+					     struct task_struct *tsk)
+{
+	/*
+	 * Only need the full barrier when switching between processes.
+	 * Barrier when switching from kernel to userspace is not
+	 * required here, given that it is implied by mmdrop(). Barrier
+	 * when switching from userspace to kernel is not needed after
+	 * store to rq->curr.
+	 */
+	if (IS_ENABLED(CONFIG_SMP) &&
+	    likely(!(atomic_read(&next->membarrier_state) &
+		     (MEMBARRIER_STATE_PRIVATE_EXPEDITED |
+		      MEMBARRIER_STATE_GLOBAL_EXPEDITED)) || !prev))
+		return;
+
+	/*
+	 * The membarrier system call requires a full memory barrier
+	 * after storing to rq->curr, before going back to user-space.
+	 * Matches a full barrier in the proximity of the membarrier
+	 * system call entry.
+	 */
+	smp_mb();
+}
+
+#endif /* _ASM_RISCV_MEMBARRIER_H */
--- a/arch/riscv/mm/context.c
+++ b/arch/riscv/mm/context.c
@@ -323,6 +323,8 @@ void switch_mm(struct mm_struct *prev, s
 	if (unlikely(prev == next))
 		return;
 
+	membarrier_arch_switch_mm(prev, next, task);
+
 	/*
 	 * Mark the current MM context as inactive, and the next as
 	 * active.  This is at least used by the icache flushing
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6679,8 +6679,9 @@ static void __sched notrace __schedule(u
 		 *
 		 * Here are the schemes providing that barrier on the
 		 * various architectures:
-		 * - mm ? switch_mm() : mmdrop() for x86, s390, sparc, PowerPC.
-		 *   switch_mm() rely on membarrier_arch_switch_mm() on PowerPC.
+		 * - mm ? switch_mm() : mmdrop() for x86, s390, sparc, PowerPC,
+		 *   RISC-V.  switch_mm() relies on membarrier_arch_switch_mm()
+		 *   on PowerPC and on RISC-V.
 		 * - finish_lock_switch() for weakly-ordered
 		 *   architectures where spin_unlock is a full barrier,
 		 * - switch_to() for arm64 (weakly-ordered, spin_unlock


