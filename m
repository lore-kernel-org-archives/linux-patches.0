Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F235E4DDB23;
	Wed, 30 Sep 2026 16:57:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787461; cv=none; b=jQkuPw6oRqh3gV5DpGrTyCBdeLBmdKFiFfP20cEBbz3oO5otEnP34NGTId/9juc+qW3AiWl4CkqLpFWn8D2sUugxt+Gg+mxycYKq7Oxd1XkLNh3UPJNIuWrow61EsC3BqtrLT8LI+CzLMzHRLqnbYYiufw69wQ794Hu5cZ1WCF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787461; c=relaxed/simple;
	bh=fE5bKVnsYIk9M97j3fSZ1QDZZjtzWewmYGeST7Xmgyo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DLp98GY/tG5SuU/WkWcjPGkxNw8LS5qLmKjT8lHHq6Q4sNLiXgd0mcZlZk//7E/Yn/v2wv3rayHmWTHygZ8Sw2FZI2lB/UdOa1a7NlM+KCqHB1Pv8WLPqCWryRtRXcs8N70GfcLHLcCxnHTvT1thg7q8JKEp0IvlnfrhgcwWsrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1GcvBLho; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1GcvBLho"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 596201F000FF;
	Wed, 30 Sep 2026 16:57:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787459;
	bh=lNMeV/BDztMxfYPOgAz9GHD7+Vo/GTDm5IZ41TF7Lnk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1GcvBLho7OMXKmsQuWtvWPKdteDaCIiIQBKBr50PguvXmp73tX75Onr2YPkX0pg78
	 OS/r9rZQo3ajcw9lGjVrcudjkTdPs554rDZzhBrydaRfKUfZ/cmrcy69nhZnx2JpJE
	 9V3NeRioPgTstzbpNIzpgOxKZSsO5SJu8VKgzt8E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Matthew Brost <matthew.brost@intel.com>,
	Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 237/457] drm/pagemap: dma-unmap pages before handling migration errors
Date: Wed, 30 Sep 2026 17:25:42 +0200
Message-ID: <20260930152351.159556387@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_pagemap.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/drm_pagemap.c b/drivers/gpu/drm/drm_pagemap.c
index 89e1ddff84dd2..a0546955d0b9f 100644
--- a/drivers/gpu/drm/drm_pagemap.c
+++ b/drivers/gpu/drm/drm_pagemap.c
@@ -1368,13 +1368,13 @@ int drm_pagemap_evict_to_ram(struct drm_pagemap_devmem *devmem_allocation)
 		goto err_finalize;
 
 err_finalize:
+	drm_pagemap_migrate_unmap_pages(devmem_allocation->dev, pagemap_addr, dst, npages,
+					DMA_FROM_DEVICE, &state);
 	if (err)
 		drm_pagemap_migration_unlock_put_pages(npages, dst);
 	migrate_device_pages(src, dst, npages);
 	drm_pagemap_retire_migrated_pages(src, npages);
 	migrate_device_finalize(src, dst, npages);
-	drm_pagemap_migrate_unmap_pages(devmem_allocation->dev, pagemap_addr, dst, npages,
-					DMA_FROM_DEVICE, &state);
 
 err_free:
 	kvfree(buf);
@@ -1494,15 +1494,15 @@ static int __drm_pagemap_migrate_to_ram(struct vm_area_struct *vas,
 		goto err_finalize;
 
 err_finalize:
+	if (dev)
+		drm_pagemap_migrate_unmap_pages(dev, pagemap_addr, migrate.dst,
+						npages, DMA_FROM_DEVICE,
+						&state);
 	if (err)
 		drm_pagemap_migration_unlock_put_pages(npages, migrate.dst);
 	migrate_vma_pages(&migrate);
 	drm_pagemap_retire_migrated_pages(migrate.src, npages);
 	migrate_vma_finalize(&migrate);
-	if (dev)
-		drm_pagemap_migrate_unmap_pages(dev, pagemap_addr, migrate.dst,
-						npages, DMA_FROM_DEVICE,
-						&state);
 err_free:
 	kvfree(buf);
 err_out:
-- 
2.53.0



