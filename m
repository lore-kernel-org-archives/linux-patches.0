Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85165241695;
	Mon, 13 Oct 2025 15:31:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369467; cv=none; b=C8YRgJ98rtyz9FMLy0J125u3qnoI516LZxlgKLskaNJ3eWwoZS/dcGJ3a6zR6JY6QaRgJ6KX6mpM2eVQemjWd/pazXHQxWvxBejtUoey+M21D3Sijfs7oX+JxFoEMdSPPWHfucQdBuNyYJuM9PsDSS3+Ay6XuK4UA+k4cvcYww4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369467; c=relaxed/simple;
	bh=v2rPmvazy4ahexvevhR0nbSW5muok1L1B/whVBFjFyQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H87uzniP3I++4KDILpvc63HiPE5YVC38bU7tKCz4LlJNqurylfDRYSItkf4Ignz/NpvGfObP1OfrsggQ/a048smbwzvLR2VmgB4LFA/mZj6LPikqNQMew4YjpaWlLaGMewsjOGYEgQu7eQERP0b9UZVF6ltArlFcCrvUWQmsB/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IuQq3M14; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IuQq3M14"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A93ECC4CEE7;
	Mon, 13 Oct 2025 15:31:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369467;
	bh=v2rPmvazy4ahexvevhR0nbSW5muok1L1B/whVBFjFyQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IuQq3M14aNrq4o6cC4hTUVkfxz20jKwNq9uxbKH2c3SpZoC2toiM5XgbMZapIItRl
	 oSswrNJlYIMF++fbpYYEjz1bIUjKXMt+Af1upIpSeFMx/maita4eDLtplgG5NIy9O7
	 U/BL0YEKoknZQvkBFfv+Po2/6216sxSFd0rXqzCM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Val Packett <val@packett.cool>,
	Abel Vesa <abel.vesa@linaro.org>,
	Suraj Kandpal <suraj.kandpal@intel.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 256/563] drm/dp: drm_edp_backlight_set_level: do not always send 3-byte commands
Date: Mon, 13 Oct 2025 16:41:57 +0200
Message-ID: <20251013144420.554210605@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Val Packett <val@packett.cool>

[ Upstream commit 4aa8961b1b9c7498550b41168a91cf1558133dd3 ]

At least some panels using the LSB register are not happy with the
unconditional increase of the command buffer to 3 bytes.

With the BOE NE14QDM in my Dell Latitude 7455, the recent patches for
luminance based brightness have introduced a regression: the brightness
range stopped being contiguous and became nonsensical (it probably was
interpreting the last 2 bytes of the buffer and not the first 2).

Change from using a fixed sizeof() to a length variable that's only
set to 3 when luminance is used. Let's leave the default as 2 even for
the single-byte version, since that's how it worked before.

Fixes: f2db78e37fe7 ("drm/dp: Modify drm_edp_backlight_set_level")
Signed-off-by: Val Packett <val@packett.cool>
Tested-by: Abel Vesa <abel.vesa@linaro.org>
Reviewed-by: Suraj Kandpal <suraj.kandpal@intel.com>
Link: https://lore.kernel.org/r/20250706204446.8918-1-val@packett.cool
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/display/drm_dp_helper.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/display/drm_dp_helper.c b/drivers/gpu/drm/display/drm_dp_helper.c
index 1ecc3df7e3167..4aaeae4fa03c3 100644
--- a/drivers/gpu/drm/display/drm_dp_helper.c
+++ b/drivers/gpu/drm/display/drm_dp_helper.c
@@ -3962,6 +3962,7 @@ int drm_edp_backlight_set_level(struct drm_dp_aux *aux, const struct drm_edp_bac
 	int ret;
 	unsigned int offset = DP_EDP_BACKLIGHT_BRIGHTNESS_MSB;
 	u8 buf[3] = { 0 };
+	size_t len = 2;
 
 	/* The panel uses the PWM for controlling brightness levels */
 	if (!(bl->aux_set || bl->luminance_set))
@@ -3974,6 +3975,7 @@ int drm_edp_backlight_set_level(struct drm_dp_aux *aux, const struct drm_edp_bac
 		buf[1] = (level & 0x00ff00) >> 8;
 		buf[2] = (level & 0xff0000) >> 16;
 		offset = DP_EDP_PANEL_TARGET_LUMINANCE_VALUE;
+		len = 3;
 	} else if (bl->lsb_reg_used) {
 		buf[0] = (level & 0xff00) >> 8;
 		buf[1] = (level & 0x00ff);
@@ -3981,7 +3983,7 @@ int drm_edp_backlight_set_level(struct drm_dp_aux *aux, const struct drm_edp_bac
 		buf[0] = level;
 	}
 
-	ret = drm_dp_dpcd_write_data(aux, offset, buf, sizeof(buf));
+	ret = drm_dp_dpcd_write_data(aux, offset, buf, len);
 	if (ret < 0) {
 		drm_err(aux->drm_dev,
 			"%s: Failed to write aux backlight level: %d\n",
-- 
2.51.0



