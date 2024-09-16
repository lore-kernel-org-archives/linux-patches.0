Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BBEB155725;
	Mon, 16 Sep 2024 12:07:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488424; cv=none; b=jg72UDKfqADMd/kViXOg2pvdrz/DesoZa9MTWjwtG/UjQoM6lX6I4G6LBX9HqLrvK7rTO3K9XBdFgHWm7rHeENlGrt+KI1kt6g/OEQpdXJrzEWg21oR/scKlH7/L/WIvG37+v8KBSm6+OVdyfkUHzGwH6i7K28QzSdSlVqGIB+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488424; c=relaxed/simple;
	bh=DYGzXn9EaRJv00mkVbJ53IRPSxZE3oHOtjh6c7BDrMg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=t0bqzJm4n8FuKLmpIqj0MwkRgsPXMvwtApAJ+7MnM4txNMNmc6xLDrh7h5l42LvbWFpODO9EcBrffZw8Sa4KzpSdj/VdmoZ7b0iGIuZ9ah81Z4Fa9NMc5CMEp6D1/fVtvGV9hHLinWr2BEaSCKKDJrti46EZ+aQttrZ7SdaOCTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IHUVSAmb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IHUVSAmb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14602C4CEC4;
	Mon, 16 Sep 2024 12:07:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488424;
	bh=DYGzXn9EaRJv00mkVbJ53IRPSxZE3oHOtjh6c7BDrMg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IHUVSAmbJsEPkD2kY8bHdnrj7zoBx0vVRrbkg2REzKgeItXwJRQwPag0k6sVX1r2j
	 eY5tFFJ0clUMjEJFVqxbuaFQIRFAZnX+jMJFq6VfzHdp/LJl3zqbLzygMvq7+agBjE
	 kRxMv2PqUpmiUx8DrihmzHjGF6AaIQYRIFtHZ/HM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Auld <matthew.auld@intel.com>,
	Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>,
	Tejas Upadhyay <tejas.upadhyay@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 6.10 109/121] drm/xe/client: add missing bo locking in show_meminfo()
Date: Mon, 16 Sep 2024 13:44:43 +0200
Message-ID: <20240916114232.699246365@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114228.914815055@linuxfoundation.org>
References: <20240916114228.914815055@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Auld <matthew.auld@intel.com>

commit 94c4aa266111262c96c98f822d1bccc494786fee upstream.

bo_meminfo() wants to inspect bo state like tt and the ttm resource,
however this state can change at any point leading to stuff like NPD and
UAF, if the bo lock is not held. Grab the bo lock when calling
bo_meminfo(), ensuring we drop any spinlocks first. In the case of
object_idr we now also need to hold a ref.

v2 (MattB)
  - Also add xe_bo_assert_held()

Fixes: 0845233388f8 ("drm/xe: Implement fdinfo memory stats printing")
Signed-off-by: Matthew Auld <matthew.auld@intel.com>
Cc: Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>
Cc: Tejas Upadhyay <tejas.upadhyay@intel.com>
Cc: "Thomas Hellström" <thomas.hellstrom@linux.intel.com>
Cc: <stable@vger.kernel.org> # v6.8+
Reviewed-by: Matthew Brost <matthew.brost@intel.com>
Reviewed-by: Tejas Upadhyay <tejas.upadhyay@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240911155527.178910-6-matthew.auld@intel.com
(cherry picked from commit 4f63d712fa104c3ebefcb289d1e733e86d8698c7)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_drm_client.c |   39 ++++++++++++++++++++++++++++++++++---
 1 file changed, 36 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/xe/xe_drm_client.c
+++ b/drivers/gpu/drm/xe/xe_drm_client.c
@@ -9,6 +9,7 @@
 #include <linux/slab.h>
 #include <linux/types.h>
 
+#include "xe_assert.h"
 #include "xe_bo.h"
 #include "xe_bo_types.h"
 #include "xe_device_types.h"
@@ -93,10 +94,13 @@ void xe_drm_client_add_bo(struct xe_drm_
  */
 void xe_drm_client_remove_bo(struct xe_bo *bo)
 {
+	struct xe_device *xe = ttm_to_xe_device(bo->ttm.bdev);
 	struct xe_drm_client *client = bo->client;
 
+	xe_assert(xe, !kref_read(&bo->ttm.base.refcount));
+
 	spin_lock(&client->bos_lock);
-	list_del(&bo->client_link);
+	list_del_init(&bo->client_link);
 	spin_unlock(&client->bos_lock);
 
 	xe_drm_client_put(client);
@@ -108,6 +112,8 @@ static void bo_meminfo(struct xe_bo *bo,
 	u64 sz = bo->size;
 	u32 mem_type;
 
+	xe_bo_assert_held(bo);
+
 	if (bo->placement.placement)
 		mem_type = bo->placement.placement->mem_type;
 	else
@@ -149,7 +155,20 @@ static void show_meminfo(struct drm_prin
 	idr_for_each_entry(&file->object_idr, obj, id) {
 		struct xe_bo *bo = gem_to_xe_bo(obj);
 
-		bo_meminfo(bo, stats);
+		if (dma_resv_trylock(bo->ttm.base.resv)) {
+			bo_meminfo(bo, stats);
+			xe_bo_unlock(bo);
+		} else {
+			xe_bo_get(bo);
+			spin_unlock(&file->table_lock);
+
+			xe_bo_lock(bo, false);
+			bo_meminfo(bo, stats);
+			xe_bo_unlock(bo);
+
+			xe_bo_put(bo);
+			spin_lock(&file->table_lock);
+		}
 	}
 	spin_unlock(&file->table_lock);
 
@@ -159,7 +178,21 @@ static void show_meminfo(struct drm_prin
 		if (!kref_get_unless_zero(&bo->ttm.base.refcount))
 			continue;
 
-		bo_meminfo(bo, stats);
+		if (dma_resv_trylock(bo->ttm.base.resv)) {
+			bo_meminfo(bo, stats);
+			xe_bo_unlock(bo);
+		} else {
+			spin_unlock(&client->bos_lock);
+
+			xe_bo_lock(bo, false);
+			bo_meminfo(bo, stats);
+			xe_bo_unlock(bo);
+
+			spin_lock(&client->bos_lock);
+			/* The bo ref will prevent this bo from being removed from the list */
+			xe_assert(xef->xe, !list_empty(&bo->client_link));
+		}
+
 		xe_bo_put_deferred(bo, &deferred);
 	}
 	spin_unlock(&client->bos_lock);


