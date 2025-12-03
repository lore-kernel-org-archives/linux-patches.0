Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 301BD34CFB0;
	Wed,  3 Dec 2025 16:02:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777730; cv=none; b=gfXEuN7PU3x7qANLw9h63Sjjv58NCCvlVJ8hOpcCGhORpMqG1OszGzI1hvoJsURSyrwMjHMdl1mvYlRuSax9SVKrms0Zo29tnwEzszCQMcJ/oJgHDfj9vaHH0Tp40+bP7ZxZtnjrK9Ntss0kFv+2iU2LTEZdmRTIONec5lm+0mg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777730; c=relaxed/simple;
	bh=ZfpzPc+MgR9vv61yIvSTTHZcznIxTKk/p5nLhDiMYZg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ki5rbc+udrkG71rSjNWIcOCQuifIyB+Uy8PqdSTOFuO2Ya/2YJLw95JImc/5+N3h9yG83iPJUvrI/HFyrUIHarOVNWNVZp9hUPNBSX5D8eXdvFsoQ69oI6GiqDNwnKYhzBW3Vt/xOCaJcwkZLbeG/K7YsA0pVbUQFvlvYp3sIaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IQeISoEx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IQeISoEx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAF3BC4CEF5;
	Wed,  3 Dec 2025 16:02:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777730;
	bh=ZfpzPc+MgR9vv61yIvSTTHZcznIxTKk/p5nLhDiMYZg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IQeISoExOAwRgvh9iHJRgooaVQPzse99X2yUNWzxvBelG9PkDeTOcxLGQr+f/LONa
	 xZ8lL+gYXyOPkgU+knpPC42hhRyqRJMDRT/jmFPX9jYdd0G1+23xqDg2HWAk8C993U
	 nKwQJZBl1Q6sSwWCj3+iAJwd15Ai2DspE0W47Bas=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Andreatta <thomas.andreatta2000@gmail.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 127/392] dmaengine: sh: setup_xref error handling
Date: Wed,  3 Dec 2025 16:24:37 +0100
Message-ID: <20251203152418.766591574@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 7f72b3f4cd1ae..e1b8808f2a984 100644
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



