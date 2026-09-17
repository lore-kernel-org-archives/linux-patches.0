Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D63FC4DDB26;
	Thu, 17 Sep 2026 18:03:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668185; cv=none; b=IoOy6QLXHOtZGEm9Op83NV8WuvQyKNCsEDgubeYJ+2FIn53AsCeQcz2SgAL03D/ofhwmhp4Yik5jlHWOAcUrzE0GVefl4c1CFD8A1geUEi81m2SkBb+lE0x0h3QVA2GCDvt13fgerW8JdkziPrsfb3BaaTdXV0H5W6WA3zVHNUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668185; c=relaxed/simple;
	bh=YuilmWMCqNeOkouool231bjW2ZArvS3iXSKGLQ2G51c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nFWo4BmX17msoNzJr7bEUN75svVG2/loYbzWmN3UinDpPNXSyl6gJVlO8W+UjZNOZ5CqIok2JvU12cMVDqYaz543NyXzBilZ0Qc3+QCpcu4BCdI6P8I7poxnh8lfmGEyJEJl2y412KvklwSDhR/Z71jSSBMy+USNuDS2AndmJeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QYh+IhTp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QYh+IhTp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A1301F000FF;
	Thu, 17 Sep 2026 18:03:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668183;
	bh=8p2J+5DY9HEXLOchsnclb0pzwi8cAI+JJX36QnpZpW4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QYh+IhTpvIzEMIbume8jIVVNuqefbLIngRLQssi3J1spkQpdfAvoWyeOiLuwyFDEA
	 cpICpVSiXMa7pcy1Zhqgp+9O/Eh6gIur84YWKWsJhxBoLdtEs4eX9axqC9Jg+3GcJT
	 y3j5b9/axzh5ZQFV9MJxpEPmcwQmrxnHEK0lYbaI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0342/1102] mailbox: imx: Add a channel shutdown field
Date: Thu, 17 Sep 2026 16:04:45 +0100
Message-ID: <20260917151548.224617237@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

[ Upstream commit 5ccea7eacb7786c358833634f45700365f6c1d99 ]

sashiko complained about possible teardown problem. The scenario

 CPU 0                              CPU 1
  imx_mu_isr()                   imx_mu_shutdown()
                                   imx_mu_xcr_rmw(priv, IMX_MU_RCR, 0, IMX_MU_xCR_RIEn(priv->dcfg->type, cp->idx));
    imx_mu_specific_rx()
      imx_mu_xcr_rmw(priv, IMX_MU_RCR, IMX_MU_xCR_RIEn(priv->dcfg->type, 0), 0);
                                   free_irq()

The RX event remains enabled because in this short window the RX event
was disabled in ->shutdown() while the interrupt was active and then
enabled again by the ISR while ->shutdown waited in free_irq().

This race requires timing and if happens can be problematic on shared
handlers if the "removed" channel triggers an interrupt. In this case
the irq-core will shutdown the interrupt with the "nobody cared"
message.

Introduce imx_mu_con_priv::shutdown to signal that the channel is
shutting down. This flag is set with the lock held (by
imx_mu_xcr_clr_shut()). The unmask side uses imx_mu_xcr_set_act() which
only enables the event if the channel has not been shutdown and
serialises on the same lock.

Reviewed-by: Peng Fan <peng.fan@nxp.com>
Reviewed-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Jassi Brar <jassisinghbrar@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/imx-mailbox.c | 40 +++++++++++++++++++++++++++++++----
 1 file changed, 36 insertions(+), 4 deletions(-)

