Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D034B28ED
	for <patches@lists.linux.dev>; Mon, 12 Dec 2022 13:33:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41386C433D2;
	Mon, 12 Dec 2022 13:33:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670851994;
	bh=BPj0+8BczAaSlB0zJpwKL8LTCDrnL6uHmIdeI/reLZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WoBXqgMr5B6IBSKd3L/JbuL7QbW47rYJ73VpAHOlw5hI9w1RzDJrhoz9h3M5Y4WGM
	 FgyrlsLRpfbuQ+LBUc6jIvIqIhh7h/ps6oNHjEJ4fh0+Z85eCYEVI0J6SMXO0vwvDB
	 4y4zkz8a2a1j+Q2vjiRfOAkUgLoNon/qWH/qBUAE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Walle <michael@walle.cc>,
	Andrew Lunn <andrew@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 112/123] net: phy: mxl-gpy: fix version reporting
Date: Mon, 12 Dec 2022 14:17:58 +0100
Message-Id: <20221212130932.061436228@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130926.811961601@linuxfoundation.org>
References: <20221212130926.811961601@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Michael Walle <michael@walle.cc>

[ Upstream commit fc3dd0367e610ae20ebbce6c38c7b86c3a2cc07f ]

The commit 09ce6b20103b ("net: phy: mxl-gpy: add temperature sensor")
will overwrite the return value and the reported version will be wrong.
Fix it.

Fixes: 09ce6b20103b ("net: phy: mxl-gpy: add temperature sensor")
Signed-off-by: Michael Walle <michael@walle.cc>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 5f4d487d01ff ("net: phy: mxl-gpy: add MDINT workaround")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/mxl-gpy.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/phy/mxl-gpy.c b/drivers/net/phy/mxl-gpy.c
index 5ce1bf03bbd7..f9c70476d7e8 100644
--- a/drivers/net/phy/mxl-gpy.c
+++ b/drivers/net/phy/mxl-gpy.c
@@ -96,6 +96,7 @@ static int gpy_config_init(struct phy_device *phydev)
 
 static int gpy_probe(struct phy_device *phydev)
 {
+	int fw_version;
 	int ret;
 
 	if (!phydev->is_c45) {
@@ -105,12 +106,12 @@ static int gpy_probe(struct phy_device *phydev)
 	}
 
 	/* Show GPY PHY FW version in dmesg */
-	ret = phy_read(phydev, PHY_FWV);
-	if (ret < 0)
-		return ret;
+	fw_version = phy_read(phydev, PHY_FWV);
+	if (fw_version < 0)
+		return fw_version;
 
-	phydev_info(phydev, "Firmware Version: 0x%04X (%s)\n", ret,
-		    (ret & PHY_FWV_REL_MASK) ? "release" : "test");
+	phydev_info(phydev, "Firmware Version: 0x%04X (%s)\n", fw_version,
+		    (fw_version & PHY_FWV_REL_MASK) ? "release" : "test");
 
 	return 0;
 }
-- 
2.35.1



