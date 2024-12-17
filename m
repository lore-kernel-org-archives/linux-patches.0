Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BD18149DFA;
	Tue, 17 Dec 2024 17:13:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734455632; cv=none; b=YlTbCMigN5eGYCl4Ts7WZ7YchdehDlR8pEDgR/j5IubpyCINwBRjSMu7sLoM1ccHYua/mPcOzhqDX14y/8xeM5bDRnmWEqMIuQEKHOzMigeifIiKoF1JRnaEs3fLiHs0h02/www9EPZ8BtQkMGUh63bW4h0d0MKKiDgYQa2QU1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734455632; c=relaxed/simple;
	bh=iLqAsxZmAqZd8CXBOdjODmdO2pZcbg+Em71756rspUM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X5bTgl3LSd1QNhWXhduZ4nEOnBaA1ItDa2M16UKybl+hxAGAoBWQwFUsaM0ir35JvKXUZGRnMaW/K1uN+aTtsH/A+lzXKSa03VgW2ycRbIi2su/XcraxFDH15b5ZSCqCn6d/ZNohR7Q/3vdd9489nqLKIXqLX9pPMyz+CH3JXZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J4d1uYLX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J4d1uYLX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA5F0C4CED3;
	Tue, 17 Dec 2024 17:13:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734455632;
	bh=iLqAsxZmAqZd8CXBOdjODmdO2pZcbg+Em71756rspUM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J4d1uYLXmbaD6VqncGJT984LnLi6ayohYWXs2hSrreH0RWDABHvz/lheaIYxvgY32
	 6hInb5hbCbqvg+D6kKhAPzl7TL32zE0ksEubpAlIIwk5L3nfDRwU1V6L6tNslXWPZt
	 3HvEZAK+4WDt1EdmmISEjPeMSaS37K54CfeZ/V5Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Wahren <wahrenst@gmx.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 32/51] qca_spi: Fix clock speed for multiple QCA7000
Date: Tue, 17 Dec 2024 18:07:25 +0100
Message-ID: <20241217170521.600644543@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170520.301972474@linuxfoundation.org>
References: <20241217170520.301972474@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Wahren <wahrenst@gmx.net>

[ Upstream commit 4dba406fac06b009873fe7a28231b9b7e4288b09 ]

Storing the maximum clock speed in module parameter qcaspi_clkspeed
has the unintended side effect that the first probed instance
defines the value for all other instances. Fix this issue by storing
it in max_speed_hz of the relevant SPI device.

This fix keeps the priority of the speed parameter (module parameter,
device tree property, driver default). Btw this uses the opportunity
to get the rid of the unused member clkspeed.

Fixes: 291ab06ecf67 ("net: qualcomm: new Ethernet over SPI driver for QCA7000")
Signed-off-by: Stefan Wahren <wahrenst@gmx.net>
Link: https://patch.msgid.link/20241206184643.123399-2-wahrenst@gmx.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qualcomm/qca_spi.c | 24 ++++++++++--------------
 drivers/net/ethernet/qualcomm/qca_spi.h |  1 -
 2 files changed, 10 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/qualcomm/qca_spi.c b/drivers/net/ethernet/qualcomm/qca_spi.c
index 385e4c62ca03..926eec0a9532 100644
--- a/drivers/net/ethernet/qualcomm/qca_spi.c
+++ b/drivers/net/ethernet/qualcomm/qca_spi.c
@@ -829,7 +829,6 @@ qcaspi_netdev_init(struct net_device *dev)
 
 	dev->mtu = QCAFRM_MAX_MTU;
 	dev->type = ARPHRD_ETHER;
-	qca->clkspeed = qcaspi_clkspeed;
 	qca->burst_len = qcaspi_burst_len;
 	qca->spi_thread = NULL;
 	qca->buffer_size = (dev->mtu + VLAN_ETH_HLEN + QCAFRM_HEADER_LEN +
@@ -918,17 +917,15 @@ qca_spi_probe(struct spi_device *spi)
 	legacy_mode = of_property_read_bool(spi->dev.of_node,
 					    "qca,legacy-mode");
 
-	if (qcaspi_clkspeed == 0) {
-		if (spi->max_speed_hz)
-			qcaspi_clkspeed = spi->max_speed_hz;
-		else
-			qcaspi_clkspeed = QCASPI_CLK_SPEED;
-	}
+	if (qcaspi_clkspeed)
+		spi->max_speed_hz = qcaspi_clkspeed;
+	else if (!spi->max_speed_hz)
+		spi->max_speed_hz = QCASPI_CLK_SPEED;
 
-	if ((qcaspi_clkspeed < QCASPI_CLK_SPEED_MIN) ||
-	    (qcaspi_clkspeed > QCASPI_CLK_SPEED_MAX)) {
-		dev_err(&spi->dev, "Invalid clkspeed: %d\n",
-			qcaspi_clkspeed);
+	if (spi->max_speed_hz < QCASPI_CLK_SPEED_MIN ||
+	    spi->max_speed_hz > QCASPI_CLK_SPEED_MAX) {
+		dev_err(&spi->dev, "Invalid clkspeed: %u\n",
+			spi->max_speed_hz);
 		return -EINVAL;
 	}
 
@@ -953,14 +950,13 @@ qca_spi_probe(struct spi_device *spi)
 		return -EINVAL;
 	}
 
-	dev_info(&spi->dev, "ver=%s, clkspeed=%d, burst_len=%d, pluggable=%d\n",
+	dev_info(&spi->dev, "ver=%s, clkspeed=%u, burst_len=%d, pluggable=%d\n",
 		 QCASPI_DRV_VERSION,
-		 qcaspi_clkspeed,
+		 spi->max_speed_hz,
 		 qcaspi_burst_len,
 		 qcaspi_pluggable);
 
 	spi->mode = SPI_MODE_3;
-	spi->max_speed_hz = qcaspi_clkspeed;
 	if (spi_setup(spi) < 0) {
 		dev_err(&spi->dev, "Unable to setup SPI device\n");
 		return -EFAULT;
diff --git a/drivers/net/ethernet/qualcomm/qca_spi.h b/drivers/net/ethernet/qualcomm/qca_spi.h
index 58ad910068d4..b3b17bd46e12 100644
--- a/drivers/net/ethernet/qualcomm/qca_spi.h
+++ b/drivers/net/ethernet/qualcomm/qca_spi.h
@@ -101,7 +101,6 @@ struct qcaspi {
 #endif
 
 	/* user configurable options */
-	u32 clkspeed;
 	u8 legacy_mode;
 	u16 burst_len;
 };
-- 
2.39.5



