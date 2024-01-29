Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADF79159578;
	Mon, 29 Jan 2024 17:10:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548226; cv=none; b=KJyAA8i58oKpx+8+ZXJJEr6NNLyiYfPmzM2ehcwZLF6mOjtr5GvvhHb91O99F4aj6NRBLHeGsNhG0myDtspabR3lzAj00I6EWXbbHUri4cqwaaDPWB4LHyI0/zxnzqjwJgwT6NgY93BwxHl11HG9Gkz6SoyXFbYc2VqNGpfYsdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548226; c=relaxed/simple;
	bh=9z7x+2vECbG647dsEXztqifsd1ouFgVS/QXp7GF1/UA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mBuSsUGepnN9OTtRBZPJgalkECH1xrMwXV40vmq78xzEf7DuqxVEa7mBpx/9laoGHiz0riXCPQN+ohZdCSv6RPgQT8rIMcwtCPoyJHosnvAgVdw+fUnC4FPvrMkeJU3Yo127VwRo8uwkZdd7lPPpHBYE1TlDlM8LBHP3DpdYpBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k7eJl3cZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k7eJl3cZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74427C43394;
	Mon, 29 Jan 2024 17:10:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548226;
	bh=9z7x+2vECbG647dsEXztqifsd1ouFgVS/QXp7GF1/UA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k7eJl3cZx7dQCIyWcl1/pqkKdrSVTaOodP9w47pHI9btboXryXB8jcx4JN8qwAKvD
	 uabMHWsKKS5FkSwppp1wTzd5rR3vjyPJ5YoqS2nT2oScaWtd0780OG2QXWuhTXIjfo
	 oK48QBYUoO6h/5cGCdFhjKE3DJw1vlRgrntLbXh4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	nerdopolis <bluescreen_avenger@verizon.net>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Javier Martinez Canillas <javierm@redhat.com>,
	Zack Rusin <zackr@vmware.com>,
	Sima Vetter <daniel.vetter@ffwll.ch>
Subject: [PATCH 6.7 255/346] drm: Allow drivers to indicate the damage helpers to ignore damage clips
Date: Mon, 29 Jan 2024 09:04:46 -0800
Message-ID: <20240129170023.901848154@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
@@ -548,6 +548,8 @@ Plane Composition Properties
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


