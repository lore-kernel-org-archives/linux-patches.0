Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7C331D5AC6;
	Tue, 15 Oct 2024 13:09:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997784; cv=none; b=fJVj5o+zDdsx1SthyEjskQnp66BDQjV6TJ0DOn2j6BCbcWXYAk2mC7ppLf80pdn31ROPvRcKWhPaZKLGRGIjbJJ/j02Uadgdubde1Ekkyg10ycmQOJFK4BVg1sd36Z0JzXwoj1V7Y8jc+zbpcJkIkgKp5QQP0xIzWsa+o6oyfCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997784; c=relaxed/simple;
	bh=a31Y+VwRUb4oGIiyNE92cA34JZ+jHTXTbr5nfmGCS4o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b+Fxv0ou5pL9TDxUdwr5t1Kr2sX2yFpiYKwhmK4EPy5lS/P7UXj8LOEYo96dO0MIK3FTSrog4lWzi3d/JRWuNq9GRl8fVX/SSNZjvoa8QlvUC7gRvmH0MdY4/MA8t+0aOFASOd6cAoYZ+gOfTOAbUkkLYMEK4b8LRwjpSwJxRj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LyWCbIRd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LyWCbIRd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59695C4CECF;
	Tue, 15 Oct 2024 13:09:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997783;
	bh=a31Y+VwRUb4oGIiyNE92cA34JZ+jHTXTbr5nfmGCS4o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LyWCbIRdgdXrIIQxOoaxfHsH1AjN6Anj3HNOaCF7Gszz/DWGmKOnyfiuCGNFm/JmF
	 HzBwzZnswHTgq4kFIqJq5+tSx2E+zElN5vQViDUMucv+GNUOSZkECiRPuLf7afPl29
	 83dFUWLoTLD6FF8XpAWAH4LGwcvk5FWH9DygOI/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robert Hancock <robert.hancock@calian.com>,
	Manikanta Guntupalli <manikanta.guntupalli@amd.com>,
	Michal Simek <michal.simek@amd.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 286/518] i2c: xiic: Try re-initialization on bus busy timeout
Date: Tue, 15 Oct 2024 14:43:10 +0200
Message-ID: <20241015123928.026921030@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 41104f9f6f0ae..9130563fbea0e 100644
--- a/drivers/i2c/busses/i2c-xiic.c
+++ b/drivers/i2c/busses/i2c-xiic.c
@@ -540,23 +540,11 @@ static int xiic_bus_busy(struct xiic_i2c *i2c)
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
@@ -710,13 +698,36 @@ static int xiic_start_xfer(struct xiic_i2c *i2c, struct i2c_msg *msgs, int num)
 
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



