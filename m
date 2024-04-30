Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3576D12C462;
	Tue, 30 Apr 2024 10:56:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474606; cv=none; b=fXNprhtLURjpmhCsshBAjtYNY/hHTKXVpD59joSWmWo1Elu71l2IfJjhSD+i2F3e79WS1MgiBYu1VlFubeZSZQgQ5Qw7fdX9c19p0zLbKJjn82qyjKDgRVvXrWR05n/zNLCWmkesUmbcIaUO8Prr/EHJ2hr5MZQNJSfrb9ALpDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474606; c=relaxed/simple;
	bh=vN9tAX3HbpJrraoL0BiGUzal8yEIKQYoIZYjlH2aB+U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sCIeef+MJ1oyBBygC7gQAK96QsfmODwR5NFgEmlIZDj1otQCknKTPTMFXQMBlQGbWUXGvhld77D37zznvTU7LAj+P/l5N2YbkybIWm/U4RxeUHrQNtOuWFNJZ19XV8WEm4qWzH83/D1XjIZnhWoQD+Vz3nBGsGQnrpUiCTvKh40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GoWgFJ1k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GoWgFJ1k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7CD6C4AF19;
	Tue, 30 Apr 2024 10:56:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474606;
	bh=vN9tAX3HbpJrraoL0BiGUzal8yEIKQYoIZYjlH2aB+U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GoWgFJ1kW6gei15DeZPluVpMGPGyGRNpVOq4KBnYtjb3qfEq0oOqTeDjuD4JIk26L
	 todm5IVBaphrK0PgbiAOou4fyrcfI4CiCCgivrJ34XTyEgrVhKFzBCUZDdHN2Mv3H2
	 +KBMSD3bVtUux63IO0ZlYUv49c0IdR2n8mT8MF60=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Tomek <mtdev79b@gmail.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 207/228] phy: rockchip-snps-pcie3: fix bifurcation on rk3588
Date: Tue, 30 Apr 2024 12:39:45 +0200
Message-ID: <20240430103109.778461374@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103103.806426847@linuxfoundation.org>
References: <20240430103103.806426847@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Tomek <mtdev79b@gmail.com>

[ Upstream commit f8020dfb311d2b6cf657668792aaa5fa8863a7dd ]

So far all RK3588 boards use fully aggregated PCIe. CM3588 is one
of the few boards using this feature and apparently it is broken.

The PHY offers the following mapping options:

  port 0 lane 0 - always mapped to controller 0 (4L)
  port 0 lane 1 - to controller 0 or 2 (1L0)
  port 1 lane 0 - to controller 0 or 1 (2L)
  port 1 lane 1 - to controller 0, 1 or 3 (1L1)

The data-lanes DT property maps these as follows:

  0 = no controller (unsupported by the HW)
  1 = 4L
  2 = 2L
  3 = 1L0
  4 = 1L1

That allows the following configurations with first column being the
mainline data-lane mapping, second column being the downstream name,
third column being PCIE3PHY_GRF_CMN_CON0 and PHP_GRF_PCIESEL register
values and final column being the user visible lane setup:

  <1 1 1 1> = AGGREG = [4 0] = x4 (aggregation)
  <1 1 2 2> = NANBNB = [0 0] = x2 x2 (no bif.)
  <1 3 2 2> = NANBBI = [1 1] = x2 x1x1 (bif. of port 0)
  <1 1 2 4> = NABINB = [2 2] = x1x1 x2 (bif. of port 1)
  <1 3 2 4> = NABIBI = [3 3] = x1x1 x1x1 (bif. of both ports)

The driver currently does not program PHP_GRF_PCIESEL correctly, which
is fixed by this patch. As a side-effect the new logic is much simpler
than the old logic.

Fixes: 2e9bffc4f713 ("phy: rockchip: Support PCIe v3")
Signed-off-by: Michal Tomek <mtdev79b@gmail.com>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Acked-by: Heiko Stuebner <heiko@sntech.de>
Link: https://lore.kernel.org/r/20240404-rk3588-pcie-bifurcation-fixes-v1-1-9907136eeafd@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../phy/rockchip/phy-rockchip-snps-pcie3.c    | 24 +++++++------------
 1 file changed, 8 insertions(+), 16 deletions(-)

diff --git a/drivers/phy/rockchip/phy-rockchip-snps-pcie3.c b/drivers/phy/rockchip/phy-rockchip-snps-pcie3.c
index 121e5961ce114..d5bcc9c42b284 100644
--- a/drivers/phy/rockchip/phy-rockchip-snps-pcie3.c
+++ b/drivers/phy/rockchip/phy-rockchip-snps-pcie3.c
@@ -132,7 +132,7 @@ static const struct rockchip_p3phy_ops rk3568_ops = {
 static int rockchip_p3phy_rk3588_init(struct rockchip_p3phy_priv *priv)
 {
 	u32 reg = 0;
-	u8 mode = 0;
+	u8 mode = RK3588_LANE_AGGREGATION; /* default */
 	int ret;
 
 	/* Deassert PCIe PMA output clamp mode */
@@ -140,28 +140,20 @@ static int rockchip_p3phy_rk3588_init(struct rockchip_p3phy_priv *priv)
 
 	/* Set bifurcation if needed */
 	for (int i = 0; i < priv->num_lanes; i++) {
-		if (!priv->lanes[i])
-			mode |= (BIT(i) << 3);
-
 		if (priv->lanes[i] > 1)
-			mode |= (BIT(i) >> 1);
-	}
-
-	if (!mode)
-		reg = RK3588_LANE_AGGREGATION;
-	else {
-		if (mode & (BIT(0) | BIT(1)))
-			reg |= RK3588_BIFURCATION_LANE_0_1;
-
-		if (mode & (BIT(2) | BIT(3)))
-			reg |= RK3588_BIFURCATION_LANE_2_3;
+			mode &= ~RK3588_LANE_AGGREGATION;
+		if (priv->lanes[i] == 3)
+			mode |= RK3588_BIFURCATION_LANE_0_1;
+		if (priv->lanes[i] == 4)
+			mode |= RK3588_BIFURCATION_LANE_2_3;
 	}
 
+	reg = mode;
 	regmap_write(priv->phy_grf, RK3588_PCIE3PHY_GRF_CMN_CON0, (0x7<<16) | reg);
 
 	/* Set pcie1ln_sel in PHP_GRF_PCIESEL_CON */
 	if (!IS_ERR(priv->pipe_grf)) {
-		reg = (mode & (BIT(6) | BIT(7))) >> 6;
+		reg = mode & 3;
 		if (reg)
 			regmap_write(priv->pipe_grf, PHP_GRF_PCIESEL_CON,
 				     (reg << 16) | reg);
-- 
2.43.0



