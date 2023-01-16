Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F5E046B7
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:34:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14375C433EF;
	Mon, 16 Jan 2023 16:34:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673886846;
	bh=ELknwW91AvAoAA8leIEPR/jnP6NKrkXbJ8KkjSWqRLE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y39HFofiLnbGG5SNq9N/PBH21IUAuDZMBaB6uY6ahlCrNB4e8FpIV80l1Q10cpqCP
	 XT7S1AQPMS48EaMcH8T1v89O4OM0mBOZKnqoAgs8Oioq806cyzKME4+hXIGcKBUNMJ
	 A8RBS/9lyM+gqmcHGORQ65TrXCysEVsU9yQ3ZkyA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqian Lin <linmq006@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 577/658] net: phy: xgmiitorgmii: Fix refcount leak in xgmiitorgmii_probe
Date: Mon, 16 Jan 2023 16:51:05 +0100
Message-Id: <20230116154935.906821449@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
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
index 151c2a3f0b3a..7a78dfdfa5bd 100644
--- a/drivers/net/phy/xilinx_gmii2rgmii.c
+++ b/drivers/net/phy/xilinx_gmii2rgmii.c
@@ -82,6 +82,7 @@ static int xgmiitorgmii_probe(struct mdio_device *mdiodev)
 
 	if (!priv->phy_dev->drv) {
 		dev_info(dev, "Attached phy not ready\n");
+		put_device(&priv->phy_dev->mdio.dev);
 		return -EPROBE_DEFER;
 	}
 
-- 
2.35.1



