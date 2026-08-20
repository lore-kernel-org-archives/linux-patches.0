Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55D93377A89;
	Thu, 20 Aug 2026 15:21:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787239312; cv=none; b=cbJpmBH1BKbPJc357vuje6EzvEUptIcl0jCNnxG2Pxn0hRC8EtgeHSE4hdhhyRjgZkKXd0qKBOB3zHDoRSKKVE7P7Zg0G5TJFg8DIxsw2bCClq+IOiR71BD3ejLlI28dSx569k9psbqOjZ2CEL/f8vh9J36oadtoDe8JSxlB8kg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787239312; c=relaxed/simple;
	bh=FRGDtVqaRti3RalqgTMD9kC9cZf/aHGPLiqnvq63zVg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=thYXeuQd2U02a57KjduMLhXojuXnQeFDvq1kZh3juueQbFvk0yCUHNcMbr4aJWj+OuLNEV5yzxXHRoqbctaND5Cv7MiMH9LC6bwfs2ixCYFDVz2hTecBt14ZczoZwU/hgZp9ZKSCvJ3dbXrj+0NIku7y1pU1k0daW7naDW0hlA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k0eo5pbp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k0eo5pbp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B01031F000E9;
	Thu, 20 Aug 2026 15:21:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787239311;
	bh=pp0Rf3o+b+xjH900M1WWKDYDd8npmFw+nSvOVuQvwcI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k0eo5pbp2e8GhpKltbLwvCGCFaCUduobqUwWmioBCeq/S72R0ROpDouHwLbx7Ku/1
	 HEoAsl/q/SA3LEUh3/rtN48G6mvj8KbjoZp3+UeMWjwDEw9Fk6pZKtYbjylgFYzAtS
	 lfL6XIiBpuK2irBIFx3ipMraeobVD2Y4bLSQZ+W8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Jocelyn Falempe <jfalempe@redhat.com>,
	Francesco Valla <francesco@valla.it>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 210/217] drm/client: Inline drm_client_buffer_addfb() and _rmfb()
Date: Thu, 20 Aug 2026 16:56:18 +0200
Message-ID: <20260820145244.013355798@linuxfoundation.org>
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

[ Upstream commit 7cc0f6171b9f93da2815d95d4410f14583cba58f ]

Creating and deleting a client buffer always creates and deletes
the underlying DRM framebuffer. Inline the helper functions into
their callers.

With the _addfb code being inlined into drm_client_buffer_create(),
clean up the function's error rollback to release the framebuffer's
handle and GEM buffer object as needed.

Move the _rmfb code into drm_client_buffer_delete() rather than its
current location in drm_client_framebuffer_delete(). The former is
now the inverse of drm_client_buffer_create(). Makes no difference
for cleaning up. Also prepares for the removal of
drm_client_framebuffer_delete().

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Reviewed-by: Jocelyn Falempe <jfalempe@redhat.com>
Tested-by: Francesco Valla <francesco@valla.it>
Link: https://patch.msgid.link/20251027121042.143588-4-tzimmermann@suse.de
Stable-dep-of: f4f2bba28df9 ("drm/log: Fix infinite loop when scale is too large for display")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_client.c | 93 ++++++++++++++++--------------------
 1 file changed, 40 insertions(+), 53 deletions(-)

