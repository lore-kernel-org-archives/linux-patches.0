Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 169A43A16AC;
	Tue, 16 Jun 2026 16:09:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781626199; cv=none; b=mzlmNT1ih+ywWH2ZA51ZZoqceQv6EomIyNLrgfusvneKVOzsiu9ukIcybZH5jeMAV9zm9LbielpFnt2Q5xllPpz2GveMY3AtohK+NvQoAxGZ1zPSq/4xymYYJvFFBDAE1MM0kAGTB/7iHJ760jxu4vIoHkq7Ys9jFwpIgFmq1GE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781626199; c=relaxed/simple;
	bh=MJYlD7DFYEngLdIGmfj53VhW/ksP9Wi4FyjzCtbkAvA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DnboCNM2Fcc6DNigQXro0vmECqvbyKPOxuXtYx/vaa3aGCPX1IaRWxnp32rAa13a+4O75zvkrhkpipfKUZDAJ4tp5LSNv1J/d/0rQO3fYWudNFdtWnIkWFHMzHa9iJBn7HLh/R6yW8chblinNZsb0wt/RCuzFoTfEkOvKxciOtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qXhOV4BG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qXhOV4BG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F2221F000E9;
	Tue, 16 Jun 2026 16:09:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781626198;
	bh=GlRnMTyI3l5/c60c+CTDBM9Cq+CqVHmbwSYybDcMOQ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qXhOV4BGZgk7ojFazYDgR5/eCATo8Zf6VL53VfPpnquscexalAnmn0rdR/LKKnwiR
	 dRNt20OMLO8zzoAZqkStuMEy5GYwxX14xoeZZP6bdoOLPx2bALktSgSpG5RXkoeYsp
	 TyRABjRbu1aIwuds2pJ14sjjZg6HSkaBTP84WetA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muchun Song <songmuchun@bytedance.com>,
	"Oscar Salvador (SUSE)" <osalvador@kernel.org>,
	Usama Arif <usama.arif@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Frank van der Linden <fvdl@google.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 249/325] mm/cma: fix reserved page leak on activation failure
Date: Tue, 16 Jun 2026 20:30:45 +0530
Message-ID: <20260616145110.912787365@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
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

From: Muchun Song <songmuchun@bytedance.com>

commit 00739e4dd46dde2b39dd9dd19a27e3c8af4ca0d0 upstream.

If cma_activate_area() fails after allocating only part of the range
bitmaps, the cleanup path still has to release the reserved pages when
CMA_RESERVE_PAGES_ON_ERROR is clear.

That is still worth doing even in this __init path.  A bitmap_zalloc()
failure does not necessarily mean the system cannot make further progress:
freeing the reserved CMA pages can return a substantial amount of memory
to the buddy allocator and may relieve the temporary memory shortage that
caused the allocation failure in the first place.

However, the cleanup path currently uses the bitmap-freeing bound for page
release as well.  That is only correct for ranges whose bitmap allocation
already succeeded.  The failed range and all later ranges still keep their
reserved pages, so a partial bitmap allocation failure can permanently
leak them.

Fix this by releasing reserved pages for all ranges.  Use the saved
early_pfn[] value for ranges whose bitmap allocation already succeeded and
for the failed range, and use cmr->early_pfn for later ranges whose bitmap
allocation was never attempted.

Link: https://lore.kernel.org/20260523060123.2207992-1-songmuchun@bytedance.com
Fixes: c009da4258f9 ("mm, cma: support multiple contiguous ranges, if requested")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Oscar Salvador (SUSE) <osalvador@kernel.org>
Acked-by: Usama Arif <usama.arif@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: Frank van der Linden <fvdl@google.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/cma.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/mm/cma.c
+++ b/mm/cma.c
@@ -186,10 +186,13 @@ cleanup:
 
 	/* Expose all pages to the buddy, they are useless for CMA. */
 	if (!test_bit(CMA_RESERVE_PAGES_ON_ERROR, &cma->flags)) {
-		for (r = 0; r < allocrange; r++) {
+		for (r = 0; r < cma->nranges; r++) {
+			unsigned long start_pfn;
+
 			cmr = &cma->ranges[r];
+			start_pfn = r <= allocrange ? early_pfn[r] : cmr->early_pfn;
 			end_pfn = cmr->base_pfn + cmr->count;
-			for (pfn = early_pfn[r]; pfn < end_pfn; pfn++)
+			for (pfn = start_pfn; pfn < end_pfn; pfn++)
 				free_reserved_page(pfn_to_page(pfn));
 		}
 	}


