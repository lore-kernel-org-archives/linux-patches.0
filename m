Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D26F20A5C3;
	Tue,  8 Apr 2025 12:46:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116386; cv=none; b=i+ixF1W5Uwvhxk0uFhgGmo3uRqkASkhbTx+YJAlhAN7QWQbaRNlzxioV5i5lbu1vFV89RRVYVOsQ1Xm+SQ7H0RjOvDr17Ts2pHRqesEaBjyJcK9D95HMuODoAZMzEATrN+TbyhIXwcTq3KOkmrCaJQZJL2Fbc2KS+gos6VIlXBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116386; c=relaxed/simple;
	bh=Pyyw5+xBfNvtArdWOqoNLZzQ2OfC3Lw1U45UH3NDn94=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hlUn4KA2DGZTZ0JKMDiN07zEJb7wrA2QuV2qbJqXwdwHHZjhdwnq1skxAxNJcSr1+TFKI/fbeviG17osjuyA7fbAx2Y6r2u4SoTIkABNpYtE6DmJpHdRWtPVhT7lRfSNgSSzItAZ2a613XOlMS0DicMHzQSWTeRlvB9skTo0rWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CIhsg249; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CIhsg249"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C27C9C4CEE5;
	Tue,  8 Apr 2025 12:46:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116386;
	bh=Pyyw5+xBfNvtArdWOqoNLZzQ2OfC3Lw1U45UH3NDn94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CIhsg249yTF7jm65IZ3j31mx2HaHsZC/YKYv8eyQoy0QoF548ltC8eBF12y/aw9Nb
	 MML4d2ZDE7uHZzq7mxzXUzIPfLT3lju9AY+R8um3KflL/GnZUT1maqFwETimRPdLTF
	 8tN/FhSiy/liOxwmgX9ManqJwNgx+By//f/71Nus=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 120/423] s390: Remove ioremap_wt() and pgprot_writethrough()
Date: Tue,  8 Apr 2025 12:47:26 +0200
Message-ID: <20250408104848.522798929@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niklas Schnelle <schnelle@linux.ibm.com>

[ Upstream commit c94bff63e49302d4ce36502a85a2710a67332a4f ]

It turns out that while s390 architecture calls its memory-I/O mapping
variants write-through and write-back the implementation of ioremap_wt()
and pgprot_writethrough() does not match Linux notion of ioremap_wt().

In particular Linux expects ioremap_wt() to be weaker still than
ioremap_wc(), allowing not just gathering and re-ordering but also reads
to be served from cache. Instead s390's implementation is equivalent to
normal ioremap() while its ioremap_wc() allows re-ordering.

Note that there are no known users of ioremap_wt() on s390 and the
resulting behavior is in line with asm-generic defining ioremap_wt() as
ioremap(), if undefined, so no breakage is expected.

As s390 does not have a mapping type matching the Linux notion of
ioremap_wt() and pgprot_writethrough(), simply drop them and rely on the
asm-generic fallbacks instead.

Fixes: b02002cc4c0f ("s390/pci: Implement ioremap_wc/prot() with MIO")
Fixes: b43b3fff042d ("s390: mm: convert to GENERIC_IOREMAP")
Acked-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/include/asm/io.h      |  2 --
 arch/s390/include/asm/pgtable.h |  3 ---
 arch/s390/mm/pgtable.c          | 10 ----------
 3 files changed, 15 deletions(-)

diff --git a/arch/s390/include/asm/io.h b/arch/s390/include/asm/io.h
index fc9933a743d69..251e0372ccbd0 100644
--- a/arch/s390/include/asm/io.h
+++ b/arch/s390/include/asm/io.h
@@ -34,8 +34,6 @@ void unxlate_dev_mem_ptr(phys_addr_t phys, void *addr);
 
 #define ioremap_wc(addr, size)  \
 	ioremap_prot((addr), (size), pgprot_val(pgprot_writecombine(PAGE_KERNEL)))
-#define ioremap_wt(addr, size)  \
-	ioremap_prot((addr), (size), pgprot_val(pgprot_writethrough(PAGE_KERNEL)))
 
 static inline void __iomem *ioport_map(unsigned long port, unsigned int nr)
 {
diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
index 0ffbaf7419558..5ee73f245a0c0 100644
--- a/arch/s390/include/asm/pgtable.h
+++ b/arch/s390/include/asm/pgtable.h
@@ -1365,9 +1365,6 @@ void gmap_pmdp_idte_global(struct mm_struct *mm, unsigned long vmaddr);
 #define pgprot_writecombine	pgprot_writecombine
 pgprot_t pgprot_writecombine(pgprot_t prot);
 
-#define pgprot_writethrough	pgprot_writethrough
-pgprot_t pgprot_writethrough(pgprot_t prot);
-
 #define PFN_PTE_SHIFT		PAGE_SHIFT
 
 /*
diff --git a/arch/s390/mm/pgtable.c b/arch/s390/mm/pgtable.c
index 2c944bafb0309..b03c665d72426 100644
--- a/arch/s390/mm/pgtable.c
+++ b/arch/s390/mm/pgtable.c
@@ -34,16 +34,6 @@ pgprot_t pgprot_writecombine(pgprot_t prot)
 }
 EXPORT_SYMBOL_GPL(pgprot_writecombine);
 
-pgprot_t pgprot_writethrough(pgprot_t prot)
-{
-	/*
-	 * mio_wb_bit_mask may be set on a different CPU, but it is only set
-	 * once at init and only read afterwards.
-	 */
-	return __pgprot(pgprot_val(prot) & ~mio_wb_bit_mask);
-}
-EXPORT_SYMBOL_GPL(pgprot_writethrough);
-
 static inline void ptep_ipte_local(struct mm_struct *mm, unsigned long addr,
 				   pte_t *ptep, int nodat)
 {
-- 
2.39.5



