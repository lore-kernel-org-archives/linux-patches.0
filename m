Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18A2733AD8A;
	Tue, 21 Jul 2026 18:32:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658756; cv=none; b=n5h6UZHP4mKs+w0RE+wM6kAdo0qe/zgDTwJcbRxJi3A2f1sdgOpQLIIsPS5nty4L3OgV0TZVTNyTrJ0oxq9JQfLhiikGBNncgKzw/gfy/QYQPa+HZdeiZ+W4JEPFEwFHCKjABzx9J2NZB4dx/TSUNkXOEPseKFfCSZ9h9vREr38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658756; c=relaxed/simple;
	bh=Z7/DaLeDBKEeQAE6+Fp3RV/Aahp2V3O4dvNHedrDzSw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DXRiIm+XNqbX4EQCR2anRWcRLx74t5XmgkZkKKXNzS2KAqZk2NqFcuGORv6+TctE8vH6MHibTaq9zoGaqacpWnmEWtUDHT2OJvYbs+RLt1viYE+9xhvJKyvKVavzk51EqWGqBxj1HqWAVkvvErsbNlsR8/KicETxkOH4Mpkzr3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0ZFg9LTN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0ZFg9LTN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F2811F000E9;
	Tue, 21 Jul 2026 18:32:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658755;
	bh=tvv/5nDP0kEKrgC1tGi0vvUCi9zxcPOGld6hzqcYS5Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0ZFg9LTNOti7uBlpKKABsiN8pJmPHq9J2+dPIArPZ3YYiUL5gdOoDovbOaEAP6pGI
	 6GHd3V8KjfoD2aPQr1eLSqG8FeZD4dRJg9OjO64PZVA6/bfHYXYOf7ldAnGZb/jIAs
	 5K8UaVjGj31OgJthCgIsI/M3TJJOMWDwknguRpRc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stafford Horne <shorne@gmail.com>
Subject: [PATCH 6.18 1264/1611] openrisc: Add full instruction cache invalidate functions
Date: Tue, 21 Jul 2026 17:23:00 +0200
Message-ID: <20260721152543.880271196@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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
@@ -326,3 +326,24 @@ void smp_icache_page_inv(struct page *pa
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


