Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB3E7346A01;
	Tue, 11 Nov 2025 01:14:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823661; cv=none; b=P4fcO20ivZHAqbK52zW/fZDv4aCz/ikmQHvJ+DW36QBgNax26H5I6xHSxojeMZmkHZZU+HmDWd95gUqCIpltEIgAP3F/8yaLevUQ3w5HK1A13TYFv/FdpoUzR9Pm8kiSfLD04oyMLi0ORnSKxwPuenlTVx8lv6HHo60/4DOx8RI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823661; c=relaxed/simple;
	bh=f0vtjkmlmmg93Ga65c11F0I+PTpToCWAsDqJUftIvLI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q2ZGtDLCLiSfp3I2kOCkofCuxTBK33/BjZ87rRqwGtgIrV5c88B0MLiApAYgSVFUNu/AqxazzHuokbXFm5D7bNSmfoxwZEdA4NWt1HOfqzpgiJZh6uudSkBv7BDznAMdg+RLJT2k2FG4HbDT+PGntpuRtt+k+0749xP2G7IOozM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r+mAeTBh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r+mAeTBh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74EABC4AF09;
	Tue, 11 Nov 2025 01:14:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823661;
	bh=f0vtjkmlmmg93Ga65c11F0I+PTpToCWAsDqJUftIvLI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r+mAeTBhiVEFIWFYCtAoeWQ8u+z7iuR+8u8xpm4kAXerNEuZCYhNZMJj+GMax5QZS
	 +TdL0MLin2LROr9kb0qfqAXegffTZ3DQP+EI+CyGjrijbXccPVqkOSvWnI0fFEzoDK
	 wUmiKoJkT9z+DXXKruDl1mUx8O6N1viiG8zoQTu0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 345/849] drm/panel: ilitek-ili9881c: turn off power-supply when init fails
Date: Tue, 11 Nov 2025 09:38:35 +0900
Message-ID: <20251111004544.761025411@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

From: Heiko Stuebner <heiko@sntech.de>

[ Upstream commit 6c66eba502709a78281333187c1add7b71f7201f ]

The prepare function turns on the power-supply regulator first, when
preparing the display. But in an error case, just returns the error
code, but does not power off the regulator again, fix that.

Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://lore.kernel.org/r/20250707164906.1445288-2-heiko@sntech.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-ilitek-ili9881c.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/panel/panel-ilitek-ili9881c.c b/drivers/gpu/drm/panel/panel-ilitek-ili9881c.c
index ac433345a1794..3af22a5f5700c 100644
--- a/drivers/gpu/drm/panel/panel-ilitek-ili9881c.c
+++ b/drivers/gpu/drm/panel/panel-ilitek-ili9881c.c
@@ -1486,7 +1486,7 @@ static int ili9881c_prepare(struct drm_panel *panel)
 						      instr->arg.cmd.data);
 
 		if (ret)
-			return ret;
+			goto disable_power;
 	}
 
 	ret = ili9881c_switch_page(ctx, 0);
@@ -1498,18 +1498,22 @@ static int ili9881c_prepare(struct drm_panel *panel)
 					 &ctx->address_mode,
 					 sizeof(ctx->address_mode));
 		if (ret < 0)
-			return ret;
+			goto disable_power;
 	}
 
 	ret = mipi_dsi_dcs_set_tear_on(ctx->dsi, MIPI_DSI_DCS_TEAR_MODE_VBLANK);
 	if (ret)
-		return ret;
+		goto disable_power;
 
 	ret = mipi_dsi_dcs_exit_sleep_mode(ctx->dsi);
 	if (ret)
-		return ret;
+		goto disable_power;
 
 	return 0;
+
+disable_power:
+	regulator_disable(ctx->power);
+	return ret;
 }
 
 static int ili9881c_enable(struct drm_panel *panel)
-- 
2.51.0



