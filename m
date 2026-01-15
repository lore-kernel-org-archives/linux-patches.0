Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 742D03D1CB3;
	Thu, 15 Jan 2026 17:54:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499664; cv=none; b=t1KESCB7PQ9konkKpHIG8A7ZMjL7tSkfrf85zXXAwuLUNAHL0kJg2nDMNN6DDVwVI9HKMBg/LAxP7DqkCNkEoYBGsEBkJl8Eem//g7L6rS9Cg8301MFIVuC0W4i9YLPrHba+9rDK7X6D6xqJxbaIUDUtudo4p+5Gj5qQ0EEZ2NM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499664; c=relaxed/simple;
	bh=bIqarl9aTtBWwbVo24iX+eWq03ThTkB+GjxrIAL5ALQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=czsKBiZdPSsUGtRCz2Y8jZdulfUDXj2vHuVAodo1lXCK3u0v7acNdkurNPpadNPyJiYARfrLH0Sv/OsCHiO+2cF5hDp8pSKYvsy1Ez5OYz+yMmhQwDz7weTrGAUFFZHsLoXjz1XHJbmnXPv1ei77HvrKn1xMANIkJCpDxqRni+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VFYrglgd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VFYrglgd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3DC8C116D0;
	Thu, 15 Jan 2026 17:54:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499664;
	bh=bIqarl9aTtBWwbVo24iX+eWq03ThTkB+GjxrIAL5ALQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VFYrglgdh6y75x5uVaDdgHXuB0J0osJ6kn6zMK7q36GN7xZz3XWORmEU/ZvZ6mtEK
	 eOmnNgRt/rYibaFDIZHB5vQEbmNOETHIMY5pBp5Xvxxzn6cvW0mR9wwTIb7CBSPRNd
	 c+7Q9M1V0FfoUhU2UvtFa2PuFEK0tFqqzIQUzfTs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Potin Lai <potin.lai@quantatw.com>,
	Andrew Lunn <andrew@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 274/451] net: mdio: aspeed: move reg accessing part into separate functions
Date: Thu, 15 Jan 2026 17:47:55 +0100
Message-ID: <20260115164240.797640229@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Potin Lai <potin.lai@quantatw.com>

[ Upstream commit 737ca352569e744bf753b4522a6f91b120a734f1 ]

Add aspeed_mdio_op() and aseed_mdio_get_data() for register accessing.

aspeed_mdio_op() handles operations, write command to control register,
then check and wait operations is finished (bit 31 is cleared).

aseed_mdio_get_data() fetchs the result value of operation from data
register.

Signed-off-by: Potin Lai <potin.lai@quantatw.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: d1a1a4bade4b ("net: mdio: aspeed: add dummy read to avoid read-after-write issue")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/mdio/mdio-aspeed.c | 70 ++++++++++++++++++----------------
 1 file changed, 38 insertions(+), 32 deletions(-)

diff --git a/drivers/net/mdio/mdio-aspeed.c b/drivers/net/mdio/mdio-aspeed.c
index e2273588c75b..f22be2f069e9 100644
--- a/drivers/net/mdio/mdio-aspeed.c
+++ b/drivers/net/mdio/mdio-aspeed.c
@@ -39,34 +39,35 @@ struct aspeed_mdio {
 	void __iomem *base;
 };
 
