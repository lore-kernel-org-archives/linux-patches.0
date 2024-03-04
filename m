Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BA238F58;
	Mon,  4 Mar 2024 21:38:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588326; cv=none; b=AXYx00FE9VUGUUr0eDyrrZDG+PBGfv5OF1FT5c0gGG1WOPPGNFYn1gRsxDERQrWFebhQ6Wr1qla3LmLOwozFkBEBgfCdSn28Thjq/RvMmEL+rTFIG1p526bRWuz+y/+9KBrRm88sCqIfPO+D9y2mTQPUC7blNrUKe0zpSYiqcgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588326; c=relaxed/simple;
	bh=jT09ICd4onNnL2IPV7X0/ixKsQcM7hfm/+saMCCSwAg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZE76MdrsJBb/OOa+Dr78oB10N6v35EVgW3LSwYo3G3Al3Ds3ce+iNjVbMe4fWf4Cz1vf0FTcEmmEpi7dikkYsxksOzSQRvqDTatIcmakgHE85wv6YMBPiibCGlEXKqc04k6SRf9sXF8jKoxrRyEx7A9f82i2BTY0sNE7HKkvmcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VNcMfPWp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VNcMfPWp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FE4BC433F1;
	Mon,  4 Mar 2024 21:38:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588325;
	bh=jT09ICd4onNnL2IPV7X0/ixKsQcM7hfm/+saMCCSwAg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VNcMfPWpkaqM8jRu6/8OU5XqTVyHNttNRHiuU5e6RePjZYsbL7VP3QSEcYaTLIXHk
	 qX4m4WFXKLtOCtddZg6dWp7Ak4nOW6G5SDPCSxBfDydMW8dRRdgoRXq8vZ481cpbrD
	 2AC5GRWkQENNRKHHvrDbWmHb5TezM6qItDvxE5bA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Dimitris Vlachos <dvlachos@ics.forth.gr>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 065/143] riscv: Sparse-Memory/vmemmap out-of-bounds fix
Date: Mon,  4 Mar 2024 21:23:05 +0000
Message-ID: <20240304211552.004822952@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211549.876981797@linuxfoundation.org>
References: <20240304211549.876981797@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dimitris Vlachos <dvlachos@ics.forth.gr>

[ Upstream commit a11dd49dcb9376776193e15641f84fcc1e5980c9 ]

Offset vmemmap so that the first page of vmemmap will be mapped
to the first page of physical memory in order to ensure that
vmemmap’s bounds will be respected during
pfn_to_page()/page_to_pfn() operations.
The conversion macros will produce correct SV39/48/57 addresses
for every possible/valid DRAM_BASE inside the physical memory limits.

v2:Address Alex's comments

Suggested-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Signed-off-by: Dimitris Vlachos <dvlachos@ics.forth.gr>
Reported-by: Dimitris Vlachos <dvlachos@ics.forth.gr>
Closes: https://lore.kernel.org/linux-riscv/20240202135030.42265-1-csd4492@csd.uoc.gr
Fixes: d95f1a542c3d ("RISC-V: Implement sparsemem")
Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Link: https://lore.kernel.org/r/20240229191723.32779-1-dvlachos@ics.forth.gr
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/include/asm/pgtable.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
index 93c1664361143..c00bd5377db9a 100644
--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -84,7 +84,7 @@
  * Define vmemmap for pfn_to_page & page_to_pfn calls. Needed if kernel
  * is configured with CONFIG_SPARSEMEM_VMEMMAP enabled.
  */
-#define vmemmap		((struct page *)VMEMMAP_START)
+#define vmemmap		((struct page *)VMEMMAP_START - (phys_ram_base >> PAGE_SHIFT))
 
 #define PCI_IO_SIZE      SZ_16M
 #define PCI_IO_END       VMEMMAP_START
-- 
2.43.0



