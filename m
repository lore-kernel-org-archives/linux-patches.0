Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0452853365;
	Thu, 12 Dec 2024 16:38:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734021520; cv=none; b=ZpIk7rFq0aikGfrWB24yjLi/g0TQShVq/8ZWQ0Sb7eOOeU+ZAiAnrHSpUO4Ty8IDWSBh34WLb7/0YSnwXacA+IZF1Zk276SR8+eIO0s4zh1gCS1QpckBEN2sCNQx7xETNgtuOzcymSlKmqusVjeaMfb1CptVnVGLN750wJY45zA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734021520; c=relaxed/simple;
	bh=Nuh3KtAuXWeVr2oSzPioRoFTkn/4xsRa/JDtHk6vet0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VIn6yZii6zMVviUqLc/7K8PwWPnXXEfP5EseHBltF578GAnbtuKU5SP+RaFlnNRwfx89xMW5rKpk/gnVsHK3h7WrNc1YY3Wo6sMHiWotw/HxI3dXlmfmPtiIS0jUfb2waWr9Hwvl2lkDo0JytQFThspPwV9Kjis7sYTJNUU2VIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tUQ1cQBk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tUQ1cQBk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B943C4CECE;
	Thu, 12 Dec 2024 16:38:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734021519;
	bh=Nuh3KtAuXWeVr2oSzPioRoFTkn/4xsRa/JDtHk6vet0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tUQ1cQBkkt/yNlyR6XTwAo0kJUMRgJCXzz9a2a7MqYoY8SFLdiyHk2eeet+WfgbOi
	 7P/Kb8EX1PTBkfqKrd0LzM3+EUQ0s1BpMixRjaqAUiR3LUL+axikRQokBwxctWDTIn
	 p5PTVEMZfGgn/S2jBFSaHGKm1Ccb+/CDoUjbnSKg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zack Rusin <zack.rusin@broadcom.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Huang Rui <ray.huang@amd.com>,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org,
	Sasha Levin <sashal@kernel.org>,
	Ye Li <ye.li@broadcom.com>,
	Ajay Kaher <ajay.kaher@broadcom.com>
Subject: [PATCH 6.1 761/772] drm/ttm: Make sure the mapped tt pages are decrypted when needed
Date: Thu, 12 Dec 2024 16:01:46 +0100
Message-ID: <20241212144421.386264421@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zack Rusin <zack.rusin@broadcom.com>

commit 71ce046327cfd3aef3f93d1c44e091395eb03f8f upstream.

Some drivers require the mapped tt pages to be decrypted. In an ideal
world this would have been handled by the dma layer, but the TTM page
fault handling would have to be rewritten to able to do that.

A side-effect of the TTM page fault handling is using a dma allocation
per order (via ttm_pool_alloc_page) which makes it impossible to just
trivially use dma_mmap_attrs. As a result ttm has to be very careful
about trying to make its pgprot for the mapped tt pages match what
the dma layer thinks it is. At the ttm layer it's possible to
deduce the requirement to have tt pages decrypted by checking
whether coherent dma allocations have been requested and the system
is running with confidential computing technologies.

This approach isn't ideal but keeping TTM matching DMAs expectations
for the page properties is in general fragile, unfortunately proper
fix would require a rewrite of TTM's page fault handling.

Fixes vmwgfx with SEV enabled.

v2: Explicitly include cc_platform.h
v3: Use CC_ATTR_GUEST_MEM_ENCRYPT instead of CC_ATTR_MEM_ENCRYPT to
limit the scope to guests and log when memory decryption is enabled.

Signed-off-by: Zack Rusin <zack.rusin@broadcom.com>
Fixes: 3bf3710e3718 ("drm/ttm: Add a generic TTM memcpy move for page-based iomem")
Reviewed-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Acked-by: Christian König <christian.koenig@amd.com>
Cc: Huang Rui <ray.huang@amd.com>
Cc: dri-devel@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org
Cc: <stable@vger.kernel.org> # v5.14+
Link: https://patchwork.freedesktop.org/patch/msgid/20230926040359.3040017-1-zack@kde.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Ye Li <ye.li@broadcom.com>
Signed-off-by: Ajay Kaher <ajay.kaher@broadcom.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/ttm/ttm_bo_util.c |   13 +++++++++++--
 drivers/gpu/drm/ttm/ttm_tt.c      |   12 ++++++++++++
 include/drm/ttm/ttm_tt.h          |    7 +++++++
 3 files changed, 30 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/ttm/ttm_bo_util.c