diff --git a/drivers/gpu/drm/drm_client.c b/drivers/gpu/drm/drm_client.c
index 9bf2edfb7b641..73ae63f856a09 100644
--- a/drivers/gpu/drm/drm_client.c
+++ b/drivers/gpu/drm/drm_client.c
@@ -174,6 +174,13 @@ EXPORT_SYMBOL(drm_client_release);
 
 static void drm_client_buffer_delete(struct drm_client_buffer *buffer)
 {
+	int ret;
+
+	ret = drm_mode_rmfb(buffer->client->dev, buffer->fb->base.id, buffer->client->file);
+	if (ret)
+		drm_err(buffer->client->dev,
+			"Error removing FB:%u (%d)\n", buffer->fb->base.id, ret);
+
 	if (buffer->gem) {
 		drm_gem_vunmap(buffer->gem, &buffer->map);
 		drm_gem_object_put(buffer->gem);
@@ -186,8 +193,21 @@ static struct drm_client_buffer *
 drm_client_buffer_create(struct drm_client_dev *client, u32 width, u32 height,
 			 u32 format, u32 handle, u32 pitch)
 {
+	struct drm_mode_fb_cmd2 fb_req = {
+		.width = width,
+		.height = height,
+		.pixel_format = format,
+		.handles = {
+			handle,
+		},
+		.pitches = {
+			pitch,
+		},
+	};
+	struct drm_device *dev = client->dev;
 	struct drm_client_buffer *buffer;
 	struct drm_gem_object *obj;
+	struct drm_framebuffer *fb;
 	int ret;
 
 	buffer = kzalloc(sizeof(*buffer), GFP_KERNEL);
@@ -202,10 +222,30 @@ drm_client_buffer_create(struct drm_client_dev *client, u32 width, u32 height,
 		goto err_delete;
 	}
 
+	ret = drm_mode_addfb2(dev, &fb_req, client->file);
+	if (ret)
+		goto err_drm_gem_object_put;
+
+	fb = drm_framebuffer_lookup(dev, client->file, fb_req.fb_id);
+	if (drm_WARN_ON(dev, !fb)) {
+		ret = -ENOENT;
+		goto err_drm_mode_rmfb;
+	}
+
+	/* drop the reference we picked up in framebuffer lookup */
+	drm_framebuffer_put(fb);
+
+	strscpy(fb->comm, client->name, TASK_COMM_LEN);
+
 	buffer->gem = obj;
+	buffer->fb = fb;
 
 	return buffer;
 
+err_drm_mode_rmfb:
+	drm_mode_rmfb(dev, fb_req.fb_id, client->file);
+err_drm_gem_object_put:
+	drm_gem_object_put(obj);
 err_delete:
 	kfree(buffer);
 	return ERR_PTR(ret);
@@ -319,51 +359,6 @@ void drm_client_buffer_vunmap(struct drm_client_buffer *buffer)
 }
 EXPORT_SYMBOL(drm_client_buffer_vunmap);
 
-static void drm_client_buffer_rmfb(struct drm_client_buffer *buffer)
-{
-	int ret;
-
-	if (!buffer->fb)
-		return;
-
-	ret = drm_mode_rmfb(buffer->client->dev, buffer->fb->base.id, buffer->client->file);
-	if (ret)
-		drm_err(buffer->client->dev,
-			"Error removing FB:%u (%d)\n", buffer->fb->base.id, ret);
-
-	buffer->fb = NULL;
-}
-
-static int drm_client_buffer_addfb(struct drm_client_buffer *buffer,
-				   u32 width, u32 height, u32 format,
-				   u32 handle, u32 pitch)
-{
-	struct drm_client_dev *client = buffer->client;
-	struct drm_mode_fb_cmd2 fb_req = { };
-	int ret;
-
-	fb_req.width = width;
-	fb_req.height = height;
-	fb_req.pixel_format = format;
-	fb_req.handles[0] = handle;
-	fb_req.pitches[0] = pitch;
-
-	ret = drm_mode_addfb2(client->dev, &fb_req, client->file);
-	if (ret)
-		return ret;
-
-	buffer->fb = drm_framebuffer_lookup(client->dev, buffer->client->file, fb_req.fb_id);
-	if (WARN_ON(!buffer->fb))
-		return -ENOENT;
-
-	/* drop the reference we picked up in framebuffer lookup */
-	drm_framebuffer_put(buffer->fb);
-
-	strscpy(buffer->fb->comm, client->name, TASK_COMM_LEN);
-
-	return 0;
-}
-
 /**
  * drm_client_framebuffer_create - Create a client framebuffer
  * @client: DRM client
@@ -401,11 +396,6 @@ drm_client_framebuffer_create(struct drm_client_dev *client, u32 width, u32 heig
 		goto err_drm_mode_destroy_dumb;
 	}
 
-	ret = drm_client_buffer_addfb(buffer, width, height, format,
-				      dumb_args.handle, dumb_args.pitch);
-	if (ret)
-		goto err_drm_client_buffer_delete;
-
 	/*
 	 * The handle is only needed for creating the framebuffer, destroy it
 	 * again to solve a circular dependency should anybody export the GEM
@@ -416,8 +406,6 @@ drm_client_framebuffer_create(struct drm_client_dev *client, u32 width, u32 heig
 
 	return buffer;
 
-err_drm_client_buffer_delete:
-	drm_client_buffer_delete(buffer);
 err_drm_mode_destroy_dumb:
 	drm_mode_destroy_dumb(client->dev, dumb_args.handle, client->file);
 	return ERR_PTR(ret);
@@ -433,7 +421,6 @@ void drm_client_framebuffer_delete(struct drm_client_buffer *buffer)
 	if (!buffer)
 		return;
 
-	drm_client_buffer_rmfb(buffer);
 	drm_client_buffer_delete(buffer);
 }
 EXPORT_SYMBOL(drm_client_framebuffer_delete);
-- 
2.53.0



