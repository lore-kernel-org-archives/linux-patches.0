Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB1F32638B8;
	Tue,  8 Apr 2025 11:23:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111434; cv=none; b=HmA0X9M7XSYDmmtPP6G+tyQPfaZD6ydsqeMEhP6UvNFpLr3fFq2/CWMuaDvlPZVkOO6JAfjoNFW/5YPHkNjV9gf0a83rB8WKG6SZERPjJuEEBWvacWR9fh2RSOsvuFQFLv/u8qVXSMUCLJKdtlZZdjG/syohTW6rvbYe9s+WlC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111434; c=relaxed/simple;
	bh=JTO+TSSJuc5G2OrlVxXWKT5Sy21Q5ZzSUBAJfHgNclw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rD0oZVr6r7n6xmVM+rWNofSitKNYmW6E0i7/gbnX907L2dm0hy8zCghbSRuxVtQqUaxOSrjuEsqXMOnGFXrOrGxqoomlguLx6XZf+LQf8JXWto//tCNLIv3RGpeNmUmUkcgmnsb73XuwRI0FlwP4XczQB1em1DvG5jRz1UFBeOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nGARPNNp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nGARPNNp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DA60C4CEE5;
	Tue,  8 Apr 2025 11:23:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111434;
	bh=JTO+TSSJuc5G2OrlVxXWKT5Sy21Q5ZzSUBAJfHgNclw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nGARPNNpm7Akpo5AH+xc8bNCSu7uvoi6npuJVZVDq6QnthhtOEoz4bfUkpK7ObAg0
	 N7wzXeu4q8ynDBfFT7LYwS+HrptgB11xG0qB/ukzLhEzG/XnBcNyaUILF/mRNaARJn
	 ai8i4IpVbgsDgjNWZqkzBXtWNtw4ZzMrB3Vt8soU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 379/731] s390: Remove ioremap_wt() and pgprot_writethrough()
Date: Tue,  8 Apr 2025 12:44:36 +0200
Message-ID: <20250408104923.092545126@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index 3ca5af4cfe432..2467e521e1c0f 100644
--- a/arch/s390/include/asm/pgtable.h
+++ b/arch/s390/include/asm/pgtable.h
@@ -1402,9 +1402,6 @@ void gmap_pmdp_idte_global(struct mm_struct *mm, unsigned long vmaddr);
 #define pgprot_writecombine	pgprot_writecombine
 pgprot_t pgprot_writecombine(pgprot_t prot);
 
-#define pgprot_writethrough	pgprot_writethrough
-pgprot_t pgprot_writethrough(pgprot_t prot);
-
 #define PFN_PTE_SHIFT		PAGE_SHIFT
 
 /*
diff --git a/arch/s390/mm/pgtable.c b/arch/s390/mm/pgtable.c
index f05e62e037c28..a248764ad9586 100644
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



