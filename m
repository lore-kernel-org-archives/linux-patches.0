Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 278D52E1C7C;
	Tue, 31 Mar 2026 17:06:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976797; cv=none; b=hFqaY4C1Nz0wJhI4jF2C8UQJa727EI8ArBVnDDu+RFf/omUfx1N/0g+lP9vVNyHBseqLTMQTaGv0vjO3EkAnf/flMgaVcBxyBGDKGAWCjYfrXDd0VKu79euqzbQRdFmyNi+2Ltpjj5XUzO7E99Z3ygLTjJayI92XahI/EDP+DEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976797; c=relaxed/simple;
	bh=AT85XFNHDI/PG6MIS18LTgLXh8/ZLgEb60rVuP+7Joc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=crTrh50OAuo5a5GjxurDZAwQBhwIAjsJuHbyNrjptc5DYEUv1s6Vw6F8ll/MHd5H4Ok/jAx7bPflSL5Yb7C7QDEVeqRyCglCmV2TsFT1/41Hcnm3pOGxfCx7AfaYtRkaFUvgpUdqgMbQwFAL3wQRfZ1r1nool1gM1QOpy1ZXxlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W3HiHGAO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W3HiHGAO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF78EC19423;
	Tue, 31 Mar 2026 17:06:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976797;
	bh=AT85XFNHDI/PG6MIS18LTgLXh8/ZLgEb60rVuP+7Joc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W3HiHGAO7OGDaLNMAHbmtEbMTOaOYImcz95JrKU9zygS8h2nh5fZlOIjjUsC2jEzY
	 QSeXmlURKMk9AWASidnBxJtRX3+xP4V1dDZICIOW+dUUu53hRu4Y7sQ0Y721w8vJ9D
	 q6a03xl6wtwJrzG4R9snLo+liMN3WEM7/7yTb+Ec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joy Zou <joy.zou@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.18 230/309] dmaengine: fsl-edma: fix channel parameter config for fixed channel requests
Date: Tue, 31 Mar 2026 18:22:13 +0200
Message-ID: <20260331161802.048212812@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joy Zou <joy.zou@nxp.com>

commit 2e7b5cf72e51c9cf9c8b75190189c757df31ddd9 upstream.

Configure only the requested channel when a fixed channel is specified
to avoid modifying other channels unintentionally.

Fix parameter configuration when a fixed DMA channel is requested on
i.MX9 AON domain and i.MX8QM/QXP/DXL platforms. When a client requests
a fixed channel (e.g., channel 6), the driver traverses channels 0-5
and may unintentionally modify their configuration if they are unused.

This leads to issues such as setting the `is_multi_fifo` flag unexpectedly,
causing memcpy tests to fail when using the dmatest tool.

Only affect edma memcpy test when the channel is fixed.

Fixes: 72f5801a4e2b ("dmaengine: fsl-edma: integrate v3 support")
Signed-off-by: Joy Zou <joy.zou@nxp.com>
Cc: stable@vger.kernel.org
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20250917-b4-edma-chanconf-v1-1-886486e02e91@nxp.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/fsl-edma-main.c |   26 +++++++++++---------------
 1 file changed, 11 insertions(+), 15 deletions(-)

--- a/drivers/dma/fsl-edma-main.c
+++ b/drivers/dma/fsl-edma-main.c
@@ -317,10 +317,8 @@ static struct dma_chan *fsl_edma3_xlate(
 			return NULL;
 		i = fsl_chan - fsl_edma->chans;
 
-		fsl_chan->priority = dma_spec->args[1];
-		fsl_chan->is_rxchan = dma_spec->args[2] & FSL_EDMA_RX;
-		fsl_chan->is_remote = dma_spec->args[2] & FSL_EDMA_REMOTE;
-		fsl_chan->is_multi_fifo = dma_spec->args[2] & FSL_EDMA_MULTI_FIFO;
+		if (!b_chmux && i != dma_spec->args[0])
+			continue;
 
 		if ((dma_spec->args[2] & FSL_EDMA_EVEN_CH) && (i & 0x1))
 			continue;
@@ -328,17 +326,15 @@ static struct dma_chan *fsl_edma3_xlate(
 		if ((dma_spec->args[2] & FSL_EDMA_ODD_CH) && !(i & 0x1))
 			continue;
 
-		if (!b_chmux && i == dma_spec->args[0]) {
-			chan = dma_get_slave_channel(chan);
-			chan->device->privatecnt++;
-			return chan;
-		} else if (b_chmux && !fsl_chan->srcid) {
-			/* if controller support channel mux, choose a free channel */
-			chan = dma_get_slave_channel(chan);
-			chan->device->privatecnt++;
-			fsl_chan->srcid = dma_spec->args[0];
-			return chan;
-		}
+		fsl_chan->srcid = dma_spec->args[0];
+		fsl_chan->priority = dma_spec->args[1];
+		fsl_chan->is_rxchan = dma_spec->args[2] & FSL_EDMA_RX;
+		fsl_chan->is_remote = dma_spec->args[2] & FSL_EDMA_REMOTE;
+		fsl_chan->is_multi_fifo = dma_spec->args[2] & FSL_EDMA_MULTI_FIFO;
+
+		chan = dma_get_slave_channel(chan);
+		chan->device->privatecnt++;
+		return chan;
 	}
 	return NULL;
 }


