Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C4CC5625FF;
	Wed,  9 Sep 2026 14:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964859; cv=none; b=bRPg7Z6amluRlbJR3eWBKgdGRwWZ0GRKF1umcyNBHM605nQuTEyTtWMw5mDznrUctyAU6tkUdBMNlpE+UH7ERHPDmbIE038rWpb5qhxpoLPcM1Dri/MPrU9jzzHtvHFSRrBPFu8t+iPs1fgZH+Xty/cknH6BYe622nNjYSiGNTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964859; c=relaxed/simple;
	bh=thNjYSXpmTEswnuwk6IPrCqrrokgijGCqvhfYureu8w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LQVDAZis3g/2jQmfFACsWjvM6lOjpDrPlZF8gZgu/bUHSvuqMtgJ0/Kbdc0JrxtYs3JSu0MTF3m4qLtMkXavx1ma9t9nMGlb4VuOpQTpJrBqwv93WGCY0ibwE0U4QRnRvOOGpkPLIyK4SU2jWQcNR6G/YrggHKzOKAjkaLwydro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hWHmG8lX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hWHmG8lX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F396D1F00A3A;
	Wed,  9 Sep 2026 14:40:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964858;
	bh=Ros/JDMw+2oE0K2lLtFRZQ3VBs8VIONM1LffRHuwbY4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hWHmG8lXxjjcUmMBy01JNg8gbJ4tu843eVSt4DBwx2lb6Tu/+MXIMw//jdVnRm2t3
	 OfON/faYiJi6VSzqZDLCN5hzDSdFNF6ab9dDpk4hngN9zMJbhv8TSDJreJnx9yAS2g
	 A+hi6J2m50mbztoHo6b2t/h+uzFXxmLyiL+YaBQw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 569/583] mm/damon/paddr: drop last same folio access check reuse optimization
Date: Wed,  9 Sep 2026 15:44:14 +0200
Message-ID: <20260909134257.502302269@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

From: SJ Park <sj@kernel.org>

commit f23f0aa62b2f32c2b12f95959fc4603ef81678b2 upstream.

It can race when multiple kdamonds are being used.  The problem from the
race is doubtful, but the gain from the optimization is also doubtful.
Simply drop the optimization in favor of code simplicity.

The user impact is doubtfully trivial.  After all, this kind of
interference can happen only by intentional user setup.  Even if it
happens, it will be rare, and the consequence is degradation of the
best-effort monitoring results.  No critical consequences like kernel
panic or memory corruption happen.

The race was discovered [1] by Sashiko.

Link: https://lore.kernel.org/20260715031002.108504-5-sj@kernel.org
Link: https://lore.kernel.org/20260621204050.10993-1-sj@kernel.org [1]
Fixes: a28397beb55b ("mm/damon: implement primitives for physical address space monitoring")
Signed-off-by: SJ Park <sj@kernel.org>
Cc: <stable@vger.kernel.org> # 5.16.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/paddr.c |   20 ++++----------------
 1 file changed, 4 insertions(+), 16 deletions(-)

--- a/mm/damon/paddr.c
+++ b/mm/damon/paddr.c
@@ -67,7 +67,7 @@ static void damon_pa_prepare_access_chec
 	}
 }
 
-static bool damon_pa_young(phys_addr_t paddr, unsigned long *folio_sz)
+static bool damon_pa_young(phys_addr_t paddr)
 {
 	struct folio *folio = damon_get_folio(PHYS_PFN(paddr));
 	bool accessed;
@@ -76,7 +76,6 @@ static bool damon_pa_young(phys_addr_t p
 		return false;
 
 	accessed = damon_folio_young(folio);
-	*folio_sz = folio_size(folio);
 	folio_put(folio);
 	return accessed;
 }
@@ -84,23 +83,12 @@ static bool damon_pa_young(phys_addr_t p
 static void __damon_pa_check_access(struct damon_region *r,
 		struct damon_attrs *attrs, unsigned long addr_unit)
 {
-	static phys_addr_t last_addr;
-	static unsigned long last_folio_sz = PAGE_SIZE;
-	static bool last_accessed;
+	bool accessed;
 	phys_addr_t sampling_addr = damon_pa_phys_addr(
 			r->sampling_addr, addr_unit);
 
-	/* If the region is in the last checked page, reuse the result */
-	if (ALIGN_DOWN(last_addr, last_folio_sz) ==
-				ALIGN_DOWN(sampling_addr, last_folio_sz)) {
-		damon_update_region_access_rate(r, last_accessed, attrs);
-		return;
-	}
-
-	last_accessed = damon_pa_young(sampling_addr, &last_folio_sz);
-	damon_update_region_access_rate(r, last_accessed, attrs);
-
-	last_addr = sampling_addr;
+	accessed = damon_pa_young(sampling_addr);
+	damon_update_region_access_rate(r, accessed, attrs);
 }
 
 static unsigned int damon_pa_check_accesses(struct damon_ctx *ctx)