diff --git a/drivers/mailbox/imx-mailbox.c b/drivers/mailbox/imx-mailbox.c
index 3319b40835f3c..fa1b0c814c575 100644
--- a/drivers/mailbox/imx-mailbox.c
+++ b/drivers/mailbox/imx-mailbox.c
@@ -82,6 +82,7 @@ struct imx_mu_con_priv {
 	enum imx_mu_chan_type	type;
 	struct mbox_chan	*chan;
 	struct work_struct 	txdb_work;
+	bool			shutdown;
 };
 
 struct imx_mu_priv {
@@ -221,6 +222,36 @@ static u32 imx_mu_xcr_rmw(struct imx_mu_priv *priv, enum imx_mu_xcr type, u32 se
 	return val;
 }
 
+static void imx_mu_xcr_clr_shut(struct imx_mu_priv *priv, struct imx_mu_con_priv *cp,
+				enum imx_mu_xcr type, u32 clr)
+{
+	unsigned long flags;
+	u32 val;
+
+	spin_lock_irqsave(&priv->xcr_lock, flags);
+	cp->shutdown = true;
+
+	val = imx_mu_read(priv, priv->dcfg->xCR[type]);
+	val &= ~clr;
+	imx_mu_write(priv, val, priv->dcfg->xCR[type]);
+	spin_unlock_irqrestore(&priv->xcr_lock, flags);
+}
+
+static void imx_mu_xcr_set_act(struct imx_mu_priv *priv, struct imx_mu_con_priv *cp,
+			       enum imx_mu_xcr type, u32 set)
+{
+	unsigned long flags;
+	u32 val;
+
+	spin_lock_irqsave(&priv->xcr_lock, flags);
+	if (!cp->shutdown) {
+		val = imx_mu_read(priv, priv->dcfg->xCR[type]);
+		val |= set;
+		imx_mu_write(priv, val, priv->dcfg->xCR[type]);
+	}
+	spin_unlock_irqrestore(&priv->xcr_lock, flags);
+}
+
 static int imx_mu_generic_tx(struct imx_mu_priv *priv,
 			     struct imx_mu_con_priv *cp,
 			     void *data)
@@ -379,7 +410,7 @@ static int imx_mu_specific_rx(struct imx_mu_priv *priv, struct imx_mu_con_priv *
 		*data++ = imx_mu_read(priv, priv->dcfg->xRR + (i % num_rr) * 4);
 	}
 
-	imx_mu_xcr_rmw(priv, IMX_MU_RCR, IMX_MU_xCR_RIEn(priv->dcfg->type, 0), 0);
+	imx_mu_xcr_set_act(priv, cp, IMX_MU_RCR, IMX_MU_xCR_RIEn(priv->dcfg->type, 0));
 	mbox_chan_received_data(cp->chan, (void *)priv->msg);
 
 	return 0;
@@ -607,6 +638,7 @@ static int imx_mu_startup(struct mbox_chan *chan)
 		return ret;
 	}
 
+	cp->shutdown = false;
 	switch (cp->type) {
 	case IMX_MU_TYPE_RX:
 		imx_mu_xcr_rmw(priv, IMX_MU_RCR, IMX_MU_xCR_RIEn(priv->dcfg->type, cp->idx), 0);
@@ -641,13 +673,13 @@ static void imx_mu_shutdown(struct mbox_chan *chan)
 
 	switch (cp->type) {
 	case IMX_MU_TYPE_TX:
-		imx_mu_xcr_rmw(priv, IMX_MU_TCR, 0, IMX_MU_xCR_TIEn(priv->dcfg->type, cp->idx));
+		imx_mu_xcr_clr_shut(priv, cp, IMX_MU_TCR, IMX_MU_xCR_TIEn(priv->dcfg->type, cp->idx));
 		break;
 	case IMX_MU_TYPE_RX:
-		imx_mu_xcr_rmw(priv, IMX_MU_RCR, 0, IMX_MU_xCR_RIEn(priv->dcfg->type, cp->idx));
+		imx_mu_xcr_clr_shut(priv, cp, IMX_MU_RCR, IMX_MU_xCR_RIEn(priv->dcfg->type, cp->idx));
 		break;
 	case IMX_MU_TYPE_RXDB:
-		imx_mu_xcr_rmw(priv, IMX_MU_GIER, 0, IMX_MU_xCR_GIEn(priv->dcfg->type, cp->idx));
+		imx_mu_xcr_clr_shut(priv, cp, IMX_MU_GIER, IMX_MU_xCR_GIEn(priv->dcfg->type, cp->idx));
 		break;
 	case IMX_MU_TYPE_RST:
 		imx_mu_xcr_rmw(priv, IMX_MU_CR, IMX_MU_xCR_RST(priv->dcfg->type), 0);
-- 
2.53.0



