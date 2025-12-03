Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3621835CB78;
	Wed,  3 Dec 2025 16:26:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779192; cv=none; b=P3Rul1B5fvVU8fThe27uubWE+a42Ve1t+3HBpXA2XPoQkJmsorxGyorv+e7fiWeBhrA4IQiwqRPMQCoH3hLMoe0WTPNFSXWOaDU177ey19GUJjxDINJM2eAX3F22xuDIBT44CBLOC4XK9lKp2raqjX6gk44EzpKQYxXrC+FeEsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779192; c=relaxed/simple;
	bh=nnXUSty5y+Ug+ctRE3PV25OzfQlKYgQhkQunSsIQdoQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l4wNvhazoC3y6/mxiofMv9nTeFnzAC78t9HlNbltwG0GkLoFETHJAiBhxii+5pmR324Iiw6wPcBkfDQ7XcercNGeFWoft3Ci67ml27SdO4rBKbzkgfIwkPUg7I8MhoyfpxU8vciBsM7AEogJ0CiLt/mSn33WKoIOP7MJXrg5QAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=02LkeXaH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="02LkeXaH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD527C4CEF5;
	Wed,  3 Dec 2025 16:26:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779192;
	bh=nnXUSty5y+Ug+ctRE3PV25OzfQlKYgQhkQunSsIQdoQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=02LkeXaHjKRi6otyjK05RYpGj+jhf0HYl76PlMHKyZhJJ4/FFT9u9xHU+Ray8645U
	 +OehZ7aMGEJiEA1W5X3EjmbmFLD8ckOsKL+BV2hQzhwhK9sP3jz96Wu4WxJx/yh9KE
	 BIh2OOH2hfqP0du0xOXj7oXZSpsiZrLOxuXGWDi0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Andreatta <thomas.andreatta2000@gmail.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 183/568] dmaengine: sh: setup_xref error handling
Date: Wed,  3 Dec 2025 16:23:05 +0100
Message-ID: <20251203152447.430258256@linuxfoundation.org>
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

From: Thomas Andreatta <thomasandreatta2000@gmail.com>

[ Upstream commit d9a3e9929452780df16f3414f0d59b5f69d058cf ]

This patch modifies the type of setup_xref from void to int and handles
errors since the function can fail.

`setup_xref` now returns the (eventual) error from
`dmae_set_dmars`|`dmae_set_chcr`, while `shdma_tx_submit` handles the
result, removing the chunks from the queue and marking PM as idle in
case of an error.

Signed-off-by: Thomas Andreatta <thomas.andreatta2000@gmail.com>
Link: https://lore.kernel.org/r/20250827152442.90962-1-thomas.andreatta2000@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/sh/shdma-base.c | 25 +++++++++++++++++++------
 drivers/dma/sh/shdmac.c     | 17 +++++++++++++----
 include/linux/shdma-base.h  |  2 +-
 3 files changed, 33 insertions(+), 11 deletions(-)

diff --git a/drivers/dma/sh/shdma-base.c b/drivers/dma/sh/shdma-base.c
index 158e5e7defaeb..f309441f847ff 100644
--- a/drivers/dma/sh/shdma-base.c
+++ b/drivers/dma/sh/shdma-base.c
@@ -129,12 +129,25 @@ static dma_cookie_t shdma_tx_submit(struct dma_async_tx_descriptor *tx)
 			const struct shdma_ops *ops = sdev->ops;
 			dev_dbg(schan->dev, "Bring up channel %d\n",
 				schan->id);
-			/*
-			 * TODO: .xfer_setup() might fail on some platforms.
-			 * Make it int then, on error remove chunks from the
-			 * queue again
-			 */
-			ops->setup_xfer(schan, schan->slave_id);
+
+			ret = ops->setup_xfer(schan, schan->slave_id);
+			if (ret < 0) {
+				dev_err(schan->dev, "setup_xfer failed: %d\n", ret);
+
+				/* Remove chunks from the queue and mark them as idle */
+				list_for_each_entry_safe(chunk, c, &schan->ld_queue, node) {
+					if (chunk->cookie == cookie) {
+						chunk->mark = DESC_IDLE;
+						list_move(&chunk->node, &schan->ld_free);
+					}
+				}
+
+				schan->pm_state = SHDMA_PM_ESTABLISHED;
+				ret = pm_runtime_put(schan->dev);
+
+				spin_unlock_irq(&schan->chan_lock);
+				return ret;
+			}
 
 			if (schan->pm_state == SHDMA_PM_PENDING)
 				shdma_chan_xfer_ld_queue(schan);
diff --git a/drivers/dma/sh/shdmac.c b/drivers/dma/sh/shdmac.c
index 5aafe548ca5f3..2b9774ae7fd32 100644
--- a/drivers/dma/sh/shdmac.c
+++ b/drivers/dma/sh/shdmac.c
@@ -301,21 +301,30 @@ static bool sh_dmae_channel_busy(struct shdma_chan *schan)
 	return dmae_is_busy(sh_chan);
 }
 
-static void sh_dmae_setup_xfer(struct shdma_chan *schan,
-			       int slave_id)
+static int sh_dmae_setup_xfer(struct shdma_chan *schan, int slave_id)
 {
 	struct sh_dmae_chan *sh_chan = container_of(schan, struct sh_dmae_chan,
 						    shdma_chan);
 
+	int ret = 0;
 	if (slave_id >= 0) {
 		const struct sh_dmae_slave_config *cfg =
 			sh_chan->config;
 
-		dmae_set_dmars(sh_chan, cfg->mid_rid);
-		dmae_set_chcr(sh_chan, cfg->chcr);
+		ret = dmae_set_dmars(sh_chan, cfg->mid_rid);
+		if (ret < 0)
+			goto END;
+
+		ret = dmae_set_chcr(sh_chan, cfg->chcr);
+		if (ret < 0)
+			goto END;
+
 	} else {
 		dmae_init(sh_chan);
 	}
+
+END:
+	return ret;
 }
 
 /*
diff --git a/include/linux/shdma-base.h b/include/linux/shdma-base.h
index 6dfd05ef5c2d9..03ba4dab2ef73 100644
--- a/include/linux/shdma-base.h
+++ b/include/linux/shdma-base.h
@@ -96,7 +96,7 @@ struct shdma_ops {
 	int (*desc_setup)(struct shdma_chan *, struct shdma_desc *,
 			  dma_addr_t, dma_addr_t, size_t *);
 	int (*set_slave)(struct shdma_chan *, int, dma_addr_t, bool);
-	void (*setup_xfer)(struct shdma_chan *, int);
+	int (*setup_xfer)(struct shdma_chan *, int);
 	void (*start_xfer)(struct shdma_chan *, struct shdma_desc *);
 	struct shdma_desc *(*embedded_desc)(void *, int);
 	bool (*chan_irq)(struct shdma_chan *, int);
-- 
2.51.0



