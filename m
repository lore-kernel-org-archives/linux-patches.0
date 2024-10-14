Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBF9826296;
	Mon, 14 Oct 2024 15:04:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918288; cv=none; b=mHLcTDpq+XScy8w5DALQU6/aUbaTTHB5GpNSSxSBgrC3wFmNhmSEJNqwAg032tEyLvU+eG0vJScID4ZwBqerFdBlcZGgZo+TUdsNrb4Scx+K9uIiZG1yPX5tA1kvEt8Jz7PDTiZIwHf6vp+T3S90qDQvMlN8+Ot0SUI3Y49lSl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918288; c=relaxed/simple;
	bh=lL8P6y+vfq+DDSaRK1UlLe+ApoEHJRlUrSMOVGUJyak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jqWrJcsqPjvPCC+6yRJXkOGzJWsU9rcVcNCB3dqtZdxKInGqeJLIt3X80SbyFMxweNRODuWr9ynVYmmDNlT2U36d++NstGOX8XWvYNZGocOgpYTjEH+AQeiE8mlAuiuQzkgKvePs9JF4+I9hyy02OVguHG9ZsXnXxNMA12/r014=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JRi5RuE7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JRi5RuE7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A865C4CEC7;
	Mon, 14 Oct 2024 15:04:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918287;
	bh=lL8P6y+vfq+DDSaRK1UlLe+ApoEHJRlUrSMOVGUJyak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JRi5RuE79qjEEv7QKUGnje/6tijPLZYV+jCHLAIQSoNNfc8IsWUGvopXsfwdkzmJZ
	 19qq2vjZTVUWxudqytdmpEiWVP6aCqvePlrml4l1d688JRDgtObQOoGvoRnx2MbpBT
	 O/fHIDWpT7FgHZY1z4988IkSS2Ga2t/SzbtqedvY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	dri-devel@lists.freedesktop.org,
	Zack Rusin <zack.rusin@broadcom.com>,
	Martin Krastev <martin.krastev@broadcom.com>,
	Maaz Mombasawala <maaz.mombasawala@broadcom.com>,
	Shivani Agarwal <shivani.agarwal@broadcom.com>
Subject: [PATCH 6.1 278/798] drm/vmwgfx: Prevent unmapping active read buffers
Date: Mon, 14 Oct 2024 16:13:52 +0200
Message-ID: <20241014141228.865628242@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zack Rusin <zack.rusin@broadcom.com>

commit aba07b9a0587f50e5d3346eaa19019cf3f86c0ea upstream.

The kms paths keep a persistent map active to read and compare the cursor
buffer. These maps can race with each other in simple scenario where:
a) buffer "a" mapped for update
b) buffer "a" mapped for compare
c) do the compare
d) unmap "a" for compare
e) update the cursor
f) unmap "a" for update
At step "e" the buffer has been unmapped and the read contents is bogus.

Prevent unmapping of active read buffers by simply keeping a count of
how many paths have currently active maps and unmap only when the count
reaches 0.

Fixes: 485d98d472d5 ("drm/vmwgfx: Add support for CursorMob and CursorBypass 4")
Cc: Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>
Cc: dri-devel@lists.freedesktop.org
Cc: <stable@vger.kernel.org> # v5.19+
Signed-off-by: Zack Rusin <zack.rusin@broadcom.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240816183332.31961-2-zack.rusin@broadcom.com
Reviewed-by: Martin Krastev <martin.krastev@broadcom.com>
Reviewed-by: Maaz Mombasawala <maaz.mombasawala@broadcom.com>
[Shivani: Modified to apply on v6.1.y]
Signed-off-by: Shivani Agarwal <shivani.agarwal@broadcom.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_bo.c  |   12 +++++++++++-
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.h |    3 +++
 2 files changed, 14 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/vmwgfx/vmwgfx_bo.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_bo.c
@@ -348,6 +348,8 @@ void *vmw_bo_map_and_cache(struct vmw_bu
 	void *virtual;
 	int ret;
 
+	atomic_inc(&vbo->map_count);
+
 	virtual = ttm_kmap_obj_virtual(&vbo->map, &not_used);
 	if (virtual)
 		return virtual;
@@ -370,10 +372,17 @@ void *vmw_bo_map_and_cache(struct vmw_bu
  */
 void vmw_bo_unmap(struct vmw_buffer_object *vbo)
 {
+	int map_count;
+
 	if (vbo->map.bo == NULL)
 		return;
 
-	ttm_bo_kunmap(&vbo->map);
+	map_count = atomic_dec_return(&vbo->map_count);
+
+	if (!map_count) {
+		ttm_bo_kunmap(&vbo->map);
+		vbo->map.bo = NULL;
+	}
 }
 
 
@@ -510,6 +519,7 @@ int vmw_bo_init(struct vmw_private *dev_
 	BUILD_BUG_ON(TTM_MAX_BO_PRIORITY <= 3);
 	vmw_bo->base.priority = 3;
 	vmw_bo->res_tree = RB_ROOT;
+	atomic_set(&vmw_bo->map_count, 0);
 
 	size = ALIGN(size, PAGE_SIZE);
 	drm_gem_private_object_init(vdev, &vmw_bo->base.base, size);
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.h
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.h
@@ -116,6 +116,8 @@ struct vmwgfx_hash_item {
  * @base: The TTM buffer object
  * @res_tree: RB tree of resources using this buffer object as a backing MOB
  * @base_mapped_count: ttm BO mapping count; used by KMS atomic helpers.
+ * @map_count: The number of currently active maps. Will differ from the
+ * cpu_writers because it includes kernel maps.
  * @cpu_writers: Number of synccpu write grabs. Protected by reservation when
  * increased. May be decreased without reservation.
  * @dx_query_ctx: DX context if this buffer object is used as a DX query MOB
@@ -129,6 +131,7 @@ struct vmw_buffer_object {
 	/* For KMS atomic helpers: ttm bo mapping count */
 	atomic_t base_mapped_count;
 
+	atomic_t map_count;
 	atomic_t cpu_writers;
 	/* Not ref-counted.  Protected by binding_mutex */
 	struct vmw_resource *dx_query_ctx;


