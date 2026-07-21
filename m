Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97FEA41735B;
	Tue, 21 Jul 2026 19:33:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662400; cv=none; b=Ncvicxh9kkdlVYh24cc1AW32RoiGFb0cZE1laPVzQ+eG5nPiRymPV2RCewbHkroQd7sghFuV5uz0pBGdZHSK4HEo8I0tzTZwfb145E+UjHUIPGyXPxseWL6znsPgHRa23ktL1BmYFLYVmFnCJeUSeXcbnGpdcKTqZCrQqwBdIHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662400; c=relaxed/simple;
	bh=yIdyPr1A9pXPtZjarOOGUTIVzZSsx+h0sP3jmB/Ci10=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ql2hdgHpV1b+XcJ6blnkbta7e0bqFyHpbOCkgVEC+F8pEozvI0jMeDvsAKJpRq/efpsOVLSxEmNU2I+8EJuihm6CuEgJboXViEUweV93IRWHGxUDSd4dWQNvNil9eDp10mftAJHLP17bSs+RUCqhy8ZvLVtGnCsXhuxFj+PRW2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FagD+toE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FagD+toE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2E121F000E9;
	Tue, 21 Jul 2026 19:33:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662399;
	bh=WuwMLGgVvLrNp6h+DN0Ti0M8DI76ucm5AmyoGVqIaGc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FagD+toEiVlVsttagRJTxO8UO2I0I7QBCAy2R1+D1BC2eiihp+S0gPtkfZ5XSiQWJ
	 TuUifePmHpt76bN6XAD0JfXP3L2Cqk88+dO9MtJpAY1xcdrY/5fRvDyE1Pe3ofBaDP
	 dxwZMsgvMvektYmsbyOEd3ZXbmGfY3QhQsFn0pEY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0431/1276] mailbox: mtk-adsp: fix UAF during device teardown
Date: Tue, 21 Jul 2026 17:14:34 +0200
Message-ID: <20260721152455.748666928@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sergey Senozhatsky <senozhatsky@chromium.org>

[ Upstream commit b57d1a40bc43258372fa1f4d39305e093947a262 ]

When the SOF audio driver fails to initialize (e.g. firmware boot
timeout), its devres unwind frees the snd_sof_dev object that the
mailbox client (mtk-adsp-ipc) reaches via chan->cl->rx_callback.
The mtk-adsp-mailbox shutdown clears the mailbox command registers
but leaves the IRQ line unmasked, so a late interrupt can still
queue a threaded handler after mbox_free_channel() had cleared
chan->cl, and mbox_chan_received_data() would then trigger UAF:

  BUG: KASAN: slab-use-after-free in sof_ipc3_validate_fw_version
   sof_ipc3_validate_fw_version
   sof_ipc3_do_rx_work
   sof_ipc3_rx_msg
   mt8196_dsp_handle_request
   mtk_adsp_ipc_recv
   mbox_chan_received_data
   mtk_adsp_mbox_isr
   irq_thread_fn
  Freed by task ...:
   kfree
   devres_release_all
   really_probe
   ... (sof-audio-of-mt8196 probe failure)

The crash was observed roughly three seconds after the failed probe.

disable_irq() in shutdown and enable_irq() in startup. disable_irq()
also waits for any in-flight interrupts, so by the time
mbox_free_channel() proceeds to clear chan->cl no rx_callback can run.

In addition, request the IRQ with IRQF_NO_AUTOEN so it stays masked
between probe and the first client bind — otherwise an early interrupt
can crash on chan->cl == NULL in mbox_chan_received_data().

Fixes: af2dfa96c52d ("mailbox: mediatek: add support for adsp mailbox controller")
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Reviewed-by: Tzung-Bi Shih <tzungbi@kernel.org>
Signed-off-by: Jassi Brar <jassisinghbrar@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/mtk-adsp-mailbox.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/mailbox/mtk-adsp-mailbox.c b/drivers/mailbox/mtk-adsp-mailbox.c
index 91487aa4d7da08..8bcecddee0eb5c 100644
--- a/drivers/mailbox/mtk-adsp-mailbox.c
+++ b/drivers/mailbox/mtk-adsp-mailbox.c
@@ -19,6 +19,7 @@ struct mtk_adsp_mbox_priv {
 	struct mbox_controller mbox;
 	void __iomem *va_mboxreg;
 	const struct mtk_adsp_mbox_cfg *cfg;
+	int irq;
 };
 
 struct mtk_adsp_mbox_cfg {
@@ -67,6 +68,8 @@ static int mtk_adsp_mbox_startup(struct mbox_chan *chan)
 	writel(0xFFFFFFFF, priv->va_mboxreg + priv->cfg->clr_in);
 	writel(0xFFFFFFFF, priv->va_mboxreg + priv->cfg->clr_out);
 
+	enable_irq(priv->irq);
+
 	return 0;
 }
 
@@ -74,6 +77,8 @@ static void mtk_adsp_mbox_shutdown(struct mbox_chan *chan)
 {
 	struct mtk_adsp_mbox_priv *priv = get_mtk_adsp_mbox_priv(chan->mbox);
 
+	disable_irq(priv->irq);
+
 	/* Clear ADSP mbox command */
 	writel(0xFFFFFFFF, priv->va_mboxreg + priv->cfg->clr_in);
 	writel(0xFFFFFFFF, priv->va_mboxreg + priv->cfg->clr_out);
@@ -139,8 +144,10 @@ static int mtk_adsp_mbox_probe(struct platform_device *pdev)
 	if (irq < 0)
 		return irq;
 
+	priv->irq = irq;
 	ret = devm_request_threaded_irq(dev, irq, mtk_adsp_mbox_irq,
-					mtk_adsp_mbox_isr, IRQF_TRIGGER_NONE,
+					mtk_adsp_mbox_isr,
+					IRQF_TRIGGER_NONE | IRQF_NO_AUTOEN,
 					dev_name(dev), mbox->chans);
 	if (ret < 0)
 		return ret;
-- 
2.53.0



