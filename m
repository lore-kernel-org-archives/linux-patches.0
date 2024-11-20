Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7856A1A0BD6;
	Wed, 20 Nov 2024 13:00:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107628; cv=none; b=Tmbv3JBAwApJxahsS19DRHPviPukYc/aOWL0nPN2JQj3Dj9hPgRGaWpcM6JAmlwrbutPBs/zSVAxe2FPZXdfR8Ku/HunDU2Ks5OX92xBVfpOhq09Jz/9iJ6xAzGpV/2HKC4cEQ81cIFa7wkwSHjfyDsvU9n9slwFV/w1s5LZ3HY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107628; c=relaxed/simple;
	bh=MabJgEQTIGsADFOpN8xRgaZ+9uplwjC33cC8RmP1afc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oqzFXqeH1/OCxdjDE4hJyKLhmRl48yWsbDQ8yHUfFI9fgXc6BqyPRe+SoVHvyR2KMXxy+4y/idirQHTseIxOo8rP0ZqAqvNt8ZviZtV2CYma/IKjm+fUsLPbFc90srvdkx4SEdKi5VExxXGeSIYpoSPzMSJ0w+e5PIvLWGbYLK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ckA7OnDg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ckA7OnDg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEF7CC4CECD;
	Wed, 20 Nov 2024 13:00:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107628;
	bh=MabJgEQTIGsADFOpN8xRgaZ+9uplwjC33cC8RmP1afc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ckA7OnDgOB5MXOykk0IcSOh6ZrAYlmZR9rwXIkN5+utAdCiDa+QybtqV1WZct5N3I
	 B4RWIHdRahuNl+Dzlv77sa9pBuVVLeVdsfbSZqQ/3KsPvW19lqKXB7Rz89eS9uYYQZ
	 DGQlvOf/PQQQrjB00KfGyXB97JBpF289sbDHqriY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.6 47/82] LoongArch: Make KASAN work with 5-level page-tables
Date: Wed, 20 Nov 2024 13:56:57 +0100
Message-ID: <20241120125630.671856856@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125629.623666563@linuxfoundation.org>
References: <20241120125629.623666563@linuxfoundation.org>
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

From: Huacai Chen <chenhuacai@loongson.cn>

commit a410656643ce4844ba9875aa4e87a7779308259b upstream.

Make KASAN work with 5-level page-tables, including:
1. Implement and use __pgd_none() and kasan_p4d_offset().
2. As done in kasan_pmd_populate() and kasan_pte_populate(), restrict
   the loop conditions of kasan_p4d_populate() and kasan_pud_populate()
   to avoid unnecessary population.

Cc: stable@vger.kernel.org
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/mm/kasan_init.c |   26 +++++++++++++++++++++++---
 1 file changed, 23 insertions(+), 3 deletions(-)

--- a/arch/loongarch/mm/kasan_init.c
+++ b/arch/loongarch/mm/kasan_init.c
@@ -13,6 +13,13 @@
 
 static pgd_t kasan_pg_dir[PTRS_PER_PGD] __initdata __aligned(PAGE_SIZE);
 
+#ifdef __PAGETABLE_P4D_FOLDED
+#define __pgd_none(early, pgd) (0)
+#else
+#define __pgd_none(early, pgd) (early ? (pgd_val(pgd) == 0) : \
+(__pa(pgd_val(pgd)) == (unsigned long)__pa(kasan_early_shadow_p4d)))
+#endif
+
 #ifdef __PAGETABLE_PUD_FOLDED
 #define __p4d_none(early, p4d) (0)
 #else
@@ -142,6 +149,19 @@ static pud_t *__init kasan_pud_offset(p4
 	return pud_offset(p4dp, addr);
 }
 
+static p4d_t *__init kasan_p4d_offset(pgd_t *pgdp, unsigned long addr, int node, bool early)
+{
+	if (__pgd_none(early, pgdp_get(pgdp))) {
+		phys_addr_t p4d_phys = early ?
+			__pa_symbol(kasan_early_shadow_p4d) : kasan_alloc_zeroed_page(node);
+		if (!early)
+			memcpy(__va(p4d_phys), kasan_early_shadow_p4d, sizeof(kasan_early_shadow_p4d));
+		pgd_populate(&init_mm, pgdp, (p4d_t *)__va(p4d_phys));
+	}
+
+	return p4d_offset(pgdp, addr);
+}
+
 static void __init kasan_pte_populate(pmd_t *pmdp, unsigned long addr,
 				      unsigned long end, int node, bool early)
 {
@@ -178,19 +198,19 @@ static void __init kasan_pud_populate(p4
 	do {
 		next = pud_addr_end(addr, end);
 		kasan_pmd_populate(pudp, addr, next, node, early);
-	} while (pudp++, addr = next, addr != end);
+	} while (pudp++, addr = next, addr != end && __pud_none(early, READ_ONCE(*pudp)));
 }
 
 static void __init kasan_p4d_populate(pgd_t *pgdp, unsigned long addr,
 					    unsigned long end, int node, bool early)
 {
 	unsigned long next;
-	p4d_t *p4dp = p4d_offset(pgdp, addr);
+	p4d_t *p4dp = kasan_p4d_offset(pgdp, addr, node, early);
 
 	do {
 		next = p4d_addr_end(addr, end);
 		kasan_pud_populate(p4dp, addr, next, node, early);
-	} while (p4dp++, addr = next, addr != end);
+	} while (p4dp++, addr = next, addr != end && __p4d_none(early, READ_ONCE(*p4dp)));
 }
 
 static void __init kasan_pgd_populate(unsigned long addr, unsigned long end,


