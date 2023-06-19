Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 263C98BE5
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 10:49:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3904C433C9;
	Mon, 19 Jun 2023 10:49:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687171790;
	bh=xVNGg+mf3PaqwE7i8ljUycbIIPAeBrznivx5dRbUUGE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mibW8RHd0v8YpIrOICpBR8zm+fNX0e9X8JjY2fVxHX31Digv6pC7h8WG0bPJQSf5b
	 wdGOwSO9/f12ohK4YKWI6kWiX1w7kGWuDbgxTYxCrlUMiKqVCzYIh8j4vkZYHeG1GI
	 3AC1udijumbPq1NJGsfj/SvMzJxnr1kgSzRAR7TU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Javier Martinez Canillas <javierm@redhat.com>,
	"Gagniuc, Alexandru" <alexandru.gagniuc@hp.com>
Subject: [PATCH 6.1 157/166] drm/amdgpu: Dont set struct drm_driver.output_poll_changed
Date: Mon, 19 Jun 2023 12:30:34 +0200
Message-ID: <20230619102202.306666026@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102154.568541872@linuxfoundation.org>
References: <20230619102154.568541872@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Thomas Zimmermann <tzimmermann@suse.de>

commit 0e3172bac3f43759719384403fe2d1e4c61f87e0 upstream.

Don't set struct drm_driver.output_poll_changed. It's used to restore
the fbdev console. But as amdgpu uses generic fbdev emulation, the
console is being restored by the DRM client helpers already. See the
functions drm_kms_helper_hotplug_event() and
drm_kms_helper_connector_hotplug_event() in drm_probe_helper.c.

v2:
	* fix commit description (Christian)

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20221103151446.2638-5-tzimmermann@suse.de
Cc: "Gagniuc, Alexandru" <alexandru.gagniuc@hp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_display.c       |    1 -
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |    2 --
 2 files changed, 3 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_display.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_display.c
@@ -1214,7 +1214,6 @@ amdgpu_display_user_framebuffer_create(s
 
 const struct drm_mode_config_funcs amdgpu_mode_funcs = {
 	.fb_create = amdgpu_display_user_framebuffer_create,
-	.output_poll_changed = drm_fb_helper_output_poll_changed,
 };
 
 static const struct drm_prop_enum_list amdgpu_underscan_enum_list[] =
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -83,7 +83,6 @@
 #include <drm/drm_atomic_uapi.h>
 #include <drm/drm_atomic_helper.h>
 #include <drm/drm_blend.h>
-#include <drm/drm_fb_helper.h>
 #include <drm/drm_fourcc.h>
 #include <drm/drm_edid.h>
 #include <drm/drm_vblank.h>
@@ -2875,7 +2874,6 @@ const struct amdgpu_ip_block_version dm_
 static const struct drm_mode_config_funcs amdgpu_dm_mode_funcs = {
 	.fb_create = amdgpu_display_user_framebuffer_create,
 	.get_format_info = amd_get_format_info,
-	.output_poll_changed = drm_fb_helper_output_poll_changed,
 	.atomic_check = amdgpu_dm_atomic_check,
 	.atomic_commit = drm_atomic_helper_commit,
 };


