Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BD4519A288;
	Fri, 24 Apr 2026 13:34:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777037652; cv=none; b=Zl9RbQrl8yZu5XFTafjvxomUHSaQ02di+Wv2EjyM3FXe4YfuHJMihf7dem10nysw/bfVz7dRTpheEadFcnXBU8pLiP/SVsTo4eZsIsj4lWlfT1K8FtTiJxMae6jqH5YD8GJr/1oAynzZT6VRBMicue07Ywxc+FITncn9y1vJtZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777037652; c=relaxed/simple;
	bh=SkMX4Wgd5Kn7t5TvBj40DmkWIlnDNhyWvJm/noa4/OQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=guvtqtU7OUizqGn3VLzgxYf11cFWVPc9zVTafrYLsKvL94c/U/5EDeMQtC/21cvBshr+RMUMq4fciiHq6QMCjp23GRGmYenHgp1NW4WDzuGcJxLNgVWHjN9RP9BM1MFyL5ot+gnA2kCgddi6FKFYZJPCP0xOYBPieHuoip5tyrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k0m3kNlg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k0m3kNlg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD66BC19425;
	Fri, 24 Apr 2026 13:34:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777037652;
	bh=SkMX4Wgd5Kn7t5TvBj40DmkWIlnDNhyWvJm/noa4/OQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k0m3kNlg71fUkZXacs0Qpp71C9CLcaLrRCe0xzUMtjKvy/UjuUrGwea4JWGlHAnmn
	 RicfnSH5fCjvUVipU3tkpVa/oPI/N9nYgK7+4SD+FviKfhTM2MvOtScnaql2FV+9YV
	 lqylj4KffTsi/i8QQdSAe6uuFPkpOaBRxUEQEYVc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wenyuan Li <2063309626@qq.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 009/166] can: mcp251x: add error handling for power enable in open and resume
Date: Fri, 24 Apr 2026 15:28:43 +0200
Message-ID: <20260424132534.834357259@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424132532.812258529@linuxfoundation.org>
References: <20260424132532.812258529@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wenyuan Li <2063309626@qq.com>

[ Upstream commit 7a57354756c7df223abe2c33774235ad70cb4231 ]

Add missing error handling for mcp251x_power_enable() calls in both
mcp251x_open() and mcp251x_can_resume() functions.

In mcp251x_open(), if power enable fails, jump to error path to close
candev without attempting to disable power again.

In mcp251x_can_resume(), properly check return values of power enable calls
for both power and transceiver regulators. If any fails, return the error
code to the PM framework and log the failure.

This ensures the driver properly handles power control failures and
maintains correct device state.

Signed-off-by: Wenyuan Li <2063309626@qq.com>
Link: https://patch.msgid.link/tencent_F3EFC5D7738AC548857B91657715E2D3AA06@qq.com
[mkl: fix patch description]
[mkl: mcp251x_can_resume(): replace goto by return]
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/spi/mcp251x.c | 29 ++++++++++++++++++++++++-----
 1 file changed, 24 insertions(+), 5 deletions(-)

diff --git a/drivers/net/can/spi/mcp251x.c b/drivers/net/can/spi/mcp251x.c
index 72ae17b2313ec..d3ffab297b77b 100644
--- a/drivers/net/can/spi/mcp251x.c
+++ b/drivers/net/can/spi/mcp251x.c
@@ -1213,7 +1213,11 @@ static int mcp251x_open(struct net_device *net)
 	}
 
 	mutex_lock(&priv->mcp_lock);
-	mcp251x_power_enable(priv->transceiver, 1);
+	ret = mcp251x_power_enable(priv->transceiver, 1);
+	if (ret) {
+		dev_err(&spi->dev, "failed to enable transceiver power: %pe\n", ERR_PTR(ret));
+		goto out_close_candev;
+	}
 
 	priv->force_quit = 0;
 	priv->tx_skb = NULL;
@@ -1260,6 +1264,7 @@ static int mcp251x_open(struct net_device *net)
 	mcp251x_hw_sleep(spi);
 out_close:
 	mcp251x_power_enable(priv->transceiver, 0);
+out_close_candev:
 	close_candev(net);
 	mutex_unlock(&priv->mcp_lock);
 	if (release_irq)
@@ -1499,11 +1504,25 @@ static int __maybe_unused mcp251x_can_resume(struct device *dev)
 {
 	struct spi_device *spi = to_spi_device(dev);
 	struct mcp251x_priv *priv = spi_get_drvdata(spi);
+	int ret = 0;
 
-	if (priv->after_suspend & AFTER_SUSPEND_POWER)
-		mcp251x_power_enable(priv->power, 1);
-	if (priv->after_suspend & AFTER_SUSPEND_UP)
-		mcp251x_power_enable(priv->transceiver, 1);
+	if (priv->after_suspend & AFTER_SUSPEND_POWER) {
+		ret = mcp251x_power_enable(priv->power, 1);
+		if (ret) {
+			dev_err(dev, "failed to restore power: %pe\n", ERR_PTR(ret));
+			return ret;
+		}
+	}
+
+	if (priv->after_suspend & AFTER_SUSPEND_UP) {
+		ret = mcp251x_power_enable(priv->transceiver, 1);
+		if (ret) {
+			dev_err(dev, "failed to restore transceiver power: %pe\n", ERR_PTR(ret));
+			if (priv->after_suspend & AFTER_SUSPEND_POWER)
+				mcp251x_power_enable(priv->power, 0);
+			return ret;
+		}
+	}
 
 	if (priv->after_suspend & (AFTER_SUSPEND_POWER | AFTER_SUSPEND_UP))
 		queue_work(priv->wq, &priv->restart_work);
-- 
2.53.0



