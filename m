Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5B1F233731;
	Mon, 10 Mar 2025 17:38:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628291; cv=none; b=kpNCQGpk/2Hsj234d8I+Jsbfmx2OSCjEMIvwBMXM6FOYU01r8wlydQtK8v935c9x6S9Exo9JNjFAjPsceY/7EZc5/WWfknpynwWxykT/23Jl4H62gUyEtPMLHjf8aZp7KraAgEcxv/JVnzzw4nimA8eC0ORsMbJrUynyEvlpq30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628291; c=relaxed/simple;
	bh=IVKb3LvF+3JmRR2lBLhuoJEcy1z2BBwtM1tJHmEvLKs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q5KQWm1vCdcEYt0v/nFaOxzt++tZJobHGfKwWNR20mQCciLXXi7t6laFEUHD3Z6necylImARDvxYCAIwVSSjfYdT77SIkHP2QaMgUzvix7SXxvCY43A8R9subtAGOrf47CFbcgiHhaHJmZX0dSGsO2hYTcc9k6J9lwhmRpRTRJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d5a8cvgh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d5a8cvgh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AE50C4CEEC;
	Mon, 10 Mar 2025 17:38:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628291;
	bh=IVKb3LvF+3JmRR2lBLhuoJEcy1z2BBwtM1tJHmEvLKs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d5a8cvghMJ75fJHf3ZDrIrR3vECN/lymzDtOE2CDJcbRUqO4I8h1g2sSpB2QO89a8
	 JNLRGztV2UqYZBBKZgW3KdH8uQP/vMzVH7JVxWEFns5QJoZCMHxWPVzJPgSgZ/KCzZ
	 SA2rHp8XzvTDGYMK/bMmwCqX7+zNdj4EZSswG7Uc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuel Holland <samuel.holland@sifive.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 6.6 132/145] riscv: Save/restore envcfg CSR during CPU suspend
Date: Mon, 10 Mar 2025 18:07:06 +0100
Message-ID: <20250310170440.088791382@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170434.733307314@linuxfoundation.org>
References: <20250310170434.733307314@linuxfoundation.org>
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

From: Samuel Holland <samuel.holland@sifive.com>

commit 05ab803d1ad8ac505ade77c6bd3f86b1b4ea0dc4 upstream.

The value of the [ms]envcfg CSR is lost when entering a nonretentive
idle state, so the CSR must be rewritten when resuming the CPU.

Cc: <stable@vger.kernel.org> # v6.7+
Fixes: 43c16d51a19b ("RISC-V: Enable cbo.zero in usermode")
Signed-off-by: Samuel Holland <samuel.holland@sifive.com>
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
Link: https://lore.kernel.org/r/20240228065559.3434837-4-samuel.holland@sifive.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/include/asm/suspend.h |    1 +
 arch/riscv/kernel/suspend.c      |    4 ++++
 2 files changed, 5 insertions(+)

--- a/arch/riscv/include/asm/suspend.h
+++ b/arch/riscv/include/asm/suspend.h
@@ -14,6 +14,7 @@ struct suspend_context {
 	struct pt_regs regs;
 	/* Saved and restored by high-level functions */
 	unsigned long scratch;
+	unsigned long envcfg;
 	unsigned long tvec;
 	unsigned long ie;
 #ifdef CONFIG_MMU
--- a/arch/riscv/kernel/suspend.c
+++ b/arch/riscv/kernel/suspend.c
@@ -11,6 +11,8 @@
 void suspend_save_csrs(struct suspend_context *context)
 {
 	context->scratch = csr_read(CSR_SCRATCH);
+	if (riscv_cpu_has_extension_unlikely(smp_processor_id(), RISCV_ISA_EXT_XLINUXENVCFG))
+		context->envcfg = csr_read(CSR_ENVCFG);
 	context->tvec = csr_read(CSR_TVEC);
 	context->ie = csr_read(CSR_IE);
 
@@ -32,6 +34,8 @@ void suspend_save_csrs(struct suspend_co
 void suspend_restore_csrs(struct suspend_context *context)
 {
 	csr_write(CSR_SCRATCH, context->scratch);
+	if (riscv_cpu_has_extension_unlikely(smp_processor_id(), RISCV_ISA_EXT_XLINUXENVCFG))
+		csr_write(CSR_ENVCFG, context->envcfg);
 	csr_write(CSR_TVEC, context->tvec);
 	csr_write(CSR_IE, context->ie);
 


