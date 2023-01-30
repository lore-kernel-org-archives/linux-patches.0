Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C50B28EB
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 13:58:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B55AAC433EF;
	Mon, 30 Jan 2023 13:58:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675087135;
	bh=HDudfltY2UvmPdSBquTeNcUEZNGlhQVx26JPJTrZY2c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vE2dS4aKcDIoHDxYY5/9nVUW68NS13zS25PbtUbaXLJkr4wfQqH/LixUkZN3xxdyI
	 ZD2jeV7cS8KxHsG6pFidipKhEA/wbMkbfJkhVSegmj6UpWpXryLcVu8KjcJazZDp4B
	 SSYOJuhLA7kqYw1YEfirOCBSA8S3NmKkgNlXDQrA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shang XiaoJing <shangxiaojing@huawei.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 068/313] phy: rockchip-inno-usb2: Fix missing clk_disable_unprepare() in rockchip_usb2phy_power_on()
Date: Mon, 30 Jan 2023 14:48:23 +0100
Message-Id: <20230130134339.845876299@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
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
index e6ededc51523..a0bc10aa7961 100644
--- a/drivers/phy/rockchip/phy-rockchip-inno-usb2.c
+++ b/drivers/phy/rockchip/phy-rockchip-inno-usb2.c
@@ -485,8 +485,10 @@ static int rockchip_usb2phy_power_on(struct phy *phy)
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



