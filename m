Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D27433C1B6;
	Fri,  9 Jan 2026 12:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961466; cv=none; b=uqnmukt+XLtUaQBs/KgJ+6GvpMI8IAnuCIZaJvY1Gb22z+ZKaf5+TYg+8o/uOSxJXi9tqB0Nf3G22LzCIotnVN6aDh7Ejuv1uyy9BnqRgaTvYDU437IW7SDcKFTSAtoHYRkMAz4CQc1kVXSWY7KnLAoRrbbRzgMNjrFE7eDGw44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961466; c=relaxed/simple;
	bh=8+YgfyGY5RN+Y7MXBEa0FXJu99h3JNen6PDXwvdpegA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AxqZi68BsuNOc1rIZG3FOvPQ4zkYIqIyVninaiZEtcY0tmydjFzJVkcbjOCuHosAmSAReIDSqg5t88mzYUVtqKRtz8BAkk50rwlTfGw5Ic56X4uldM5q1OOGVP81DBMZPB4LDsbtNGHXhES11j5uTDG6ox6S+2ete/LH8L71Ejk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zB9F6UMl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zB9F6UMl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE31DC4CEF1;
	Fri,  9 Jan 2026 12:24:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961466;
	bh=8+YgfyGY5RN+Y7MXBEa0FXJu99h3JNen6PDXwvdpegA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zB9F6UMlY99AW5a4Awb9PB1yapKnGF2Y6v7BHok5oR+Ep72Yo2LnVUe9z3aL1ApBu
	 t4iLDnpwXDytkNsseCuIlFdU1ceIjdF4om8sroBdEELkIqx3Rm17RYIl/ouRBtf+zf
	 0gDzoWy7ldCD95By6zUoJpVTOm03HLOWQCu327ok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Forbes <ian.forbes@broadcom.com>,
	Zack Rusin <zack.rusin@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 024/634] drm/vmwgfx: Use kref in vmw_bo_dirty
Date: Fri,  9 Jan 2026 12:35:02 +0100
Message-ID: <20260109112118.355507757@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Forbes <ian.forbes@broadcom.com>

[ Upstream commit c1962742ffff7e245f935903a4658eb6f94f6058 ]

Rather than using an ad hoc reference count use kref which is atomic
and has underflow warnings.

Signed-off-by: Ian Forbes <ian.forbes@broadcom.com>
Signed-off-by: Zack Rusin <zack.rusin@broadcom.com>
Link: https://patch.msgid.link/20251030193640.153697-1-ian.forbes@broadcom.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_page_dirty.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_page_dirty.c b/drivers/gpu/drm/vmwgfx/vmwgfx_page_dirty.c
index 7bc99b1279f7d..09e938498442c 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_page_dirty.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_page_dirty.c
@@ -50,22 +50,22 @@ enum vmw_bo_dirty_method {
 
 /**
  * struct vmw_bo_dirty - Dirty information for buffer objects
+ * @ref_count: Reference count for this structure. Must be first member!
  * @start: First currently dirty bit
  * @end: Last currently dirty bit + 1
  * @method: The currently used dirty method
  * @change_count: Number of consecutive method change triggers
- * @ref_count: Reference count for this structure
  * @bitmap_size: The size of the bitmap in bits. Typically equal to the
  * nuber of pages in the bo.
  * @bitmap: A bitmap where each bit represents a page. A set bit means a
  * dirty page.
  */
 struct vmw_bo_dirty {
+	struct   kref ref_count;
 	unsigned long start;
 	unsigned long end;
 	enum vmw_bo_dirty_method method;
 	unsigned int change_count;
-	unsigned int ref_count;
 	unsigned long bitmap_size;
 	unsigned long bitmap[];
 };
@@ -235,7 +235,7 @@ int vmw_bo_dirty_add(struct vmw_buffer_object *vbo)
 	int ret;
 
 	if (dirty) {
-		dirty->ref_count++;
+		kref_get(&dirty->ref_count);
 		return 0;
 	}
 
@@ -249,7 +249,7 @@ int vmw_bo_dirty_add(struct vmw_buffer_object *vbo)
 	dirty->bitmap_size = num_pages;
 	dirty->start = dirty->bitmap_size;
 	dirty->end = 0;
-	dirty->ref_count = 1;
+	kref_init(&dirty->ref_count);
 	if (num_pages < PAGE_SIZE / sizeof(pte_t)) {
 		dirty->method = VMW_BO_DIRTY_PAGETABLE;
 	} else {
@@ -288,10 +288,8 @@ void vmw_bo_dirty_release(struct vmw_buffer_object *vbo)
 {
 	struct vmw_bo_dirty *dirty = vbo->dirty;
 
-	if (dirty && --dirty->ref_count == 0) {
-		kvfree(dirty);
+	if (dirty && kref_put(&dirty->ref_count, (void *)kvfree))
 		vbo->dirty = NULL;
-	}
 }
 
 /**
-- 
2.51.0



