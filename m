Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D818221D9C;
	Mon, 19 May 2025 21:21:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747689714; cv=none; b=A8l7HdLqhfd3y3Worm4KmCoNgOsVqbBXdYyJWEzZkik9neXbKmueLs1/nqzU7sgRSoy9NYN/lMwLT8LJcXaQ9paVm88+iQNhYSjOZl14XNlVzQ/xG2YlWqRYT3hctoueKIxvCmGpYbZ2/Ac0fEn6NsOquW0tAfLimcF444o9FfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747689714; c=relaxed/simple;
	bh=LfKgBqTTScbLaiJqyKNCt7VK1YfWHS/A9Ldo7X3cW8I=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=p1Lq7LCbxD9zUt7UeI5u9cDgh7GizUjWQLnGIYBcHT/joCTHiAYF4NMOB9SjSEII4OT/0GaaSP+Vgy9dq5atOvUkGKUvTYtQk9Q0A07mmTtDCufEpP89zWtQF+0dhn3FrcqAWf2LrwTDsIKCgOQ49xX8B4aMgQUbUjuDAGN2xAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SUAHtZMw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SUAHtZMw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA0D2C4CEEB;
	Mon, 19 May 2025 21:21:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747689713;
	bh=LfKgBqTTScbLaiJqyKNCt7VK1YfWHS/A9Ldo7X3cW8I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SUAHtZMwI/VCF73YO+p6zauBAiqt9pV5v5wNGaHCj1yY/xJJ63SuX2yntmbL47aiS
	 MzZNOUbfHTlUKcikt8phH7ardFj3bf7ABwUu1ymFfqjCdEevRzFrdlGJ7kUYIogTLV
	 k7C9eGYfX0xF8iMqqiQnNiNHMo8ncM74vSRAIyZIKWIbtNyfq0aQArmzIclzc+T5Y6
	 N3hQHeRCFjZ5JIba0AdKEdEeE+NKNvA2hav9DlJmUFwfYCJLRNwOEi25LcbhrFHzYP
	 zTgqTtgYSHT+ogHKLb4JJFxUizdsgX32UAN8ahiIUDvcQfA1ITQgywbqQJP/eW47R9
	 dQjRmLaLFPWHw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Algea Cao <algea.cao@rock-chips.com>,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	kishon@ti.com,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-rockchip@lists.infradead.org
Subject: [PATCH AUTOSEL 6.14 14/23] phy: phy-rockchip-samsung-hdptx: Fix PHY PLL output 50.25MHz error
Date: Mon, 19 May 2025 17:21:21 -0400
Message-Id: <20250519212131.1985647-14-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250519212131.1985647-1-sashal@kernel.org>
References: <20250519212131.1985647-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.14.7
Content-Transfer-Encoding: 8bit

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
index 2fb4f297fda3d..88d265220e2c4 100644
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

