Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14A2E31E833;
	Thu, 30 Jul 2026 14:42:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422524; cv=none; b=GWKlR+3TAbYfWsOUjEpptvhyhS6FU7EesujbqX8vdAXdQAm1CRG2/owLCChsCqQsNW/kBbUrk3Sit9S93IuutG0llUbsx+mEDk+4F49ETSL+TyMYkNCqKePYj5T4+aBQrs4kghmGPjOQRufmtWlLyPusUnO050c1m8z0ZoIrnIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422524; c=relaxed/simple;
	bh=KoiPvKX0fUvPuUy0W52sV2hnOl97zroK1RbK8WVT5wc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jSvVd0/pr5PCR70fQOb0uEwOp5Qr+PLL96k2PvhfsDfM3rH2vz9kF5RdNKJ5JfW2L+sMbYWRQbT7yWEETiqafMI/9PYOqP82qBmOFOVtZUDRynZziJnToaMDuaLZuc0LBfmxxczT0beKw7PP+K6zM4seLw8AXUPalSzlvD5bO2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sgJLqEd4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sgJLqEd4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 516B31F000E9;
	Thu, 30 Jul 2026 14:42:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422522;
	bh=JjGLuzvYr7/L0mkSTk2PpnlSm9rVCvFtr/MlWqfk5fU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sgJLqEd4VpY3OtGps9XXgnm1snDWt6YiMLCxIfE4Qa648frx2Z8RG9n8wkQrVOVBl
	 hmjpPERub6pydIuZUM70vw5sDgKcE1rUNzSSRRnMBVv9COhCqU8Bq8BsgNhGwgFM0a
	 4ezaQcpJZBaBEdoAsuPVjEUgOfa3k1S/iyBRuoVY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Jan Stancek <jstancek@redhat.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>
Subject: [PATCH 7.1 469/744] drm/pagemap: Guard HPAGE_PMD_ORDER use with CONFIG_ARCH_ENABLE_THP_MIGRATION
Date: Thu, 30 Jul 2026 16:12:22 +0200
Message-ID: <20260730141454.266756979@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

From: Matthew Brost <matthew.brost@intel.com>

commit 04b177544a040cbafab760d6b766381c6b22e0a8 upstream.

HPAGE_PMD_SHIFT expands to BUILD_BUG() when CONFIG_PGTABLE_HAS_HUGE_LEAVES
is not set, causing a compile error when both CONFIG_TRANSPARENT_HUGEPAGE
and CONFIG_HUGETLB_PAGE are disabled:

 drivers/gpu/drm/drm_pagemap.c:480:12: error: call to '__compiletime_assert_458'
 declared with 'error' attribute: BUILD_BUG failed
   480 |                         order = HPAGE_PMD_ORDER;
       |                                 ^
 include/linux/huge_mm.h:117:26: note: expanded from macro 'HPAGE_PMD_ORDER'
   117 | #define HPAGE_PMD_ORDER (HPAGE_PMD_SHIFT-PAGE_SHIFT)
       |                          ^
 include/linux/huge_mm.h:113:28: note: expanded from macro 'HPAGE_PMD_SHIFT'
   113 | #define HPAGE_PMD_SHIFT ({ BUILD_BUG(); 0; })

Define DRM_PAGEMAP_PMD_ORDER, which maps to HPAGE_PMD_ORDER when
CONFIG_ARCH_ENABLE_THP_MIGRATION is enabled and to -1 otherwise.

This is safe because all code paths that use DRM_PAGEMAP_PMD_ORDER are
reachable only when CONFIG_ARCH_ENABLE_THP_MIGRATION is enabled.

Fixes: 139ab31aea8a ("drm/pagemap: Correct cpages calculation for migrate_vma_setup")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/r/202607201914.LpAGsbXs-lkp@intel.com/
Cc: Jan Stancek <jstancek@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Tested-by: Jan Stancek <jstancek@redhat.com>
Reviewed-by: Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>
Link: https://patch.msgid.link/20260721223244.1102276-1-matthew.brost@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_pagemap.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/drm_pagemap.c
+++ b/drivers/gpu/drm/drm_pagemap.c
@@ -12,6 +12,12 @@
 #include <drm/drm_pagemap_util.h>
 #include <drm/drm_print.h>
 
+#if IS_ENABLED(CONFIG_ARCH_ENABLE_THP_MIGRATION)
+#define DRM_PAGEMAP_PMD_ORDER	HPAGE_PMD_ORDER
+#else
+#define DRM_PAGEMAP_PMD_ORDER	(-1)
+#endif
+
 /**
  * DOC: Overview
  *
@@ -480,7 +486,7 @@ static int drm_pagemap_cpages(unsigned l
 			order = folio_order(folio);
 			cpages += NR_PAGES(order);
 		} else if (migrate_pfn[i] & MIGRATE_PFN_COMPOUND) {
-			order = HPAGE_PMD_ORDER;
+			order = DRM_PAGEMAP_PMD_ORDER;
 			cpages += NR_PAGES(order);
 		}
 
@@ -670,10 +676,11 @@ int drm_pagemap_migrate_to_devmem(struct
 
 		if (migrate.src[i] & MIGRATE_PFN_COMPOUND) {
 			drm_WARN_ONCE(dpagemap->drm, src_page &&
-				      folio_order(page_folio(src_page)) != HPAGE_PMD_ORDER,
+				      folio_order(page_folio(src_page)) !=
+				      DRM_PAGEMAP_PMD_ORDER,
 				      "Unexpected folio order\n");
 
-			order = HPAGE_PMD_ORDER;
+			order = DRM_PAGEMAP_PMD_ORDER;
 			migrate.dst[i] |= MIGRATE_PFN_COMPOUND;
 
 			for (j = 1; j < NR_PAGES(order) && i + j < npages; j++)


