Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4582E225390;
	Tue, 26 Aug 2025 14:08:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217322; cv=none; b=Mbz5A4YvpDegXVEol1jO8uFftitRg9gSP6k7BD+6Nd16nzVBsg++mCggqmdwaKxWjYlMga9iDeUX73Dn3hJtciMEhfg0XFQd1lNff3Wv93QoOZI3Nrc8Tjr0EuWczrkajmtb5BImjpsA2imYxnSyZLoX3DPB+x9o8wSGb0xLVQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217322; c=relaxed/simple;
	bh=orfBFIIsTRTXkmei3kmnHL67VJZcOcNbPitD3W2haGY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lq5ZlKrZQljx1sY6kLdqm3o5msvB8K06x42RHreCNIxbVPYWNYGc7ieDazejCQrgS6k/jgkOOD8YWsE31mLOITgd0WmOQ0rysrL90AVal4dM42jKuMIkssUfOGD6ELstQtnE8Asy5MgndHUiIXaqma1vQ8mKqZIm5TKavxZdOAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OERXdFS+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OERXdFS+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C953C4CEF1;
	Tue, 26 Aug 2025 14:08:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217321;
	bh=orfBFIIsTRTXkmei3kmnHL67VJZcOcNbPitD3W2haGY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OERXdFS+JQVxcNYz+NmfBRLsylKDRsYUyszpd0BTGsHGRt96FmmtaANiP4EoR+CA0
	 XDx0OFwW5Qz3oT7JfZN60vtBtczkYYWHeIkbW2rYQhPTXpEulLThZpl9yq4JwshKQI
	 7Lz/ppJyRLuX6U11iRCdXAIq6UHXiKxqv2Sx76Jk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Hostetler <thostet@google.com>,
	Praveen Kaligineedi <pkaligineedi@google.com>,
	Harshitha Ramamurthy <hramamurthy@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 068/523] gve: Fix stuck TX queue for DQ queue format
Date: Tue, 26 Aug 2025 13:04:38 +0200
Message-ID: <20250826110926.252230334@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Praveen Kaligineedi <pkaligineedi@google.com>

commit b03f15c0192b184078206760c839054ae6eb4eaa upstream.

gve_tx_timeout was calculating missed completions in a way that is only
relevant in the GQ queue format. Additionally, it was attempting to
disable device interrupts, which is not needed in either GQ or DQ queue
formats.

As a result, TX timeouts with the DQ queue format likely would have
triggered early resets without kicking the queue at all.

This patch drops the check for pending work altogether and always kicks
the queue after validating the queue has not seen a TX timeout too
recently.

Cc: stable@vger.kernel.org
Fixes: 87a7f321bb6a ("gve: Recover from queue stall due to missed IRQ")
Co-developed-by: Tim Hostetler <thostet@google.com>
Signed-off-by: Tim Hostetler <thostet@google.com>
Signed-off-by: Praveen Kaligineedi <pkaligineedi@google.com>
Signed-off-by: Harshitha Ramamurthy <hramamurthy@google.com>
Link: https://patch.msgid.link/20250717192024.1820931-1-hramamurthy@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/google/gve/gve_main.c |   71 +++++++++++++++--------------
 1 file changed, 39 insertions(+), 32 deletions(-)

--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -944,49 +944,56 @@ static void gve_turnup(struct gve_priv *
 	gve_set_napi_enabled(priv);
 }
 
-static void gve_tx_timeout(struct net_device *dev, unsigned int txqueue)
+static struct gve_notify_block *gve_get_tx_notify_block(struct gve_priv *priv,
+							unsigned int txqueue)
 {
-	struct gve_notify_block *block;
-	struct gve_tx_ring *tx = NULL;
-	struct gve_priv *priv;
-	u32 last_nic_done;
-	u32 current_time;
 	u32 ntfy_idx;
 
-	netdev_info(dev, "Timeout on tx queue, %d", txqueue);
-	priv = netdev_priv(dev);
 	if (txqueue > priv->tx_cfg.num_queues)
-		goto reset;
+		return NULL;
 
 	ntfy_idx = gve_tx_idx_to_ntfy(priv, txqueue);
 	if (ntfy_idx >= priv->num_ntfy_blks)
-		goto reset;
+		return NULL;
+
+	return &priv->ntfy_blocks[ntfy_idx];
+}
+
+static bool gve_tx_timeout_try_q_kick(struct gve_priv *priv,
+				      unsigned int txqueue)
+{
+	struct gve_notify_block *block;
+	u32 current_time;
 
-	block = &priv->ntfy_blocks[ntfy_idx];
-	tx = block->tx;
+	block = gve_get_tx_notify_block(priv, txqueue);
+
+	if (!block)
+		return false;
 
 	current_time = jiffies_to_msecs(jiffies);
-	if (tx->last_kick_msec + MIN_TX_TIMEOUT_GAP > current_time)
-		goto reset;
+	if (block->tx->last_kick_msec + MIN_TX_TIMEOUT_GAP > current_time)
+		return false;
+
+	netdev_info(priv->dev, "Kicking queue %d", txqueue);
+	napi_schedule(&block->napi);
+	block->tx->last_kick_msec = current_time;
+	return true;
+}
+
+static void gve_tx_timeout(struct net_device *dev, unsigned int txqueue)
+{
+	struct gve_notify_block *block;
+	struct gve_priv *priv;
+
+	netdev_info(dev, "Timeout on tx queue, %d", txqueue);
+	priv = netdev_priv(dev);
+
+	if (!gve_tx_timeout_try_q_kick(priv, txqueue))
+		gve_schedule_reset(priv);
 
-	/* Check to see if there are missed completions, which will allow us to
-	 * kick the queue.
-	 */
-	last_nic_done = gve_tx_load_event_counter(priv, tx);
-	if (last_nic_done - tx->done) {
-		netdev_info(dev, "Kicking queue %d", txqueue);
-		iowrite32be(GVE_IRQ_MASK, gve_irq_doorbell(priv, block));
-		napi_schedule(&block->napi);
-		tx->last_kick_msec = current_time;
-		goto out;
-	} // Else reset.
-
-reset:
-	gve_schedule_reset(priv);
-
-out:
-	if (tx)
-		tx->queue_timeout++;
+	block = gve_get_tx_notify_block(priv, txqueue);
+	if (block)
+		block->tx->queue_timeout++;
 	priv->tx_timeo_cnt++;
 }
 


