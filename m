Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D80C208BD
	for <patches@lists.linux.dev>; Mon,  6 Nov 2023 13:18:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d851uvgI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B976CC433C8;
	Mon,  6 Nov 2023 13:18:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1699276732;
	bh=HHU2gHIc2Im3T0Pvhb/KPaVncmLAcn2s25zMUJ/2mSE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d851uvgImBRvdCLFz7G8/SkTuRdlpF+mAkN0JcmQDfz3fZvtenjEK+zo8d9BZlEo+
	 ocwIvrwqSHS+peGIW6iXUJJaPjcJgcOI773BQzYQBK5421hrJQBbQMyYILq54IYTVB
	 UfnYT/aowTNuC3YWNFblJQ4NBEowSCfhNBK9gpMQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Icenowy Zheng <uwu@icenowy.me>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 49/88] LoongArch: Disable WUC for pgprot_writecombine() like ioremap_wc()
Date: Mon,  6 Nov 2023 14:03:43 +0100
Message-ID: <20231106130307.656842716@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231106130305.772449722@linuxfoundation.org>
References: <20231106130305.772449722@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Icenowy Zheng <uwu@icenowy.me>

[ Upstream commit 278be83601dd1725d4732241f066d528e160a39d ]

Currently the code disables WUC only disables it for ioremap_wc(), which
is only used when mapping writecombine pages like ioremap() (mapped to
the kernel space). But for VRAM mapped in TTM/GEM, it is mapped with a
crafted pgprot by the pgprot_writecombine() function, in which case WUC
isn't disabled now.

Disable WUC for pgprot_writecombine() (fallback to SUC) if needed, like
ioremap_wc().

This improves the AMDGPU driver's stability (solves some misrendering)
on Loongson-3A5000/3A6000 machines.

Signed-off-by: Icenowy Zheng <uwu@icenowy.me>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/loongarch/include/asm/io.h           |  5 ++---
 arch/loongarch/include/asm/pgtable-bits.h |  4 +++-
 arch/loongarch/kernel/setup.c             | 10 +++++-----
 3 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/arch/loongarch/include/asm/io.h b/arch/loongarch/include/asm/io.h
index 1c94102200407..0355b64e90ed0 100644
--- a/arch/loongarch/include/asm/io.h
+++ b/arch/loongarch/include/asm/io.h
@@ -54,10 +54,9 @@ static inline void __iomem *ioremap_prot(phys_addr_t offset, unsigned long size,
  * @offset:    bus address of the memory
  * @size:      size of the resource to map
  */
-extern pgprot_t pgprot_wc;
-
 #define ioremap_wc(offset, size)	\
-	ioremap_prot((offset), (size), pgprot_val(pgprot_wc))
+	ioremap_prot((offset), (size),	\
+		pgprot_val(wc_enabled ? PAGE_KERNEL_WUC : PAGE_KERNEL_SUC))
 
 #define ioremap_cache(offset, size)	\
 	ioremap_prot((offset), (size), pgprot_val(PAGE_KERNEL))
diff --git a/arch/loongarch/include/asm/pgtable-bits.h b/arch/loongarch/include/asm/pgtable-bits.h
index de46a6b1e9f11..7b9ac012cd090 100644
--- a/arch/loongarch/include/asm/pgtable-bits.h
+++ b/arch/loongarch/include/asm/pgtable-bits.h
@@ -105,13 +105,15 @@ static inline pgprot_t pgprot_noncached(pgprot_t _prot)
 	return __pgprot(prot);
 }
 
+extern bool wc_enabled;
+
 #define pgprot_writecombine pgprot_writecombine
 
 static inline pgprot_t pgprot_writecombine(pgprot_t _prot)
 {
 	unsigned long prot = pgprot_val(_prot);
 
-	prot = (prot & ~_CACHE_MASK) | _CACHE_WUC;
+	prot = (prot & ~_CACHE_MASK) | (wc_enabled ? _CACHE_WUC : _CACHE_SUC);
 
 	return __pgprot(prot);
 }
diff --git a/arch/loongarch/kernel/setup.c b/arch/loongarch/kernel/setup.c
index 9d830ab4e3025..1351614042d4e 100644
--- a/arch/loongarch/kernel/setup.c
+++ b/arch/loongarch/kernel/setup.c
@@ -161,19 +161,19 @@ static void __init smbios_parse(void)
 }
 
 #ifdef CONFIG_ARCH_WRITECOMBINE
-pgprot_t pgprot_wc = PAGE_KERNEL_WUC;
+bool wc_enabled = true;
 #else
-pgprot_t pgprot_wc = PAGE_KERNEL_SUC;
+bool wc_enabled = false;
 #endif
 
-EXPORT_SYMBOL(pgprot_wc);
+EXPORT_SYMBOL(wc_enabled);
 
 static int __init setup_writecombine(char *p)
 {
 	if (!strcmp(p, "on"))
-		pgprot_wc = PAGE_KERNEL_WUC;
+		wc_enabled = true;
 	else if (!strcmp(p, "off"))
-		pgprot_wc = PAGE_KERNEL_SUC;
+		wc_enabled = false;
 	else
 		pr_warn("Unknown writecombine setting \"%s\".\n", p);
 
-- 
2.42.0



