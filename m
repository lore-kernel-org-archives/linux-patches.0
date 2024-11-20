Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8DE715853A;
	Wed, 20 Nov 2024 12:58:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107538; cv=none; b=RnWciJT1+7OoVK/CcN/QBIZZCpZ2SX8xVBx+4FJqWDbPxkIaYOOCPT0Stpn7pnfhCbqlo/llO8xld8HkjG3KNBSy4RGhkq6NaBvP+uiSueyomYJNlF7abo+MosnG1aC79riufEFRX2YAy71T9CyuLYvXAKSQEUcEMkVqlFGe7TY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107538; c=relaxed/simple;
	bh=emaWHrKVAJMpbiG+Ush8Rk4dlXrjL9urXMpgTvgmhLw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bGPN1LnKLwsoOxcAWOgdfBXcv4Y4zC0w4Y1IkPzIG251UsYP0rxdzsPlxXX7BOUDARamxDOkSy9d4zxDKDUSLR7BxJ+RUQhm0iQNmqonx8rs73vezSZ/4Ih9EE08eSRGvM+E1BE9G1nMjGQY05+7V+SJsLhziyVL9vHpkGUwYk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ovj7/f4N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ovj7/f4N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B63EC4CED1;
	Wed, 20 Nov 2024 12:58:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107538;
	bh=emaWHrKVAJMpbiG+Ush8Rk4dlXrjL9urXMpgTvgmhLw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ovj7/f4Nrpz+QXF7uDuI/zYXslZn+oR+8NBt14Wxpjd9MZV7qa0OaOzjnUZnju2AC
	 gBxoW9mkOxqBFeB9NKi5LjLu+wSZbtTAq1chWp2OF0+4xo828ZAipdTClb0EHxuYDX
	 MXiH013KpF4+qNCsF7AMDCUXSQKd6HUP/c/AQfyo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kanglong Wang <wangkanglong@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.11 072/107] LoongArch: Add WriteCombine shadow mapping in KASAN
Date: Wed, 20 Nov 2024 13:56:47 +0100
Message-ID: <20241120125631.305954704@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125629.681745345@linuxfoundation.org>
References: <20241120125629.681745345@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
@@ -55,6 +55,9 @@ void *kasan_mem_to_shadow(const void *ad
 		case XKPRANGE_UC_SEG:
 			offset = XKPRANGE_UC_SHADOW_OFFSET;
 			break;
+		case XKPRANGE_WC_SEG:
+			offset = XKPRANGE_WC_SHADOW_OFFSET;
+			break;
 		case XKVRANGE_VC_SEG:
 			offset = XKVRANGE_VC_SHADOW_OFFSET;
 			break;
@@ -79,6 +82,8 @@ const void *kasan_shadow_to_mem(const vo
 
 	if (addr >= XKVRANGE_VC_SHADOW_OFFSET)
 		return (void *)(((addr - XKVRANGE_VC_SHADOW_OFFSET) << KASAN_SHADOW_SCALE_SHIFT) + XKVRANGE_VC_START);
+	else if (addr >= XKPRANGE_WC_SHADOW_OFFSET)
+		return (void *)(((addr - XKPRANGE_WC_SHADOW_OFFSET) << KASAN_SHADOW_SCALE_SHIFT) + XKPRANGE_WC_START);
 	else if (addr >= XKPRANGE_UC_SHADOW_OFFSET)
 		return (void *)(((addr - XKPRANGE_UC_SHADOW_OFFSET) << KASAN_SHADOW_SCALE_SHIFT) + XKPRANGE_UC_START);
 	else if (addr >= XKPRANGE_CC_SHADOW_OFFSET)


