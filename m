Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA29A2BD031;
	Tue, 17 Feb 2026 20:40:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771360807; cv=none; b=iXiCj6NbkMNX9vxNUTO424PFEg2m2B5YmnOlpxI48OUjh6IYKPkUL9uW7nqEDETNsb2hamY7av4MxPc8BwGhvL7KAB/hez+d0V/aVzts7TGz2ys93c/W/LoTDNA/eyJT7FdHrQcleqIjSgnlW/wzlDlrSYLseFdq8acsy/3fKEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771360807; c=relaxed/simple;
	bh=TRXotKQ40MF70rZDW96tuY3i3H7psajmGrOpTXTiYss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f6nBTc89GExouoDRcdfSD+w6/jxawLn6M9XYxOghYAAdeG1BwHImJrQR+BdmJPcezHTGZM5HJdoBIPENkBzXBTOuj7wXLtt4YK7QTwAeS5axxiD1Fy0XF+GPT81VGXoCxb01djxh6grt+r89tLwqT5FJnsP9bVRbPj+wiNaXGDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yaBjYdfR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yaBjYdfR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20F4AC4CEF7;
	Tue, 17 Feb 2026 20:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771360807;
	bh=TRXotKQ40MF70rZDW96tuY3i3H7psajmGrOpTXTiYss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yaBjYdfR6Bw1imBI4iyjT4GoZm27H+mtaFDTYwPDxvEMcQUyf7RYA63G7A9eFGme5
	 /h3AfTgG9baHchrzd6eFhFbJ6lr5kq9lfdIm4hxIo22Gq7XbzbnSuvDOLSLJkJ8M5a
	 qH8IAfbXerZWzafdPAWii5v0xHFY6K9dwlV0tFWo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kanglong Wang <wangkanglong@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.6 21/39] LoongArch: Add WriteCombine shadow mapping in KASAN
Date: Tue, 17 Feb 2026 21:30:43 +0100
Message-ID: <20260217200005.032316136@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260217200004.221651386@linuxfoundation.org>
References: <20260217200004.221651386@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kanglong Wang <wangkanglong@loongson.cn>

commit 139d42ca51018c1d43ab5f35829179f060d1ab31 upstream.

Currently, the kernel couldn't boot when ARCH_IOREMAP, ARCH_WRITECOMBINE
and KASAN are enabled together. Because DMW2 is used by kernel now which
is configured as 0xa000000000000000 for WriteCombine, but KASAN has no
segment mapping for it. This patch fix this issue.

Solution: Add the relevant definitions for WriteCombine (DMW2) in KASAN.

Cc: stable@vger.kernel.org
Fixes: 8e02c3b782ec ("LoongArch: Add writecombine support for DMW-based ioremap()")
Signed-off-by: Kanglong Wang <wangkanglong@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/include/asm/kasan.h |   11 ++++++++++-
 arch/loongarch/mm/kasan_init.c     |    5 +++++
 2 files changed, 15 insertions(+), 1 deletion(-)

--- a/arch/loongarch/include/asm/kasan.h
+++ b/arch/loongarch/include/asm/kasan.h
@@ -25,6 +25,7 @@
 /* 64-bit segment value. */
 #define XKPRANGE_UC_SEG		(0x8000)
 #define XKPRANGE_CC_SEG		(0x9000)
+#define XKPRANGE_WC_SEG		(0xa000)
 #define XKVRANGE_VC_SEG		(0xffff)
 
 /* Cached */
@@ -41,10 +42,17 @@
 #define XKPRANGE_UC_SHADOW_SIZE		(XKPRANGE_UC_SIZE >> KASAN_SHADOW_SCALE_SHIFT)
 #define XKPRANGE_UC_SHADOW_END		(XKPRANGE_UC_KASAN_OFFSET + XKPRANGE_UC_SHADOW_SIZE)
 
+/* WriteCombine */
+#define XKPRANGE_WC_START		WRITECOMBINE_BASE
+#define XKPRANGE_WC_SIZE		XRANGE_SIZE
+#define XKPRANGE_WC_KASAN_OFFSET	XKPRANGE_UC_SHADOW_END
+#define XKPRANGE_WC_SHADOW_SIZE		(XKPRANGE_WC_SIZE >> KASAN_SHADOW_SCALE_SHIFT)
+#define XKPRANGE_WC_SHADOW_END		(XKPRANGE_WC_KASAN_OFFSET + XKPRANGE_WC_SHADOW_SIZE)
+
 /* VMALLOC (Cached or UnCached)  */
 #define XKVRANGE_VC_START		MODULES_VADDR
 #define XKVRANGE_VC_SIZE		round_up(KFENCE_AREA_END - MODULES_VADDR + 1, PGDIR_SIZE)
-#define XKVRANGE_VC_KASAN_OFFSET	XKPRANGE_UC_SHADOW_END
+#define XKVRANGE_VC_KASAN_OFFSET	XKPRANGE_WC_SHADOW_END
 #define XKVRANGE_VC_SHADOW_SIZE		(XKVRANGE_VC_SIZE >> KASAN_SHADOW_SCALE_SHIFT)
 #define XKVRANGE_VC_SHADOW_END		(XKVRANGE_VC_KASAN_OFFSET + XKVRANGE_VC_SHADOW_SIZE)
 
@@ -55,6 +63,7 @@
 
 #define XKPRANGE_CC_SHADOW_OFFSET	(KASAN_SHADOW_START + XKPRANGE_CC_KASAN_OFFSET)
 #define XKPRANGE_UC_SHADOW_OFFSET	(KASAN_SHADOW_START + XKPRANGE_UC_KASAN_OFFSET)
+#define XKPRANGE_WC_SHADOW_OFFSET	(KASAN_SHADOW_START + XKPRANGE_WC_KASAN_OFFSET)
 #define XKVRANGE_VC_SHADOW_OFFSET	(KASAN_SHADOW_START + XKVRANGE_VC_KASAN_OFFSET)
 
 extern bool kasan_early_stage;
--- a/arch/loongarch/mm/kasan_init.c
+++ b/arch/loongarch/mm/kasan_init.c
@@ -62,6 +62,9 @@ void *kasan_mem_to_shadow(const void *ad
 		case XKPRANGE_UC_SEG:
 			offset = XKPRANGE_UC_SHADOW_OFFSET;
 			break;
+		case XKPRANGE_WC_SEG:
+			offset = XKPRANGE_WC_SHADOW_OFFSET;
+			break;
 		case XKVRANGE_VC_SEG:
 			offset = XKVRANGE_VC_SHADOW_OFFSET;
 			break;
@@ -86,6 +89,8 @@ const void *kasan_shadow_to_mem(const vo
 
 	if (addr >= XKVRANGE_VC_SHADOW_OFFSET)
 		return (void *)(((addr - XKVRANGE_VC_SHADOW_OFFSET) << KASAN_SHADOW_SCALE_SHIFT) + XKVRANGE_VC_START);
+	else if (addr >= XKPRANGE_WC_SHADOW_OFFSET)
+		return (void *)(((addr - XKPRANGE_WC_SHADOW_OFFSET) << KASAN_SHADOW_SCALE_SHIFT) + XKPRANGE_WC_START);
 	else if (addr >= XKPRANGE_UC_SHADOW_OFFSET)
 		return (void *)(((addr - XKPRANGE_UC_SHADOW_OFFSET) << KASAN_SHADOW_SCALE_SHIFT) + XKPRANGE_UC_START);
 	else if (addr >= XKPRANGE_CC_SHADOW_OFFSET)


