Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DFB14EB860;
	Thu, 17 Sep 2026 15:47:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660042; cv=none; b=I/H+TRdZ0ompBB7NcoZVDGcBmbJidOvsEIXWYclGAm8r2KsSFjnFD+g8tJM9y/Ql8ThflmCanP+NBccEtk9E52a2Flksz60ywVO8EON0359QDE1lqFy39vYKCHHAaUjfmjP1TZGIqpZhLR3Xem5EBnKvTAnDK3/Z+p/8ePqr4BA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660042; c=relaxed/simple;
	bh=UxzPibLZ637m5C3CzyKb9HHxW1fXvD8ALhTz59pN9Ys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LkS2LTp5H/Cdumdasjx+LAdamulu51ZvuIESLOuSE+sUM7JUkj6AXOpJ1GWV2BNVd0wH/NmBsIMczmqy5SicyvC8YNY6091dPYuATjNEuiYTdKOKTe7xhDasjuSPcFQ+reOBGL4spQdHHcGX8QNCpztOXoan/NjYMDCqy+jZEqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iY83fNPY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iY83fNPY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F005C1F000FF;
	Thu, 17 Sep 2026 15:47:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660038;
	bh=4jL3ELlYOHjGT1YMv5Auk6ASlxbXENHk3q3e1rfX7Wc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iY83fNPYxGdT5hbX4rvHP4d8MrDX13p7pokma3hvlzV3b9xwr0wfxq9OeZeOwYU06
	 0jxKQ44sndrXbceyj+nFovlLDJpXRNeYhgoF6jFJsCme9XDvUz/I7FULtEkdtDE9F6
	 1sYt/VMsHnCWgMkICd3/lq9zukJ0wwA10zxdhLcg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Mukesh Kumar Chaurasiya (IBM)" <mkchauras@gmail.com>,
	Aboorva Devarajan <aboorvad@linux.ibm.com>,
	Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
	Amit Machhiwal <amachhiw@linux.ibm.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 410/733] powerpc/entry: Fix double accounting of user time on interrupt entry
Date: Thu, 17 Sep 2026 16:11:58 +0100
Message-ID: <20260917151401.983263241@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aboorva Devarajan <aboorvad@linux.ibm.com>

[ Upstream commit 11ae2e1dc58304a48816fc8ca4afa8f2ef9d1bdf ]

Since the switch to generic entry, an interrupt from user mode
accounts user time twice: once in arch_interrupt_enter_prepare()
and again in arch_enter_from_user_mode(), which irqentry_enter()
invokes for the same interrupt:

	arch_interrupt_enter_prepare()
	  account_cpu_user_entry()		/* first */
	irqentry_enter()
	  arch_enter_from_user_mode()
	    account_cpu_user_entry()		/* second */

The second call charges the same interval again, because
account_cpu_user_entry() accumulates the time spent in user mode
since the last return to user space.

The two calls come from the GENERIC_ENTRY preparation series,
where each step was a no-op on its own. Commit 09a9d3a8499d
("powerpc: introduce arch_enter_from_user_mode") added the hook
with the user-time accounting in it, but nothing called it yet.
Commit 893082ac769b ("powerpc: Prepare for IRQ entry exit")
copied interrupt_enter_prepare() verbatim into entry-common.h as
arch_interrupt_enter_prepare(); that copy was equally unused, as
handlers still called interrupt_enter_prepare().

Commit bee25f97ad24 ("powerpc: Enable GENERIC_ENTRY feature")
made both live. On the syscall side it did the full conversion:
system_call_exception() now accounts once through the hook via
syscall_enter_from_user_mode(), rather than calling
account_cpu_user_entry() directly. On the interrupt side it
switched the handler macros to arch_interrupt_enter_prepare()
followed by irqentry_enter(), which also runs the hook, but the
accounting in arch_interrupt_enter_prepare() was not removed to
match. The double accounting starts with that commit.

With CONFIG_VIRT_CPU_ACCOUNTING_NATIVE=y this roughly doubles the
reported user time of any workload that takes interrupts. The
other accounting modes compile account_cpu_user_entry() to an
empty stub, so they are not affected.

Remove the accounting from arch_interrupt_enter_prepare() and rely
on arch_enter_from_user_mode(), which already runs for both
syscalls and interrupts. The duplicate account_stolen_time() call
is removed the same way.

On a pseries LPAR a busy loop reports 6s user time in 3s elapsed
(~210% CPU) before the fix, and 3s (~105% CPU) after it:

  $ python3 -c 'while True: pass' &
  $ sleep 3; ps -p $! -o etime,time,pcpu

            ELAPSED     TIME  %CPU
  Before      00:03 00:00:06   210
  After       00:03 00:00:03   105

A 50% load reports ~70% usr / 30% idle before the fix, and
~49% usr / 51% idle after it:

  $ taskset -c 6 stress-ng --cpu 1 --cpu-load 50 &
  $ mpstat -P 6 1

            CPU    %usr   %idle
  Before      6   69.74   30.26
  After       6   48.51   50.50

Fixes: bee25f97ad24 ("powerpc: Enable GENERIC_ENTRY feature")
Reviewed-by: Mukesh Kumar Chaurasiya (IBM) <mkchauras@gmail.com>
Signed-off-by: Aboorva Devarajan <aboorvad@linux.ibm.com>
Tested-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Reviewed-by: Amit Machhiwal <amachhiw@linux.ibm.com>
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Reviewed-by: Christophe Leroy (CS GROUP) <chleroy@kernel.org>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20260904025831.3439809-1-aboorvad@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/entry-common.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/powerpc/include/asm/entry-common.h b/arch/powerpc/include/asm/entry-common.h
index 80b07750b531b..8e91489fdf2bb 100644
--- a/arch/powerpc/include/asm/entry-common.h
+++ b/arch/powerpc/include/asm/entry-common.h
@@ -222,8 +222,6 @@ static inline void arch_interrupt_enter_prepare(struct pt_regs *regs)
 
 	if (user_mode(regs)) {
 		kuap_lock();
-		account_cpu_user_entry();
-		account_stolen_time();
 	} else {
 		kuap_save_and_lock(regs);
 		/*
-- 
2.53.0



