Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6207341ACA;
	Wed,  3 Dec 2025 16:44:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780273; cv=none; b=D4tH9HUc8/kZK95l1HLDL/VczOPeCP5Iq3159Qr2tnkRN/4HfsDQGfm/pNH3j9zc727iEkACofSNjJJLN5m3a46SSesqaMA0Gm+1zXmPEA04iBIvxL/4T84Hmmdck5EeHWhkaPAijfO4y2+deRuqCRnjXWKhFpbEcJvWKb5FohI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780273; c=relaxed/simple;
	bh=2h1VqRc0Zq2SW6XYCuj6Y4MazwZcvuacSJ8FlkzyT3w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JbDfPGZGYHZ1bJVB9Wp8WhcJmmpHb/vOq20w549VHsDq5S3m2MH7dOW7cjAdwEhyTVoj8YovvWk6BmoSz+K7yy/vy3iFd/5xH0oBUc4ZAodoBeXDg/YKA8p+nUy3QPaajvDHgKrO0Gca2+w+pibXjLJrVV6kuHDJoSo9IVVFebM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jpGOoTgP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jpGOoTgP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26F10C4CEF5;
	Wed,  3 Dec 2025 16:44:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780273;
	bh=2h1VqRc0Zq2SW6XYCuj6Y4MazwZcvuacSJ8FlkzyT3w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jpGOoTgPzD1BtHVntxhXA6bndl8zZBfeqf7ZQ0CM87f+raLPLlbnT1cx5Qdre6O6G
	 4WFPpSEwKFsrr7Zh+z6u+9wDqoR3ipSj5F0Hg50STsU3r+U4uCbTzcR5vb0NDFlFhp
	 q72IQIvJRCyTpOEyrP6oo5gciFrQgj/drMfztELo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sudeep Holla <sudeep.holla@arm.com>,
	Elliot Berman <quic_eberman@quicinc.com>,
	Jassi Brar <jaswinder.singh@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 508/568] mailbox: pcc: Use mbox_bind_client
Date: Wed,  3 Dec 2025 16:28:30 +0100
Message-ID: <20251203152459.321014548@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Elliot Berman <quic_eberman@quicinc.com>

[ Upstream commit 76d4adacd52e78bea2e393081f2a5766261d1e3a ]

Use generic mbox_bind_client() to bind omap mailbox channel to a client.

mbox_bind_client is identical to the replaced lines, except that it:
 - Does the operation under con_mutex which prevents possible races in
   removal path
 - Sets TXDONE_BY_ACK if pcc uses TXDONE_BY_POLL and the client knows
   when tx is done. TXDONE_BY_ACK is already set if there's no interrupt,
   so this is not applicable.
 - Calls chan->mbox->ops->startup. This is usecase for requesting irq:
   move the devm_request_irq into the startup callback and unregister it
   in the shutdown path.

Tested-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Elliot Berman <quic_eberman@quicinc.com>
Signed-off-by: Jassi Brar <jaswinder.singh@linaro.org>
Stable-dep-of: ff0e4d4c97c9 ("mailbox: pcc: don't zero error register")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/pcc.c | 84 +++++++++++++++++++++++--------------------
 1 file changed, 45 insertions(+), 39 deletions(-)

diff --git a/drivers/mailbox/pcc.c b/drivers/mailbox/pcc.c
index 105d46c9801ba..a44d4b3e5beb2 100644
--- a/drivers/mailbox/pcc.c
+++ b/drivers/mailbox/pcc.c
@@ -282,8 +282,7 @@ pcc_mbox_request_channel(struct mbox_client *cl, int subspace_id)
 {
 	struct pcc_chan_info *pchan;
 	struct mbox_chan *chan;
-	struct device *dev;
-	unsigned long flags;
+	int rc;
 
 	if (subspace_id < 0 || subspace_id >= pcc_chan_count)
 		return ERR_PTR(-ENOENT);
@@ -294,32 +293,10 @@ pcc_mbox_request_channel(struct mbox_client *cl, int subspace_id)
 		pr_err("Channel not found for idx: %d\n", subspace_id);
 		return ERR_PTR(-EBUSY);
 	}
