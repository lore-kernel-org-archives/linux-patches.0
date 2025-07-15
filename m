Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DC082E49B2;
	Tue, 15 Jul 2025 13:33:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586396; cv=none; b=LZQBVezc9IKMi1Uz+/RHrpD20sjT1YMLy5AnLizq8fflZ0XOlTp+kct79kXaYOTnrdrj1zKIy/igzqVQNhO0sVE0g12bPFgaW81kHZLZf18TDTfid429zcAeZYcCWj41B6YUa/+2LD1pFihR0nxez9p0Jk7bjbb64tWCawZkfHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586396; c=relaxed/simple;
	bh=BOfmmKxHbWv7Ngkj91MBF+2CbGgIEeMBXEihPWaoRt0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uYpo9iUBQ5Vye68SOUFqgqHjq7SdkW1eT4gvvE+uJ4K2kykN2oMQJjjzkXDTIAYsfbcxTt7Mmt+HRMD+gbAV7ckIYVssTySeoavNOXLGPy98Aadi7uO9ubhtk531qK4C6qTrQmadkk5ZqvhZyhPDg6cJbjoko4taktbm/gIP1RQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UkbzoAEE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UkbzoAEE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC5B5C4CEF1;
	Tue, 15 Jul 2025 13:33:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586396;
	bh=BOfmmKxHbWv7Ngkj91MBF+2CbGgIEeMBXEihPWaoRt0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UkbzoAEEMGmnA+V8Ips3yhjVcVqDKP3Oqn5uNN6iiAnJHZFloa78x4MgIrbRTzSDQ
	 NmVhOC5EIvh/Dj9JWYDVWmH1HQzbHP0INIznAtSyk3WWS1Cv01Lk7XDahcNpb5Hh/4
	 OyjQeXHD8OC31mGy3fjiKujnHXDBAx8bXhjE93aI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Aradhya Bhatia <a-bhatia1@ti.com>,
	Aradhya Bhatia <aradhya.bhatia@linux.dev>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Subject: [PATCH 5.4 050/148] drm/bridge: cdns-dsi: Fix the clock variable for mode_valid()
Date: Tue, 15 Jul 2025 15:12:52 +0200
Message-ID: <20250715130802.326411295@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130800.293690950@linuxfoundation.org>
References: <20250715130800.293690950@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -609,13 +609,14 @@ static int cdns_dsi_check_conf(struct cd
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
 


