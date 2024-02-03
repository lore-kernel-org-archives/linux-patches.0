Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C26A18E27;
	Sat,  3 Feb 2024 04:14:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933686; cv=none; b=J7vZRUO0gtfOD9JWMc86tKa9rVH7cbzWVSmEu3uJgfkl699YW+Sn32V0R6+PYci0SqKimCkcv1AfX24zxI1InK14Z7zdfBJ+DdbGxlOX6dVcJmehT9F7OdK5ATCXS2cOcCvsluI5XT07Ey6pcDnh1OAIXxmsLqWRfx/jQPD5vRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933686; c=relaxed/simple;
	bh=oVgbtp3J4xUfFEPj6G6Dk0xUma2RzEFiXo9lGY65Xkg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h+p8NMjsMfl6zziUHpEGcQEYJM1ROXFSPnodaZD8hjnZ3H8e3+Zp/Bn2Owa0yFq15kRtgryimUGgHHt8eWr0YNS36N0z0enqK0IGQrQXdYsaF5F6LTpykMTepAvj+Tj2cRitbLwt4EFOCdzVBnLW3Oyue/BBkcDyDrdgEHlW6DY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n3HosiXK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n3HosiXK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E473AC433F1;
	Sat,  3 Feb 2024 04:14:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933686;
	bh=oVgbtp3J4xUfFEPj6G6Dk0xUma2RzEFiXo9lGY65Xkg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n3HosiXKb/2PbXDm/6Ovmo+5kYEGu/dyjTtlAnRfpZTV2kTfo4KkTP2TA5ktNEXsF
	 tmo41LyiZpcNvTpzxRDnUoRGekih+hiHV8sNXdSs2sheXtexDay6dEQQeQmXewXrAj
	 TxYgp4zDU1w9esiHB1PTSiluI1eyiGm44HrvkmBE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 263/322] riscv: Fix build error on rv32 + XIP
Date: Fri,  2 Feb 2024 20:06:00 -0800
Message-ID: <20240203035407.633283569@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035359.041730947@linuxfoundation.org>
References: <20240203035359.041730947@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexandre Ghiti <alexghiti@rivosinc.com>

[ Upstream commit 66f962d8939fd2ac74de901d30d30310c8ddca79 ]

commit 66f1e6809397 ("riscv: Make XIP bootable again") restricted page
offset to the sv39 page offset instead of the default sv57, which makes
sense since probably the platforms that target XIP kernels do not
support anything else than sv39 and we do not try to find out the
largest address space supported on XIP kernels (ie set_satp_mode()).

But PAGE_OFFSET_L3 is not defined for rv32, so fix the build error by
restoring the previous behaviour which picks CONFIG_PAGE_OFFSET for rv32.

Fixes: 66f1e6809397 ("riscv: Make XIP bootable again")
Reported-by: Randy Dunlap <rdunlap@infradead.org>
Closes: https://lore.kernel.org/linux-riscv/344dca85-5c48-44e1-bc64-4fa7973edd12@infradead.org/T/#u
Signed-off-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Tested-by: Randy Dunlap <rdunlap@infradead.org> # build-tested
Link: https://lore.kernel.org/r/20240118212120.2087803-1-alexghiti@rivosinc.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/mm/init.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/riscv/mm/init.c b/arch/riscv/mm/init.c
index 5f1921d014b1..e71dd19ac801 100644
--- a/arch/riscv/mm/init.c
+++ b/arch/riscv/mm/init.c
@@ -1058,7 +1058,11 @@ asmlinkage void __init setup_vm(uintptr_t dtb_pa)
 	kernel_map.virt_addr = KERNEL_LINK_ADDR + kernel_map.virt_offset;
 
 #ifdef CONFIG_XIP_KERNEL
+#ifdef CONFIG_64BIT
 	kernel_map.page_offset = PAGE_OFFSET_L3;
+#else
+	kernel_map.page_offset = _AC(CONFIG_PAGE_OFFSET, UL);
+#endif
 	kernel_map.xiprom = (uintptr_t)CONFIG_XIP_PHYS_ADDR;
 	kernel_map.xiprom_sz = (uintptr_t)(&_exiprom) - (uintptr_t)(&_xiprom);
 
-- 
2.43.0



