Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F126A93F
	for <patches@lists.linux.dev>; Tue, 10 Jan 2023 18:10:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC2DDC433EF;
	Tue, 10 Jan 2023 18:10:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673374251;
	bh=qR6ssOcePY4bE+MRpEZp0lPnMh4TA3sLIpcorx5sMZM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yWT+AXlxtgBjajVFUXNfkwweRlSLYBmk/IverspfS/8KfLEaTZrVlsm4FO8FGcNag
	 5AlKhGkHfncch9l4TJViLSmj/ZMpKbtnxsww00ehhv1utG7sh8pWWgCalR5QiCcjVC
	 6GvCg2NTQyIkq/lXJbSX83beqQ7HggBDeormDGuA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqian Lin <linmq006@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 071/148] net: phy: xgmiitorgmii: Fix refcount leak in xgmiitorgmii_probe
Date: Tue, 10 Jan 2023 19:02:55 +0100
Message-Id: <20230110180019.468964365@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180017.145591678@linuxfoundation.org>
References: <20230110180017.145591678@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit d039535850ee47079d59527e96be18d8e0daa84b ]

of_phy_find_device() return device node with refcount incremented.
Call put_device() to relese it when not needed anymore.

Fixes: ab4e6ee578e8 ("net: phy: xgmiitorgmii: Check phy_driver ready before accessing")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/xilinx_gmii2rgmii.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/phy/xilinx_gmii2rgmii.c b/drivers/net/phy/xilinx_gmii2rgmii.c
index 8dcb49ed1f3d..7fd9fe6a602b 100644
--- a/drivers/net/phy/xilinx_gmii2rgmii.c
+++ b/drivers/net/phy/xilinx_gmii2rgmii.c
@@ -105,6 +105,7 @@ static int xgmiitorgmii_probe(struct mdio_device *mdiodev)
 
 	if (!priv->phy_dev->drv) {
 		dev_info(dev, "Attached phy not ready\n");
+		put_device(&priv->phy_dev->mdio.dev);
 		return -EPROBE_DEFER;
 	}
 
-- 
2.35.1



