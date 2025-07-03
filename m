Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 956E42EF9B8;
	Thu,  3 Jul 2025 14:54:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554465; cv=none; b=Wt5+wUPFI8SKUX5cLJM9dTl66qkHmnprINnKxbA53gH1wsekG6X2ozIB5n71j8btRNBRhTzyNrPjyAUYAPlllvljFJeGmVnswAY5AqClKgypdlNSsBmb1GMMJEEmLlmA9XCiG8zAiWIc3xixgqtTd4VbujGY0puYbaxHnF4pzFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554465; c=relaxed/simple;
	bh=8CdtrllSFJqPQh54cJaG5tJO1YPFzIR9oR+ELe8riYw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LfKPt62VHvTp2uNW97LdPgVJeGKx5/IgsRzKe55WInjq9ajkKPpM472dqG2wPd1RXg+/yZUTt4rvh0i0bgPq3aj7/F+nlouquhFIWvANFsV4h9tK5W+773rVq78i5eG0M0CEW6Uf1YQFQk0mGovZC8cqbIVUo7auNjyplKeNvKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K99egrWZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K99egrWZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 283B8C4CEE3;
	Thu,  3 Jul 2025 14:54:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554465;
	bh=8CdtrllSFJqPQh54cJaG5tJO1YPFzIR9oR+ELe8riYw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K99egrWZ3SQo7l4gBIDB1TKfHk8+kHaNk98utH60E1XyeIlMPUckfGc3C6BL4gKXq
	 Hv8xgMgr/TmdNbVJp9JFOQE8Zo4LRa/BFSgTOBg1TYavLGjFZpeCj6e5GYy2S4b/QG
	 P0O5A8U9zf2LNB4yWc/4rYpdXrsLXyyki5gl9RpY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Aradhya Bhatia <a-bhatia1@ti.com>,
	Aradhya Bhatia <aradhya.bhatia@linux.dev>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Subject: [PATCH 6.12 156/218] drm/bridge: cdns-dsi: Fix the clock variable for mode_valid()
Date: Thu,  3 Jul 2025 16:41:44 +0200
Message-ID: <20250703144002.388843370@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143955.956569535@linuxfoundation.org>
References: <20250703143955.956569535@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/gpu/drm/bridge/cadence/cdns-dsi-core.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/bridge/cadence/cdns-dsi-core.c
+++ b/drivers/gpu/drm/bridge/cadence/cdns-dsi-core.c
@@ -568,13 +568,14 @@ static int cdns_dsi_check_conf(struct cd
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
 


