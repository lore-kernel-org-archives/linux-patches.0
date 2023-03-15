Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6486B4431
	for <patches@lists.linux.dev>; Wed, 15 Mar 2023 12:18:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB998C433D2;
	Wed, 15 Mar 2023 12:18:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678882704;
	bh=Ov497nPgF4VA9UaKn/HlVMfovA3gDDy6lWy2sRtgQxo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zcSIL59KO2fhPEAfiHKJsqbWrOHZBR3lL8cp54PgsbgbZiie39RIBfTw88elSS8EJ
	 kKM0gU8yx34jQJIXfBYBCTPk/8dGrdRloWNjTrtiNLniFK03VbmZopyyV+V7ZQ4hXx
	 tphumYMqDwRrXbnXxFWhfxmApLHokQEWvqxN3P5s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wayne Lin <waynelin@amd.com>,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Uma Shankar <uma.shankar@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 11/68] drm/edid: Fix HDMI VIC handling
Date: Wed, 15 Mar 2023 13:12:05 +0100
Message-Id: <20230315115726.545802234@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115726.103942885@linuxfoundation.org>
References: <20230315115726.103942885@linuxfoundation.org>
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

[ Upstream commit 949561eb85bcee10248e7da51d44a0325d5e0d1b ]

Extract drm_mode_hdmi_vic() to correctly calculate the final HDMI
VIC for us. Currently this is being done a bit differently between
the AVI and HDMI infoframes. Let's get both to agree on this.

We need to allow the case where a mode is both 3D and has a HDMI
VIC. Currently we'll just refuse to generate the HDMI infoframe when
we really should be setting HDMI VIC to 0 and instead enabling 3D
stereo signalling.

If the sink doesn't even support the HDMI infoframe we should
not be picking the HDMI VIC in favor of the CEA VIC, because then
we'll end up not sending either VIC in the end.

Cc: Wayne Lin <waynelin@amd.com>
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20191004141914.20600-3-ville.syrjala@linux.intel.com
Reviewed-by: Uma Shankar <uma.shankar@intel.com>
Stable-dep-of: 1cbc1f0d324b ("drm/edid: fix AVI infoframe aspect ratio handling")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_edid.c | 37 +++++++++++++++++++++----------------
 1 file changed, 21 insertions(+), 16 deletions(-)

diff --git a/drivers/gpu/drm/drm_edid.c b/drivers/gpu/drm/drm_edid.c
index 10eb78b9347e1..245e495f57c93 100644
--- a/drivers/gpu/drm/drm_edid.c
+++ b/drivers/gpu/drm/drm_edid.c
@@ -5065,11 +5065,25 @@ drm_hdmi_infoframe_set_hdr_metadata(struct hdmi_drm_infoframe *frame,
 }
 EXPORT_SYMBOL(drm_hdmi_infoframe_set_hdr_metadata);
 
+static u8 drm_mode_hdmi_vic(struct drm_connector *connector,
+			    const struct drm_display_mode *mode)
+{
+	bool has_hdmi_infoframe = connector ?
+		connector->display_info.has_hdmi_infoframe : false;
+
+	if (!has_hdmi_infoframe)
+		return 0;
+
+	/* No HDMI VIC when signalling 3D video format */
+	if (mode->flags & DRM_MODE_FLAG_3D_MASK)
+		return 0;
+
+	return drm_match_hdmi_mode(mode);
+}
+
 static u8 drm_mode_cea_vic(struct drm_connector *connector,
 			   const struct drm_display_mode *mode)
 {
-	u8 vendor_if_vic = drm_match_hdmi_mode(mode);
-	bool is_s3d = mode->flags & DRM_MODE_FLAG_3D_MASK;
 	u8 vic;
 
 	/*
@@ -5078,7 +5092,7 @@ static u8 drm_mode_cea_vic(struct drm_connector *connector,
 	 * VIC in AVI infoframes. Lets check if this mode is present in
 	 * HDMI 1.4b 4K modes
 	 */
-	if (drm_valid_hdmi_vic(vendor_if_vic) && !is_s3d)
+	if (drm_mode_hdmi_vic(connector, mode))
 		return 0;
 
 	vic = drm_match_cea_mode(mode);
@@ -5338,8 +5352,6 @@ drm_hdmi_vendor_infoframe_from_display_mode(struct hdmi_vendor_infoframe *frame,
 	bool has_hdmi_infoframe = connector ?
 		connector->display_info.has_hdmi_infoframe : false;
 	int err;
-	u32 s3d_flags;
-	u8 vic;
 
 	if (!frame || !mode)
 		return -EINVAL;
@@ -5347,8 +5359,9 @@ drm_hdmi_vendor_infoframe_from_display_mode(struct hdmi_vendor_infoframe *frame,
 	if (!has_hdmi_infoframe)
 		return -EINVAL;
 
-	vic = drm_match_hdmi_mode(mode);
-	s3d_flags = mode->flags & DRM_MODE_FLAG_3D_MASK;
+	err = hdmi_vendor_infoframe_init(frame);
+	if (err < 0)
+		return err;
 
 	/*
 	 * Even if it's not absolutely necessary to send the infoframe
@@ -5359,15 +5372,7 @@ drm_hdmi_vendor_infoframe_from_display_mode(struct hdmi_vendor_infoframe *frame,
 	 * mode if the source simply stops sending the infoframe when
 	 * it wants to switch from 3D to 2D.
 	 */
-
-	if (vic && s3d_flags)
-		return -EINVAL;
-
-	err = hdmi_vendor_infoframe_init(frame);
-	if (err < 0)
-		return err;
-
-	frame->vic = vic;
+	frame->vic = drm_mode_hdmi_vic(connector, mode);
 	frame->s3d_struct = s3d_structure_from_display_mode(mode);
 
 	return 0;
-- 
2.39.2



