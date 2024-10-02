Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18ED91D0B99;
	Wed,  2 Oct 2024 14:43:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727880226; cv=none; b=Hxblr345cxtRpSV5I9mHjbX86uw5qMdKE3sFhHutY4eu9Yg+cHtTSUDpNyP069YXvzwXNtOZXpkck9GKClKQI5FgQOp7MdD1SKK26casRqUa6h52Z2UDhwX4YkdrPdJ8otsM0GwFRoolrpDSYJK2KlNbXFAwoxy+VDYW4mZfwjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727880226; c=relaxed/simple;
	bh=zid43ne4mlTfAIaPdwQmanhZxZdUuEKbHT1BoMsQwcI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=akDysyHn5WUUNLAcIIABGgcTA8HSoaZZDU3IhDskaOec1fRRtZC3wPV863qTS3uvtz5wSXgwuVJYj05tE+AXy5qP8caMXj7u3cPNcPJmetmUXMI44VWRx6Ei7Q8dHBJ/bMXzDRmmJ4cugcsfLnhZ81AXLYXWLaTO/MR18mzmYSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TCxu1sC2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TCxu1sC2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94B81C4CEC2;
	Wed,  2 Oct 2024 14:43:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727880226;
	bh=zid43ne4mlTfAIaPdwQmanhZxZdUuEKbHT1BoMsQwcI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TCxu1sC2hDzOyxlBjEMmuWOEcla/OPoirMwm/UvysI7zA941zwdTFMpoGBlt21KGJ
	 8N59wCe2buZOweKOvhfcsv9b2P3r21tqcp+XYYPSRqUNy7vy8hR2KJTF+0xYiicQi6
	 vc3T8HBgMkPLbjhDjCv2SyAhFR4e3L+YubXsZGXc=
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
Subject: [PATCH 6.6 386/538] drm/vmwgfx: Prevent unmapping active read buffers
Date: Wed,  2 Oct 2024 15:00:25 +0200
Message-ID: <20241002125807.667158491@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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
[Shivani: Modified to apply on v6.6.y]
Signed-off-by: Shivani Agarwal <shivani.agarwal@broadcom.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_bo.c |   13 +++++++++++--
 drivers/gpu/drm/vmwgfx/vmwgfx_bo.h |    3 +++
 2 files changed, 14 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/vmwgfx/vmwgfx_bo.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_bo.c
@@ -331,6 +331,8 @@ void *vmw_bo_map_and_cache(struct vmw_bo
 	void *virtual;
 	int ret;
 
+	atomic_inc(&vbo->map_count);
+
 	virtual = ttm_kmap_obj_virtual(&vbo->map, &not_used);
 	if (virtual)
 		return virtual;
@@ -353,11 +355,17 @@ void *vmw_bo_map_and_cache(struct vmw_bo
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
 
 
@@ -390,6 +398,7 @@ static int vmw_bo_init(struct vmw_privat
 	BUILD_BUG_ON(TTM_MAX_BO_PRIORITY <= 3);
 	vmw_bo->tbo.priority = 3;
 	vmw_bo->res_tree = RB_ROOT;
+	atomic_set(&vmw_bo->map_count, 0);
 
 	params->size = ALIGN(params->size, PAGE_SIZE);
 	drm_gem_private_object_init(vdev, &vmw_bo->tbo.base, params->size);
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_bo.h
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_bo.h
@@ -68,6 +68,8 @@ struct vmw_bo_params {
  * @map: Kmap object for semi-persistent mappings
  * @res_tree: RB tree of resources using this buffer object as a backing MOB
  * @res_prios: Eviction priority counts for attached resources
+ * @map_count: The number of currently active maps. Will differ from the
+ * cpu_writers because it includes kernel maps.
  * @cpu_writers: Number of synccpu write grabs. Protected by reservation when
  * increased. May be decreased without reservation.
  * @dx_query_ctx: DX context if this buffer object is used as a DX query MOB
@@ -86,6 +88,7 @@ struct vmw_bo {
 	struct rb_root res_tree;
 	u32 res_prios[TTM_MAX_BO_PRIORITY];
 
+	atomic_t map_count;
 	atomic_t cpu_writers;
 	/* Not ref-counted.  Protected by binding_mutex */
 	struct vmw_resource *dx_query_ctx;


