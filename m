Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E16F17AA6
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:24:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D319CC433C8;
	Wed,  9 Aug 2023 11:24:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691580251;
	bh=Sa3BukU6kNkCDw15hMlUGK7S1VHMnOS1tI3hAkDUbvo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xbJEocZJIXWHX6DInUh0rCSEMqt6oNvM+7r/3QDCKWbu/2iQV9ayM4sEcUo/OvUA5
	 8NPRNNNyAkf1W9MLdJ3L4FNnADY+vX3jdWMExLPOmFMwU+P+1u+s2aGfSosna5Ce9B
	 q/udQHkhRRQKwNb3i+3Xlt+L4/oeY2WTasxbYGuM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Yi <yizhan@redhat.com>,
	Jocelyn Falempe <jfalempe@redhat.com>,
	Javier Martinez Canillas <javierm@redhat.com>,
	Thomas Zimmermann <tzimmermann@suse.de>
Subject: [PATCH 4.19 282/323] drm/client: Fix memory leak in drm_client_target_cloned
Date: Wed,  9 Aug 2023 12:42:00 +0200
Message-ID: <20230809103710.948981242@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103658.104386911@linuxfoundation.org>
References: <20230809103658.104386911@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jocelyn Falempe <jfalempe@redhat.com>

commit c2a88e8bdf5f6239948d75283d0ae7e0c7945b03 upstream.

dmt_mode is allocated and never freed in this function.
It was found with the ast driver, but most drivers using generic fbdev
setup are probably affected.

This fixes the following kmemleak report:
  backtrace:
    [<00000000b391296d>] drm_mode_duplicate+0x45/0x220 [drm]
    [<00000000e45bb5b3>] drm_client_target_cloned.constprop.0+0x27b/0x480 [drm]
    [<00000000ed2d3a37>] drm_client_modeset_probe+0x6bd/0xf50 [drm]
    [<0000000010e5cc9d>] __drm_fb_helper_initial_config_and_unlock+0xb4/0x2c0 [drm_kms_helper]
    [<00000000909f82ca>] drm_fbdev_client_hotplug+0x2bc/0x4d0 [drm_kms_helper]
    [<00000000063a69aa>] drm_client_register+0x169/0x240 [drm]
    [<00000000a8c61525>] ast_pci_probe+0x142/0x190 [ast]
    [<00000000987f19bb>] local_pci_probe+0xdc/0x180
    [<000000004fca231b>] work_for_cpu_fn+0x4e/0xa0
    [<0000000000b85301>] process_one_work+0x8b7/0x1540
    [<000000003375b17c>] worker_thread+0x70a/0xed0
    [<00000000b0d43cd9>] kthread+0x29f/0x340
    [<000000008d770833>] ret_from_fork+0x1f/0x30
unreferenced object 0xff11000333089a00 (size 128):

cc: <stable@vger.kernel.org>
Fixes: 1d42bbc8f7f9 ("drm/fbdev: fix cloning on fbcon")
Reported-by: Zhang Yi <yizhan@redhat.com>
Signed-off-by: Jocelyn Falempe <jfalempe@redhat.com>
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20230711092203.68157-2-jfalempe@redhat.com
Signed-off-by: Jocelyn Falempe <jfalempe@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_fb_helper.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/gpu/drm/drm_fb_helper.c
+++ b/drivers/gpu/drm/drm_fb_helper.c
@@ -2233,6 +2233,9 @@ static bool drm_target_cloned(struct drm
 	can_clone = true;
 	dmt_mode = drm_mode_find_dmt(fb_helper->dev, 1024, 768, 60, false);
 
+	if (!dmt_mode)
+		goto fail;
+
 	drm_fb_helper_for_each_connector(fb_helper, i) {
 		if (!enabled[i])
 			continue;
@@ -2249,11 +2252,13 @@ static bool drm_target_cloned(struct drm
 		if (!modes[i])
 			can_clone = false;
 	}
+	kfree(dmt_mode);
 
 	if (can_clone) {
 		DRM_DEBUG_KMS("can clone using 1024x768\n");
 		return true;
 	}
+fail:
 	DRM_INFO("kms: can't enable cloning when we probably wanted to.\n");
 	return false;
 }


