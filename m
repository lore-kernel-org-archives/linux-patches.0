Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52DA6611B
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:36:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE27FC433D2;
	Sun, 28 May 2023 19:36:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685302575;
	bh=TIaDIeDjZgTtyITQ9yqlwoWYJ6BuId/BjJC34Ywfb/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ecMnSDe53MduHUC9b/XMHsow7ao1sfncZ4xFHmPGBo+zeQpupzJIq3v5lIKWI32bK
	 JrFNZU8nJ0iYxXr511+0gdOKzXnxMN+J2iPXtOCts7D3WrIYwMRk+Q7JVCvh1JsDXM
	 Bl5DXWPKtRFMmon8SL6QzRqxIACtOmEUtcZo60M0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Phil Oester <kernel@linuxace.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Jocelyn Falempe <jfalempe@redhat.com>
Subject: [PATCH 6.1 041/119] drm/mgag200: Fix gamma lut not initialized.
Date: Sun, 28 May 2023 20:10:41 +0100
Message-Id: <20230528190836.752325375@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190835.386670951@linuxfoundation.org>
References: <20230528190835.386670951@linuxfoundation.org>
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

commit ad81e23426a651eb89a4b306e1c4169e6308c124 upstream.

When mgag200 switched from simple KMS to regular atomic helpers,
the initialization of the gamma settings was lost.
This leads to a black screen, if the bios/uefi doesn't use the same
pixel color depth.

v2: rebase on top of drm-misc-fixes, and add Cc stable tag.

Link: https://bugzilla.redhat.com/show_bug.cgi?id=2171155
Fixes: 1baf9127c482 ("drm/mgag200: Replace simple-KMS with regular atomic helpers")
Cc: <stable@vger.kernel.org>
Tested-by: Phil Oester <kernel@linuxace.com>
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Jocelyn Falempe <jfalempe@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230510131034.284078-1-jfalempe@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/mgag200/mgag200_mode.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/gpu/drm/mgag200/mgag200_mode.c b/drivers/gpu/drm/mgag200/mgag200_mode.c
index 0a5aaf78172a..576c4c838a33 100644
--- a/drivers/gpu/drm/mgag200/mgag200_mode.c
+++ b/drivers/gpu/drm/mgag200/mgag200_mode.c
@@ -640,6 +640,11 @@ void mgag200_crtc_helper_atomic_enable(struct drm_crtc *crtc, struct drm_atomic_
 	if (funcs->pixpllc_atomic_update)
 		funcs->pixpllc_atomic_update(crtc, old_state);
 
+	if (crtc_state->gamma_lut)
+		mgag200_crtc_set_gamma(mdev, format, crtc_state->gamma_lut->data);
+	else
+		mgag200_crtc_set_gamma_linear(mdev, format);
+
 	mgag200_enable_display(mdev);
 
 	if (funcs->enable_vidrst)
-- 
2.40.1



