Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1488188CB6;
	Tue, 10 Sep 2024 10:34:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964481; cv=none; b=YOaebhOafosFRN3CSKXEAUSMW8pzDyIFEaLxaTSTpdgk+ibXF9Bm+ClJE0/UqEOf2mmaScjg17xmLQSG3tx638D3a9zdArV4oiHmqZS6B7AF0qOCiWXRK89JADargGP2d94M4321y5qVitnT2UvIBl4Vm4gy7igoXntbLcupcuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964481; c=relaxed/simple;
	bh=tdlOWxweStGxw5byYiBz+OwO5h31ODF9CN8aSEcEa6k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uB2tMzL017ZKwqF//HH5h9kQlbyL/Cv4Wq2iC51Vy2Rh/XS3wk2DLHudxYYty1Vw3Co3FEYlt+8zj+fFOaIpsdzHOjd4V9Cvf03MIG20LP3a5i6hp06l+lHF9nlGO/esFvxWiG5bYcMpXJIXPt8laypCGTxQwtLlAFs4JPAXSwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fFB+MyO6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fFB+MyO6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26139C4CEC3;
	Tue, 10 Sep 2024 10:34:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964481;
	bh=tdlOWxweStGxw5byYiBz+OwO5h31ODF9CN8aSEcEa6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fFB+MyO6HDkku/CL6MvKvF3CNo2xTBl2m8i7+JTT/0kFTmUTsjzZtwfDaoWkGvGYC
	 ZhyicwAT94ECt7eIJtv+3cC3QYtLVtcvSCxuY5tVp0in/BZ/XLwKRSbRsFzDJ97Eue
	 g782lMn9wGhIUh3xPWFpUfZIL/Gp53VdA2UhbXVo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	WangYuli <wangyuli@uniontech.com>
Subject: [PATCH 6.6 197/269] mm: Introduce pudp/p4dp/pgdp_get() functions
Date: Tue, 10 Sep 2024 11:33:04 +0200
Message-ID: <20240910092615.125068684@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
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

commit eba2591d99d1f14a04c8a8a845ab0795b93f5646 upstream.

Instead of directly dereferencing page tables entries, which can cause
issues (see commit 20a004e7b017 ("arm64: mm: Use READ_ONCE/WRITE_ONCE when
accessing page tables"), let's introduce new functions to get the
pud/p4d/pgd entries (the pte and pmd versions already exist).

Note that arm pgd_t is actually an array so pgdp_get() is defined as a
macro to avoid a build error.

Those new functions will be used in subsequent commits by the riscv
architecture.

Signed-off-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Link: https://lore.kernel.org/r/20231213203001.179237-3-alexghiti@rivosinc.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: WangYuli <wangyuli@uniontech.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/include/asm/pgtable.h |    2 ++
 include/linux/pgtable.h        |   21 +++++++++++++++++++++
 2 files changed, 23 insertions(+)

--- a/arch/arm/include/asm/pgtable.h
+++ b/arch/arm/include/asm/pgtable.h
@@ -151,6 +151,8 @@ extern pgprot_t phys_mem_access_prot(str
 
 extern pgd_t swapper_pg_dir[PTRS_PER_PGD];
 
+#define pgdp_get(pgpd)		READ_ONCE(*pgdp)
+
 #define pud_page(pud)		pmd_page(__pmd(pud_val(pud)))
 #define pud_write(pud)		pmd_write(__pmd(pud_val(pud)))
 
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -292,6 +292,27 @@ static inline pmd_t pmdp_get(pmd_t *pmdp
 }
 #endif
 
+#ifndef pudp_get
+static inline pud_t pudp_get(pud_t *pudp)
+{
+	return READ_ONCE(*pudp);
+}
+#endif
+
+#ifndef p4dp_get
+static inline p4d_t p4dp_get(p4d_t *p4dp)
+{
+	return READ_ONCE(*p4dp);
+}
+#endif
+
+#ifndef pgdp_get
+static inline pgd_t pgdp_get(pgd_t *pgdp)
+{
+	return READ_ONCE(*pgdp);
+}
+#endif
+
 #ifndef __HAVE_ARCH_PTEP_TEST_AND_CLEAR_YOUNG
 static inline int ptep_test_and_clear_young(struct vm_area_struct *vma,
 					    unsigned long address,


