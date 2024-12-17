Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FF871F8AD4;
	Tue, 17 Dec 2024 17:31:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456710; cv=none; b=MvrxTgrEnq1W0fT4rJgjJdr76e6kvjm8LEZUvDzdVnxU+JYoqdTcMnVUKPSmvRhLUD77X3v8o4I5zYSMNEV8ctS1JzHp6Km90Ne8hf/BSm+TkwfDUm+K9oegM99thtrj/YGUErSSI4zweCJ1aXraJx8OSG7XWm8EQmWu0A8WBsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456710; c=relaxed/simple;
	bh=WypR1eqsAOqJ2PEK+q0ODPAVH+gttPhm/x2zEQXweWo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f8yZtSiFQVK03C9WefiUpyyXBh0D1vRmX5C4TtMuuAjaSUObyB2HO2o8Dbp0MbNm1CchMH1g/I3ZsPBVvGuu72RERooR7N0TgVGKIGIcYKfgmwX1rmykWTreZZ/CRbdmdOYFu695gn81XfxCHXMfY1UFvFL+Z+cExUEC5ms+85c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PLIAfE6R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PLIAfE6R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE166C4CED3;
	Tue, 17 Dec 2024 17:31:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456710;
	bh=WypR1eqsAOqJ2PEK+q0ODPAVH+gttPhm/x2zEQXweWo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PLIAfE6R1pfYZnv8karKRLTQAZa5kfKX0R3VeA7p6ku09Yc914a9FALOy7Qt8cpYL
	 DUfZkeT94mF1/q8yJcAt2vxhf6IAFW8vj7XEzMksrOTdvo5GEoTdlnwDTc5lTIITBd
	 1e7RNn1y02RYkJbvfOiSpQu+kQPqlVsDhDmmM0RQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Wahren <wahrenst@gmx.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 114/172] qca_spi: Fix clock speed for multiple QCA7000
Date: Tue, 17 Dec 2024 18:07:50 +0100
Message-ID: <20241217170551.060082512@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170546.209657098@linuxfoundation.org>
References: <20241217170546.209657098@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 8f7ce6b51a1c..a73426a8c429 100644
--- a/drivers/net/ethernet/qualcomm/qca_spi.c
+++ b/drivers/net/ethernet/qualcomm/qca_spi.c
@@ -812,7 +812,6 @@ qcaspi_netdev_init(struct net_device *dev)
 
 	dev->mtu = QCAFRM_MAX_MTU;
 	dev->type = ARPHRD_ETHER;
-	qca->clkspeed = qcaspi_clkspeed;
 	qca->burst_len = qcaspi_burst_len;
 	qca->spi_thread = NULL;
 	qca->buffer_size = (QCAFRM_MAX_MTU + VLAN_ETH_HLEN + QCAFRM_HEADER_LEN +
@@ -903,17 +902,15 @@ qca_spi_probe(struct spi_device *spi)
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
 
@@ -938,14 +935,13 @@ qca_spi_probe(struct spi_device *spi)
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
index 8f4808695e82..0831cefc58b8 100644
--- a/drivers/net/ethernet/qualcomm/qca_spi.h
+++ b/drivers/net/ethernet/qualcomm/qca_spi.h
@@ -89,7 +89,6 @@ struct qcaspi {
 #endif
 
 	/* user configurable options */
-	u32 clkspeed;
 	u8 legacy_mode;
 	u16 burst_len;
 };
-- 
2.39.5



