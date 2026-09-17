Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FA464D17B4;
	Thu, 17 Sep 2026 17:44:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667094; cv=none; b=ZoEGqUBfHbWNoaeioTj20p8rXTyDD3aVJGDKfxlqOKTqriIfeG60hsFiw6Gj3S1V41QD2biuTaUzcEdIxyWusoCxdFqiUD9gscMCkL8Zw9CP/5+ZicXgR6iGvzjxzFyQ/lh9pBDeiTyIHskLmq5w9p1K6TtCwOuq0TIdkoB1B/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667094; c=relaxed/simple;
	bh=qdjEKrkuNF9Fo039UXZqhILbModzbHLcQg7FmwVIPGY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DlREoV0/qdEqGXfcQJGM+ILEwtXwwlPiXRHKP8YWcFS+Gppeyes5fzgE4v/FiPgLXZsdNWfN2gkrc2QEKrBTuW8yPcxzhgAz9pCvLf+HcE8GwH5v0N2rW/9Ugsc9HpFuejtDT8mEMCTxsronH6BAueTNVwGpLKzqT+DKMwlwq1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uOrOwMcM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uOrOwMcM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33E591F000FF;
	Thu, 17 Sep 2026 17:44:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667092;
	bh=aEDAV6/gGGcFEqYJUo4sH++90K2B/X8HQgSDJcXx07Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uOrOwMcMHAQoygJUsNKuvxgCbmlzyOQZRairqlgVogp+wVoZWU7AfkOUjs9XMVVPO
	 BK3qA518fgThM86uk80auSKo32Y8TlurMAaGMhpy7gzA8Zspw5ioaP9G6rLTOhSh/S
	 mAG5wm+tHr4PpwdXPfrJdjb0WElM6EEctxoqQPdQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Matthew Brost <matthew.brost@intel.com>,
	Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1189/1250] drm/pagemap: dma-unmap pages before handling migration errors
Date: Thu, 17 Sep 2026 16:16:24 +0100
Message-ID: <20260917151624.511666771@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Matthew Brost <matthew.brost@intel.com>

[ Upstream commit 9e6372ec2a3990662ae0a67f56ac0aee19848d5b ]

drm_pagemap_migrate_unmap_pages() relies on the pages array to determine
which pages require DMA unmapping. However,
drm_pagemap_migration_unlock_put_pages() clears the array as part of its
cleanup, leaving drm_pagemap_migrate_unmap_pages() with no valid page
information if it is called afterward.

Call drm_pagemap_migrate_unmap_pages() before
drm_pagemap_migration_unlock_put_pages() so the pages array remains
valid during DMA unmapping.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Fixes: f86ad0ed620c ("drm/gpusvm, drm/pagemap: Move migration functionality to drm_pagemap")
Cc: stable@vger.kernel.org
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Reviewed-by: Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>
Link: https://patch.msgid.link/20260902063504.3024362-1-matthew.brost@intel.com
[ Adapted DMA-unmap calls to the older helper signature without destination-page or IOVA-state arguments. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_pagemap.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/drm_pagemap.c
+++ b/drivers/gpu/drm/drm_pagemap.c
@@ -606,12 +606,12 @@ retry:
 		goto err_finalize;
 
 err_finalize:
+	drm_pagemap_migrate_unmap_pages(devmem_allocation->dev, pagemap_addr, npages,
+					DMA_FROM_DEVICE);
 	if (err)
 		drm_pagemap_migration_unlock_put_pages(npages, dst);
 	migrate_device_pages(src, dst, npages);
 	migrate_device_finalize(src, dst, npages);
-	drm_pagemap_migrate_unmap_pages(devmem_allocation->dev, pagemap_addr, npages,
-					DMA_FROM_DEVICE);
 err_free:
 	kvfree(buf);
 err_out:
@@ -742,13 +742,13 @@ static int __drm_pagemap_migrate_to_ram(
 		goto err_finalize;
 
 err_finalize:
+	if (dev)
+		drm_pagemap_migrate_unmap_pages(dev, pagemap_addr, npages,
+						DMA_FROM_DEVICE);
 	if (err)
 		drm_pagemap_migration_unlock_put_pages(npages, migrate.dst);
 	migrate_vma_pages(&migrate);
 	migrate_vma_finalize(&migrate);
-	if (dev)
-		drm_pagemap_migrate_unmap_pages(dev, pagemap_addr, npages,
-						DMA_FROM_DEVICE);
 err_free:
 	kvfree(buf);
 err_out:


