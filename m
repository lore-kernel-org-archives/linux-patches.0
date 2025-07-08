Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C79A62E5B20;
	Tue,  8 Jul 2025 16:59:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993978; cv=none; b=VvhCFwk8+a5FfIkUlx7Q9jl2rMevB2TiorMIw2vznrPScg8JNmehFAY7VWWhdqvABh28EDURqVNGyCc1tko4vEcAUgiH82OcHhI2AxbnD2oi2DP7FMmfKVtvdQaSKThzrwnWbp9M9byhYtHEViO6steuYjQyKK+5QKGjlBw8JKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993978; c=relaxed/simple;
	bh=aHImYyamILo6EroWZrhH2PwvAIvoogH0jCkqzR/qiOI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Odj9hAKnLRuMg3axeqUZ4pxofJb+Scfia5A1pLOouD9iUbGGP9Og0eMOhvZBJFb0L+Runm8gZaXgAPK7D2LDCDdKntvlK619G6g8XbGvps2wSeNNoyZ5qvSad7TYo3iz0ER4p05W4/lbNHKTO47IIVBufKcalmg3qKqTTzclG3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=15JuIjQ8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="15JuIjQ8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FC72C4CEF0;
	Tue,  8 Jul 2025 16:59:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993978;
	bh=aHImYyamILo6EroWZrhH2PwvAIvoogH0jCkqzR/qiOI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=15JuIjQ8rhV9UKZiBvww541dHTZfPmpKReKIwAIOFRFHz3EZzLv9GQmGuyICFsegy
	 2/UBUj4FbuLzucJEZ1cn5WKkVl7nEl+EJFsWxzixtuPz8MsZBIK6+J+l9cihqKrD+f
	 3neuKnX4Qzrf2tA/XsmJwiqaNo90NLWTA78+53Yk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Aradhya Bhatia <a-bhatia1@ti.com>,
	Aradhya Bhatia <aradhya.bhatia@linux.dev>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Subject: [PATCH 5.15 084/160] drm/bridge: cdns-dsi: Fix the clock variable for mode_valid()
Date: Tue,  8 Jul 2025 18:22:01 +0200
Message-ID: <20250708162233.853895713@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162231.503362020@linuxfoundation.org>
References: <20250708162231.503362020@linuxfoundation.org>
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

From: Aradhya Bhatia <a-bhatia1@ti.com>

commit 132bdcec399be6ae947582249a134b38cf56731c upstream.

The crtc_* mode parameters do not get generated (duplicated in this
case) from the regular parameters before the mode validation phase
begins.

The rest of the code conditionally uses the crtc_* parameters only
during the bridge enable phase, but sticks to the regular parameters
for mode validation. In this singular instance, however, the driver
tries to use the crtc_clock parameter even during the mode validation,
causing the validation to fail.

Allow the D-Phy config checks to use mode->clock instead of
mode->crtc_clock during mode_valid checks, like everywhere else in the
driver.

Fixes: fced5a364dee ("drm/bridge: cdns: Convert to phy framework")
Cc: stable@vger.kernel.org
Reviewed-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Tested-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Signed-off-by: Aradhya Bhatia <a-bhatia1@ti.com>
Signed-off-by: Aradhya Bhatia <aradhya.bhatia@linux.dev>
Link: https://lore.kernel.org/r/20250329113925.68204-4-aradhya.bhatia@linux.dev
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/bridge/cdns-dsi.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/bridge/cdns-dsi.c
+++ b/drivers/gpu/drm/bridge/cdns-dsi.c
@@ -608,13 +608,14 @@ static int cdns_dsi_check_conf(struct cd
 	struct phy_configure_opts_mipi_dphy *phy_cfg = &output->phy_opts.mipi_dphy;
 	unsigned long dsi_hss_hsa_hse_hbp;
 	unsigned int nlanes = output->dev->lanes;
+	int mode_clock = (mode_valid_check ? mode->clock : mode->crtc_clock);
 	int ret;
 
 	ret = cdns_dsi_mode2cfg(dsi, mode, dsi_cfg, mode_valid_check);
 	if (ret)
 		return ret;
 
-	phy_mipi_dphy_get_default_config(mode->crtc_clock * 1000,
+	phy_mipi_dphy_get_default_config(mode_clock * 1000,
 					 mipi_dsi_pixel_format_to_bpp(output->dev->format),
 					 nlanes, phy_cfg);
 


