Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35CC638236C;
	Thu, 20 Aug 2026 15:21:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787239315; cv=none; b=tnR+1sDRQWZnIm0USnoGneT7hV6uFBggqg6YCWu6Pe7dDw+kgHMopfK21iZL4xdhYE9LW0e41pOw9BuipIHu7lDtuz1F6THDYYQbjgUtazXpkGZz/KcGtXr2rTDE1WO5w1XXBfXppFq0mbIGlp0LpQnCGCra8muoHQjxRzhARbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787239315; c=relaxed/simple;
	bh=Oo16a2swjo/+WjsbBbStF/BPJS6HAd/rwI6CQ6g4R2o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FbCMastCJyqRPmJ1sVoWeb5UE3vwAyxfiASGzJW4EWEx1HavJYkXSC5DAUtYNkvaW4MmVOuDzSeh9wMZjdq0TZY5sfAunWlyLR4Cyhpup00RQHzFMmBEcWKy78M0nWEpWay5h9D5zPBXenp6xVBr6QdlFrI7e0O8t4tSbkI4Thw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0fcafpRF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0fcafpRF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FA1D1F00A3F;
	Thu, 20 Aug 2026 15:21:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787239314;
	bh=DFPPiwPysk07x0Lcq+HLQEAJmLHpEjf66PtqBASY5VM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0fcafpRFehZWDpKtEgiCSpW87HIjOFwaN5zjNl5PxIA1XDS5nP+pMS+8liKNul1X/
	 KZxMbr2ObYbsgj+nXSBGL3900N1h3dfrw1dS8yMb8WZdAXdqNPckwXRdTSCbFFkNnN
	 RYTDm7kOscFEnvVaZYvXEHiTH0xnnTbKmb+0M+eM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Jocelyn Falempe <jfalempe@redhat.com>,
	Francesco Valla <francesco@valla.it>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 211/217] drm/client: Deprecate struct drm_client_buffer.gem
Date: Thu, 20 Aug 2026 16:56:19 +0200
Message-ID: <20260820145244.041270461@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145237.531699751@linuxfoundation.org>
References: <20260820145237.531699751@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Zimmermann <tzimmermann@suse.de>

[ Upstream commit ea39f2e66e61035e203530977a3df428345d03e2 ]

The client buffer's framebuffer holds a reference and pointer on
each of its GEM buffer objects. Thus the field gem in the client-
buffer struct is not necessary. Deprecated the field and convert
the client-buffer helpers to use the framebuffer's objects.

In drm_client_buffer_delete(), do a possible vunmap before releasing
the framebuffer. Otherwise we'd eventually release the framebuffer
before unmaping its buffer objects.

v2:
- avoid dependency on CONFIG_DRM_KMS_HELPER

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Reviewed-by: Jocelyn Falempe <jfalempe@redhat.com>
Tested-by: Francesco Valla <francesco@valla.it>
Link: https://patch.msgid.link/20251027121042.143588-5-tzimmermann@suse.de
Stable-dep-of: f4f2bba28df9 ("drm/log: Fix infinite loop when scale is too large for display")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_client.c | 20 ++++++++++++--------
 include/drm/drm_client.h     |  9 +++------
 2 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/drivers/gpu/drm/drm_client.c b/drivers/gpu/drm/drm_client.c
index 73ae63f856a09..9bb49d3771cb7 100644
--- a/drivers/gpu/drm/drm_client.c
+++ b/drivers/gpu/drm/drm_client.c
@@ -17,6 +17,7 @@
 #include <drm/drm_fourcc.h>
 #include <drm/drm_framebuffer.h>
 #include <drm/drm_gem.h>
+#include <drm/drm_gem_framebuffer_helper.h>
 #include <drm/drm_mode.h>
 #include <drm/drm_print.h>
 
@@ -174,17 +175,17 @@ EXPORT_SYMBOL(drm_client_release);
 
 static void drm_client_buffer_delete(struct drm_client_buffer *buffer)
 {
+	struct drm_gem_object *gem = buffer->fb->obj[0];
 	int ret;
 
+	drm_gem_vunmap(gem, &buffer->map);
+
 	ret = drm_mode_rmfb(buffer->client->dev, buffer->fb->base.id, buffer->client->file);
 	if (ret)
 		drm_err(buffer->client->dev,
 			"Error removing FB:%u (%d)\n", buffer->fb->base.id, ret);
 
-	if (buffer->gem) {
-		drm_gem_vunmap(buffer->gem, &buffer->map);
-		drm_gem_object_put(buffer->gem);
-	}
+	drm_gem_object_put(buffer->gem);
 
 	kfree(buffer);
 }
@@ -274,7 +275,7 @@ drm_client_buffer_create(struct drm_client_dev *client, u32 width, u32 height,
 int drm_client_buffer_vmap_local(struct drm_client_buffer *buffer,
 				 struct iosys_map *map_copy)
 {
-	struct drm_gem_object *gem = buffer->gem;
+	struct drm_gem_object *gem = buffer->fb->obj[0];
 	struct iosys_map *map = &buffer->map;
 	int ret;
 
@@ -303,7 +304,7 @@ EXPORT_SYMBOL(drm_client_buffer_vmap_local);
  */
 void drm_client_buffer_vunmap_local(struct drm_client_buffer *buffer)
 {
-	struct drm_gem_object *gem = buffer->gem;
+	struct drm_gem_object *gem = buffer->fb->obj[0];
 	struct iosys_map *map = &buffer->map;
 
 	drm_gem_vunmap_locked(gem, map);
@@ -334,9 +335,10 @@ EXPORT_SYMBOL(drm_client_buffer_vunmap_local);
 int drm_client_buffer_vmap(struct drm_client_buffer *buffer,
 			   struct iosys_map *map_copy)
 {
+	struct drm_gem_object *gem = buffer->fb->obj[0];
 	int ret;
 
-	ret = drm_gem_vmap(buffer->gem, &buffer->map);
+	ret = drm_gem_vmap(gem, &buffer->map);
 	if (ret)
 		return ret;
 	*map_copy = buffer->map;
@@ -355,7 +357,9 @@ EXPORT_SYMBOL(drm_client_buffer_vmap);
  */
 void drm_client_buffer_vunmap(struct drm_client_buffer *buffer)
 {
-	drm_gem_vunmap(buffer->gem, &buffer->map);
+	struct drm_gem_object *gem = buffer->fb->obj[0];
+
+	drm_gem_vunmap(gem, &buffer->map);
 }
 EXPORT_SYMBOL(drm_client_buffer_vunmap);
 
diff --git a/include/drm/drm_client.h b/include/drm/drm_client.h
index 23a8420816224..78db5f03b80e6 100644
--- a/include/drm/drm_client.h
+++ b/include/drm/drm_client.h
@@ -176,12 +176,9 @@ struct drm_client_buffer {
 	/**
 	 * @gem: GEM object backing this buffer
 	 *
-	 * FIXME: The dependency on GEM here isn't required, we could
-	 * convert the driver handle to a dma-buf instead and use the
-	 * backend-agnostic dma-buf vmap support instead. This would
-	 * require that the handle2fd prime ioctl is reworked to pull the
-	 * fd_install step out of the driver backend hooks, to make that
-	 * final step optional for internal users.
+	 * FIXME: The DRM framebuffer holds a reference on its GEM
+	 * buffer objects. Do not use this field in new code and
+	 * update existing users.
 	 */
 	struct drm_gem_object *gem;
 
-- 
2.53.0



