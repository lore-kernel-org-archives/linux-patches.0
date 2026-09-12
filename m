Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11D13370D47;
	Sat, 12 Sep 2026 09:41:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789206115; cv=none; b=FPWrV/lvFqPpM0P6gJIJxbtED3rRooXYGh6ayJRAbMGQ6C6dHCe6K3A6XZRuFOckd08weCLq663aROZzThR0MHtoQiEieXv25aJ7Z0/eQNjLvKLt5GNgMhIUukZ848ZsqxjcQ0CsSsMBCkYP0gqgV7SFmGJXAd/62ByPo1cQMh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789206115; c=relaxed/simple;
	bh=dL/dviPcJIOqHpeRvRSbYg2Kt6i4LFe+A5JTLEvLhpU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R/bMeFg6/yCHHv9wnNTKakLvdFOycWHzJXiKamvScow0BuCPgkr+VbxnocOZiTN3+GnoC2EFpsGMKNmKbtg1YcLnKtpBpi6Gy2QzQnFsV8DVdrFHSSh1CBD8gwQVWg0ENUKOeLuK+fluJwjSYbuvvf9ESqa2njVYpnPRdcoilA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sBl++6U4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sBl++6U4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA3671F000FF;
	Sat, 12 Sep 2026 09:41:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789206114;
	bh=tOlHhnJFAt5XPvTAOI8TshT2kI3xCDAoMHXjx7msyoY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sBl++6U4jmh0lHIySEt6zTbbQgYCUpmLz+oB0vFREkaLiVEWcEuHcFQYdt5R/cRP0
	 Ky5buR9OjT+L5eqpi1vWlyW5cbOZbSiArqPS0ULXyXKmmwqLtJdxgrWd5g8cfiQDcv
	 EBiGOFGEFPOeLoFkH0AAaqGaLF0R49KRiWo3O4kQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0097/1518] drm/rockchip: dw_dp: Simplify error handling
Date: Sat, 12 Sep 2026 08:37:46 +0200
Message-ID: <20260912065625.671622211@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>

[ Upstream commit 26cb3e26efa7cc84289966cab871889f6ca93616 ]

Make the code a bit more compact by getting rid of the superfluous
assignments around PTR_ERR().

While at it, also drop dev assignment in dw_dp_probe().

Signed-off-by: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://patch.msgid.link/20260310-drm-rk-fixes-v2-4-645ecfb43f49@collabora.com
Stable-dep-of: cc6d7aca2f37 ("drm/rockchip: dw_dp: Release core resources")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/rockchip/dw_dp-rockchip.c | 21 +++++++--------------
 1 file changed, 7 insertions(+), 14 deletions(-)

diff --git a/drivers/gpu/drm/rockchip/dw_dp-rockchip.c b/drivers/gpu/drm/rockchip/dw_dp-rockchip.c
index 80aa8d11b49cb..0e7a2d46dcb0b 100644
--- a/drivers/gpu/drm/rockchip/dw_dp-rockchip.c
+++ b/drivers/gpu/drm/rockchip/dw_dp-rockchip.c
@@ -104,20 +104,15 @@ static int dw_dp_rockchip_bind(struct device *dev, struct device *master, void *
 	drm_encoder_helper_add(encoder, &dw_dp_encoder_helper_funcs);
 
 	dp->base = dw_dp_bind(dev, encoder, plat_data);
-	if (IS_ERR(dp->base)) {
-		ret = PTR_ERR(dp->base);
-		return ret;
-	}
+	if (IS_ERR(dp->base))
+		return PTR_ERR(dp->base);
 
 	connector = drm_bridge_connector_init(drm_dev, encoder);
-	if (IS_ERR(connector)) {
-		ret = PTR_ERR(connector);
-		return dev_err_probe(dev, ret, "Failed to init bridge connector");
-	}
+	if (IS_ERR(connector))
+		return dev_err_probe(dev, PTR_ERR(connector),
+				     "Failed to init bridge connector");
 
-	drm_connector_attach_encoder(connector, encoder);
-
-	return 0;
+	return drm_connector_attach_encoder(connector, encoder);
 }
 
 static const struct component_ops dw_dp_rockchip_component_ops = {
@@ -126,9 +121,7 @@ static const struct component_ops dw_dp_rockchip_component_ops = {
 
 static int dw_dp_probe(struct platform_device *pdev)
 {
-	struct device *dev = &pdev->dev;
-
-	return component_add(dev, &dw_dp_rockchip_component_ops);
+	return component_add(&pdev->dev, &dw_dp_rockchip_component_ops);
 }
 
 static void dw_dp_remove(struct platform_device *pdev)
-- 
2.53.0



