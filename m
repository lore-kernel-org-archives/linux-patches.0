Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 125E538C2C3;
	Sat, 17 Oct 2026 16:50:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255836; cv=none; b=MVnOsaLQaIg7JMlTYYZk3rKZLdHbTjUiGN/Y7VWfgna+FY2RiAKRx6pJhLqwez04qxnNetMlk74g8bR61ZbTrn5KNhBMSkExQxe+ndy++Wt/BSRdRPKxBGLUutS4j81hXJlJ/wBgkhUuwV+y6luYv9url+Ch1ck/cHkhplTdqjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255836; c=relaxed/simple;
	bh=fZLX2GXtQXDKGOL9Uh3lkuzGfFUF8R+x221Q1zDjIyk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bw2qcEKovw7VdcSc2NOX8Tjj70vUVrglBR+FBTyiJ9VwU+lf79hDzun3bh3wZhYubd0cv7t2beCJNsFbuScwmveeSy0ElAIQvRyiFNpIAJlCY5PzPDXMgydmWV0isiFkVwqieZP+sa+szrmMw4ZvEMKcdqnciNn9srECKJEA3E8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zkekyRWJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zkekyRWJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 270631F000C4;
	Sat, 17 Oct 2026 16:50:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255834;
	bh=hjpA7Kpcsj1+s/bD6uyhOiy7gpSAeAH+jme0SL6QN/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zkekyRWJI69sZMsoxFHymlISVQW/cmOsVa0noxBSu2yF1Idq6d8kSMTA8NqIXXEi2
	 Fa4JV1lLHmlqpFgDMKeIW/8S3k38v+nWAb2KC0Ew2k5qjuRlj1BwSapROubNFuCYZ/
	 jI0saW7xNmxcjhq9c2Dw6L4ImABj3pcDX/N61BPM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Fan Wu <fanwu01@zju.edu.cn>,
	Stefan Schmidt <stefan@datenfreihafen.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0038/1674] ieee802154: cc2520: fix FIFOP work use-after-free
Date: Sat, 17 Oct 2026 17:38:30 +0200
Message-ID: <20261017160432.120083553@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Fan Wu <fanwu01@zju.edu.cn>

[ Upstream commit ff5891b266a7fc6a062710836be84f1cc19338b5 ]

The FIFOP interrupt handler queues cc2520_fifop_irqwork.  On removal,
cc2520_remove() only flushes the work.  The devm-managed FIFOP IRQ
remains active until after ->remove() returns and can queue the work
again after that flush, allowing it to run after the private data is
released.

Disable the work with disable_work_sync() instead of flushing it, so
the handler can no longer queue it once removal begins.  Destroy the
buffer mutex last, since the worker and the stop callback invoked
through ieee802154_unregister_hw() both take it.

Found by an in-house static analysis tool.

Fixes: 0da6bc8cc341 ("ieee802154: cc2520: adds driver for TI CC2520 radio")
Cc: stable@vger.kernel.org # v6.10+
Suggested-by: Miquel Raynal <miquel.raynal@bootlin.com>
Reviewed-by: Miquel Raynal <miquel.raynal@bootlin.com>
Assisted-by: Codex:gpt-5.6
Signed-off-by: Fan Wu <fanwu01@zju.edu.cn>
Link: https://lore.kernel.org/20260812061714.175966-1-fanwu01@zju.edu.cn
Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
[ replaced unavailable disable_work_sync() with disable_irq() followed by cancel_work_sync(). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ieee802154/cc2520.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ieee802154/cc2520.c b/drivers/net/ieee802154/cc2520.c
index a94d8dd71aad9..10bdc317ae282 100644
--- a/drivers/net/ieee802154/cc2520.c
+++ b/drivers/net/ieee802154/cc2520.c
@@ -206,6 +206,7 @@ struct cc2520_private {
 	bool is_tx;			/* Flag for sync b/w Tx and Rx */
 	bool amplified;			/* Flag for CC2591 */
 	struct gpio_desc *fifo_pin;	/* FIFO GPIO pin number */
+	int fifop_irq;			/* FIFOP IRQ */
 	struct work_struct fifop_irqwork;/* Workqueue for FIFOP */
 	spinlock_t lock;		/* Lock for is_tx*/
 	struct completion tx_complete;	/* Work completion for Tx */
@@ -1117,8 +1118,9 @@ static int cc2520_probe(struct spi_device *spi)
 		goto err_hw_init;
 
 	/* Set up fifop interrupt */
+	priv->fifop_irq = gpiod_to_irq(fifop);
 	ret = devm_request_irq(&spi->dev,
-			       gpiod_to_irq(fifop),
+			       priv->fifop_irq,
 			       cc2520_fifop_isr,
 			       IRQF_TRIGGER_RISING,
 			       dev_name(&spi->dev),
@@ -1156,11 +1158,11 @@ static void cc2520_remove(struct spi_device *spi)
 {
 	struct cc2520_private *priv = spi_get_drvdata(spi);
 
-	mutex_destroy(&priv->buffer_mutex);
-	flush_work(&priv->fifop_irqwork);
-
+	disable_irq(priv->fifop_irq);
+	cancel_work_sync(&priv->fifop_irqwork);
 	ieee802154_unregister_hw(priv->hw);
 	ieee802154_free_hw(priv->hw);
+	mutex_destroy(&priv->buffer_mutex);
 }
 
 static const struct spi_device_id cc2520_ids[] = {
-- 
2.53.0



