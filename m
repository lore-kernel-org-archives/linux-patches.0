Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86F912737FC;
	Sat, 12 Sep 2026 09:38:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789205926; cv=none; b=dm0by2Ym+ZbjyKx718fbaueEa2jEzHmM+WadNwYs/38z6NSn/93xblVuG5cRHZnSho5026udI85YKTqSuydKZjQMrP/oTORuxylrLrxuMknfwXc+eQ8Ja50Bz/kv9+AYbx1qFYzRB8ZtScby6O7u2y01fWpwpeCp996KQxA0h+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789205926; c=relaxed/simple;
	bh=YPAiYbMnNEIFcjF67rdJrYhxbee+5opdRHLR6b9OWPQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BgOpStocJFEFkpj4oSTkba3U/9WInjmrIgXNmeWFWptDodL0DkQnGqT40w3Y/Jsy4CYpgzOdP/+T0EFFVOhyQcvu6C/+SYfSd/DqJ0sx7A/wclSWo87UO8GNAFLty+3G1qR5wktK4Q4+r3VfVICY6mA+j4ff8iFF6WsNbZDI6kU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FK3773an; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FK3773an"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA5341F000FF;
	Sat, 12 Sep 2026 09:38:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789205925;
	bh=KDmUpVo5/5tpo/TpcMWZbKQUbO4zfXzMfzHCHMgq7Vw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FK3773anQ7oDk+uE3hLgRNlJ0LEiQfJ9x5I8tUEYTE/1Jiz4LYg7eTYZTL9pg997T
	 enkpSZr5oETFXydNfnKN99vLsvKRcBVClad19BIDTy54QeKZwb2BP5ueaL8Iy3qd6V
	 Qj2iJiDD2qGdqEc+r0h9hSTm9B5lNLYvq2Tae77g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damon Ding <damon.ding@rock-chips.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0102/1518] drm/rockchip: analogix_dp: Enable hclk for RK3588
Date: Sat, 12 Sep 2026 08:37:51 +0200
Message-ID: <20260912065625.786657727@linuxfoundation.org>
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

From: Damon Ding <damon.ding@rock-chips.com>

[ Upstream commit 104f20616d72825fdcf56cfdc5f89f4e96fd8dbe ]

Acquire and enable the HCLK_VO1 bus clock explicitly for RK3588
eDP controller to guarantee register and datapath access.

The clock was previously enabled implicitly via rockchip,vo-grf
phandle reference, which relies on side effect and is fragile.

Fetch optional "hclk" clock in driver to align with updated device
tree binding and keep consistent with hardware clock dependency.

Fixes: 729f8eefdcad ("drm/rockchip: analogix_dp: Add support for RK3588")
Signed-off-by: Damon Ding <damon.ding@rock-chips.com>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://patch.msgid.link/20260601065100.1103873-6-damon.ding@rock-chips.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/rockchip/analogix_dp-rockchip.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/gpu/drm/rockchip/analogix_dp-rockchip.c b/drivers/gpu/drm/rockchip/analogix_dp-rockchip.c
index b905e28afa074..33e9183837487 100644
--- a/drivers/gpu/drm/rockchip/analogix_dp-rockchip.c
+++ b/drivers/gpu/drm/rockchip/analogix_dp-rockchip.c
@@ -328,6 +328,7 @@ static int rockchip_dp_of_probe(struct rockchip_dp_device *dp)
 {
 	struct device *dev = dp->dev;
 	struct device_node *np = dev->of_node;
+	struct clk *clk;
 
 	dp->grf = syscon_regmap_lookup_by_phandle(np, "rockchip,grf");
 	if (IS_ERR(dp->grf)) {
@@ -351,6 +352,11 @@ static int rockchip_dp_of_probe(struct rockchip_dp_device *dp)
 		return PTR_ERR(dp->pclk);
 	}
 
+	clk = devm_clk_get_optional_enabled(dev, "hclk");
+	if (IS_ERR(clk))
+		return dev_err_probe(dev, PTR_ERR(clk),
+				     "failed to get hclk property\n");
+
 	dp->rst = devm_reset_control_get(dev, "dp");
 	if (IS_ERR(dp->rst)) {
 		DRM_DEV_ERROR(dev, "failed to get dp reset control\n");
-- 
2.53.0



