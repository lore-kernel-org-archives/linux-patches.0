Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D2267BB1B;
	Mon,  4 Mar 2024 21:30:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709587832; cv=none; b=HVg53PnkpUwMA1XyTMjMxGgAFKY6sIkwtnEZTfS6Zxl0ZF6sZSdZOQcDtwjsBF3uGgyA2MRWO1qpPuFiHAS9nU3aZV5n2GPK+ZXzntImvQQMOhy0OhCyCNgaW5lczjSNoQe0HZ6vPozzZNsT8yC8/WO4+KlA1EXizE62NsoG4es=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709587832; c=relaxed/simple;
	bh=v9Op5os/DDFyKV3lsBTCB81F8DKQpo1jHCty6lsklfo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QJzVpyntGTbjFHWsi8j/JG/bRWaZ6EKF7fy+YCweba5i/RQczULj8+tGffxmaMeDhhVTESZyQh15Z4otEcXn1VgvKSRqT1KbXHLncY9sZcFY8UwdrCLAyU7cr1cuJ6s2T0o/U44XOzj0Q/wkIrUjhJ1V/ROXZUkeklCPav9tzcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sb825whg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sb825whg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AD9BC433C7;
	Mon,  4 Mar 2024 21:30:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709587832;
	bh=v9Op5os/DDFyKV3lsBTCB81F8DKQpo1jHCty6lsklfo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Sb825whgRszJMhj61frw/IsChPI6/io2HxOcarL0VdIHN3bCkoiIZTOq33MUaJp0/
	 aDBbV3kF0GX7QBoM89Tmiq/X3VYv33TDsU0QNp8WBZWwKKlSvNT+/R6HtF90MSsS0+
	 KxEOPgc4u9CXruI/dIokqfdpXSl0u7ZEJ39FdlHI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Jones <ajones@ventanamicro.com>,
	Samuel Holland <samuel.holland@sifive.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 6.7 107/162] riscv: Fix enabling cbo.zero when running in M-mode
Date: Mon,  4 Mar 2024 21:22:52 +0000
Message-ID: <20240304211555.216977466@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211551.833500257@linuxfoundation.org>
References: <20240304211551.833500257@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
@@ -415,6 +415,7 @@
 # define CSR_STATUS	CSR_MSTATUS
 # define CSR_IE		CSR_MIE
 # define CSR_TVEC	CSR_MTVEC
+# define CSR_ENVCFG	CSR_MENVCFG
 # define CSR_SCRATCH	CSR_MSCRATCH
 # define CSR_EPC	CSR_MEPC
 # define CSR_CAUSE	CSR_MCAUSE
@@ -439,6 +440,7 @@
 # define CSR_STATUS	CSR_SSTATUS
 # define CSR_IE		CSR_SIE
 # define CSR_TVEC	CSR_STVEC
+# define CSR_ENVCFG	CSR_SENVCFG
 # define CSR_SCRATCH	CSR_SSCRATCH
 # define CSR_EPC	CSR_SEPC
 # define CSR_CAUSE	CSR_SCAUSE
--- a/arch/riscv/kernel/cpufeature.c
+++ b/arch/riscv/kernel/cpufeature.c
@@ -740,7 +740,7 @@ arch_initcall(check_unaligned_access_all
 void riscv_user_isa_enable(void)
 {
 	if (riscv_cpu_has_extension_unlikely(smp_processor_id(), RISCV_ISA_EXT_ZICBOZ))
-		csr_set(CSR_SENVCFG, ENVCFG_CBZE);
+		csr_set(CSR_ENVCFG, ENVCFG_CBZE);
 }
 
 #ifdef CONFIG_RISCV_ALTERNATIVE


