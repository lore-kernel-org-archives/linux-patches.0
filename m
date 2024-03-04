Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 376807BB1B;
	Mon,  4 Mar 2024 21:30:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709587837; cv=none; b=WY/cXDD3EIGWmUwuVE4kiP2uMPuC5z3pwpdGsxj44sRKUT9IBXobPDih+WdypYOrH1PN5IylBVE3OVcIqJlJQVZRcAJRvqTEpbYuB+r2XCOLorIEgTB5NYDMQgVKpFrDPiawPW7aLwFpNBQK5wT5KKsd6w8dQd+S9qoWnlBQM2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709587837; c=relaxed/simple;
	bh=+5Boo2z+ZsVRySuHTHLdT3jTHg3cPBwJ3+eeULgZgfk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z8TsJHSz8fpj19y+R2ik4B3hu3xvRwDDmVRDgd2jbmctBYzAQdqcdejyG3btf+YPV+mAem3Ike1bZWSQm2WZYJXTKdVwBb0mOnIlOYbCd5y53IpGzg6BS8xDJ2pBCJQexnW+BjYRu4OR7bKwQsSMYc5PaHJOAPUYtnlo57D3G3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aLpyIVct; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aLpyIVct"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF901C433C7;
	Mon,  4 Mar 2024 21:30:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709587837;
	bh=+5Boo2z+ZsVRySuHTHLdT3jTHg3cPBwJ3+eeULgZgfk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aLpyIVctL5KL6dWTZxOt4y39KGAjapi86ySrIUVq/HWew2VQvu7uzIrLp+E7j451l
	 O9v8rwjD4YCobNPUBgjSDjR33G5eKxz6jFnOn+tafLDxZgIgVDrYq6xLqYzmnTX13N
	 fO0M5H6dbvN1lWJfFwVD6TrwkrZlWC4+VYlkpO7c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuel Holland <samuel.holland@sifive.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 6.7 108/162] riscv: Save/restore envcfg CSR during CPU suspend
Date: Mon,  4 Mar 2024 21:22:53 +0000
Message-ID: <20240304211555.240842316@linuxfoundation.org>
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
 


