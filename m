Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E82933ADB8;
	Fri,  9 Jan 2026 11:49:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959359; cv=none; b=ifFNVIPHWFfDvW2yCMd7bqK6E40S9brvmk3Gr9DgXOgui1SAlnAzv5d+8AAwB3kY/JVGfOyCmMbsmujy4482R5JUAd/1mwKgzYQbheWdBoFgXBZePqKIuuXToTRwvRNytfYaDe+CQufgyORkB37tkHePNPgnXteTYIz5f3jnNg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959359; c=relaxed/simple;
	bh=SOzll4eZk46cxktnA7VULBPqZ76NvUXIk05xcsgyo9Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O7gtKCajWd/GdeaEfOK0O6LRDIUEBXuY1/O20Kd4a8alyyCyrIlONX1ojFY7aijOw4rz+T5BgYZqiGp+6+c4UA894ZhV9VQ1Ef7uU4SeMyTSgvfhq7CI3bzuZ5oLFA6jb9u75oS7flqIdOIeR4NDpblbvlf7bRU7jOuePB6E0c8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hf/Q5JtY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hf/Q5JtY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9200C4CEF1;
	Fri,  9 Jan 2026 11:49:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959359;
	bh=SOzll4eZk46cxktnA7VULBPqZ76NvUXIk05xcsgyo9Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hf/Q5JtYLzEpN9epZnXBg0cmdtDERScIMoAyd3In/c50B7cqJu8W7x0xPMvBgh0QY
	 ayvdW2QI61pTnVS5S3bk+Xq6hX7UlkXQQjGl4HRzdj4obNW615CiMFxvCh23SytOqv
	 yA9meGxUItlLaUCa63kiVR2ukvQ6U6HbTBipUTu0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Forbes <ian.forbes@broadcom.com>,
	Zack Rusin <zack.rusin@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 024/737] drm/vmwgfx: Use kref in vmw_bo_dirty
Date: Fri,  9 Jan 2026 12:32:43 +0100
Message-ID: <20260109112134.905440752@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