+++ b/drivers/gpu/drm/ttm/ttm_bo_util.c
@@ -274,7 +274,13 @@ pgprot_t ttm_io_prot(struct ttm_buffer_o
 	enum ttm_caching caching;
 
 	man = ttm_manager_type(bo->bdev, res->mem_type);
-	caching = man->use_tt ? bo->ttm->caching : res->bus.caching;
+	if (man->use_tt) {
+		caching = bo->ttm->caching;
+		if (bo->ttm->page_flags & TTM_TT_FLAG_DECRYPTED)
+			tmp = pgprot_decrypted(tmp);
+	} else  {
+		caching = res->bus.caching;
+	}
 
 	return ttm_prot_from_caching(caching, tmp);
 }
@@ -317,6 +323,8 @@ static int ttm_bo_kmap_ttm(struct ttm_bu
 		.no_wait_gpu = false
 	};
 	struct ttm_tt *ttm = bo->ttm;
+	struct ttm_resource_manager *man =
+			ttm_manager_type(bo->bdev, bo->resource->mem_type);
 	pgprot_t prot;
 	int ret;
 
@@ -326,7 +334,8 @@ static int ttm_bo_kmap_ttm(struct ttm_bu
 	if (ret)
 		return ret;
 
-	if (num_pages == 1 && ttm->caching == ttm_cached) {
+	if (num_pages == 1 && ttm->caching == ttm_cached &&
+	    !(man->use_tt && (ttm->page_flags & TTM_TT_FLAG_DECRYPTED))) {
 		/*
 		 * We're mapping a single page, and the desired
 		 * page protection is consistent with the bo.
--- a/drivers/gpu/drm/ttm/ttm_tt.c
+++ b/drivers/gpu/drm/ttm/ttm_tt.c
@@ -31,11 +31,13 @@
 
 #define pr_fmt(fmt) "[TTM] " fmt
 
+#include <linux/cc_platform.h>
 #include <linux/sched.h>
 #include <linux/shmem_fs.h>
 #include <linux/file.h>
 #include <linux/module.h>
 #include <drm/drm_cache.h>
+#include <drm/drm_device.h>
 #include <drm/ttm/ttm_bo_driver.h>
 
 #include "ttm_module.h"
@@ -59,6 +61,7 @@ static atomic_long_t ttm_dma32_pages_all
 int ttm_tt_create(struct ttm_buffer_object *bo, bool zero_alloc)
 {
 	struct ttm_device *bdev = bo->bdev;
+	struct drm_device *ddev = bo->base.dev;
 	uint32_t page_flags = 0;
 
 	dma_resv_assert_held(bo->base.resv);
@@ -80,6 +83,15 @@ int ttm_tt_create(struct ttm_buffer_obje
 		pr_err("Illegal buffer object type\n");
 		return -EINVAL;
 	}
+	/*
+	 * When using dma_alloc_coherent with memory encryption the
+	 * mapped TT pages need to be decrypted or otherwise the drivers
+	 * will end up sending encrypted mem to the gpu.
+	 */
+	if (bdev->pool.use_dma_alloc && cc_platform_has(CC_ATTR_GUEST_MEM_ENCRYPT)) {
+		page_flags |= TTM_TT_FLAG_DECRYPTED;
+		drm_info(ddev, "TT memory decryption enabled.");
+	}
 
 	bo->ttm = bdev->funcs->ttm_tt_create(bo, page_flags);
 	if (unlikely(bo->ttm == NULL))
--- a/include/drm/ttm/ttm_tt.h
+++ b/include/drm/ttm/ttm_tt.h
@@ -79,6 +79,12 @@ struct ttm_tt {
 	 *   page_flags = TTM_TT_FLAG_EXTERNAL |
 	 *		  TTM_TT_FLAG_EXTERNAL_MAPPABLE;
 	 *
+	 * TTM_TT_FLAG_DECRYPTED: The mapped ttm pages should be marked as
+	 * not encrypted. The framework will try to match what the dma layer
+	 * is doing, but note that it is a little fragile because ttm page
+	 * fault handling abuses the DMA api a bit and dma_map_attrs can't be
+	 * used to assure pgprot always matches.
+	 *
 	 * TTM_TT_FLAG_PRIV_POPULATED: TTM internal only. DO NOT USE. This is
 	 * set by TTM after ttm_tt_populate() has successfully returned, and is
 	 * then unset when TTM calls ttm_tt_unpopulate().
@@ -87,6 +93,7 @@ struct ttm_tt {
 #define TTM_TT_FLAG_ZERO_ALLOC		(1 << 1)
 #define TTM_TT_FLAG_EXTERNAL		(1 << 2)
 #define TTM_TT_FLAG_EXTERNAL_MAPPABLE	(1 << 3)
+#define TTM_TT_FLAG_DECRYPTED		(1 << 4)
 
 #define TTM_TT_FLAG_PRIV_POPULATED  (1U << 31)
 	uint32_t page_flags;


