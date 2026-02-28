Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49EBC371449;
	Sat, 28 Feb 2026 17:57:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301476; cv=none; b=cpYW/P6TJ87aWm0nVb43jO2+tN88y7NFaqqizhyAdSi8ROtAbxOnYoxfZEaKmeUF0tq3rXWC8hoAnqtJF5PX3erGH9d76xgO3s9Z758A9yMdIL9hMHaAuwDbzo4g/hIagvNPjwIX2pTnhhcJIikh8/ptFpQaFc5iP+MebzTgl2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301476; c=relaxed/simple;
	bh=dQkMmHrbcqCy/oztNkPAM72dHeZZl1pyQ+qFF3r0YC4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B4yuJ9PRwXpWFwZWVGAHBtF9HSqH0hFZEhKNeCgoKIl+clW/yOveAxTdy2W9BWzfU7TAzWYi7AMjrkL5ftL0i3xtoTJ08E0/Wgg/13k3dxxTboQAwL/dj/5lv/AnpJHbdfP+w6kyYyduZCDGGezNJVF0/nBynqLcSml74HaXaec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rQfhxUGw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rQfhxUGw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5930DC116D0;
	Sat, 28 Feb 2026 17:57:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301476;
	bh=dQkMmHrbcqCy/oztNkPAM72dHeZZl1pyQ+qFF3r0YC4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rQfhxUGw1WQ2pt2c0TWRFBQUTnzO9GkV4bKPUR7OjbJg/0+hJl94W6Y++JKxVPtgj
	 IVOoDEQDL26xAJ+YCGVzqdaqazgL9r5EGuJIZjgaHob9ZXtWhTcaCkbAVskH4wi2sf
	 KrlcMNofNvTDsNVr3kG0t8IkeSBOa82jKRl6VR0smeSeIjUHO/+kgDdNE/+MA4dtD+
	 Ct9jUx+s7oSN5jY7dGSV/ZEcp2IDFRAya4lcMiYLemHyXAyt5ZiiJW6LDXXfK5ICvN
	 u4ZUUjQsEpvZ3PIYtmFrDj3e5Qi8/RT4gTo79/RwJ9/2tqsoVFUOMrq2s4vbrfqFFj
	 iNszaiy9/ydFw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Rong Zhang <rongrong@oss.cipunited.com>,
	stable@vger.kernel.org,
	Beiyan Yun <root@infi.wang>,
	Yao Zi <me@ziyao.cc>,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 661/752] MIPS: Loongson2ef: Register PCI controller in early stage
Date: Sat, 28 Feb 2026 12:46:12 -0500
Message-ID: <20260228174750.1542406-661-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Rong Zhang <rongrong@oss.cipunited.com>

[ Upstream commit 6a00c043af07492502ba7a2263ddc4cdb01b66a7 ]

We are about to set loongson_pci_io_resource.start to 0 and adopt
PCIBIOS_MIN_IO. As the first step, PCI controller needs to be registered
in early stage to make it the root of other resources (e.g., i8259) and
prevent resource conflicts.

Register it in plat_mem_setup() instead of arch_initcall().

Fixes: ae81aad5c2e1 ("MIPS: PCI: Use pci_enable_resources()")
Cc: stable@vger.kernel.org
Tested-by: Beiyan Yun <root@infi.wang>
Tested-by: Yao Zi <me@ziyao.cc>
Signed-off-by: Rong Zhang <rongrong@oss.cipunited.com>
Acked-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/include/asm/mach-loongson2ef/loongson.h | 6 ++++++
 arch/mips/loongson2ef/common/pci.c                | 7 +------
 arch/mips/loongson2ef/common/setup.c              | 1 +
 3 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/arch/mips/include/asm/mach-loongson2ef/loongson.h b/arch/mips/include/asm/mach-loongson2ef/loongson.h
index 4a098fb102325..0e586787eb87a 100644
--- a/arch/mips/include/asm/mach-loongson2ef/loongson.h
+++ b/arch/mips/include/asm/mach-loongson2ef/loongson.h
@@ -324,4 +324,10 @@ extern unsigned long _loongson_addrwincfg_base;
 
 #endif	/* ! CONFIG_CPU_SUPPORTS_ADDRWINCFG */
 
+#ifdef CONFIG_PCI
+void loongson2ef_pcibios_init(void);
+#else
+static inline void loongson2ef_pcibios_init(void) { }
+#endif
+
 #endif /* __ASM_MACH_LOONGSON2EF_LOONGSON_H */
diff --git a/arch/mips/loongson2ef/common/pci.c b/arch/mips/loongson2ef/common/pci.c
index 7d9ea51e8c01e..55524f9a7b96b 100644
--- a/arch/mips/loongson2ef/common/pci.c
+++ b/arch/mips/loongson2ef/common/pci.c
@@ -73,15 +73,10 @@ static void __init setup_pcimap(void)
 #endif
 }
 
-static int __init pcibios_init(void)
+void __init loongson2ef_pcibios_init(void)
 {
 	setup_pcimap();
 
 	loongson_pci_controller.io_map_base = mips_io_port_base;
 	register_pci_controller(&loongson_pci_controller);
-
-
-	return 0;
 }
-
-arch_initcall(pcibios_init);
diff --git a/arch/mips/loongson2ef/common/setup.c b/arch/mips/loongson2ef/common/setup.c
index 4fd27f4f90edb..a639e35acce59 100644
--- a/arch/mips/loongson2ef/common/setup.c
+++ b/arch/mips/loongson2ef/common/setup.c
@@ -27,4 +27,5 @@ EXPORT_SYMBOL(__wbflush);
 
 void __init plat_mem_setup(void)
 {
+	loongson2ef_pcibios_init();
 }
-- 
2.51.0