-	dev = chan->mbox->dev;
 
-	spin_lock_irqsave(&chan->lock, flags);
-	chan->msg_free = 0;
-	chan->msg_count = 0;
-	chan->active_req = NULL;
-	chan->cl = cl;
-	init_completion(&chan->tx_complete);
-
-	if (chan->txdone_method == TXDONE_BY_POLL && cl->knows_txdone)
-		chan->txdone_method = TXDONE_BY_ACK;
-
-	spin_unlock_irqrestore(&chan->lock, flags);
-
-	if (pchan->plat_irq > 0) {
-		int rc;
-
-		rc = devm_request_irq(dev, pchan->plat_irq, pcc_mbox_irq, 0,
-				      MBOX_IRQ_NAME, chan);
-		if (unlikely(rc)) {
-			dev_err(dev, "failed to register PCC interrupt %d\n",
-				pchan->plat_irq);
-			pcc_mbox_free_channel(&pchan->chan);
-			return ERR_PTR(rc);
-		}
-	}
+	rc = mbox_bind_client(chan, cl);
+	if (rc)
+		return ERR_PTR(rc);
 
 	return &pchan->chan;
 }
@@ -333,23 +310,12 @@ EXPORT_SYMBOL_GPL(pcc_mbox_request_channel);
  */
 void pcc_mbox_free_channel(struct pcc_mbox_chan *pchan)
 {
-	struct pcc_chan_info *pchan_info = to_pcc_chan_info(pchan);
 	struct mbox_chan *chan = pchan->mchan;
-	unsigned long flags;
 
 	if (!chan || !chan->cl)
 		return;
 
-	if (pchan_info->plat_irq > 0)
-		devm_free_irq(chan->mbox->dev, pchan_info->plat_irq, chan);
-
-	spin_lock_irqsave(&chan->lock, flags);
-	chan->cl = NULL;
-	chan->active_req = NULL;
-	if (chan->txdone_method == TXDONE_BY_ACK)
-		chan->txdone_method = TXDONE_BY_POLL;
-
-	spin_unlock_irqrestore(&chan->lock, flags);
+	mbox_free_channel(chan);
 }
 EXPORT_SYMBOL_GPL(pcc_mbox_free_channel);
 
@@ -377,8 +343,48 @@ static int pcc_send_data(struct mbox_chan *chan, void *data)
 	return pcc_chan_reg_read_modify_write(&pchan->db);
 }
 
+/**
+ * pcc_startup - Called from Mailbox Controller code. Used here
+ *		to request the interrupt.
+ * @chan: Pointer to Mailbox channel to startup.
+ *
+ * Return: Err if something failed else 0 for success.
+ */
+static int pcc_startup(struct mbox_chan *chan)
+{
+	struct pcc_chan_info *pchan = chan->con_priv;
+	int rc;
+
+	if (pchan->plat_irq > 0) {
+		rc = devm_request_irq(chan->mbox->dev, pchan->plat_irq, pcc_mbox_irq, 0,
+				      MBOX_IRQ_NAME, chan);
+		if (unlikely(rc)) {
+			dev_err(chan->mbox->dev, "failed to register PCC interrupt %d\n",
+				pchan->plat_irq);
+			return rc;
+		}
+	}
+
+	return 0;
+}
+
+/**
+ * pcc_shutdown - Called from Mailbox Controller code. Used here
+ *		to free the interrupt.
+ * @chan: Pointer to Mailbox channel to shutdown.
+ */
+static void pcc_shutdown(struct mbox_chan *chan)
+{
+	struct pcc_chan_info *pchan = chan->con_priv;
+
+	if (pchan->plat_irq > 0)
+		devm_free_irq(chan->mbox->dev, pchan->plat_irq, chan);
+}
+
 static const struct mbox_chan_ops pcc_chan_ops = {
 	.send_data = pcc_send_data,
+	.startup = pcc_startup,
+	.shutdown = pcc_shutdown,
 };
 
 /**
-- 
2.51.0



