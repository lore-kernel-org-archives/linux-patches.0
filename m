Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 055E81E4A2;
	Mon,  8 Jan 2024 15:38:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HWkcglQx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E5CFC433CB;
	Mon,  8 Jan 2024 15:38:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704728285;
	bh=eqzUt2b52g6QAxUP5nMWjKPwXA4JWsIRx8Kf1+vYq/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HWkcglQxa8XfE2lxLaWKizBUR3I+oI0STQRqcQvDwffZI7jR4ChDKpaeMdH57JY03
	 Dxd8q5kEQphmc+i5wiPAZ8tozu6hj9M9ITNRfCuv2U5QyircLQDhnNsdpifbmvKZtg
	 tuZlfC7IxutIAaBSqRzzejb3jbauQ7LndTJrt90A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roger Sewell <roger.sewell@cantab.net>,
	Jocelyn Falempe <jfalempe@redhat.com>,
	Thomas Zimmermann <tzimmermann@suse.de>
Subject: [PATCH 6.1 008/150] drm/mgag200: Fix gamma lut not initialized for G200ER, G200EV, G200SE
Date: Mon,  8 Jan 2024 16:34:19 +0100
Message-ID: <20240108153511.617046763@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240108153511.214254205@linuxfoundation.org>
References: <20240108153511.214254205@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jocelyn Falempe <jfalempe@redhat.com>

commit 11f9eb899ecc8c02b769cf8d2532ba12786a7af7 upstream.

When mgag200 switched from simple KMS to regular atomic helpers,
the initialization of the gamma settings was lost.
This leads to a black screen, if the bios/uefi doesn't use the same
pixel color depth.
This has been fixed with commit ad81e23426a6 ("drm/mgag200: Fix gamma
lut not initialized.") for most G200, but G200ER, G200EV, G200SE use
their own version of crtc_helper_atomic_enable() and need to be fixed
too.

Fixes: 1baf9127c482 ("drm/mgag200: Replace simple-KMS with regular atomic helpers")
Cc: <stable@vger.kernel.org> #v6.1+
Reported-by: Roger Sewell <roger.sewell@cantab.net>
Suggested-by: Roger Sewell <roger.sewell@cantab.net>
Signed-off-by: Jocelyn Falempe <jfalempe@redhat.com>
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20231214163849.359691-1-jfalempe@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/mgag200/mgag200_drv.h    |    5 +++++
 drivers/gpu/drm/mgag200/mgag200_g200er.c |    5 +++++
 drivers/gpu/drm/mgag200/mgag200_g200ev.c |    5 +++++
 drivers/gpu/drm/mgag200/mgag200_g200se.c |    5 +++++
 drivers/gpu/drm/mgag200/mgag200_mode.c   |   10 +++++-----
 5 files changed, 25 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/mgag200/mgag200_drv.h
+++ b/drivers/gpu/drm/mgag200/mgag200_drv.h
@@ -390,6 +390,11 @@ void mgag200_primary_plane_helper_atomic
 	.destroy = drm_plane_cleanup, \
 	DRM_GEM_SHADOW_PLANE_FUNCS
 
+void mgag200_crtc_set_gamma_linear(struct mga_device *mdev, const struct drm_format_info *format);
+void mgag200_crtc_set_gamma(struct mga_device *mdev,
+			    const struct drm_format_info *format,
+			    struct drm_color_lut *lut);
+
 enum drm_mode_status mgag200_crtc_helper_mode_valid(struct drm_crtc *crtc,
 						    const struct drm_display_mode *mode);
 int mgag200_crtc_helper_atomic_check(struct drm_crtc *crtc, struct drm_atomic_state *new_state);
--- a/drivers/gpu/drm/mgag200/mgag200_g200er.c
+++ b/drivers/gpu/drm/mgag200/mgag200_g200er.c
@@ -202,6 +202,11 @@ static void mgag200_g200er_crtc_helper_a
 
 	mgag200_g200er_reset_tagfifo(mdev);
 
+	if (crtc_state->gamma_lut)
+		mgag200_crtc_set_gamma(mdev, format, crtc_state->gamma_lut->data);
+	else
+		mgag200_crtc_set_gamma_linear(mdev, format);
+
 	mgag200_enable_display(mdev);
 
 	if (funcs->enable_vidrst)
--- a/drivers/gpu/drm/mgag200/mgag200_g200ev.c
+++ b/drivers/gpu/drm/mgag200/mgag200_g200ev.c
@@ -203,6 +203,11 @@ static void mgag200_g200ev_crtc_helper_a
 
 	mgag200_g200ev_set_hiprilvl(mdev);
 
+	if (crtc_state->gamma_lut)
+		mgag200_crtc_set_gamma(mdev, format, crtc_state->gamma_lut->data);
+	else
+		mgag200_crtc_set_gamma_linear(mdev, format);
+
 	mgag200_enable_display(mdev);
 
 	if (funcs->enable_vidrst)
--- a/drivers/gpu/drm/mgag200/mgag200_g200se.c
+++ b/drivers/gpu/drm/mgag200/mgag200_g200se.c
@@ -334,6 +334,11 @@ static void mgag200_g200se_crtc_helper_a
 
 	mgag200_g200se_set_hiprilvl(mdev, adjusted_mode, format);
 
+	if (crtc_state->gamma_lut)
+		mgag200_crtc_set_gamma(mdev, format, crtc_state->gamma_lut->data);
+	else
+		mgag200_crtc_set_gamma_linear(mdev, format);
+
 	mgag200_enable_display(mdev);
 
 	if (funcs->enable_vidrst)
--- a/drivers/gpu/drm/mgag200/mgag200_mode.c
+++ b/drivers/gpu/drm/mgag200/mgag200_mode.c
@@ -28,8 +28,8 @@
  * This file contains setup code for the CRTC.
  */
 
-static void mgag200_crtc_set_gamma_linear(struct mga_device *mdev,
-					  const struct drm_format_info *format)
+void mgag200_crtc_set_gamma_linear(struct mga_device *mdev,
+				   const struct drm_format_info *format)
 {
 	int i;
 
@@ -65,9 +65,9 @@ static void mgag200_crtc_set_gamma_linea
 	}
 }
 
-static void mgag200_crtc_set_gamma(struct mga_device *mdev,
-				   const struct drm_format_info *format,
-				   struct drm_color_lut *lut)
+void mgag200_crtc_set_gamma(struct mga_device *mdev,
+			    const struct drm_format_info *format,
+			    struct drm_color_lut *lut)
 {
 	int i;
 


