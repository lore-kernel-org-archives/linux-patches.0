Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60C881F4165;
	Mon,  2 Jun 2025 14:58:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748876338; cv=none; b=CKp9V7+ktOch9zn3nLlFreHfgRIW20fPjMT2PwWklIDPh1E1zZlzLRm1rULbjx3877PtdnEB6kQDB7Wo0yKvLkg9rYdzqTOqN+dqclWYK3SDPjU1+Pu5Rg652OTwEY+pgBj2dG6MnOYMatAwFA4sWQMkFjN1O9iF5R/UEO/c+ig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748876338; c=relaxed/simple;
	bh=wdLS0WjiuLOdD7TeTQvXIULLj7MECuAhppAWKAKymYI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ThcGmDNZ25Y0OHPILm+HJQ58USQ9pVSto4zv2VD24EcxnSShG1fn0eADaOFsY+gnHq4RFc+WqPYoOvCOazeTTplXkbG5dahu+4h4HhfpnMxBlow5BgbXmke691k/w4LvDuGOPvx14KSkTxw2xAWnET5jfDLiQI0os8Vy+kYtZoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KUfTtiwZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KUfTtiwZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2CA5C4CEEB;
	Mon,  2 Jun 2025 14:58:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748876338;
	bh=wdLS0WjiuLOdD7TeTQvXIULLj7MECuAhppAWKAKymYI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KUfTtiwZ3Slktg/Fodb2s3VMbJ98WKY/AV3Ra8ABMtMGy5NHdvPHHLdigrR35Ts/q
	 I+sW7BnYYuFvkDpud3mcj3g/vzZPFcs/wTtU4qpARDQZ9e4B9ZM4gnV367U9gV6vW0
	 JGhWuks14Cs3J7RSd9B6IPo9YcthEj53NufprGPc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Jocelyn Falempe <jfalempe@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 145/207] drm/ast: Find VBIOS mode from regular display size
Date: Mon,  2 Jun 2025 15:48:37 +0200
Message-ID: <20250602134304.402022009@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134258.769974467@linuxfoundation.org>
References: <20250602134258.769974467@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Zimmermann <tzimmermann@suse.de>

[ Upstream commit c81202906b5cd56db403e95db3d29c9dfc8c74c1 ]

The ast driver looks up supplied display modes from an internal list of
display modes supported by the VBIOS.

Do not use the crtc_-prefixed display values from struct drm_display_mode
for looking up the VBIOS mode. The fields contain raw values that the
driver programs to hardware. They are affected by display settings like
double-scan or interlace.

Instead use the regular vdisplay and hdisplay fields for lookup. As the
programmed values can now differ from the values used for lookup, set
struct drm_display_mode.crtc_vdisplay and .crtc_hdisplay from the VBIOS
mode.

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Reviewed-by: Jocelyn Falempe <jfalempe@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250131092257.115596-9-tzimmermann@suse.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/ast/ast_mode.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/ast/ast_mode.c b/drivers/gpu/drm/ast/ast_mode.c
index 08ed0d08d03b8..87d31d3b0e357 100644
--- a/drivers/gpu/drm/ast/ast_mode.c
+++ b/drivers/gpu/drm/ast/ast_mode.c
@@ -105,7 +105,7 @@ static bool ast_get_vbios_mode_info(const struct drm_format_info *format,
 		return false;
 	}
 
-	switch (mode->crtc_hdisplay) {
+	switch (mode->hdisplay) {
 	case 640:
 		vbios_mode->enh_table = &res_640x480[refresh_rate_index];
 		break;
@@ -116,7 +116,7 @@ static bool ast_get_vbios_mode_info(const struct drm_format_info *format,
 		vbios_mode->enh_table = &res_1024x768[refresh_rate_index];
 		break;
 	case 1280:
-		if (mode->crtc_vdisplay == 800)
+		if (mode->vdisplay == 800)
 			vbios_mode->enh_table = &res_1280x800[refresh_rate_index];
 		else
 			vbios_mode->enh_table = &res_1280x1024[refresh_rate_index];
@@ -128,7 +128,7 @@ static bool ast_get_vbios_mode_info(const struct drm_format_info *format,
 		vbios_mode->enh_table = &res_1440x900[refresh_rate_index];
 		break;
 	case 1600:
-		if (mode->crtc_vdisplay == 900)
+		if (mode->vdisplay == 900)
 			vbios_mode->enh_table = &res_1600x900[refresh_rate_index];
 		else
 			vbios_mode->enh_table = &res_1600x1200[refresh_rate_index];
@@ -137,7 +137,7 @@ static bool ast_get_vbios_mode_info(const struct drm_format_info *format,
 		vbios_mode->enh_table = &res_1680x1050[refresh_rate_index];
 		break;
 	case 1920:
-		if (mode->crtc_vdisplay == 1080)
+		if (mode->vdisplay == 1080)
 			vbios_mode->enh_table = &res_1920x1080[refresh_rate_index];
 		else
 			vbios_mode->enh_table = &res_1920x1200[refresh_rate_index];
@@ -181,6 +181,7 @@ static bool ast_get_vbios_mode_info(const struct drm_format_info *format,
 	hborder = (vbios_mode->enh_table->flags & HBorder) ? 8 : 0;
 	vborder = (vbios_mode->enh_table->flags & VBorder) ? 8 : 0;
 
+	adjusted_mode->crtc_hdisplay = vbios_mode->enh_table->hde;
 	adjusted_mode->crtc_htotal = vbios_mode->enh_table->ht;
 	adjusted_mode->crtc_hblank_start = vbios_mode->enh_table->hde + hborder;
 	adjusted_mode->crtc_hblank_end = vbios_mode->enh_table->ht - hborder;
@@ -190,6 +191,7 @@ static bool ast_get_vbios_mode_info(const struct drm_format_info *format,
 					 vbios_mode->enh_table->hfp +
 					 vbios_mode->enh_table->hsync);
 
+	adjusted_mode->crtc_vdisplay = vbios_mode->enh_table->vde;
 	adjusted_mode->crtc_vtotal = vbios_mode->enh_table->vt;
 	adjusted_mode->crtc_vblank_start = vbios_mode->enh_table->vde + vborder;
 	adjusted_mode->crtc_vblank_end = vbios_mode->enh_table->vt - vborder;
-- 
2.39.5



