Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D37DA18801A;
	Tue, 30 Jul 2024 16:55:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358557; cv=none; b=cTv9OUEVmm/pHCvYpXs/pv5dvimEDj3KAagn+qKqUv6wjTVKMxU2n03a/MMmIlKcgkLbPRA3DI8Jf99jq16YfQ5yPG3UW2GBkftBdEXCOXjK+8+MbQHeK+oHJU63RDC+OKtxmS+vpD8Gz1ztyZZ6qWzq/94CFWpJ52BmBx05hLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358557; c=relaxed/simple;
	bh=zDoE6M5aA2nV72gzQUViUc9h8F7APUuJ1YeR4ejRy94=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=B9fDYkaO5/+WXtEIn+NAR4o7KLBMD3XUoAOESTgKNCX/swTevSFBNTysNxYf37v586/1zHukCJun5mqDTF3FG3Y8VhHs30y0vuQhuGgZUisWgSM56mVaH+EsdZodUvPjEsQqfzDXNR3yJWk93MPwFv5Zj1iHRHvPN+5UeNPNS4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z+slddAI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z+slddAI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E86C7C32782;
	Tue, 30 Jul 2024 16:55:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358556;
	bh=zDoE6M5aA2nV72gzQUViUc9h8F7APUuJ1YeR4ejRy94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z+slddAIG5KTKovT++K5iyR/u6Gp73yZvT2JGYKEAQ6Gwe/q0zFjtKdBeohqOR/oL
	 D7q01L4sbnWlzsQPdWlEI+brb5//NU0lh7R9/aFc1FdMlYDQRvj4eg8BpE1f6Z8sBB
	 pPN9nBu7dHtlhs8O9M816yBHnLkzbGXuDLcNjiOA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	David Kaplan <david.kaplan@amd.com>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Dmitry Osipenko <dmitry.osipenko@collabora.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Zack Rusin <zack.rusin@broadcom.com>,
	Dave Airlie <airlied@redhat.com>,
	Gerd Hoffmann <kraxel@redhat.com>,
	virtualization@lists.linux.dev,
	spice-devel@lists.freedesktop.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 373/809] drm/qxl: Pin buffer objects for internal mappings
Date: Tue, 30 Jul 2024 17:44:09 +0200
Message-ID: <20240730151739.392917742@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

From: Thomas Zimmermann <tzimmermann@suse.de>

[ Upstream commit c537fb4e3d36e7cd1a0837dd577cd30d3d64f1bc ]

Add qxl_bo_pin_and_vmap() that pins and vmaps a buffer object in one
step. Update callers of the regular qxl_bo_vmap(). Fixes a bug where
qxl accesses an unpinned buffer object while it is being moved; such
as with the monitor-description BO. An typical error is shown below.

[    4.303586] [drm:drm_atomic_helper_commit_planes] *ERROR* head 1 wrong: 65376256x16777216+0+0
[    4.586883] [drm:drm_atomic_helper_commit_planes] *ERROR* head 1 wrong: 65376256x16777216+0+0
[    4.904036] [drm:drm_atomic_helper_commit_planes] *ERROR* head 1 wrong: 65335296x16777216+0+0
[    5.374347] [drm:qxl_release_from_id_locked] *ERROR* failed to find id in release_idr

Commit b33651a5c98d ("drm/qxl: Do not pin buffer objects for vmap")
removed the implicit pin operation from qxl's vmap code. This is the
correct behavior for GEM and PRIME interfaces, but the pin is still
needed for qxl internal operation.

Also add a corresponding function qxl_bo_vunmap_and_unpin() and remove
the old qxl_bo_vmap() helpers.

Future directions: BOs should not be pinned or vmapped unnecessarily.
The pin-and-vmap operation should be removed from the driver and a
temporary mapping should be established with a vmap_local-like helper.
See the client helper drm_client_buffer_vmap_local() for semantics.

v2:
- unreserve BO on errors in qxl_bo_pin_and_vmap() (Dmitry)

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Fixes: b33651a5c98d ("drm/qxl: Do not pin buffer objects for vmap")
Reported-by: David Kaplan <david.kaplan@amd.com>
Closes: https://lore.kernel.org/dri-devel/ab0fb17d-0f96-4ee6-8b21-65d02bb02655@suse.de/
Tested-by: David Kaplan <david.kaplan@amd.com>
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Dmitry Osipenko <dmitry.osipenko@collabora.com>
Cc: Christian König <christian.koenig@amd.com>
Cc: Zack Rusin <zack.rusin@broadcom.com>
Cc: Dave Airlie <airlied@redhat.com>
Cc: Gerd Hoffmann <kraxel@redhat.com>
Cc: virtualization@lists.linux.dev
Cc: spice-devel@lists.freedesktop.org
Reviewed-by: Dmitry Osipenko <dmitry.osipenko@collabora.com>
Reviewed-by: Zack Rusin <zack.rusin@broadcom.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240708142208.194361-1-tzimmermann@suse.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/qxl/qxl_display.c | 14 +++++++-------
 drivers/gpu/drm/qxl/qxl_object.c  | 13 +++++++++++--
 drivers/gpu/drm/qxl/qxl_object.h  |  4 ++--
 3 files changed, 20 insertions(+), 11 deletions(-)

