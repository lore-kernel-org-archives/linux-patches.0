Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AFBE296D30;
	Mon, 12 May 2025 17:51:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072300; cv=none; b=dpchDSSLJyDFlZstSEoRBVgqRpd71hhqsw07oMCghqhWWGKp4OQPFhnTHZ7W/MIfU18vXQOU3iFZ9aiNtJn6I/hCW7mrFOzt7W+Ztj+EU/oJOldk6KogG6yxT5ia2RyxgFc6DdHYyxdX6BrQcdlzylXigbIri7zwhFK7FVpjD9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072300; c=relaxed/simple;
	bh=2G5J9/+/t31kizradFnrZY5I5g59QkXSLQNDtTHLEAE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IiMKP737N2UcZ8NKFgg8B/9xWYYfrsR+VF2u7kLjo6r/TFCyUwuwCCX0cequzYjUWAu3sVrU381gdSAAt2a47MpUKQ74vcrvzfHoriTW3WKgNH4jUaUp81l8XBySutPXddKyONww/3M6qyhaB9GKvXAfxL7B8Y5QDr/6zpn3plU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BpxlE3Ws; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BpxlE3Ws"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90F1BC4CEE9;
	Mon, 12 May 2025 17:51:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072299;
	bh=2G5J9/+/t31kizradFnrZY5I5g59QkXSLQNDtTHLEAE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BpxlE3WsGpUMDkGZbW+QHpbuYQY8tCi+acyf7o4SGeNsswNPhxAO+NxolccnIbb9U
	 Ob5KXjEbKixJ0Bk6H9dFEfWIlXf0qKo9lnhAqcFqzjtw2pLDeu0Nd9iSvDOET72Wxa
	 Dfi3N3VM/SPgWazk/wF0QmxoOHEXsn3f+8upiXKo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 165/197] riscv: misaligned: factorize trap handling
Date: Mon, 12 May 2025 19:40:15 +0200
Message-ID: <20250512172051.102659177@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172044.326436266@linuxfoundation.org>
References: <20250512172044.326436266@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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



