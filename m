Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25D431C57BF;
	Tue, 27 Aug 2024 15:03:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771039; cv=none; b=m0FZ+TZvoyj12BmaNuozZhpbTerd9iY5k961HTCBw5JYyEYKNFUzAYMToWFbH5kvQeA9QG/L/STsV1fmUDBsFvQhZZx/1AGlDfw2+2pIvo7GEpc6FL/kFH6a2iEe13DME42GiBpgT1effyRIrsWTkMQERL/HbVoZMuPwLGrB8cQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771039; c=relaxed/simple;
	bh=qhpqsKLcSMXN8ICIRtS3BPHzpCEo04UN55CoqgJSpnI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DV1UdO/vfxor0pKnkPFuUCyinlKZG9jH9jlIRGTEAuMwJn+V8/BsRLrJfrdlIOT258+pfvR/eqK9oP0bm0uAmNxs5MsP2g3wbn0uD3wF3JsRFGyt6C3BCcdbp+NVpxNbj/dq/mwdWT12wopZ+ghLlK6JpXVYZ4c2ZQExg1rA5PQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=niKHjs6C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="niKHjs6C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 877ECC6104C;
	Tue, 27 Aug 2024 15:03:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771039;
	bh=qhpqsKLcSMXN8ICIRtS3BPHzpCEo04UN55CoqgJSpnI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=niKHjs6CWG2tr3aWI5sJKOTu4qqZ2+BwsEMeua7PGJxs/nNQWSHI7qprYfgB0TcgN
	 U15Pkq4R22rdzHvi5/Nm9BuFxrYbND3XFHgnEQKgOl1R1WVj96ZE/rdzvsgN7chz7C
	 khg5xfIhPjNjnTx5IU/r3DhhvcTCmera0KymJfeU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nam Cao <namcao@linutronix.de>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 6.10 027/273] riscv: change XIPs kernel_map.size to be size of the entire kernel
Date: Tue, 27 Aug 2024 16:35:51 +0200
Message-ID: <20240827143834.425643561@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nam Cao <namcao@linutronix.de>

commit 57d76bc51fd80824bcc0c84a5b5ec944f1b51edd upstream.

With XIP kernel, kernel_map.size is set to be only the size of data part of
the kernel. This is inconsistent with "normal" kernel, who sets it to be
the size of the entire kernel.

More importantly, XIP kernel fails to boot if CONFIG_DEBUG_VIRTUAL is
enabled, because there are checks on virtual addresses with the assumption
that kernel_map.size is the size of the entire kernel (these checks are in
arch/riscv/mm/physaddr.c).

Change XIP's kernel_map.size to be the size of the entire kernel.

Signed-off-by: Nam Cao <namcao@linutronix.de>
Cc: <stable@vger.kernel.org> # v6.1+
Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Link: https://lore.kernel.org/r/20240508191917.2892064-1-namcao@linutronix.de
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/mm/init.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/riscv/mm/init.c
+++ b/arch/riscv/mm/init.c
@@ -931,7 +931,7 @@ static void __init create_kernel_page_ta
 				   PMD_SIZE, PAGE_KERNEL_EXEC);
 
 	/* Map the data in RAM */
-	end_va = kernel_map.virt_addr + XIP_OFFSET + kernel_map.size;
+	end_va = kernel_map.virt_addr + kernel_map.size;
 	for (va = kernel_map.virt_addr + XIP_OFFSET; va < end_va; va += PMD_SIZE)
 		create_pgd_mapping(pgdir, va,
 				   kernel_map.phys_addr + (va - (kernel_map.virt_addr + XIP_OFFSET)),
@@ -1100,7 +1100,7 @@ asmlinkage void __init setup_vm(uintptr_
 
 	phys_ram_base = CONFIG_PHYS_RAM_BASE;
 	kernel_map.phys_addr = (uintptr_t)CONFIG_PHYS_RAM_BASE;
-	kernel_map.size = (uintptr_t)(&_end) - (uintptr_t)(&_sdata);
+	kernel_map.size = (uintptr_t)(&_end) - (uintptr_t)(&_start);
 
 	kernel_map.va_kernel_xip_pa_offset = kernel_map.virt_addr - kernel_map.xiprom;
 #else