-static int aspeed_mdio_read(struct mii_bus *bus, int addr, int regnum)
+static int aspeed_mdio_op(struct mii_bus *bus, u8 st, u8 op, u8 phyad, u8 regad,
+			  u16 data)
 {
 	struct aspeed_mdio *ctx = bus->priv;
 	u32 ctrl;
-	u32 data;
-	int rc;
 
-	dev_dbg(&bus->dev, "%s: addr: %d, regnum: %d\n", __func__, addr,
-		regnum);
-
-	/* Just clause 22 for the moment */
-	if (regnum & MII_ADDR_C45)
-		return -EOPNOTSUPP;
+	dev_dbg(&bus->dev, "%s: st: %u op: %u, phyad: %u, regad: %u, data: %u\n",
+		__func__, st, op, phyad, regad, data);
 
 	ctrl = ASPEED_MDIO_CTRL_FIRE
-		| FIELD_PREP(ASPEED_MDIO_CTRL_ST, ASPEED_MDIO_CTRL_ST_C22)
-		| FIELD_PREP(ASPEED_MDIO_CTRL_OP, MDIO_C22_OP_READ)
-		| FIELD_PREP(ASPEED_MDIO_CTRL_PHYAD, addr)
-		| FIELD_PREP(ASPEED_MDIO_CTRL_REGAD, regnum);
+		| FIELD_PREP(ASPEED_MDIO_CTRL_ST, st)
+		| FIELD_PREP(ASPEED_MDIO_CTRL_OP, op)
+		| FIELD_PREP(ASPEED_MDIO_CTRL_PHYAD, phyad)
+		| FIELD_PREP(ASPEED_MDIO_CTRL_REGAD, regad)
+		| FIELD_PREP(ASPEED_MDIO_DATA_MIIRDATA, data);
 
 	iowrite32(ctrl, ctx->base + ASPEED_MDIO_CTRL);
 
-	rc = readl_poll_timeout(ctx->base + ASPEED_MDIO_CTRL, ctrl,
+	return readl_poll_timeout(ctx->base + ASPEED_MDIO_CTRL, ctrl,
 				!(ctrl & ASPEED_MDIO_CTRL_FIRE),
 				ASPEED_MDIO_INTERVAL_US,
 				ASPEED_MDIO_TIMEOUT_US);
-	if (rc < 0)
-		return rc;
+}
+
+static int aspeed_mdio_get_data(struct mii_bus *bus)
+{
+	struct aspeed_mdio *ctx = bus->priv;
+	int rc;
+	u32 data;
 
 	rc = readl_poll_timeout(ctx->base + ASPEED_MDIO_DATA, data,
 				data & ASPEED_MDIO_DATA_IDLE,
@@ -78,31 +79,36 @@ static int aspeed_mdio_read(struct mii_bus *bus, int addr, int regnum)
 	return FIELD_GET(ASPEED_MDIO_DATA_MIIRDATA, data);
 }
 
-static int aspeed_mdio_write(struct mii_bus *bus, int addr, int regnum, u16 val)
+static int aspeed_mdio_read(struct mii_bus *bus, int addr, int regnum)
 {
-	struct aspeed_mdio *ctx = bus->priv;
-	u32 ctrl;
+	int rc;
 
-	dev_dbg(&bus->dev, "%s: addr: %d, regnum: %d, val: 0x%x\n",
-		__func__, addr, regnum, val);
+	dev_dbg(&bus->dev, "%s: addr: %d, regnum: %d\n", __func__, addr,
+		regnum);
 
 	/* Just clause 22 for the moment */
 	if (regnum & MII_ADDR_C45)
 		return -EOPNOTSUPP;
 
-	ctrl = ASPEED_MDIO_CTRL_FIRE
-		| FIELD_PREP(ASPEED_MDIO_CTRL_ST, ASPEED_MDIO_CTRL_ST_C22)
-		| FIELD_PREP(ASPEED_MDIO_CTRL_OP, MDIO_C22_OP_WRITE)
-		| FIELD_PREP(ASPEED_MDIO_CTRL_PHYAD, addr)
-		| FIELD_PREP(ASPEED_MDIO_CTRL_REGAD, regnum)
-		| FIELD_PREP(ASPEED_MDIO_CTRL_MIIWDATA, val);
+	rc = aspeed_mdio_op(bus, ASPEED_MDIO_CTRL_ST_C22, MDIO_C22_OP_READ,
+			    addr, regnum, 0);
+	if (rc < 0)
+		return rc;
 
-	iowrite32(ctrl, ctx->base + ASPEED_MDIO_CTRL);
+	return aspeed_mdio_get_data(bus);
+}
 
-	return readl_poll_timeout(ctx->base + ASPEED_MDIO_CTRL, ctrl,
-				  !(ctrl & ASPEED_MDIO_CTRL_FIRE),
-				  ASPEED_MDIO_INTERVAL_US,
-				  ASPEED_MDIO_TIMEOUT_US);
+static int aspeed_mdio_write(struct mii_bus *bus, int addr, int regnum, u16 val)
+{
+	dev_dbg(&bus->dev, "%s: addr: %d, regnum: %d, val: 0x%x\n",
+		__func__, addr, regnum, val);
+
+	/* Just clause 22 for the moment */
+	if (regnum & MII_ADDR_C45)
+		return -EOPNOTSUPP;
+
+	return aspeed_mdio_op(bus, ASPEED_MDIO_CTRL_ST_C22, MDIO_C22_OP_WRITE,
+			      addr, regnum, val);
 }
 
 static int aspeed_mdio_probe(struct platform_device *pdev)
-- 
2.51.0



