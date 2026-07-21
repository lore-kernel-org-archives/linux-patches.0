Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C2EC44AB62;
	Tue, 21 Jul 2026 21:27:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669249; cv=none; b=aqbqR0o583UbLbylCRj+C+PzsUY9ClCJ6iR20Y0IpKUcpSjS44CBUvKMvX0CgU0HBkG4dfPaDlqqZbbRjyxzoV8D0s6v/4lMKxujKV0Ps0maevWOe2TlakW5eMLKhZ4HZXJggbIBfK1vftacLkjdrZUNtDdQE7lpZDLlXXOh0Gw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669249; c=relaxed/simple;
	bh=LuHwsqBgtlaNcymgEKiHW0LgNUoprc2MlGTeHck1s3M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SiNfhc5XnAnmvc3a8mFdGpSmlK/ummJof2o8GyYH8t85SykrgCwio9aRiemEzQvFOu3wfx01wyZs0/mKLQqLN2CgzY0AwALhhEfWC1k1IPbmgqzyKDeGhfpzbj4kFKx9eRdZY1DQrJ/oWYWjWwrOrsz0GmV7aIDpDVT2bE+V5P4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=09WX5bPn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="09WX5bPn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 822CA1F000E9;
	Tue, 21 Jul 2026 21:27:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669248;
	bh=I3xg+2qXv9oY+hy5IOpT2X3e6A6OmdzURUN9GD3Q+ew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=09WX5bPnEGZLN7sY3dGqXkWh9qHNF7YA/rfF1DyBrX9/FFTgK5gVHs6c8hQnJIGxr
	 8MvXcraMsUrEPk1PCwKeLhuVQRJRx/7yrHLaJzr9mi63HYPZd9mwJtH1CR8MIQawnt
	 y8zB87ho4MdEKp7axzhXjORJIWlD4hmj6BD6g6zs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0484/1067] mailbox: mtk-adsp: fix UAF during device teardown
Date: Tue, 21 Jul 2026 17:18:05 +0200
Message-ID: <20260721152435.444067788@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 14bc0057de814c..182045dd90df94 100644
--- a/drivers/mailbox/mtk-adsp-mailbox.c
+++ b/drivers/mailbox/mtk-adsp-mailbox.c
@@ -18,6 +18,7 @@ struct mtk_adsp_mbox_priv {
 	struct mbox_controller mbox;
 	void __iomem *va_mboxreg;
 	const struct mtk_adsp_mbox_cfg *cfg;
+	int irq;
 };
 
 struct mtk_adsp_mbox_cfg {
@@ -66,6 +67,8 @@ static int mtk_adsp_mbox_startup(struct mbox_chan *chan)
 	writel(0xFFFFFFFF, priv->va_mboxreg + priv->cfg->clr_in);
 	writel(0xFFFFFFFF, priv->va_mboxreg + priv->cfg->clr_out);
 
+	enable_irq(priv->irq);
+
 	return 0;
 }
 
@@ -73,6 +76,8 @@ static void mtk_adsp_mbox_shutdown(struct mbox_chan *chan)
 {
 	struct mtk_adsp_mbox_priv *priv = get_mtk_adsp_mbox_priv(chan->mbox);
 
+	disable_irq(priv->irq);
+
 	/* Clear ADSP mbox command */
 	writel(0xFFFFFFFF, priv->va_mboxreg + priv->cfg->clr_in);
 	writel(0xFFFFFFFF, priv->va_mboxreg + priv->cfg->clr_out);
@@ -138,8 +143,10 @@ static int mtk_adsp_mbox_probe(struct platform_device *pdev)
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



