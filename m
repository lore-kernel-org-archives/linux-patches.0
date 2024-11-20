Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD2F515853A;
	Wed, 20 Nov 2024 12:58:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107537; cv=none; b=GKUqxCpAtZyE3IMrOltZGp5EMVjvKHU2e+Dh8G3zFH4znW8nM7JzewXKUVEKdXd0gfNYMSxuGo5pW0dotqSZww/OQxZJYOTOeLdQCMjLuhXM0PYYNsnPLIPDDcrq2VJFbqyMBBwZtLNtfXYGOJLOjHCl1uY27ZeRWyx2kHFCmn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107537; c=relaxed/simple;
	bh=RD1uMX6XRiJfjlpLVkjo/DPJ8rebGUL4rrDEN1Hbzg8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kFgfV6lH5tSPeUlDivEr/6nNgyO2WA9UTF1KSVZj58W+X2ZDYAm0tWC77APHxbGImmz+ljS+7FgpkvavF1GhlVKsF0s8OvxnjuEWGOrUIB8tV8kbQhhtN4KntFiXiRzN/rB3Wh5Qxpf/cTajqT6yD8QVZacEG9AUGW0SgN1xQVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L8aSxVsL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L8aSxVsL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A692EC4CECD;
	Wed, 20 Nov 2024 12:58:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107537;
	bh=RD1uMX6XRiJfjlpLVkjo/DPJ8rebGUL4rrDEN1Hbzg8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L8aSxVsL5m631v+zJcnpXIn6jwnIJ+N/6IoK+lFIv5hG5G2thjCl2Y+Rh9UPCY2Fv
	 JW7SD4vGIsGuAPUTbTNl9UvxkBiERAgOCbaJbDYDRMm3IaomOvfL3s4+yDpIpwLwNM
	 e5v7IahuTdUDUMUFDdywt4vcJP+CFkhZ2LhEqTVY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.11 071/107] LoongArch: Disable KASAN if PGDIR_SIZE is too large for cpu_vabits
Date: Wed, 20 Nov 2024 13:56:46 +0100
Message-ID: <20241120125631.282723620@linuxfoundation.org>
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

From: Huacai Chen <chenhuacai@loongson.cn>

commit 227ca9f6f6aeb8aa8f0c10430b955f1fe2aeab91 upstream.

If PGDIR_SIZE is too large for cpu_vabits, KASAN_SHADOW_END will
overflow UINTPTR_MAX because KASAN_SHADOW_START/KASAN_SHADOW_END are
aligned up by PGDIR_SIZE. And then the overflowed KASAN_SHADOW_END looks
like a user space address.

For example, PGDIR_SIZE of CONFIG_4KB_4LEVEL is 2^39, which is too large
for Loongson-2K series whose cpu_vabits = 39.

Since CONFIG_4KB_4LEVEL is completely legal for CPUs with cpu_vabits <=
39, we just disable KASAN via early return in kasan_init(). Otherwise we
get a boot failure.

Moreover, we change KASAN_SHADOW_END from the first address after KASAN
shadow area to the last address in KASAN shadow area, in order to avoid
the end address exactly overflow to 0 (which is a legal case). We don't
need to worry about alignment because pgd_addr_end() can handle it.

Cc: stable@vger.kernel.org
Reviewed-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/include/asm/kasan.h |    2 +-
 arch/loongarch/mm/kasan_init.c     |   15 +++++++++++++--
 2 files changed, 14 insertions(+), 3 deletions(-)

--- a/arch/loongarch/include/asm/kasan.h
+++ b/arch/loongarch/include/asm/kasan.h
@@ -51,7 +51,7 @@
 /* KAsan shadow memory start right after vmalloc. */
 #define KASAN_SHADOW_START		round_up(KFENCE_AREA_END, PGDIR_SIZE)
 #define KASAN_SHADOW_SIZE		(XKVRANGE_VC_SHADOW_END - XKPRANGE_CC_KASAN_OFFSET)
-#define KASAN_SHADOW_END		round_up(KASAN_SHADOW_START + KASAN_SHADOW_SIZE, PGDIR_SIZE)
+#define KASAN_SHADOW_END		(round_up(KASAN_SHADOW_START + KASAN_SHADOW_SIZE, PGDIR_SIZE) - 1)
 
 #define XKPRANGE_CC_SHADOW_OFFSET	(KASAN_SHADOW_START + XKPRANGE_CC_KASAN_OFFSET)
 #define XKPRANGE_UC_SHADOW_OFFSET	(KASAN_SHADOW_START + XKPRANGE_UC_KASAN_OFFSET)
--- a/arch/loongarch/mm/kasan_init.c
+++ b/arch/loongarch/mm/kasan_init.c
@@ -218,7 +218,7 @@ static void __init kasan_map_populate(un
 asmlinkage void __init kasan_early_init(void)
 {
 	BUILD_BUG_ON(!IS_ALIGNED(KASAN_SHADOW_START, PGDIR_SIZE));
-	BUILD_BUG_ON(!IS_ALIGNED(KASAN_SHADOW_END, PGDIR_SIZE));
+	BUILD_BUG_ON(!IS_ALIGNED(KASAN_SHADOW_END + 1, PGDIR_SIZE));
 }
 
 static inline void kasan_set_pgd(pgd_t *pgdp, pgd_t pgdval)
@@ -233,7 +233,7 @@ static void __init clear_pgds(unsigned l
 	 * swapper_pg_dir. pgd_clear() can't be used
 	 * here because it's nop on 2,3-level pagetable setups
 	 */
-	for (; start < end; start += PGDIR_SIZE)
+	for (; start < end; start = pgd_addr_end(start, end))
 		kasan_set_pgd((pgd_t *)pgd_offset_k(start), __pgd(0));
 }
 
@@ -243,6 +243,17 @@ void __init kasan_init(void)
 	phys_addr_t pa_start, pa_end;
 
 	/*
+	 * If PGDIR_SIZE is too large for cpu_vabits, KASAN_SHADOW_END will
+	 * overflow UINTPTR_MAX and then looks like a user space address.
+	 * For example, PGDIR_SIZE of CONFIG_4KB_4LEVEL is 2^39, which is too
+	 * large for Loongson-2K series whose cpu_vabits = 39.
+	 */
+	if (KASAN_SHADOW_END < vm_map_base) {
+		pr_warn("PGDIR_SIZE too large for cpu_vabits, KernelAddressSanitizer disabled.\n");
+		return;
+	}
+
+	/*
 	 * PGD was populated as invalid_pmd_table or invalid_pud_table
 	 * in pagetable_init() which depends on how many levels of page
 	 * table you are using, but we had to clean the gpd of kasan


