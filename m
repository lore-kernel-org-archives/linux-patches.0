Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53BE8537FF;
	Sun,  1 Sep 2024 16:31:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208302; cv=none; b=NZ1CV+Y1qHt3HBpsqg8x8Bspe3Dd6vaetFq3u2QwqbsJVGlQHWv7HgKKEtamDrEUbZowaR81dqLDg3qntYjU92ncWYI1H8RoUG86TRA2a/uKvGfY1cKbHe55umSG90jAf4LiNQLDbYUQ46NRpH/rufjzjrtd492KmiV+HyEQWs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208302; c=relaxed/simple;
	bh=ql2EXjexnVLrRkxhY/wMyL2HQ+oazucCcBolv6uHwHQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uMcQYryaj4Bph2cyo/axXXXtcjs0mFO/CH6oVMDo38YaQZufeQOnUxcKvJQdDNkV4w9fu95h4NPqKEQyKGgH3ByQCjSCZ2fmE1Bt/ag9I5/QJn/hWk5eDztOgxfB663ij+peX/QYmzET8To98bjsNyLfmeAx6mTSML4E/6/YXrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MGD2R7yi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MGD2R7yi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC47FC4CEC3;
	Sun,  1 Sep 2024 16:31:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208302;
	bh=ql2EXjexnVLrRkxhY/wMyL2HQ+oazucCcBolv6uHwHQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MGD2R7yi8n7DNPnUNz8ax0+9BGUCQ6wm3fgCBNimQAyu5l3MIkJJRQwUhOdcZSneZ
	 2XUdvJmOWubUPLksq3em8/6Jszmcth6mMQJA7aPhJGjuOgxdrJHR2BQJgXatWo81DL
	 NgzvkeyLfxK0yuro5Gd/ADft1UDGmrav3s42Csfc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	dri-devel@lists.freedesktop.org,
	Zack Rusin <zack.rusin@broadcom.com>,
	Martin Krastev <martin.krastev@broadcom.com>,
	Maaz Mombasawala <maaz.mombasawala@broadcom.com>
Subject: [PATCH 6.10 040/149] drm/vmwgfx: Prevent unmapping active read buffers
Date: Sun,  1 Sep 2024 18:15:51 +0200
Message-ID: <20240901160818.970833301@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160817.461957599@linuxfoundation.org>
References: <20240901160817.461957599@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_bo.c |   13 +++++++++++--
 drivers/gpu/drm/vmwgfx/vmwgfx_bo.h |    3 +++
 2 files changed, 14 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/vmwgfx/vmwgfx_bo.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_bo.c
@@ -360,6 +360,8 @@ void *vmw_bo_map_and_cache_size(struct v
 	void *virtual;
 	int ret;
 
+	atomic_inc(&vbo->map_count);
+
 	virtual = ttm_kmap_obj_virtual(&vbo->map, &not_used);
 	if (virtual)
 		return virtual;
@@ -383,11 +385,17 @@ void *vmw_bo_map_and_cache_size(struct v
  */
 void vmw_bo_unmap(struct vmw_bo *vbo)
 {
+	int map_count;
+
 	if (vbo->map.bo == NULL)
 		return;
 
-	ttm_bo_kunmap(&vbo->map);
-	vbo->map.bo = NULL;
+	map_count = atomic_dec_return(&vbo->map_count);
+
+	if (!map_count) {
+		ttm_bo_kunmap(&vbo->map);
+		vbo->map.bo = NULL;
+	}
 }
 
 
@@ -421,6 +429,7 @@ static int vmw_bo_init(struct vmw_privat
 	vmw_bo->tbo.priority = 3;
 	vmw_bo->res_tree = RB_ROOT;
 	xa_init(&vmw_bo->detached_resources);
+	atomic_set(&vmw_bo->map_count, 0);
 
 	params->size = ALIGN(params->size, PAGE_SIZE);
 	drm_gem_private_object_init(vdev, &vmw_bo->tbo.base, params->size);
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_bo.h
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_bo.h
@@ -71,6 +71,8 @@ struct vmw_bo_params {
  * @map: Kmap object for semi-persistent mappings
  * @res_tree: RB tree of resources using this buffer object as a backing MOB
  * @res_prios: Eviction priority counts for attached resources
+ * @map_count: The number of currently active maps. Will differ from the
+ * cpu_writers because it includes kernel maps.
  * @cpu_writers: Number of synccpu write grabs. Protected by reservation when
  * increased. May be decreased without reservation.
  * @dx_query_ctx: DX context if this buffer object is used as a DX query MOB
@@ -90,6 +92,7 @@ struct vmw_bo {
 	u32 res_prios[TTM_MAX_BO_PRIORITY];
 	struct xarray detached_resources;
 
+	atomic_t map_count;
 	atomic_t cpu_writers;
 	/* Not ref-counted.  Protected by binding_mutex */
 	struct vmw_resource *dx_query_ctx;


