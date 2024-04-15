Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B153378685;
	Mon, 15 Apr 2024 14:38:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191917; cv=none; b=mWLDoYYWOdsfw3/2POziFjhorg9w/Rbp5+ITPSZqhALIDqxd3Vg391GRq83bQqZNAyBiWHx6a5XcOds7CibGHiC8K8CUHTyg5O2+v6ztKfkVia17j9D2NABQZctW15HR6Qv0L8sUUpyqw186Ojmdc5pqJGU6pyKSAogMYnkMBXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191917; c=relaxed/simple;
	bh=KstyiJDBRMBByego7vhIAwHySaxRsMbSx4MW0V2HwWY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fu4BQLvmpdR1p8TB6W2aZCOQIKHajC8XzkB8mHMEFQVeulJE7BWdGdpIs9CK7P8aXnooIDcOyrKjyGHAusXrQPK4BA8hbEe8TCRrhDrsMDzz8EU78dKLDqNcNtC34ckKUnjCvlQf32eBDVCZUwrZrApaIrn1uCa0Lf9MD3lFg0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c/9Frdg8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c/9Frdg8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A80CC113CC;
	Mon, 15 Apr 2024 14:38:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191917;
	bh=KstyiJDBRMBByego7vhIAwHySaxRsMbSx4MW0V2HwWY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c/9Frdg8GcwlTHHJeaV+26cGjuH5PdpjGH9lVfNUG+xwJ5pdCvznBWxsC5Xt1vC7r
	 xgSyzwjEiy4vBCREMKoioICGX415hFjbyWQZSSfgB1rsjCYWGuhHXGhznZtdcENZUI
	 VoVi3FdjsAUaTYUbCpMJpvgM3W32kPALrA86Lcec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steven Price <steven.price@arm.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Dmitry Osipenko <dmitry.osipenko@collabora.com>
Subject: [PATCH 6.6 092/122] drm/panfrost: Fix the error path in panfrost_mmu_map_fault_addr()
Date: Mon, 15 Apr 2024 16:20:57 +0200
Message-ID: <20240415141956.135930511@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141953.365222063@linuxfoundation.org>
References: <20240415141953.365222063@linuxfoundation.org>
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

From: Boris Brezillon <boris.brezillon@collabora.com>

commit 1fc9af813b25e146d3607669247d0f970f5a87c3 upstream.

Subject: [PATCH 6.6 092/122] drm/panfrost: Fix the error path in panfrost_mmu_map_fault_addr()

If some the pages or sgt allocation failed, we shouldn't release the
pages ref we got earlier, otherwise we will end up with unbalanced
get/put_pages() calls. We should instead leave everything in place
and let the BO release function deal with extra cleanup when the object
is destroyed, or let the fault handler try again next time it's called.

Fixes: 187d2929206e ("drm/panfrost: Add support for GPU heap allocations")
Cc: <stable@vger.kernel.org>
Reviewed-by: Steven Price <steven.price@arm.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
Co-developed-by: Dmitry Osipenko <dmitry.osipenko@collabora.com>
Signed-off-by: Dmitry Osipenko <dmitry.osipenko@collabora.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240105184624.508603-18-dmitry.osipenko@collabora.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/panfrost/panfrost_mmu.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/panfrost/panfrost_mmu.c
+++ b/drivers/gpu/drm/panfrost/panfrost_mmu.c
@@ -500,11 +500,18 @@ static int panfrost_mmu_map_fault_addr(s
 	mapping_set_unevictable(mapping);
 
 	for (i = page_offset; i < page_offset + NUM_FAULT_PAGES; i++) {
+		/* Can happen if the last fault only partially filled this
+		 * section of the pages array before failing. In that case
+		 * we skip already filled pages.
+		 */
+		if (pages[i])
+			continue;
+
 		pages[i] = shmem_read_mapping_page(mapping, i);
 		if (IS_ERR(pages[i])) {
 			ret = PTR_ERR(pages[i]);
 			pages[i] = NULL;
-			goto err_pages;
+			goto err_unlock;
 		}
 	}
 
@@ -512,7 +519,7 @@ static int panfrost_mmu_map_fault_addr(s
 	ret = sg_alloc_table_from_pages(sgt, pages + page_offset,
 					NUM_FAULT_PAGES, 0, SZ_2M, GFP_KERNEL);
 	if (ret)
-		goto err_pages;
+		goto err_unlock;
 
 	ret = dma_map_sgtable(pfdev->dev, sgt, DMA_BIDIRECTIONAL, 0);
 	if (ret)
@@ -534,8 +541,6 @@ out:
 
 err_map:
 	sg_free_table(sgt);
-err_pages:
-	drm_gem_shmem_put_pages(&bo->base);
 err_unlock:
 	dma_resv_unlock(obj->resv);
 err_bo:


