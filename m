Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5621582D98;
	Mon,  6 Jan 2025 15:28:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177332; cv=none; b=h4cLz+vEvXTkF3iOZjcrZc8DY3EWcHkCNhX2QeDgTmvDA/fuhW8T417qsqcEdWpHaHp27gZS0rMVYCih6a76Aao0Qmw5Q6XZibKZsNwnD35qi2tUr64TJf1BpGVV76+q8PHKjsd9LcGzd+WT1vdrvLDaYxITkKbPk3j4SeV5uT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177332; c=relaxed/simple;
	bh=zu2Y6cMTVkjrBvh7s36DCD4TXXiSD+/ttA23ZVoaCok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XZ/p54keWHHHlwVnbKuvi4OrUfzcepQl03quwczz4TqXy1OsZrknth82oAe3XPHpa2hN1v509mR4MzJBi//A+CsG/zew8Xb57/n6EltB3k31y/V4JXoSklKpU0TlRleJ6nlDCc26j+Vn6TDVmwQyXzFMsR9pqG1GVi4kFMzjjd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FeZXEl4t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FeZXEl4t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0089C4CED2;
	Mon,  6 Jan 2025 15:28:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177332;
	bh=zu2Y6cMTVkjrBvh7s36DCD4TXXiSD+/ttA23ZVoaCok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FeZXEl4tdItpTQKA12jcI2l2/sk0xTyrqnn8C//YLjA2EHLrHNl3U42u2oWL1EM6M
	 cSFd9JtkXVTx215Atpqz9zMWvRM78u1TOKRFYtqMvG4uQrVrDqwC81r3teXgv4qIXQ
	 V1W1shLFhd6AASHbXzkCzAUVdTIc+fhAoMdM7V1U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	Xin Li <xin3.li@intel.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Shan Kang <shan.kang@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	"H. Peter Anvin (Intel)" <hpa@zytor.com>
Subject: [PATCH 6.6 097/222] x86/ptrace: Cleanup the definition of the pt_regs structure
Date: Mon,  6 Jan 2025 16:15:01 +0100
Message-ID: <20250106151154.268669635@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151150.585603565@linuxfoundation.org>
References: <20250106151150.585603565@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xin Li <xin3.li@intel.com>

[ Upstream commit ee63291aa8287cb7ded767d340155fe8681fc075 ]

struct pt_regs is hard to read because the member or section related
comments are not aligned with the members.

The 'cs' and 'ss' members of pt_regs are type of 'unsigned long' while
in reality they are only 16-bit wide. This works so far as the
remaining space is unused, but FRED will use the remaining bits for
other purposes.

To prepare for FRED:

  - Cleanup the formatting
  - Convert 'cs' and 'ss' to u16 and embed them into an union
    with a u64
  - Fixup the related printk() format strings

Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Originally-by: H. Peter Anvin (Intel) <hpa@zytor.com>
Signed-off-by: Xin Li <xin3.li@intel.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Tested-by: Shan Kang <shan.kang@intel.com>
Link: https://lore.kernel.org/r/20231205105030.8698-14-xin3.li@intel.com
Stable-dep-of: dc81e556f2a0 ("x86/fred: Clear WFE in missing-ENDBRANCH #CPs")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/entry/vsyscall/vsyscall_64.c |  2 +-
 arch/x86/include/asm/ptrace.h         | 48 +++++++++++++++++++--------
 arch/x86/kernel/process_64.c          |  2 +-
 3 files changed, 37 insertions(+), 15 deletions(-)

diff --git a/arch/x86/entry/vsyscall/vsyscall_64.c b/arch/x86/entry/vsyscall/vsyscall_64.c
index 1245000a8792..2fb7d53cf333 100644
--- a/arch/x86/entry/vsyscall/vsyscall_64.c
+++ b/arch/x86/entry/vsyscall/vsyscall_64.c
@@ -76,7 +76,7 @@ static void warn_bad_vsyscall(const char *level, struct pt_regs *regs,
 	if (!show_unhandled_signals)
 		return;
 
-	printk_ratelimited("%s%s[%d] %s ip:%lx cs:%lx sp:%lx ax:%lx si:%lx di:%lx\n",
+	printk_ratelimited("%s%s[%d] %s ip:%lx cs:%x sp:%lx ax:%lx si:%lx di:%lx\n",
 			   level, current->comm, task_pid_nr(current),
 			   message, regs->ip, regs->cs,
 			   regs->sp, regs->ax, regs->si, regs->di);
diff --git a/arch/x86/include/asm/ptrace.h b/arch/x86/include/asm/ptrace.h
index f4db78b09c8f..b268cd2a2d01 100644
--- a/arch/x86/include/asm/ptrace.h
+++ b/arch/x86/include/asm/ptrace.h
@@ -57,17 +57,19 @@ struct pt_regs {
 #else /* __i386__ */
 
 struct pt_regs {
-/*
- * C ABI says these regs are callee-preserved. They aren't saved on kernel entry
- * unless syscall needs a complete, fully filled "struct pt_regs".
- */
+	/*
+	 * C ABI says these regs are callee-preserved. They aren't saved on
+	 * kernel entry unless syscall needs a complete, fully filled
+	 * "struct pt_regs".
+	 */
 	unsigned long r15;
 	unsigned long r14;
 	unsigned long r13;
 	unsigned long r12;
 	unsigned long bp;
 	unsigned long bx;
-/* These regs are callee-clobbered. Always saved on kernel entry. */
+
+	/* These regs are callee-clobbered. Always saved on kernel entry. */
 	unsigned long r11;
 	unsigned long r10;
 	unsigned long r9;
@@ -77,18 +79,38 @@ struct pt_regs {
 	unsigned long dx;
 	unsigned long si;
 	unsigned long di;
-/*
- * On syscall entry, this is syscall#. On CPU exception, this is error code.
- * On hw interrupt, it's IRQ number:
- */
+
+	/*
+	 * orig_ax is used on entry for:
+	 * - the syscall number (syscall, sysenter, int80)
+	 * - error_code stored by the CPU on traps and exceptions
+	 * - the interrupt number for device interrupts
+	 */
 	unsigned long orig_ax;
-/* Return frame for iretq */
+
+	/* The IRETQ return frame starts here */
 	unsigned long ip;
-	unsigned long cs;
+
+	union {
+		/* The full 64-bit data slot containing CS */
+		u64		csx;
+		/* CS selector */
+		u16		cs;
+	};
+
 	unsigned long flags;
 	unsigned long sp;
-	unsigned long ss;
-/* top of stack page */
+
+	union {
+		/* The full 64-bit data slot containing SS */
+		u64		ssx;
+		/* SS selector */
+		u16		ss;
+	};
+
+	/*
+	 * Top of stack on IDT systems.
+	 */
 };
 
 #endif /* !__i386__ */
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index d595ef7c1de0..dd19a4db741a 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -117,7 +117,7 @@ void __show_regs(struct pt_regs *regs, enum show_regs_mode mode,
 
 	printk("%sFS:  %016lx(%04x) GS:%016lx(%04x) knlGS:%016lx\n",
 	       log_lvl, fs, fsindex, gs, gsindex, shadowgs);
-	printk("%sCS:  %04lx DS: %04x ES: %04x CR0: %016lx\n",
+	printk("%sCS:  %04x DS: %04x ES: %04x CR0: %016lx\n",
 		log_lvl, regs->cs, ds, es, cr0);
 	printk("%sCR2: %016lx CR3: %016lx CR4: %016lx\n",
 		log_lvl, cr2, cr3, cr4);
-- 
2.39.5



