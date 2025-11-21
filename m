Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B2721F09AC;
	Fri, 21 Nov 2025 13:22:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731330; cv=none; b=Et8pQCsZ9QE+N9g68uk7b2MxUmLd/CPEtrGO46+K4IAeoc2Vda/bZuWaejc40li19Oy9/EErDfKNENC01aLilSRqE96xUGyn/zGlHMN7MSOv48F2c0hPCNFkusZTlojkw27RxqpQ/FoW3mQkRds182pj5fLE3r9QZbz3mG9ac9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731330; c=relaxed/simple;
	bh=ZyiAtsLoPKPOxJYyNemO/acLajjBdHvGs8bIwxZAdyI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GFkgja/JNMkEksB6JJMswMjc+kik+k/HmozgGljJmO6/qtuyHDcWPxNSbij1UWDmwRB0g/DiSBQQTXxscPGWj8ASCXsBbljCuzE5BfmEOfiAxaxWXcuYKoniZzz2+SJBZcsX3Y8GjO+ihevXds2+d49DaB/VvpN+Wo3nMdQZx6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A5pM14iI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A5pM14iI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3773C4CEFB;
	Fri, 21 Nov 2025 13:22:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731330;
	bh=ZyiAtsLoPKPOxJYyNemO/acLajjBdHvGs8bIwxZAdyI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A5pM14iIcb1ThwRi8JwjNcvpz+NMwYgsVlk8Uxy1bUUHqwz8CTu9F3xpfGyKDCyQc
	 D/SfPVBEvKeF/22pB7fvMpqPpAopyh4cudL48OUSByespKzaGV+/gtUhHFBhI75A+d
	 k0yl2alaYZ33dvT0ukz/s6RgvA5oEZBPUBRv4hzo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.17 171/247] LoongArch: Consolidate early_ioremap()/ioremap_prot()
Date: Fri, 21 Nov 2025 14:11:58 +0100
Message-ID: <20251121130200.858167615@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Huacai Chen <chenhuacai@loongson.cn>

commit 43a9e6a10bdde32445ad2725f568e08a94e51dc9 upstream.

1. Use phys_addr_t instead of u64, which can work for both 32/64 bits.
2. Check whether the input physical address is above TO_PHYS_MASK (and
   return NULL if yes) for the DMW version.

Note: In theory early_ioremap() also need the TO_PHYS_MASK checking, but
the UEFI BIOS pass some DMW virtual addresses.

Cc: stable@vger.kernel.org
Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/include/asm/io.h |    5 ++++-
 arch/loongarch/mm/ioremap.c     |    2 +-
 2 files changed, 5 insertions(+), 2 deletions(-)

--- a/arch/loongarch/include/asm/io.h
+++ b/arch/loongarch/include/asm/io.h
@@ -14,7 +14,7 @@
 #include <asm/pgtable-bits.h>
 #include <asm/string.h>
 
-extern void __init __iomem *early_ioremap(u64 phys_addr, unsigned long size);
+extern void __init __iomem *early_ioremap(phys_addr_t phys_addr, unsigned long size);
 extern void __init early_iounmap(void __iomem *addr, unsigned long size);
 
 #define early_memremap early_ioremap
@@ -25,6 +25,9 @@ extern void __init early_iounmap(void __
 static inline void __iomem *ioremap_prot(phys_addr_t offset, unsigned long size,
 					 pgprot_t prot)
 {
+	if (offset > TO_PHYS_MASK)
+		return NULL;
+
 	switch (pgprot_val(prot) & _CACHE_MASK) {
 	case _CACHE_CC:
 		return (void __iomem *)(unsigned long)(CACHE_BASE + offset);
--- a/arch/loongarch/mm/ioremap.c
+++ b/arch/loongarch/mm/ioremap.c
@@ -6,7 +6,7 @@
 #include <asm/io.h>
 #include <asm-generic/early_ioremap.h>
 
-void __init __iomem *early_ioremap(u64 phys_addr, unsigned long size)
+void __init __iomem *early_ioremap(phys_addr_t phys_addr, unsigned long size)
 {
 	return ((void __iomem *)TO_CACHE(phys_addr));
 }


