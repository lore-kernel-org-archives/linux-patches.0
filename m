Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E1181FB4
	for <patches@lists.linux.dev>; Fri,  3 Feb 2023 10:19:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 136E4C433EF;
	Fri,  3 Feb 2023 10:19:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675419551;
	bh=xdVSzrx6mttr7f0mXuAQ7HK2cVQMe6xjPKToJBwQdj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0fkhXRHr92z2ytFJI8t9ygsOFPyDEfW3aDlxFPC8dX4KrX0r9vL85341znHUbcA6v
	 SCADjbXEdNOlN4jcjqAmwyYPfw1mXN6fXPRj/EI+wPtYdykRHKukrcrJoulpmFv+6e
	 E+a6wTjjDt/w1dgZwgxApThFXeJFFMeW3wFzkQhs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shang XiaoJing <shangxiaojing@huawei.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 13/80] phy: rockchip-inno-usb2: Fix missing clk_disable_unprepare() in rockchip_usb2phy_power_on()
Date: Fri,  3 Feb 2023 11:12:07 +0100
Message-Id: <20230203101015.782697441@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101015.263854890@linuxfoundation.org>
References: <20230203101015.263854890@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Shang XiaoJing <shangxiaojing@huawei.com>

[ Upstream commit 5daba914da0e48950e9407ea4d75fa57029c9adc ]

The clk_disable_unprepare() should be called in the error handling of
rockchip_usb2phy_power_on().

Fixes: 0e08d2a727e6 ("phy: rockchip-inno-usb2: add a new driver for Rockchip usb2phy")
Signed-off-by: Shang XiaoJing <shangxiaojing@huawei.com>
Link: https://lore.kernel.org/r/20221205115823.16957-1-shangxiaojing@huawei.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/rockchip/phy-rockchip-inno-usb2.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/phy/rockchip/phy-rockchip-inno-usb2.c b/drivers/phy/rockchip/phy-rockchip-inno-usb2.c
index 5049dac79bd0..77c1c3ffaed7 100644
--- a/drivers/phy/rockchip/phy-rockchip-inno-usb2.c
+++ b/drivers/phy/rockchip/phy-rockchip-inno-usb2.c
@@ -477,8 +477,10 @@ static int rockchip_usb2phy_power_on(struct phy *phy)
 		return ret;
 
 	ret = property_enable(base, &rport->port_cfg->phy_sus, false);
-	if (ret)
+	if (ret) {
+		clk_disable_unprepare(rphy->clk480m);
 		return ret;
+	}
 
 	/* waiting for the utmi_clk to become stable */
 	usleep_range(1500, 2000);
-- 
2.39.0



