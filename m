Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8929391501;
	Thu, 20 Aug 2026 15:21:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787239307; cv=none; b=OoFrNf25nnXX9kaxM6lhyoxraNWvQZm64+yQDZgDW9Np0Ms2gDwbkfVOly5YkQjXaO1WeCLPDNLR/3mglysG5zle6sNg4PPECO13TRAopqbuNKnwFd/y8mj8nATRWRK2+AozCR1UIshGL4Hbcky18E8Zsi+ADSKB+SoyC9EzinQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787239307; c=relaxed/simple;
	bh=jXVMcZwg0lNvR7nVZ+d1N4khH/HpXS9OreW+AbKKB/Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Slp/rr1ddawPz8hjV62o+uRg5G/8yayac7gBX1tp6eeIlx/vBth6u8bHYPpq/GG0lGHJB6FCcPeQGqZxp+87/srh2z4HLo7mT7FTPIdSAiRovuhv3hKphhlxfvKRdrLJMjw+q5X2GbrCefm8wvJUjqnkg/xDdCSVNwkiGiUjHj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K4pgvcf/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K4pgvcf/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F22591F00A3A;
	Thu, 20 Aug 2026 15:21:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787239305;
	bh=q9zXkTS0tGtBoXWHo6RwxqhBBhnIF/fKFG1QN3fBCwQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K4pgvcf/FX+52FshyVLRuHpMmnYvHKyeeDxKRZ10sCnoIIGcoyMmWpLjy81IDD2ho
	 cbQtyX/tQtVA7udNMPuGMKR7tHWV6aN2PgKu/LM4BjReNWcuwwPib+F4OwYXHCQYiK
	 J8HdSD0Zc1llNw4V70pq8hPCe+t1I3U/O8vE6wuw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Jocelyn Falempe <jfalempe@redhat.com>,
	Francesco Valla <francesco@valla.it>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 208/217] drm/client: Remove pitch from struct drm_client_buffer
Date: Thu, 20 Aug 2026 16:56:16 +0200
Message-ID: <20260820145243.958619592@linuxfoundation.org>
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

[ Upstream commit dce4657ff526b65007fe8d5c92968a933cc7c9da ]

Only the client-buffer setup uses the pitch field from struct
drm_client_buffer. Remove the field and pass the value among setup
helpers.

Clients that need the pitch should rather look at the framebuffer's
pitches[0] directly.

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Reviewed-by: Jocelyn Falempe <jfalempe@redhat.com>
Tested-by: Francesco Valla <francesco@valla.it>
Link: https://patch.msgid.link/20251027121042.143588-2-tzimmermann@suse.de
Stable-dep-of: f4f2bba28df9 ("drm/log: Fix infinite loop when scale is too large for display")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_client.c | 14 +++++++-------
 include/drm/drm_client.h     |  5 -----
 2 files changed, 7 insertions(+), 12 deletions(-)

diff --git a/drivers/gpu/drm/drm_client.c b/drivers/gpu/drm/drm_client.c
index 3fa38d4ac70b6..5fa8a16285635 100644
--- a/drivers/gpu/drm/drm_client.c
+++ b/drivers/gpu/drm/drm_client.c
@@ -184,7 +184,7 @@ static void drm_client_buffer_delete(struct drm_client_buffer *buffer)
 
 static struct drm_client_buffer *
 drm_client_buffer_create(struct drm_client_dev *client, u32 width, u32 height,
-			 u32 format, u32 *handle)
+			 u32 format, u32 *handle, u32 *pitch)
 {
 	const struct drm_format_info *info = drm_format_info(format);
 	struct drm_mode_create_dumb dumb_args = { };
@@ -212,9 +212,9 @@ drm_client_buffer_create(struct drm_client_dev *client, u32 width, u32 height,
 		goto err_delete;
 	}
 
-	buffer->pitch = dumb_args.pitch;
 	buffer->gem = obj;
 	*handle = dumb_args.handle;
+	*pitch = dumb_args.pitch;
 
 	return buffer;
 
@@ -349,7 +349,7 @@ static void drm_client_buffer_rmfb(struct drm_client_buffer *buffer)
 
 static int drm_client_buffer_addfb(struct drm_client_buffer *buffer,
 				   u32 width, u32 height, u32 format,
-				   u32 handle)
+				   u32 handle, u32 pitch)
 {
 	struct drm_client_dev *client = buffer->client;
 	struct drm_mode_fb_cmd2 fb_req = { };
@@ -359,7 +359,7 @@ static int drm_client_buffer_addfb(struct drm_client_buffer *buffer,
 	fb_req.height = height;
 	fb_req.pixel_format = format;
 	fb_req.handles[0] = handle;
-	fb_req.pitches[0] = buffer->pitch;
+	fb_req.pitches[0] = pitch;
 
 	ret = drm_mode_addfb2(client->dev, &fb_req, client->file);
 	if (ret)
@@ -395,15 +395,15 @@ struct drm_client_buffer *
 drm_client_framebuffer_create(struct drm_client_dev *client, u32 width, u32 height, u32 format)
 {
 	struct drm_client_buffer *buffer;
-	u32 handle;
+	u32 handle, pitch;
 	int ret;
 
 	buffer = drm_client_buffer_create(client, width, height, format,
-					  &handle);
+					  &handle, &pitch);
 	if (IS_ERR(buffer))
 		return buffer;
 
-	ret = drm_client_buffer_addfb(buffer, width, height, format, handle);
+	ret = drm_client_buffer_addfb(buffer, width, height, format, handle, pitch);
 
 	/*
 	 * The handle is only needed for creating the framebuffer, destroy it
diff --git a/include/drm/drm_client.h b/include/drm/drm_client.h
index 146ca80e35db6..23a8420816224 100644
--- a/include/drm/drm_client.h
+++ b/include/drm/drm_client.h
@@ -173,11 +173,6 @@ struct drm_client_buffer {
 	 */
 	struct drm_client_dev *client;
 
-	/**
-	 * @pitch: Buffer pitch
-	 */
-	u32 pitch;
-
 	/**
 	 * @gem: GEM object backing this buffer
 	 *
-- 
2.53.0