diff --git a/drivers/gpu/drm/qxl/qxl_display.c b/drivers/gpu/drm/qxl/qxl_display.c
index 86a5dea710c0f..bc24af08dfcd5 100644
--- a/drivers/gpu/drm/qxl/qxl_display.c
+++ b/drivers/gpu/drm/qxl/qxl_display.c
@@ -584,11 +584,11 @@ static struct qxl_bo *qxl_create_cursor(struct qxl_device *qdev,
 	if (ret)
 		goto err;
 
-	ret = qxl_bo_vmap(cursor_bo, &cursor_map);
+	ret = qxl_bo_pin_and_vmap(cursor_bo, &cursor_map);
 	if (ret)
 		goto err_unref;
 
-	ret = qxl_bo_vmap(user_bo, &user_map);
+	ret = qxl_bo_pin_and_vmap(user_bo, &user_map);
 	if (ret)
 		goto err_unmap;
 
@@ -614,12 +614,12 @@ static struct qxl_bo *qxl_create_cursor(struct qxl_device *qdev,
 		       user_map.vaddr, size);
 	}
 
-	qxl_bo_vunmap(user_bo);
-	qxl_bo_vunmap(cursor_bo);
+	qxl_bo_vunmap_and_unpin(user_bo);
+	qxl_bo_vunmap_and_unpin(cursor_bo);
 	return cursor_bo;
 
 err_unmap:
-	qxl_bo_vunmap(cursor_bo);
+	qxl_bo_vunmap_and_unpin(cursor_bo);
 err_unref:
 	qxl_bo_unpin(cursor_bo);
 	qxl_bo_unref(&cursor_bo);
@@ -1205,7 +1205,7 @@ int qxl_create_monitors_object(struct qxl_device *qdev)
 	}
 	qdev->monitors_config_bo = gem_to_qxl_bo(gobj);
 
-	ret = qxl_bo_vmap(qdev->monitors_config_bo, &map);
+	ret = qxl_bo_pin_and_vmap(qdev->monitors_config_bo, &map);
 	if (ret)
 		return ret;
 
@@ -1236,7 +1236,7 @@ int qxl_destroy_monitors_object(struct qxl_device *qdev)
 	qdev->monitors_config = NULL;
 	qdev->ram_header->monitors_config = 0;
 
-	ret = qxl_bo_vunmap(qdev->monitors_config_bo);
+	ret = qxl_bo_vunmap_and_unpin(qdev->monitors_config_bo);
 	if (ret)
 		return ret;
 
diff --git a/drivers/gpu/drm/qxl/qxl_object.c b/drivers/gpu/drm/qxl/qxl_object.c
index 5893e27a7ae50..66635c55cf857 100644
--- a/drivers/gpu/drm/qxl/qxl_object.c
+++ b/drivers/gpu/drm/qxl/qxl_object.c
@@ -182,7 +182,7 @@ int qxl_bo_vmap_locked(struct qxl_bo *bo, struct iosys_map *map)
 	return 0;
 }
 
-int qxl_bo_vmap(struct qxl_bo *bo, struct iosys_map *map)
+int qxl_bo_pin_and_vmap(struct qxl_bo *bo, struct iosys_map *map)
 {
 	int r;
 
@@ -190,7 +190,15 @@ int qxl_bo_vmap(struct qxl_bo *bo, struct iosys_map *map)
 	if (r)
 		return r;
 
+	r = qxl_bo_pin_locked(bo);
+	if (r) {
+		qxl_bo_unreserve(bo);
+		return r;
+	}
+
 	r = qxl_bo_vmap_locked(bo, map);
+	if (r)
+		qxl_bo_unpin_locked(bo);
 	qxl_bo_unreserve(bo);
 	return r;
 }
@@ -241,7 +249,7 @@ void qxl_bo_vunmap_locked(struct qxl_bo *bo)
 	ttm_bo_vunmap(&bo->tbo, &bo->map);
 }
 
-int qxl_bo_vunmap(struct qxl_bo *bo)
+int qxl_bo_vunmap_and_unpin(struct qxl_bo *bo)
 {
 	int r;
 
@@ -250,6 +258,7 @@ int qxl_bo_vunmap(struct qxl_bo *bo)
 		return r;
 
 	qxl_bo_vunmap_locked(bo);
+	qxl_bo_unpin_locked(bo);
 	qxl_bo_unreserve(bo);
 	return 0;
 }
diff --git a/drivers/gpu/drm/qxl/qxl_object.h b/drivers/gpu/drm/qxl/qxl_object.h
index 1cf5bc7591016..875f63221074c 100644
--- a/drivers/gpu/drm/qxl/qxl_object.h
+++ b/drivers/gpu/drm/qxl/qxl_object.h
@@ -59,9 +59,9 @@ extern int qxl_bo_create(struct qxl_device *qdev,
 			 u32 priority,
 			 struct qxl_surface *surf,
 			 struct qxl_bo **bo_ptr);
-int qxl_bo_vmap(struct qxl_bo *bo, struct iosys_map *map);
+int qxl_bo_pin_and_vmap(struct qxl_bo *bo, struct iosys_map *map);
 int qxl_bo_vmap_locked(struct qxl_bo *bo, struct iosys_map *map);
-int qxl_bo_vunmap(struct qxl_bo *bo);
+int qxl_bo_vunmap_and_unpin(struct qxl_bo *bo);
 void qxl_bo_vunmap_locked(struct qxl_bo *bo);
 void *qxl_bo_kmap_atomic_page(struct qxl_device *qdev, struct qxl_bo *bo, int page_offset);
 void qxl_bo_kunmap_atomic_page(struct qxl_device *qdev, struct qxl_bo *bo, void *map);
-- 
2.43.0



