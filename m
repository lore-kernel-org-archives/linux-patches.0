Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0E747560A;
	Mon, 29 Jan 2024 17:16:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548600; cv=none; b=iZ62dyuf8HDUhtYmOIOZaFI2Pe6LFXAKIBArJIj3gCMDAg1tZ6sNMyMDoC6Eq1U69ic9awolfDQogDmQxDj81GeBUgpr9ulVJqtLM2Zt6OVTOYqPm0P/QmSpcx9F3OJyvBh6hK4KrtVKdoSsx7LIxTA2orEt3Er+pS6GM3jZ1R0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548600; c=relaxed/simple;
	bh=HRstAD3rWayu2A92uT5HOoEZoscppgrEWJB4DJn0gjE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YnWKyj4oyAR1KSNMavB4qRSsbyP/0sWjDhARdPtaNYw/ZBDERCUq8Qjpqdxf/mhtyD72nW2PMDUieV8qijLIbCth6X1NzvCpw51B8KcVvpcRyRi/hEH5/oYnIffpdoOHiDLpRQAwR0BadigG92RxtbTwk9HONvkHZV9kVZanmE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KwH1oTUr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KwH1oTUr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A96CBC433F1;
	Mon, 29 Jan 2024 17:16:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548599;
	bh=HRstAD3rWayu2A92uT5HOoEZoscppgrEWJB4DJn0gjE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KwH1oTUrDoug9zCIBwn/GO/lrjK3H4s1drroZ8vifBdC+hsTwBU9Nm8tAyQQix6Ah
	 A9/+Jtp7kwJboTFGX5lCoHc2ikj89ijy204qH+AhVzCCXvSKfeF/m64YN+BBO+zTQI
	 0dc/uBppZbU77lZaivbYzolZEKaFPN/fWmd5lqjU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	nerdopolis <bluescreen_avenger@verizon.net>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Javier Martinez Canillas <javierm@redhat.com>,
	Zack Rusin <zackr@vmware.com>,
	Sima Vetter <daniel.vetter@ffwll.ch>
Subject: [PATCH 6.6 261/331] drm: Allow drivers to indicate the damage helpers to ignore damage clips
Date: Mon, 29 Jan 2024 09:05:25 -0800
Message-ID: <20240129170022.513609134@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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

From: Javier Martinez Canillas <javierm@redhat.com>

commit 35ed38d58257336c1df26b14fd5110b026e2adde upstream.

It allows drivers to set a struct drm_plane_state .ignore_damage_clips in
their plane's .atomic_check callback, as an indication to damage helpers
such as drm_atomic_helper_damage_iter_init() that the damage clips should
be ignored.

To be used by drivers that do per-buffer (e.g: virtio-gpu) uploads (rather
than per-plane uploads), since these type of drivers need to handle buffer
damages instead of frame damages.

That way, these drivers could force a full plane update if the framebuffer
attached to a plane's state has changed since the last update (page-flip).

Fixes: 01f05940a9a7 ("drm/virtio: Enable fb damage clips property for the primary plane")
Cc: <stable@vger.kernel.org> # v6.4+
Reported-by: nerdopolis <bluescreen_avenger@verizon.net>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=218115
Suggested-by: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Javier Martinez Canillas <javierm@redhat.com>
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Reviewed-by: Zack Rusin <zackr@vmware.com>
Acked-by: Sima Vetter <daniel.vetter@ffwll.ch>
Link: https://patchwork.freedesktop.org/patch/msgid/20231123221315.3579454-2-javierm@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/gpu/drm-kms.rst       |    2 ++
 drivers/gpu/drm/drm_damage_helper.c |    3 ++-
 include/drm/drm_plane.h             |   10 ++++++++++
 3 files changed, 14 insertions(+), 1 deletion(-)

--- a/Documentation/gpu/drm-kms.rst
+++ b/Documentation/gpu/drm-kms.rst
@@ -546,6 +546,8 @@ Plane Composition Properties
 .. kernel-doc:: drivers/gpu/drm/drm_blend.c
    :doc: overview
 
+.. _damage_tracking_properties:
+
 Damage Tracking Properties
 --------------------------
 
--- a/drivers/gpu/drm/drm_damage_helper.c
+++ b/drivers/gpu/drm/drm_damage_helper.c
@@ -241,7 +241,8 @@ drm_atomic_helper_damage_iter_init(struc
 	iter->plane_src.x2 = (src.x2 >> 16) + !!(src.x2 & 0xFFFF);
 	iter->plane_src.y2 = (src.y2 >> 16) + !!(src.y2 & 0xFFFF);
 
-	if (!iter->clips || !drm_rect_equals(&state->src, &old_state->src)) {
+	if (!iter->clips || state->ignore_damage_clips ||
+	    !drm_rect_equals(&state->src, &old_state->src)) {
 		iter->clips = NULL;
 		iter->num_clips = 0;
 		iter->full_update = true;
--- a/include/drm/drm_plane.h
+++ b/include/drm/drm_plane.h
@@ -191,6 +191,16 @@ struct drm_plane_state {
 	struct drm_property_blob *fb_damage_clips;
 
 	/**
+	 * @ignore_damage_clips:
+	 *
+	 * Set by drivers to indicate the drm_atomic_helper_damage_iter_init()
+	 * helper that the @fb_damage_clips blob property should be ignored.
+	 *
+	 * See :ref:`damage_tracking_properties` for more information.
+	 */
+	bool ignore_damage_clips;
+
+	/**
 	 * @src:
 	 *
 	 * source coordinates of the plane (in 16.16).


