Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFC6126A0A7;
	Wed, 10 Dec 2025 07:32:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765351978; cv=none; b=qPvAAAKzsNhEZI0i66LN+Lds8SgeCh1hjU4ANqfLXb2oP38yrRTpAP2vRluGJenA+xbciExz0u2LGSXI9KDUtXVBmk9MLJ4qmVixSI60F1hy5TVHhP9IcXAFHQVwzzIaRkGQLLXFtFYUDxhNhIXCxugrT2hlgO8K1GfLUjv+iMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765351978; c=relaxed/simple;
	bh=ydm7EofrMjYIdqVmswDoQQlxQgFz9czY/bMphPYgMGE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b6DW9nd39gLxAHwRc1ZOfI+uMZy5cvWmd8f7hCnllrvbC0dvlvZrE/cfvRd0f1RUapncDnaAFjBJPEF9OnhLAbFsnFYEd36oAjEIA6rgUEaOpImi4GZDjAEogqLypCCnKI0auCV0S8sv62Ke/xyi6RAEHhLPCHUvQ2mhr152uIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bLAz3XIR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bLAz3XIR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C321FC4CEF1;
	Wed, 10 Dec 2025 07:32:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765351978;
	bh=ydm7EofrMjYIdqVmswDoQQlxQgFz9czY/bMphPYgMGE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bLAz3XIRH8kTgscnp3hhCh5kMXfFoRbyCaohNgFR6+HnRltaiTJyKBf2pUVTHopuV
	 YwJYVQD2g9As0LC7InrA85vORwV4ecfDSq1LHCPG+xlC2T0bH4V5Lv9nwPnWLn6kTA
	 RVUCEbUsoLcpCuBSDphVGcQ0rhgzztopOlzyRENM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Forbes <ian.forbes@broadcom.com>,
	Zack Rusin <zack.rusin@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 23/49] drm/vmwgfx: Use kref in vmw_bo_dirty
Date: Wed, 10 Dec 2025 16:29:53 +0900
Message-ID: <20251210072948.725394968@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251210072948.125620687@linuxfoundation.org>
References: <20251210072948.125620687@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 74ff2812d66a1..de2498749e276 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_page_dirty.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_page_dirty.c
@@ -51,22 +51,22 @@ enum vmw_bo_dirty_method {
 
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
@@ -235,7 +235,7 @@ int vmw_bo_dirty_add(struct vmw_bo *vbo)
 	int ret;
 
 	if (dirty) {
-		dirty->ref_count++;
+		kref_get(&dirty->ref_count);
 		return 0;
 	}
 
@@ -249,7 +249,7 @@ int vmw_bo_dirty_add(struct vmw_bo *vbo)
 	dirty->bitmap_size = num_pages;
 	dirty->start = dirty->bitmap_size;
 	dirty->end = 0;
-	dirty->ref_count = 1;
+	kref_init(&dirty->ref_count);
 	if (num_pages < PAGE_SIZE / sizeof(pte_t)) {
 		dirty->method = VMW_BO_DIRTY_PAGETABLE;
 	} else {
@@ -288,10 +288,8 @@ void vmw_bo_dirty_release(struct vmw_bo *vbo)
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



