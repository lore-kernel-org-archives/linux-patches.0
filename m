Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72EC93BBFD0;
	Sat, 12 Sep 2026 20:06:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789243571; cv=none; b=N+5VK99EpcAQJsZmV4Or3v9mU3thOvWwms+MBaKV6viwx4zz086a8DXOHolc84x8xuiAs3DIgALEQsjxKKumMy5psadx8HtluFgTOkz/pOUFVzENllQ9iFXB9c9GOvJRpcUcxvnfPbTRPL76PykuPDm6Q0iFbHpQAlir58Lz1Fw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789243571; c=relaxed/simple;
	bh=a4o1SkMV0xzmQnLdXP/FM5qktmcAsvVqq8iWLjFV7Js=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GKstr1hxLGA2tPlFRie382loMDFDo+V/LCN5uIAepGCMeeyp/qTyYciBKR1cJQJl5PCnK9a2uAfUw42Uj+ld23Dg4MTreccq5SekcW76QATL+SG3v8NrrRmXnyt2ZazYGFtq0Yoya4jrM0xB4kPjmSWJqB3oQJEN5SSBxkPQK68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=raG1jQ9S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="raG1jQ9S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCBDA1F000FF;
	Sat, 12 Sep 2026 20:06:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789243569;
	bh=VX4ngPm5yiXpDigyoPCD4xJh3mQxCKC55nzUjaBSGYE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=raG1jQ9SI9Cc7Z4xfWxymlh5IfgflZ8z3PYw3+P50hXT1y7uGJyBrtxvqqW+oWjt7
	 kYoky7FpONzvnVMultvRG3HBli7fMAXFawLm4Mc7AwGJMwhYDsh2VoGqEIBxbbBASd
	 Ty/pLx2LpITLzBigE1nsZvvB+TKCxS/7PI1RWSu8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	vtolkm@googlemail.com,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 791/798] mm/highmem: Take kmap_high_get() properly into account
Date: Sat, 12 Sep 2026 09:06:59 +0200
Message-ID: <20260912065535.191128110@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

[ Upstream commit 2a656cad337e0e1ca582f58847d7b0c7eeba4dc8 ]

kunmap_local() warns when the virtual address to unmap is below
PAGE_OFFSET. This is correct except for the case that the mapping was
obtained via kmap_high_get() because the PKMAP addresses are right below
PAGE_OFFSET.

Cure it by skipping the WARN_ON() when the unmap was handled by
kunmap_high().

Fixes: 298fa1ad5571 ("highmem: Provide generic variant of kmap_atomic*")
Reported-by: vtolkm@googlemail.com
Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
Tested-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Link: https://lore.kernel.org/r/87y2j6n8mj.fsf@nanos.tec.linutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/highmem.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/mm/highmem.c b/mm/highmem.c
index ac81a3363db09..fec263e598553 100644
--- a/mm/highmem.c
+++ b/mm/highmem.c
@@ -426,12 +426,15 @@ static inline void *arch_kmap_local_high_get(struct page *page)
 #endif
 
 /* Unmap a local mapping which was obtained by kmap_high_get() */
-static inline void kmap_high_unmap_local(unsigned long vaddr)
+static inline bool kmap_high_unmap_local(unsigned long vaddr)
 {
 #ifdef ARCH_NEEDS_KMAP_HIGH_GET
-	if (vaddr >= PKMAP_ADDR(0) && vaddr < PKMAP_ADDR(LAST_PKMAP))
+	if (vaddr >= PKMAP_ADDR(0) && vaddr < PKMAP_ADDR(LAST_PKMAP)) {
 		kunmap_high(pte_page(pkmap_page_table[PKMAP_NR(vaddr)]));
+		return true;
+	}
 #endif
+	return false;
 }
 
 static inline int kmap_local_calc_idx(int idx)
@@ -491,10 +494,14 @@ void kunmap_local_indexed(void *vaddr)
 
 	if (addr < __fix_to_virt(FIX_KMAP_END) ||
 	    addr > __fix_to_virt(FIX_KMAP_BEGIN)) {
-		WARN_ON_ONCE(addr < PAGE_OFFSET);
-
-		/* Handle mappings which were obtained by kmap_high_get() */
-		kmap_high_unmap_local(addr);
+		/*
+		 * Handle mappings which were obtained by kmap_high_get()
+		 * first as the virtual address of such mappings is below
+		 * PAGE_OFFSET. Warn for all other addresses which are in
+		 * the user space part of the virtual address space.
+		 */
+		if (!kmap_high_unmap_local(addr))
+			WARN_ON_ONCE(addr < PAGE_OFFSET);
 		return;
 	}
 
-- 
2.53.0



