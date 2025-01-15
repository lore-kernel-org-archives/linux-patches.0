Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 532EB248BA6;
	Wed, 15 Jan 2025 10:48:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938090; cv=none; b=J2DHgWqatAPV79G6q4fdLRBVqTZtBvx0hVeT6yx201SbWJVBAsMItQj1xq+AYFGV29F1rfylqueluev/mQx74LxnVBhIBd8+fpaU+YYAN8eWa7IjeWzbswF1Om8Pl0Qn2deABJ9nmuH5Qh8otIHcb/tKsONGWWOsbFZcPay9ioY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938090; c=relaxed/simple;
	bh=k+J6I6zrFJUXCk0VGoV851RiEvkXrQ3dF1oVezqMKVI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TV6iuu2gsD1Hx+EsBTtfiWjWMpq4a1G1yd/fPVDjiGCKhY3fyiHb/LNia/FLIY4dg5/cmOT8HxceTTVBwFXXTv8A59Z2dqLZh9bhmbbDFRvnjDho/BGICcWqu+QZWCTdSbMII3dAcL3ORqXENA92jxs3T4/LZoMv4YkCDE5PvFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fo3zZ0uw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fo3zZ0uw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54B50C4CEDF;
	Wed, 15 Jan 2025 10:48:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938089;
	bh=k+J6I6zrFJUXCk0VGoV851RiEvkXrQ3dF1oVezqMKVI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fo3zZ0uw7m6gybLjndv6cy2gzugHnYMMlMnDdPSANhMlf7UPAr3KlFqr9dCxUQYJ8
	 cKupeWXdHMufli5vk5Cw5FMqrvhk3+U2SeWG7ouADNgCMmOj8Ru5Jn4WOPpfRo0ojv
	 9SM5SSWBkl6i8cZalaAZUtmiTMtWOL29Kal3/dxY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 079/189] riscv: use local label names instead of global ones in assembly
Date: Wed, 15 Jan 2025 11:36:15 +0100
Message-ID: <20250115103609.504260841@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103606.357764746@linuxfoundation.org>
References: <20250115103606.357764746@linuxfoundation.org>
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

[ Upstream commit 5cd900b8b7e42c492431eb4261c18927768db1f9 ]

Local labels should be prefix by '.L' or they'll be exported in the
symbol table. Additionally, this messes up the backtrace by displaying
an incorrect symbol:

  ...
  [   12.751810] [<ffffffff80441628>] _copy_from_user+0x28/0xc2
  [   12.752035] [<ffffffff800152ca>] handle_misaligned_load+0x1ca/0x2fc
  [   12.752310] [<ffffffff80a033e8>] do_trap_load_misaligned+0x24/0xee
  [   12.752596] [<ffffffff80a0dcae>] _new_vmalloc_restore_context_a0+0xc2/0xce

After:
  ...
  [   10.243916] [<ffffffff804415e4>] _copy_from_user+0x28/0xc2
  [   10.244026] [<ffffffff800152ca>] handle_misaligned_load+0x1ca/0x2fc
  [   10.244150] [<ffffffff80a033a0>] do_trap_load_misaligned+0x24/0xee
  [   10.244268] [<ffffffff80a0dc66>] handle_exception+0x146/0x152

Signed-off-by: Clément Léger <cleger@rivosinc.com>
Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Fixes: 503638e0babf3 ("riscv: Stop emitting preventive sfence.vma for new vmalloc mappings")
Link: https://lore.kernel.org/r/20250103141814.508865-1-cleger@rivosinc.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/entry.S | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/riscv/kernel/entry.S b/arch/riscv/kernel/entry.S
index 7a6c48e6d211..33a5a9f2a0d4 100644
--- a/arch/riscv/kernel/entry.S
+++ b/arch/riscv/kernel/entry.S
@@ -23,21 +23,21 @@
 	REG_S 	a0, TASK_TI_A0(tp)
 	csrr 	a0, CSR_CAUSE
 	/* Exclude IRQs */
-	blt  	a0, zero, _new_vmalloc_restore_context_a0
+	blt  	a0, zero, .Lnew_vmalloc_restore_context_a0
 
 	REG_S 	a1, TASK_TI_A1(tp)
 	/* Only check new_vmalloc if we are in page/protection fault */
 	li   	a1, EXC_LOAD_PAGE_FAULT
-	beq  	a0, a1, _new_vmalloc_kernel_address
+	beq  	a0, a1, .Lnew_vmalloc_kernel_address
 	li   	a1, EXC_STORE_PAGE_FAULT
-	beq  	a0, a1, _new_vmalloc_kernel_address
+	beq  	a0, a1, .Lnew_vmalloc_kernel_address
 	li   	a1, EXC_INST_PAGE_FAULT
-	bne  	a0, a1, _new_vmalloc_restore_context_a1
+	bne  	a0, a1, .Lnew_vmalloc_restore_context_a1
 
-_new_vmalloc_kernel_address:
+.Lnew_vmalloc_kernel_address:
 	/* Is it a kernel address? */
 	csrr 	a0, CSR_TVAL
-	bge 	a0, zero, _new_vmalloc_restore_context_a1
+	bge 	a0, zero, .Lnew_vmalloc_restore_context_a1
 
 	/* Check if a new vmalloc mapping appeared that could explain the trap */
 	REG_S	a2, TASK_TI_A2(tp)
@@ -69,7 +69,7 @@ _new_vmalloc_kernel_address:
 	/* Check the value of new_vmalloc for this cpu */
 	REG_L	a2, 0(a0)
 	and	a2, a2, a1
-	beq	a2, zero, _new_vmalloc_restore_context
+	beq	a2, zero, .Lnew_vmalloc_restore_context
 
 	/* Atomically reset the current cpu bit in new_vmalloc */
 	amoxor.d	a0, a1, (a0)
@@ -83,11 +83,11 @@ _new_vmalloc_kernel_address:
 	csrw	CSR_SCRATCH, x0
 	sret
 
-_new_vmalloc_restore_context:
+.Lnew_vmalloc_restore_context:
 	REG_L 	a2, TASK_TI_A2(tp)
-_new_vmalloc_restore_context_a1:
+.Lnew_vmalloc_restore_context_a1:
 	REG_L 	a1, TASK_TI_A1(tp)
-_new_vmalloc_restore_context_a0:
+.Lnew_vmalloc_restore_context_a0:
 	REG_L	a0, TASK_TI_A0(tp)
 .endm
 
-- 
2.39.5



