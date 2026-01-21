Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8965D285060;
	Wed, 21 Jan 2026 18:29:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769020182; cv=none; b=ZCE5AN4tiZusCw8Rd/D7xe6c7GhRJf6yW/PXnAddOmV6YlqYGGA3IRpV19DVQ72heeLYuTojqIBPJNYiMM/qXAF85YcKhEPtN7GBLWri2c2t2cGDMlulqjxRTjKjXl1zoBncbu7fZ1PjOUjhC4RinhDJozGfcVi+BAoE5MfKIUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769020182; c=relaxed/simple;
	bh=3PXF09dbt+BQ0v3l3iaKlUUJ9JxIxHrqzYa/9NpXGU4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DRHBe4hGjEhXvAt4CwLPn28uJDY66NwwsmSgLJpuFYg9cAR+pQt2/EYTkauaQof+WrlVVzOOtYgapAw/vStZ67NSwoFCd8491ooMKozZZsrwt3k3tJL1CRu+B0DTGOoaRYtbHqN0RaOPLuqZDBrKvdE8D0FfWHkBWLERZxaHfG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZVr89ryr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZVr89ryr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8381AC16AAE;
	Wed, 21 Jan 2026 18:29:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769020182;
	bh=3PXF09dbt+BQ0v3l3iaKlUUJ9JxIxHrqzYa/9NpXGU4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZVr89ryr01yKOHqBoXFPwSckiVVwfo1AQyKw++xoMnqq6i6cuwHUBrg2NsLUr1kSS
	 MJFIZBmO4hASOdQTebiE5rNbFhQwOrOHwE5ygt6E5GWFn0jWVUoC7ACF5anErD1AyH
	 XzeKnJh7VCQXez6Eoah8FpZh4DyjRKDYB5D8t0q8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Markus Stockhausen <markus.stockhausen@gmx.de>,
	Chris Packham <chris.packham@alliedtelesis.co.nz>,
	Hauke Mehrtens <hauke@hauke-m.de>,
	Jonas Jelonek <jelonek.jonas@gmail.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Thomas Gleinxer <tglx@linutronix.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 066/198] mips: fix HIGHMEM initialization
Date: Wed, 21 Jan 2026 19:14:54 +0100
Message-ID: <20260121181420.935080219@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181418.537774329@linuxfoundation.org>
References: <20260121181418.537774329@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Rapoport (Microsoft) <rppt@kernel.org>

[ Upstream commit f171b55f1441294344b86edfeaa575ea9673fd23 ]

Commit 6faea3422e3b ("arch, mm: streamline HIGHMEM freeing") overzealously
removed mem_init_free_highmem() function that beside freeing high memory
pages checked for CPU support for high memory as a prerequisite.

Partially restore mem_init_free_highmem() with a new highmem_init() name
and make it discard high memory in case there is no CPU support for it.

Link: https://lkml.kernel.org/r/20251231105701.519711-1-rppt@kernel.org
Fixes: 6faea3422e3b ("arch, mm: streamline HIGHMEM freeing")
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reported-by: Markus Stockhausen <markus.stockhausen@gmx.de>
Cc: Chris Packham <chris.packham@alliedtelesis.co.nz>
Cc: Hauke Mehrtens <hauke@hauke-m.de>
Cc: Jonas Jelonek <jelonek.jonas@gmail.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/mm/init.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/arch/mips/mm/init.c b/arch/mips/mm/init.c
index a673d3d68254b..8986048f9b110 100644
--- a/arch/mips/mm/init.c
+++ b/arch/mips/mm/init.c
@@ -425,6 +425,28 @@ void __init paging_init(void)
 static struct kcore_list kcore_kseg0;
 #endif
 
+static inline void __init highmem_init(void)
+{
+#ifdef CONFIG_HIGHMEM
+	unsigned long tmp;
+
+	/*
+	 * If CPU cannot support HIGHMEM discard the memory above highstart_pfn
+	 */
+	if (cpu_has_dc_aliases) {
+		memblock_remove(PFN_PHYS(highstart_pfn), -1);
+		return;
+	}
+
+	for (tmp = highstart_pfn; tmp < highend_pfn; tmp++) {
+		struct page *page = pfn_to_page(tmp);
+
+		if (!memblock_is_memory(PFN_PHYS(tmp)))
+			SetPageReserved(page);
+	}
+#endif
+}
+
 void __init arch_mm_preinit(void)
 {
 	/*
@@ -435,6 +457,7 @@ void __init arch_mm_preinit(void)
 
 	maar_init();
 	setup_zero_pages();	/* Setup zeroed pages.  */
+	highmem_init();
 
 #ifdef CONFIG_64BIT
 	if ((unsigned long) &_text > (unsigned long) CKSEG0)
-- 
2.51.0



