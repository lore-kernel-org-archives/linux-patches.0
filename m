Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0CBD1DE3B2;
	Tue,  8 Oct 2024 12:16:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728389779; cv=none; b=lCyY+NBiDEOozhTXDMM7y80bOphTegJejhDshSRCj1DNl7CN4OqxgzdtC1hDsilsq1/5Nw0tc1vrzhKRnh+MXfVifpwmYwUsvNtX7XahIoUvOZYYOm9my65ZTG0+6xQehBYW19LL2uf9ukzxUCbBKnHuXYx8TF0q5sf6dNbNJf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728389779; c=relaxed/simple;
	bh=q+0DRV9QEGpbLtl7t5r7TV6T3HB8heu6JrgnksMWNpo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jBixg6w81/W+aCZOwVkYrCeXpYU0Y1ZI1gvYNN/3cyB0oh/0nBc/W8a2ohfVmZ1LYDVs911P52ntKX5V7scUeujgzE1tU1CwcG40XGlfDyzpEiFEH1MNA/GR7Dm3Sn7MFB+I7nV3A6y45IYMCIRy2KkzTNceqB4G57vrc+t+HYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U56845m/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U56845m/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27709C4CEC7;
	Tue,  8 Oct 2024 12:16:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728389779;
	bh=q+0DRV9QEGpbLtl7t5r7TV6T3HB8heu6JrgnksMWNpo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U56845m/vneUS0maOdwge9RIi51BjNbE2pzTDjopN1J5ONigoGyEVVYiCOx88LRcn
	 BxmebEmZ/rAPpJ+IGcmav0UIgjMPgNA9LtSIA+Q8g+mJRba0sXZN603mbk6jjIXg5o
	 bYFfGE7u7vVQWAVs8jX9Ji03JPXfVJYPh+e92dk4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robert Hancock <robert.hancock@calian.com>,
	Manikanta Guntupalli <manikanta.guntupalli@amd.com>,
	Michal Simek <michal.simek@amd.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 052/482] i2c: xiic: Try re-initialization on bus busy timeout
Date: Tue,  8 Oct 2024 14:01:55 +0200
Message-ID: <20241008115650.352943230@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Robert Hancock <robert.hancock@calian.com>

[ Upstream commit 1d4a1adbed2582444aaf97671858b7d12915bd05 ]

In the event that the I2C bus was powered down when the I2C controller
driver loads, or some spurious pulses occur on the I2C bus, it's
possible that the controller detects a spurious I2C "start" condition.
In this situation it may continue to report the bus is busy indefinitely
and block the controller from working.

The "single-master" DT flag can be specified to disable bus busy checks
entirely, but this may not be safe to use in situations where other I2C
masters may potentially exist.

In the event that the controller reports "bus busy" for too long when
starting a transaction, we can try reinitializing the controller to see
if the busy condition clears. This allows recovering from this scenario.

Fixes: e1d5b6598cdc ("i2c: Add support for Xilinx XPS IIC Bus Interface")
Signed-off-by: Robert Hancock <robert.hancock@calian.com>
Cc: <stable@vger.kernel.org> # v2.6.34+
Reviewed-by: Manikanta Guntupalli <manikanta.guntupalli@amd.com>
Acked-by: Michal Simek <michal.simek@amd.com>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-xiic.c | 41 ++++++++++++++++++++++-------------
 1 file changed, 26 insertions(+), 15 deletions(-)

diff --git a/drivers/i2c/busses/i2c-xiic.c b/drivers/i2c/busses/i2c-xiic.c
index 19468565120e1..d3ca7d2f81a61 100644
--- a/drivers/i2c/busses/i2c-xiic.c
+++ b/drivers/i2c/busses/i2c-xiic.c
@@ -844,23 +844,11 @@ static int xiic_bus_busy(struct xiic_i2c *i2c)
 	return (sr & XIIC_SR_BUS_BUSY_MASK) ? -EBUSY : 0;
 }
 
-static int xiic_busy(struct xiic_i2c *i2c)
+static int xiic_wait_not_busy(struct xiic_i2c *i2c)
 {
 	int tries = 3;
 	int err;
 
-	if (i2c->tx_msg || i2c->rx_msg)
-		return -EBUSY;
-
-	/* In single master mode bus can only be busy, when in use by this
-	 * driver. If the register indicates bus being busy for some reason we
-	 * should ignore it, since bus will never be released and i2c will be
-	 * stuck forever.
-	 */
-	if (i2c->singlemaster) {
-		return 0;
-	}
-
 	/* for instance if previous transfer was terminated due to TX error
 	 * it might be that the bus is on it's way to become available
 	 * give it at most 3 ms to wake
@@ -1104,13 +1092,36 @@ static int xiic_start_xfer(struct xiic_i2c *i2c, struct i2c_msg *msgs, int num)
 
 	mutex_lock(&i2c->lock);
 
-	ret = xiic_busy(i2c);
-	if (ret) {
+	if (i2c->tx_msg || i2c->rx_msg) {
 		dev_err(i2c->adap.dev.parent,
 			"cannot start a transfer while busy\n");
+		ret = -EBUSY;
 		goto out;
 	}
 
+	/* In single master mode bus can only be busy, when in use by this
+	 * driver. If the register indicates bus being busy for some reason we
+	 * should ignore it, since bus will never be released and i2c will be
+	 * stuck forever.
+	 */
+	if (!i2c->singlemaster) {
+		ret = xiic_wait_not_busy(i2c);
+		if (ret) {
+			/* If the bus is stuck in a busy state, such as due to spurious low
+			 * pulses on the bus causing a false start condition to be detected,
+			 * then try to recover by re-initializing the controller and check
+			 * again if the bus is still busy.
+			 */
+			dev_warn(i2c->adap.dev.parent, "I2C bus busy timeout, reinitializing\n");
+			ret = xiic_reinit(i2c);
+			if (ret)
+				goto out;
+			ret = xiic_wait_not_busy(i2c);
+			if (ret)
+				goto out;
+		}
+	}
+
 	i2c->tx_msg = msgs;
 	i2c->rx_msg = NULL;
 	i2c->nmsgs = num;
-- 
2.43.0



