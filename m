Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74DA6380FF6;
	Thu, 20 Aug 2026 15:21:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787239309; cv=none; b=lNZiv1ryPJtiaQHxUHVTHI9dQPJGS6ZodvqZAdRYS5qAcw1FAX8ugfaRkWQeQsjCGow70YJpP3P6HTTncTkIcmn2VdIhSB8MHpiE4bHcBrO3FpvTQkunzwXmf11yITQrXBWFfCM/5btmMdJBUab5h7+hIZVx0OpVulzjaXRZLGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787239309; c=relaxed/simple;
	bh=UtupW37sDUvvZqLPdaS5sO12vqp0+C7iJmMJYGn7ECY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UpMGevIGBcftyGOOTlFBh4FF4eUuubs3/yN8HoTd1XOhaaI+uoAMQlgQ85JqJsWgCiEEldB/f1JnQxR2l4lC+2pC2e/rEbASCmsBC8YpZ+mHcWC+bpOREKvcf4VLsHX5HiSGeo2Rf154e52onfxsi0uUNLLsX4/cAVMWvZJoPEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aFJMQw1f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aFJMQw1f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CED151F000E9;
	Thu, 20 Aug 2026 15:21:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787239308;
	bh=SlxZPfiID/9oQmJi1yfW9RJ6K70tFmq2gcGdKwOQwbY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aFJMQw1fq8AqRV+qWy1idZs3AuwK4SRnmiIBVwzhrIOkT7O4EO39WRFdfwHFt/1/r
	 Axz01Pu/5lQssjogCRTnRD9DvjsUxuQXYuTQjdd1RhrhN0eBQ93LF/r9ttptsWWlZx
	 aXq+Sqr/InGnaqA1NVP3eMePkhutVKqT0xjQJepM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Jocelyn Falempe <jfalempe@redhat.com>,
	Francesco Valla <francesco@valla.it>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 209/217] drm/client: Move dumb-buffer handling to drm_client_framebuffer_create()
Date: Thu, 20 Aug 2026 16:56:17 +0200
Message-ID: <20260820145243.986109779@linuxfoundation.org>
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

[ Upstream commit 2d262a483c7a128e50cdb64a0ec20c6d78df66cc ]

Dumb-buffer creation within the client code is asymetrically balanced
across drm_client_buffer_create() and drm_client_framebuffer_create().
Put all dumb-buffer code into drm_client_framebuffer_create() and leave
client-buffer initialization to drm_client_buffer_create(). Clarifies
responsibility between these functions.

Apart form the architectural improvements, drm_client_buffer_create()
can now be exported if needed by clients. The client will be able to
initialize buffers that have been created from other interfaces than
dumb buffers.

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Reviewed-by: Jocelyn Falempe <jfalempe@redhat.com>
Tested-by: Francesco Valla <francesco@valla.it>
Link: https://patch.msgid.link/20251027121042.143588-3-tzimmermann@suse.de
Stable-dep-of: f4f2bba28df9 ("drm/log: Fix infinite loop when scale is too large for display")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_client.c | 56 +++++++++++++++++++-----------------
 1 file changed, 29 insertions(+), 27 deletions(-)

diff --git a/drivers/gpu/drm/drm_client.c b/drivers/gpu/drm/drm_client.c
index 5fa8a16285635..9bf2edfb7b641 100644
--- a/drivers/gpu/drm/drm_client.c
+++ b/drivers/gpu/drm/drm_client.c
@@ -184,11 +184,8 @@ static void drm_client_buffer_delete(struct drm_client_buffer *buffer)
 
 static struct drm_client_buffer *
 drm_client_buffer_create(struct drm_client_dev *client, u32 width, u32 height,
-			 u32 format, u32 *handle, u32 *pitch)
+			 u32 format, u32 handle, u32 pitch)
 {
-	const struct drm_format_info *info = drm_format_info(format);
-	struct drm_mode_create_dumb dumb_args = { };
-	struct drm_device *dev = client->dev;
 	struct drm_client_buffer *buffer;
 	struct drm_gem_object *obj;
 	int ret;
@@ -199,28 +196,18 @@ drm_client_buffer_create(struct drm_client_dev *client, u32 width, u32 height,
 
 	buffer->client = client;
 
-	dumb_args.width = width;
-	dumb_args.height = height;
-	dumb_args.bpp = drm_format_info_bpp(info, 0);
-	ret = drm_mode_create_dumb(dev, &dumb_args, client->file);
-	if (ret)
-		goto err_delete;
-
-	obj = drm_gem_object_lookup(client->file, dumb_args.handle);
+	obj = drm_gem_object_lookup(client->file, handle);
 	if (!obj)  {
 		ret = -ENOENT;
 		goto err_delete;
 	}
 
 	buffer->gem = obj;
-	*handle = dumb_args.handle;
-	*pitch = dumb_args.pitch;
 
 	return buffer;
 
 err_delete:
-	drm_client_buffer_delete(buffer);
-
+	kfree(buffer);
 	return ERR_PTR(ret);
 }
 
@@ -394,16 +381,30 @@ static int drm_client_buffer_addfb(struct drm_client_buffer *buffer,
 struct drm_client_buffer *
 drm_client_framebuffer_create(struct drm_client_dev *client, u32 width, u32 height, u32 format)
 {
+	const struct drm_format_info *info = drm_format_info(format);
+	struct drm_device *dev = client->dev;
+	struct drm_mode_create_dumb dumb_args = { };
 	struct drm_client_buffer *buffer;
-	u32 handle, pitch;
 	int ret;
 
+	dumb_args.width = width;
+	dumb_args.height = height;
+	dumb_args.bpp = drm_format_info_bpp(info, 0);
+	ret = drm_mode_create_dumb(dev, &dumb_args, client->file);
+	if (ret)
+		return ERR_PTR(ret);
+
 	buffer = drm_client_buffer_create(client, width, height, format,
-					  &handle, &pitch);
-	if (IS_ERR(buffer))
-		return buffer;
+					  dumb_args.handle, dumb_args.pitch);
+	if (IS_ERR(buffer)) {
+		ret = PTR_ERR(buffer);
+		goto err_drm_mode_destroy_dumb;
+	}
 
-	ret = drm_client_buffer_addfb(buffer, width, height, format, handle, pitch);
+	ret = drm_client_buffer_addfb(buffer, width, height, format,
+				      dumb_args.handle, dumb_args.pitch);
+	if (ret)
+		goto err_drm_client_buffer_delete;
 
 	/*
 	 * The handle is only needed for creating the framebuffer, destroy it
@@ -411,14 +412,15 @@ drm_client_framebuffer_create(struct drm_client_dev *client, u32 width, u32 heig
 	 * object as DMA-buf. The framebuffer and our buffer structure are still
 	 * holding references to the GEM object to prevent its destruction.
 	 */
-	drm_mode_destroy_dumb(client->dev, handle, client->file);
-
-	if (ret) {
-		drm_client_buffer_delete(buffer);
-		return ERR_PTR(ret);
-	}
+	drm_mode_destroy_dumb(client->dev, dumb_args.handle, client->file);
 
 	return buffer;
+
+err_drm_client_buffer_delete:
+	drm_client_buffer_delete(buffer);
+err_drm_mode_destroy_dumb:
+	drm_mode_destroy_dumb(client->dev, dumb_args.handle, client->file);
+	return ERR_PTR(ret);
 }
 EXPORT_SYMBOL(drm_client_framebuffer_create);
 
-- 
2.53.0



