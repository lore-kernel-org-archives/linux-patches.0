Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6779217E90E;
	Mon, 27 May 2024 19:04:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836693; cv=none; b=YrJp1CDg/xG0joASMZsfvMUvQM0YeoBlS+beg0ZJGZRA5/HBQa8aGlnS8AnzmAJiWHmXRnfpoqvliPAU21TMMebJHVxx0qJ+8lSfElxfFyI+IillLr59GCBVhd/lChSoCdmYTBTEwTfLp/OwVTRpJgemoWMhCRG2H0QIO19/Tt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836693; c=relaxed/simple;
	bh=8j3lePxQGDQaJZu5zDH7dcLmZp2tapadsGKD5D1hDxk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lqCweC5v/KVJ1SjyUtBFykjIxKVfTl/pPz8OYLyzAgrWlaNBWbn34WBLdBEi81eJuaEqgfmoOAKOfJ08yc8rM2r35NfrTfkB2EyuNkpySoqz+Y3otMWkqnxvdgGGECNeT4IK3DUsUZVirKmBtUh2Ryf741fopTQVkbeGM4NFZL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1NtQDXJE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1NtQDXJE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EEC8C2BBFC;
	Mon, 27 May 2024 19:04:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836692;
	bh=8j3lePxQGDQaJZu5zDH7dcLmZp2tapadsGKD5D1hDxk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1NtQDXJE4H8PzApm5qA0tD6Ddq4HEkfHJHAmRgu6WOm7R04RYKOVJTyxDiZhiS5bP
	 uaGO3ByOXW8NFdFk+9QsuQL8YbBOkY6r5MCgLlorXbbpmPjwgzWqK8Rf+OSMceVBk1
	 vf1/IqlTHH4F57E2a3cspdWKXFE6wnRi++27vjjw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stafford Horne <shorne@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 152/427] openrisc: traps: Dont send signals to kernel mode threads
Date: Mon, 27 May 2024 20:53:19 +0200
Message-ID: <20240527185616.699993615@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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



