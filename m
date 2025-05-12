Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85DFF29A316;
	Mon, 12 May 2025 18:04:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073079; cv=none; b=Qu+TjVG2ZbyADMInHTULzfXbfvH60C/o3tOLKxGmb5vqDtu8pvEbYnei6SJpaIf/FjeTiGblZDq+TsQqULzqW3cMA85rS3mkYWWtgJ29vvLfJyl5JzfghYQTwVT4h8rcURYoQgRsKJ2RXC5WtxE1a7M8YazltQMED9s6IClvhwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073079; c=relaxed/simple;
	bh=Pk0mUCRODHL8qHD0uMwUn0I69qH9zP2bLxKkudZLGuw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gN0xtuwC/hG9JiRx7dr+UsIpnQdHgVWwe+K+VVZ5MhtoAXANR97hPy/7s1L0w0rtOdS4D0wNxeAXcUCFEAxPMAK1DtHTP32a4ko1+E0SasMgIF4V1ziQurYsPYg22m7ZC+MYp3y0fjrdDwrgzPpE3Cx5VcsbM+9U5njHi4fpFYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UrttF2kt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UrttF2kt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F35CC4CEE9;
	Mon, 12 May 2025 18:04:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747073078;
	bh=Pk0mUCRODHL8qHD0uMwUn0I69qH9zP2bLxKkudZLGuw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UrttF2ktodJoItIZkRKdAMDyOwrJ5YR+micpnb9t0/Nn9sl+hQuCnu8ANsdmO5+oa
	 6HqSxhc3DT2QcQvt4MAEBcPK1W25+FdUzrtVqJixY14lo2gi/9+JxM28m8j6nOxUXc
	 hSuefJI7dkDrVxoR3vu1rPMv20MPzO6fG+rR+rig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 147/184] riscv: misaligned: factorize trap handling
Date: Mon, 12 May 2025 19:45:48 +0200
Message-ID: <20250512172047.802375711@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172041.624042835@linuxfoundation.org>
References: <20250512172041.624042835@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Clément Léger <cleger@rivosinc.com>

[ Upstream commit fd94de9f9e7aac11ec659e386b9db1203d502023 ]

Since both load/store and user/kernel should use almost the same path and
that we are going to add some code around that, factorize it.

Signed-off-by: Clément Léger <cleger@rivosinc.com>
Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Link: https://lore.kernel.org/r/20250422162324.956065-2-cleger@rivosinc.com
Signed-off-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Stable-dep-of: 453805f0a28f ("riscv: misaligned: enable IRQs while handling misaligned accesses")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/traps.c | 66 +++++++++++++++++++++------------------
 1 file changed, 36 insertions(+), 30 deletions(-)

diff --git a/arch/riscv/kernel/traps.c b/arch/riscv/kernel/traps.c
index 8ff8e8b36524b..b1d991c78a233 100644
--- a/arch/riscv/kernel/traps.c
+++ b/arch/riscv/kernel/traps.c
@@ -198,47 +198,53 @@ asmlinkage __visible __trap_section void do_trap_insn_illegal(struct pt_regs *re
 DO_ERROR_INFO(do_trap_load_fault,
 	SIGSEGV, SEGV_ACCERR, "load access fault");
 
-asmlinkage __visible __trap_section void do_trap_load_misaligned(struct pt_regs *regs)
+enum misaligned_access_type {
+	MISALIGNED_STORE,
+	MISALIGNED_LOAD,
+};
+static const struct {
+	const char *type_str;
+	int (*handler)(struct pt_regs *regs);
+} misaligned_handler[] = {
+	[MISALIGNED_STORE] = {
+		.type_str = "Oops - store (or AMO) address misaligned",
+		.handler = handle_misaligned_store,
+	},
+	[MISALIGNED_LOAD] = {
+		.type_str = "Oops - load address misaligned",
+		.handler = handle_misaligned_load,
+	},
+};
+
+static void do_trap_misaligned(struct pt_regs *regs, enum misaligned_access_type type)
 {
-	if (user_mode(regs)) {
+	irqentry_state_t state;
+
+	if (user_mode(regs))
 		irqentry_enter_from_user_mode(regs);
+	else
+		state = irqentry_nmi_enter(regs);
 
-		if (handle_misaligned_load(regs))
-			do_trap_error(regs, SIGBUS, BUS_ADRALN, regs->epc,
-			      "Oops - load address misaligned");
+	if (misaligned_handler[type].handler(regs))
+		do_trap_error(regs, SIGBUS, BUS_ADRALN, regs->epc,
+			      misaligned_handler[type].type_str);
 
+	if (user_mode(regs))
 		irqentry_exit_to_user_mode(regs);
-	} else {
-		irqentry_state_t state = irqentry_nmi_enter(regs);
-
-		if (handle_misaligned_load(regs))
-			do_trap_error(regs, SIGBUS, BUS_ADRALN, regs->epc,
-			      "Oops - load address misaligned");
-
+	else
 		irqentry_nmi_exit(regs, state);
-	}
 }
 
-asmlinkage __visible __trap_section void do_trap_store_misaligned(struct pt_regs *regs)
+asmlinkage __visible __trap_section void do_trap_load_misaligned(struct pt_regs *regs)
 {
-	if (user_mode(regs)) {
-		irqentry_enter_from_user_mode(regs);
-
-		if (handle_misaligned_store(regs))
-			do_trap_error(regs, SIGBUS, BUS_ADRALN, regs->epc,
-				"Oops - store (or AMO) address misaligned");
-
-		irqentry_exit_to_user_mode(regs);
-	} else {
-		irqentry_state_t state = irqentry_nmi_enter(regs);
-
-		if (handle_misaligned_store(regs))
-			do_trap_error(regs, SIGBUS, BUS_ADRALN, regs->epc,
-				"Oops - store (or AMO) address misaligned");
+	do_trap_misaligned(regs, MISALIGNED_LOAD);
+}
 
-		irqentry_nmi_exit(regs, state);
-	}
+asmlinkage __visible __trap_section void do_trap_store_misaligned(struct pt_regs *regs)
+{
+	do_trap_misaligned(regs, MISALIGNED_STORE);
 }
+
 DO_ERROR_INFO(do_trap_store_fault,
 	SIGSEGV, SEGV_ACCERR, "store (or AMO) access fault");
 DO_ERROR_INFO(do_trap_ecall_s,
-- 
2.39.5



