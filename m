Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4B8E302145;
	Wed, 10 Dec 2025 07:33:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765352028; cv=none; b=qeVRduUItT95bkBQnEKjc0SxTUsePKgsSLnTOdStBU8B3nPYG0p4QDKVpT5wJY3yV2oGPLQWp/wqOUvYTHA7MxkEHD4nYMfhlKdLrd+LQQTv8NV1Fyb2rQGnBcS+URUzDg2vNTgX0jjd2YUeziFQf+RkzfrIDGLc+NRRKLJwRgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765352028; c=relaxed/simple;
	bh=R7ox0CV7/dYXgJzCIazQ8HEpOuzCyakphemutEfWz68=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cBmKNSLzDCdNxYaaH7taAMrNSFvHgO/nYd3vVQs95kjbiR78XGHhPDmMHlsSe8G5hpakfsYExMulIkS7QxRvNXMvdEjM/7FgGHzcL22IEJdZjoA46Fp11K1cUYRsZhWVnaGW6+mUzquKvu2vxcgT231fKRn1yq7Ru0WdFYQ/1Do=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PIHwlyOI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PIHwlyOI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26FFDC4CEF1;
	Wed, 10 Dec 2025 07:33:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765352028;
	bh=R7ox0CV7/dYXgJzCIazQ8HEpOuzCyakphemutEfWz68=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PIHwlyOIrhCp/QBfpjyKjVP5TN7ARsUlbW8JPXP+ufKZRrAhDb8aL1G/6BPVAYrKv
	 xZ48iTL+XCQI6M7PuWtlr58BTMRd6MVBOrXHkDKeZ/jzh6RgMmhNePLVe102qcy/AF
	 nyxz3RlioX55ewocNjbcF2GFyJAPZyCdtrm4gkd4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Forbes <ian.forbes@broadcom.com>,
	Zack Rusin <zack.rusin@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 23/60] drm/vmwgfx: Use kref in vmw_bo_dirty
Date: Wed, 10 Dec 2025 16:29:53 +0900
Message-ID: <20251210072948.407278575@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251210072947.850479903@linuxfoundation.org>
References: <20251210072947.850479903@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 7de20e56082c8..fd4e76486f2d1 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_page_dirty.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_page_dirty.c
@@ -32,22 +32,22 @@ enum vmw_bo_dirty_method {
 
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
@@ -221,7 +221,7 @@ int vmw_bo_dirty_add(struct vmw_bo *vbo)
 	int ret;
 
 	if (dirty) {
-		dirty->ref_count++;
+		kref_get(&dirty->ref_count);
 		return 0;
 	}
 
@@ -235,7 +235,7 @@ int vmw_bo_dirty_add(struct vmw_bo *vbo)
 	dirty->bitmap_size = num_pages;
 	dirty->start = dirty->bitmap_size;
 	dirty->end = 0;
-	dirty->ref_count = 1;
+	kref_init(&dirty->ref_count);
 	if (num_pages < PAGE_SIZE / sizeof(pte_t)) {
 		dirty->method = VMW_BO_DIRTY_PAGETABLE;
 	} else {
@@ -274,10 +274,8 @@ void vmw_bo_dirty_release(struct vmw_bo *vbo)
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



