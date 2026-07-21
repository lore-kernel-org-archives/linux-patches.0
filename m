Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD35B401A18;
	Tue, 21 Jul 2026 17:22:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654542; cv=none; b=d5CwMyfIGQD3MKyMqlKNStxICCS7vNrGwfbtsviynDc8nW4mPsRYKb25VgJmdv39Kg3lPlnl9H8GVRTVOkbwC5gUQA25KegFGfRc1ERYyjUMPyQv5xwwDNSuvt+2Idayg6QErNd7xTX4/yaLkUbNKc9iBJ+5KZOUD6tUBJxj0FQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654542; c=relaxed/simple;
	bh=cNLPLCx3z9sWSU1ABEKIVJxfcOOQXzRqqgFX7jr1Mmk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GrfDlMFoQEtfVyPTIPY+iAHUig+AOsTucDIw8aTTzxHbQF6P7dJqbTZpQcgTde5fR3GfXMBsLhxUg3Y5AnY+F8RUCPVOmuIKaVQ6o6aumSwoOxGzNcajYoAjoAkVmbM+wuxL3+4sdGV9amB50+UdRhrNiahlxLrDHRRCmz+SYYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=040Ub9iq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="040Ub9iq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A6201F000E9;
	Tue, 21 Jul 2026 17:22:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654541;
	bh=nvs6f2npQ7xShhYBICXKIY0UlQbY/9e6ntKwQpQ0W5w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=040Ub9iqeOzHmgsIXfDbGWZ3GSxwC2Yu32uAjjfPKmZvzpIVtUaZ26dc0JL0+m3wu
	 5MrEncO1sS0nI7tpNLBFey4GqaxSb8O27nWrowaHla5xyKgiulO8nleQoxyLpK2ibI
	 qYYB0K3hrDzIX/rmc3q5/hw/mqJJM5H62M5GGcfo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stafford Horne <shorne@gmail.com>
Subject: [PATCH 7.1 1743/2077] openrisc: Add full instruction cache invalidate functions
Date: Tue, 21 Jul 2026 17:23:36 +0200
Message-ID: <20260721152633.858380235@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stafford Horne <shorne@gmail.com>

commit 1be031de802ba486a7605b52eda825f128b026e2 upstream.

Add functions to invalidate all cache lines which we will use for
static_key patching.

On OpenRISC there is no instruction to invalidate an entire cache so we
loop and invalidate cache lines one by one.  This is not extremely
expensive on OpenRISC as we usually have only a few hundred cache lines.

I considered using the invalidate cache page or range functions.
However, tracking which ranges need invalidation would have been more
expensive than flushing all pages.

Cc: stable@vger.kernel.org
Signed-off-by: Stafford Horne <shorne@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/openrisc/include/asm/cacheflush.h |    4 ++++
 arch/openrisc/kernel/smp.c             |   21 +++++++++++++++++++++
 arch/openrisc/mm/cache.c               |   16 ++++++++++++++++
 3 files changed, 41 insertions(+)

--- a/arch/openrisc/include/asm/cacheflush.h
+++ b/arch/openrisc/include/asm/cacheflush.h
@@ -26,6 +26,7 @@ extern void local_icache_page_inv(struct
 extern void local_dcache_range_flush(unsigned long start, unsigned long end);
 extern void local_dcache_range_inv(unsigned long start, unsigned long end);
 extern void local_icache_range_inv(unsigned long start, unsigned long end);
+extern void local_icache_all_inv(void);
 
 /*
  * Data cache flushing always happen on the local cpu. Instruction cache
@@ -35,10 +36,13 @@ extern void local_icache_range_inv(unsig
 #ifndef CONFIG_SMP
 #define dcache_page_flush(page)      local_dcache_page_flush(page)
 #define icache_page_inv(page)        local_icache_page_inv(page)
+#define icache_all_inv()             local_icache_all_inv()
 #else  /* CONFIG_SMP */
 #define dcache_page_flush(page)      local_dcache_page_flush(page)
 #define icache_page_inv(page)        smp_icache_page_inv(page)
+#define icache_all_inv()             smp_icache_all_inv()
 extern void smp_icache_page_inv(struct page *page);
+extern void smp_icache_all_inv(void);
 #endif /* CONFIG_SMP */
 
 /*
--- a/arch/openrisc/kernel/smp.c
+++ b/arch/openrisc/kernel/smp.c
@@ -346,3 +346,24 @@ void smp_icache_page_inv(struct page *pa
 	on_each_cpu(ipi_icache_page_inv, page, 1);
 }
 EXPORT_SYMBOL(smp_icache_page_inv);
+
+static void ipi_icache_all_inv(void *arg)
+{
+	local_icache_all_inv();
+}
+
+void smp_icache_all_inv(void)
+{
+	if (num_online_cpus() < 2) {
+		local_icache_all_inv();
+		return;
+	}
+
+	/*
+	 * Ensure stores complete before we request remote icaches
+	 * to invalidate.
+	 */
+	mb();
+
+	on_each_cpu(ipi_icache_all_inv, NULL, 1);
+}
--- a/arch/openrisc/mm/cache.c
+++ b/arch/openrisc/mm/cache.c
@@ -63,6 +63,22 @@ void local_icache_page_inv(struct page *
 }
 EXPORT_SYMBOL(local_icache_page_inv);
 
+void local_icache_all_inv(void)
+{
+	if (cpu_cache_is_present(SPR_UPR_ICP)) {
+		unsigned long iccfgr = mfspr(SPR_ICCFGR);
+		unsigned long sets = 1 << ((iccfgr & SPR_ICCFGR_NCS) >> 3);
+		unsigned long block_size = 16 << ((iccfgr & SPR_ICCFGR_CBS) >> 7);
+		unsigned long paddr = 0;
+		unsigned long end = sets * block_size;
+
+		while (paddr < end) {
+			mtspr(SPR_ICBIR, paddr);
+			paddr += block_size;
+		}
+	}
+}
+
 void local_dcache_range_flush(unsigned long start, unsigned long end)
 {
 	cache_loop(start, end, SPR_DCBFR, SPR_UPR_DCP);


