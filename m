Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CC501779BD;
	Fri, 27 Sep 2024 12:33:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727440428; cv=none; b=eW+XJ5ywOp2JnYhgxutXgWE3LUIPG2YPbVqM+LomkdaovkJS28H4xCpVT7hHccOECqlApem/0eYLnGHbbd+umwM+Re7ldriVwNVex8TB2FGCUk/Gne1knBucS+GL+cjQiZJnCYNqO5hwH0evx05RTNNBnVhtq/UPI/KIBa6v56w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727440428; c=relaxed/simple;
	bh=wz28Rewg+mBIGQalQGablL9ycQlcingi/h2rSyNOuZ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eQ/LR+VaCNhJ1w7ccBFC/nsG41MDb7yCYZKBp/ecYmV1EKO1+wKExHlQW7S0ThB8L3xHnJHmDzNtr2YHK1atDPvaE6E20dyRIDFvFWqfmKsMgwq/le/TEs6STC/Qlaw9DZ1GbE3MejylItu1mcR1OzrTvIUCJoI26ES9VTLtqZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cteP3iJb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cteP3iJb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E7D1C4CEC4;
	Fri, 27 Sep 2024 12:33:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727440427;
	bh=wz28Rewg+mBIGQalQGablL9ycQlcingi/h2rSyNOuZ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cteP3iJbOvy1oa1heh3SWvF9C+ICIFZtYE5hyGO9XvN2CUfh8Npf5gm9CQvCMKm82
	 PTFxyNjjmh5ZHEfO8sE9KIY0lL7ALZjgel0Tc1eWE9HhPQMSdKVGsDpAcvX9BFSFve
	 SzxveIyGh5bqEt2Rg9pqDV8Epf3u1sucR6pagYKo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.1 67/73] can: mcp251xfd: move mcp251xfd_timestamp_start()/stop() into mcp251xfd_chip_start/stop()
Date: Fri, 27 Sep 2024 14:24:18 +0200
Message-ID: <20240927121722.567647069@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20240927121719.897851549@linuxfoundation.org>
References: <20240927121719.897851549@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Kleine-Budde <mkl@pengutronix.de>

commit a7801540f325d104de5065850a003f1d9bdc6ad3 upstream.

The mcp251xfd wakes up from Low Power or Sleep Mode when SPI activity
is detected. To avoid this, make sure that the timestamp worker is
stopped before shutting down the chip.

Split the starting of the timestamp worker out of
mcp251xfd_timestamp_init() into the separate function
mcp251xfd_timestamp_start().

Call mcp251xfd_timestamp_init() before mcp251xfd_chip_start(), move
mcp251xfd_timestamp_start() to mcp251xfd_chip_start(). In this way,
mcp251xfd_timestamp_stop() can be called unconditionally by
mcp251xfd_chip_stop().

Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c      |    8 +++++---
 drivers/net/can/spi/mcp251xfd/mcp251xfd-timestamp.c |    7 +++++--
 drivers/net/can/spi/mcp251xfd/mcp251xfd.h           |    1 +
 3 files changed, 11 insertions(+), 5 deletions(-)

--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
@@ -744,6 +744,7 @@ static void mcp251xfd_chip_stop(struct m
 
 	mcp251xfd_chip_interrupts_disable(priv);
 	mcp251xfd_chip_rx_int_disable(priv);
+	mcp251xfd_timestamp_stop(priv);
 	mcp251xfd_chip_sleep(priv);
 }
 
@@ -763,6 +764,8 @@ static int mcp251xfd_chip_start(struct m
 	if (err)
 		goto out_chip_stop;
 
+	mcp251xfd_timestamp_start(priv);
+
 	err = mcp251xfd_set_bittiming(priv);
 	if (err)
 		goto out_chip_stop;
@@ -1610,11 +1613,12 @@ static int mcp251xfd_open(struct net_dev
 	if (err)
 		goto out_mcp251xfd_ring_free;
 
+	mcp251xfd_timestamp_init(priv);
+
 	err = mcp251xfd_chip_start(priv);
 	if (err)
 		goto out_transceiver_disable;
 
-	mcp251xfd_timestamp_init(priv);
 	clear_bit(MCP251XFD_FLAGS_DOWN, priv->flags);
 	can_rx_offload_enable(&priv->offload);
 
@@ -1648,7 +1652,6 @@ out_destroy_workqueue:
 out_can_rx_offload_disable:
 	can_rx_offload_disable(&priv->offload);
 	set_bit(MCP251XFD_FLAGS_DOWN, priv->flags);
-	mcp251xfd_timestamp_stop(priv);
 out_transceiver_disable:
 	mcp251xfd_transceiver_disable(priv);
 out_mcp251xfd_ring_free:
@@ -1674,7 +1677,6 @@ static int mcp251xfd_stop(struct net_dev
 	free_irq(ndev->irq, priv);
 	destroy_workqueue(priv->wq);
 	can_rx_offload_disable(&priv->offload);
-	mcp251xfd_timestamp_stop(priv);
 	mcp251xfd_chip_stop(priv, CAN_STATE_STOPPED);
 	mcp251xfd_transceiver_disable(priv);
 	mcp251xfd_ring_free(priv);
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-timestamp.c
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-timestamp.c
@@ -48,9 +48,12 @@ void mcp251xfd_timestamp_init(struct mcp
 	cc->shift = 1;
 	cc->mult = clocksource_hz2mult(priv->can.clock.freq, cc->shift);
 
-	timecounter_init(&priv->tc, &priv->cc, ktime_get_real_ns());
-
 	INIT_DELAYED_WORK(&priv->timestamp, mcp251xfd_timestamp_work);
+}
+
+void mcp251xfd_timestamp_start(struct mcp251xfd_priv *priv)
+{
+	timecounter_init(&priv->tc, &priv->cc, ktime_get_real_ns());
 	schedule_delayed_work(&priv->timestamp,
 			      MCP251XFD_TIMESTAMP_WORK_DELAY_SEC * HZ);
 }
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd.h
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd.h
@@ -939,6 +939,7 @@ int mcp251xfd_ring_alloc(struct mcp251xf
 int mcp251xfd_handle_rxif(struct mcp251xfd_priv *priv);
 int mcp251xfd_handle_tefif(struct mcp251xfd_priv *priv);
 void mcp251xfd_timestamp_init(struct mcp251xfd_priv *priv);
+void mcp251xfd_timestamp_start(struct mcp251xfd_priv *priv);
 void mcp251xfd_timestamp_stop(struct mcp251xfd_priv *priv);
 
 void mcp251xfd_tx_obj_write_sync(struct work_struct *work);


