Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9D6718DB24;
	Mon, 10 Mar 2025 17:37:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628230; cv=none; b=dCrwB3rgki7XrUy1TaitSbuR6sDQTspNbvSL5FxuKemKHk1rhxy6vnrTp2yIYs0iKWajSBq5Skl8yV+p/7lFPK2PzKlLsUpLEB/m3jFQjKALIjnwRRJtzaZEaxAP8RIjr7ZDKr6mcPSyoPBeLxk+ktSPJhyyYoS/jzs+w54/VAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628230; c=relaxed/simple;
	bh=hCdAsGjTVw3LAduvr2P1TR2iJXAvZKjyDYgBsmk+zX8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P5eSSnIGe9g7XZ3qWXg83TSFMLJjWvC2nc1Y/nFhElPRiR3uGbbxw/6hhYO4s4RIB13zpZgMyWYfh3kTKkEf04Z6qNrVAA3XyTzCelf6ijpoWTr8V+ss7/+SodfbUzu/EeXV7jKWylDu1tKeHMq4yaK3TBSGa0A0g6wQFJjdqR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N6qCdsAp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N6qCdsAp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35683C4CEE5;
	Mon, 10 Mar 2025 17:37:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628230;
	bh=hCdAsGjTVw3LAduvr2P1TR2iJXAvZKjyDYgBsmk+zX8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N6qCdsApjaHb4NQBZ8eBdeUFyYIfSbpvUeP7ixQA1yw06kiEciv5ewXB4hwRy4GsI
	 cuVbrMmozsJXItcVEKEMxvF4QSOMda0o5VH/OSlwokzzFMxUdMGcZAcoYGBmohogSL
	 +EFpnP2FspIwEmVfzGzkgmvtGwzG1fA7/FYcNBb8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Jones <ajones@ventanamicro.com>,
	Samuel Holland <samuel.holland@sifive.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 6.6 131/145] riscv: Fix enabling cbo.zero when running in M-mode
Date: Mon, 10 Mar 2025 18:07:05 +0100
Message-ID: <20250310170440.051068889@linuxfoundation.org>
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

commit 3fb3f7164edc467450e650dca51dbe4823315a56 upstream.

When the kernel is running in M-mode, the CBZE bit must be set in the
menvcfg CSR, not in senvcfg.

Cc: <stable@vger.kernel.org>
Fixes: 43c16d51a19b ("RISC-V: Enable cbo.zero in usermode")
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
Signed-off-by: Samuel Holland <samuel.holland@sifive.com>
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
Link: https://lore.kernel.org/r/20240228065559.3434837-2-samuel.holland@sifive.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/include/asm/csr.h   |    2 ++
 arch/riscv/kernel/cpufeature.c |    2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

--- a/arch/riscv/include/asm/csr.h
+++ b/arch/riscv/include/asm/csr.h
@@ -398,6 +398,7 @@
 # define CSR_STATUS	CSR_MSTATUS
 # define CSR_IE		CSR_MIE
 # define CSR_TVEC	CSR_MTVEC
+# define CSR_ENVCFG	CSR_MENVCFG
 # define CSR_SCRATCH	CSR_MSCRATCH
 # define CSR_EPC	CSR_MEPC
 # define CSR_CAUSE	CSR_MCAUSE
@@ -422,6 +423,7 @@
 # define CSR_STATUS	CSR_SSTATUS
 # define CSR_IE		CSR_SIE
 # define CSR_TVEC	CSR_STVEC
+# define CSR_ENVCFG	CSR_SENVCFG
 # define CSR_SCRATCH	CSR_SSCRATCH
 # define CSR_EPC	CSR_SEPC
 # define CSR_CAUSE	CSR_SCAUSE
--- a/arch/riscv/kernel/cpufeature.c
+++ b/arch/riscv/kernel/cpufeature.c
@@ -679,7 +679,7 @@ arch_initcall(check_unaligned_access_boo
 void riscv_user_isa_enable(void)
 {
 	if (riscv_cpu_has_extension_unlikely(smp_processor_id(), RISCV_ISA_EXT_ZICBOZ))
-		csr_set(CSR_SENVCFG, ENVCFG_CBZE);
+		csr_set(CSR_ENVCFG, ENVCFG_CBZE);
 }
 
 #ifdef CONFIG_RISCV_ALTERNATIVE


