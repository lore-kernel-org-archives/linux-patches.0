Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21669197A75;
	Thu,  6 Jun 2024 14:13:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683238; cv=none; b=cpJxzJRtC+QQDUzJVUMzD62kPuH/GdmKacvfFYe7RhA6P8nNAm0P7hG9452guDOGLifAu76R5usEgljYPllqNJd0kAuigF3itC87Y3OpJJdSGu7Y+Kf3Hp/hujQvJ1DxB4/vs+ElipkFtfwtrH5EE4iWIn0a8xJyhvwPmuDRdhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683238; c=relaxed/simple;
	bh=1VwTZhfn9W1RDV+7Qho0wyi8ma4hl4ROxAi1iJlAea8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wfz0YAGjl3QyI3YZtDusJRBKszgXuC5ie5CuGyrRpSE9LJHkb89vgPTnACgzvNEWy3LTRr3NBGg7iVz3RLT/vUv8hrrMxruYCRJ84xvKwNsabJIkOnBlCZ//Yhsj3pkHhvcSIXFooGHESWDWIfGC1kImud7rIGeZwNVJwLBC1KY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hlLGz0nD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hlLGz0nD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02B90C32781;
	Thu,  6 Jun 2024 14:13:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683238;
	bh=1VwTZhfn9W1RDV+7Qho0wyi8ma4hl4ROxAi1iJlAea8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hlLGz0nDYOpcA96e9LtOGgAByrRSJb2hW/tKuwff0ATn3rLH1XgWgulG/eoO5UrcW
	 +sYHi978TEUwUTR1kGCEpxMCOjzHY3mBdjlqmv38bnnG9LYGdNavXHc/M2fACBXhf6
	 YE2YklyUkpuVdcEaug/PIXYAEa6hsiAkMH3RHmC8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stafford Horne <shorne@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 174/744] openrisc: traps: Dont send signals to kernel mode threads
Date: Thu,  6 Jun 2024 15:57:26 +0200
Message-ID: <20240606131738.009707660@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

From: Stafford Horne <shorne@gmail.com>

[ Upstream commit c88cfb5cea5f8f9868ef02cc9ce9183a26dcf20f ]

OpenRISC exception handling sends signals to user processes on floating
point exceptions and trap instructions (for debugging) among others.
There is a bug where the trap handling logic may send signals to kernel
threads, we should not send these signals to kernel threads, if that
happens we treat it as an error.

This patch adds conditions to die if the kernel receives these
exceptions in kernel mode code.

Fixes: 27267655c531 ("openrisc: Support floating point user api")
Signed-off-by: Stafford Horne <shorne@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/openrisc/kernel/traps.c | 48 ++++++++++++++++++++++--------------
 1 file changed, 29 insertions(+), 19 deletions(-)

diff --git a/arch/openrisc/kernel/traps.c b/arch/openrisc/kernel/traps.c
index 9370888c9a7e3..90554a5558fbc 100644
--- a/arch/openrisc/kernel/traps.c
+++ b/arch/openrisc/kernel/traps.c
@@ -180,29 +180,39 @@ asmlinkage void unhandled_exception(struct pt_regs *regs, int ea, int vector)
 
 asmlinkage void do_fpe_trap(struct pt_regs *regs, unsigned long address)
 {
-	int code = FPE_FLTUNK;
-	unsigned long fpcsr = regs->fpcsr;
-
-	if (fpcsr & SPR_FPCSR_IVF)
-		code = FPE_FLTINV;
-	else if (fpcsr & SPR_FPCSR_OVF)
-		code = FPE_FLTOVF;
-	else if (fpcsr & SPR_FPCSR_UNF)
-		code = FPE_FLTUND;
-	else if (fpcsr & SPR_FPCSR_DZF)
-		code = FPE_FLTDIV;
-	else if (fpcsr & SPR_FPCSR_IXF)
-		code = FPE_FLTRES;
-
-	/* Clear all flags */
-	regs->fpcsr &= ~SPR_FPCSR_ALLF;
-
-	force_sig_fault(SIGFPE, code, (void __user *)regs->pc);
+	if (user_mode(regs)) {
+		int code = FPE_FLTUNK;
+		unsigned long fpcsr = regs->fpcsr;
+
+		if (fpcsr & SPR_FPCSR_IVF)
+			code = FPE_FLTINV;
+		else if (fpcsr & SPR_FPCSR_OVF)
+			code = FPE_FLTOVF;
+		else if (fpcsr & SPR_FPCSR_UNF)
+			code = FPE_FLTUND;
+		else if (fpcsr & SPR_FPCSR_DZF)
+			code = FPE_FLTDIV;
+		else if (fpcsr & SPR_FPCSR_IXF)
+			code = FPE_FLTRES;
+
+		/* Clear all flags */
+		regs->fpcsr &= ~SPR_FPCSR_ALLF;
+
+		force_sig_fault(SIGFPE, code, (void __user *)regs->pc);
+	} else {
+		pr_emerg("KERNEL: Illegal fpe exception 0x%.8lx\n", regs->pc);
+		die("Die:", regs, SIGFPE);
+	}
 }
 
 asmlinkage void do_trap(struct pt_regs *regs, unsigned long address)
 {
-	force_sig_fault(SIGTRAP, TRAP_BRKPT, (void __user *)regs->pc);
+	if (user_mode(regs)) {
+		force_sig_fault(SIGTRAP, TRAP_BRKPT, (void __user *)regs->pc);
+	} else {
+		pr_emerg("KERNEL: Illegal trap exception 0x%.8lx\n", regs->pc);
+		die("Die:", regs, SIGILL);
+	}
 }
 
 asmlinkage void do_unaligned_access(struct pt_regs *regs, unsigned long address)
-- 
2.43.0



