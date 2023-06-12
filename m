Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3288F1952C
	for <patches@lists.linux.dev>; Mon, 12 Jun 2023 10:31:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD02AC433D2;
	Mon, 12 Jun 2023 10:31:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686565918;
	bh=gu+woyY600EgFNCOX5M7aN+WcWbBcb/QrxPZoXv4bwo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v9xzQK4ysB+ErIFZNai2xjmqWLX8wflfJr3XEIghqAz6UT7J1aj0NDgV92yw1ma8D
	 4QlNPOh8WtaKbuWVFatLYOeN03wlUGfqE/nW87n0uH+FzTwiQGQz9ouLtkaZmSpuOc
	 lH5T0mvv0jGcQmPXmMsP60DiNQ3iSHfVJbMVJ8DE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	fuyufan <fuyufan@huawei.com>,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Maxime Ripard <maxime@cerno.tech>,
	Fedor Pchelkin <pchelkin@ispras.ru>
Subject: [PATCH 5.4 40/45] drm/atomic: Dont pollute crtc_state->mode_blob with error pointers
Date: Mon, 12 Jun 2023 12:26:34 +0200
Message-ID: <20230612101656.280451877@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230612101654.644983109@linuxfoundation.org>
References: <20230612101654.644983109@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

commit 439cf34c8e0a8a33d8c15a31be1b7423426bc765 upstream.

Make sure we don't assign an error pointer to crtc_state->mode_blob
as that will break all kinds of places that assume either NULL or a
valid pointer (eg. drm_property_blob_put()).

Cc: stable@vger.kernel.org
Reported-by: fuyufan <fuyufan@huawei.com>
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220209091928.14766-1-ville.syrjala@linux.intel.com
Acked-by: Maxime Ripard <maxime@cerno.tech>
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_atomic_uapi.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- a/drivers/gpu/drm/drm_atomic_uapi.c
+++ b/drivers/gpu/drm/drm_atomic_uapi.c
@@ -75,15 +75,17 @@ int drm_atomic_set_mode_for_crtc(struct
 	state->mode_blob = NULL;
 
 	if (mode) {
+		struct drm_property_blob *blob;
+
 		drm_mode_convert_to_umode(&umode, mode);
-		state->mode_blob =
-			drm_property_create_blob(state->crtc->dev,
-		                                 sizeof(umode),
-		                                 &umode);
-		if (IS_ERR(state->mode_blob))
-			return PTR_ERR(state->mode_blob);
+		blob = drm_property_create_blob(crtc->dev,
+						sizeof(umode), &umode);
+		if (IS_ERR(blob))
+			return PTR_ERR(blob);
 
 		drm_mode_copy(&state->mode, mode);
+
+		state->mode_blob = blob;
 		state->enable = true;
 		DRM_DEBUG_ATOMIC("Set [MODE:%s] for [CRTC:%d:%s] state %p\n",
 				 mode->name, crtc->base.id, crtc->name, state);


