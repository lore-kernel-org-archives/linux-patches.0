Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F18601A3A80;
	Mon,  2 Jun 2025 13:59:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748872765; cv=none; b=Rs8zN03I542ogGNyNRWdFD6Q/kMq74hA1IjFKi0Q1peY4cPZZaW4+myWwR5H6aCcJzLsQLp98F2+WLZPq9rhICeVYsS3J1CF12hsXSbxLNqfnWx520K+Wlh4Zo6Sn0Hne4Z+261XjG/JvoBYwqnCC8gcxt88dvr7H5P59CjBTWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748872765; c=relaxed/simple;
	bh=hSdEFRhWxTvsmkn3m7jnutgkQWLFyTno9BQbXBaF4e4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VwDaHHkrqkVDYBNHghdu/AdAvbXmp5DCWIK5bZ351WqE0pPVFdY2FZBCpXzeos/Nn+nIEfezwGu/BL0/Ab3+YkEmxDwqgWNO/IEnS+EJClyr+VI481lVMRtSz5YW1bkrkkQcaeWnDaBWHHVGKx+KyMMY9gmc+P6mZQOYsUtDFPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ib6tNQ4H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ib6tNQ4H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 707A0C4CEEB;
	Mon,  2 Jun 2025 13:59:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748872764;
	bh=hSdEFRhWxTvsmkn3m7jnutgkQWLFyTno9BQbXBaF4e4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ib6tNQ4HqKBH6/NBvEGl2toDtj+gl7EKHTfjzWysvbhxl3op/HMtgAglUba8vb6eX
	 9UBg4uzlY7AzNCpsHsQVqjdq4AW8rTmZJ1itaBJORBt6d5oDgq9ul1rogu0wcb0wUi
	 Eu9OJ6Fy3BBWBR9eqIQ0vJ/G+NDUg/Dxv608JWjo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Algea Cao <algea.cao@rock-chips.com>,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 61/73] phy: phy-rockchip-samsung-hdptx: Fix PHY PLL output 50.25MHz error
Date: Mon,  2 Jun 2025 15:47:47 +0200
Message-ID: <20250602134244.092998272@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134241.673490006@linuxfoundation.org>
References: <20250602134241.673490006@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Algea Cao <algea.cao@rock-chips.com>

[ Upstream commit f9475055b11c0c70979bd1667a76b2ebae638eb7 ]

When using HDMI PLL frequency division coefficient at 50.25MHz
that is calculated by rk_hdptx_phy_clk_pll_calc(), it fails to
get PHY LANE lock. Although the calculated values are within the
allowable range of PHY PLL configuration.

In order to fix the PHY LANE lock error and provide the expected
50.25MHz output, manually compute the required PHY PLL frequency
division coefficient and add it to ropll_tmds_cfg configuration
table.

Signed-off-by: Algea Cao <algea.cao@rock-chips.com>
Reviewed-by: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
Acked-by: Heiko Stuebner <heiko@sntech.de>
Link: https://lore.kernel.org/r/20250427095124.3354439-1-algea.cao@rock-chips.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/rockchip/phy-rockchip-samsung-hdptx.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/phy/rockchip/phy-rockchip-samsung-hdptx.c b/drivers/phy/rockchip/phy-rockchip-samsung-hdptx.c
index 920abf6fa9bdd..28a4235bfd5fb 100644
--- a/drivers/phy/rockchip/phy-rockchip-samsung-hdptx.c
+++ b/drivers/phy/rockchip/phy-rockchip-samsung-hdptx.c
@@ -325,6 +325,8 @@ static const struct ropll_config ropll_tmds_cfg[] = {
 	  1, 1, 0, 0x20, 0x0c, 1, 0x0e, 0, 0, },
 	{ 650000, 162, 162, 1, 1, 11, 1, 1, 1, 1, 1, 1, 1, 54, 0, 16, 4, 1,
 	  1, 1, 0, 0x20, 0x0c, 1, 0x0e, 0, 0, },
+	{ 502500, 84, 84, 1, 1, 7, 1, 1, 1, 1, 1, 1, 1, 11, 1, 4, 5,
+	  4, 11, 1, 0, 0x20, 0x0c, 1, 0x0e, 0, 0, },
 	{ 337500, 0x70, 0x70, 1, 1, 0xf, 1, 1, 1, 1, 1, 1, 1, 0x2, 0, 0x01, 5,
 	  1, 1, 1, 0, 0x20, 0x0c, 1, 0x0e, 0, 0, },
 	{ 400000, 100, 100, 1, 1, 11, 1, 1, 0, 1, 0, 1, 1, 0x9, 0, 0x05, 0,
-- 
2.39.5



