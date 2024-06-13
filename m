Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A356143887;
	Thu, 13 Jun 2024 11:41:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718278897; cv=none; b=YGQrh9wpI/QnHxpym3Epv4jt6hpNdkQT3dZ1aH+jw2+rjP+r9Wh3L0B63Z2k8dv0MS/pxqndL8rRXPFW3YiwFT+VVedQtfz5zqyM5W9DV9nwKrTXRuz+n0EqwkXofopNtUFzCsPaI5Zkubi74nBqWxK14SY8jRE/u/46b6WNtRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718278897; c=relaxed/simple;
	bh=9J7ZqDvtG+PkSLYvPpAjt9S2cjqWvOmYy9SJjWlO1N4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cyyQFeQPsAafK+bpGovKTdTe+YDSl9o7UZ1z1QMSwN+fx7hPHdLR3NePGjtJ4pM3dULfn9e+ItBBROwZKT8Mwf21IFysuoWByCGngxdGx1/VvHBipE+dWT8Mj3PO5yX/Avpr4+VUbzJHV8QaYsOLGwoi+ZaWqyNAsfi8WsxUKd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vqFI/Bcn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vqFI/Bcn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 819E9C2BBFC;
	Thu, 13 Jun 2024 11:41:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718278896;
	bh=9J7ZqDvtG+PkSLYvPpAjt9S2cjqWvOmYy9SJjWlO1N4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vqFI/BcnVQ3Re/orAP5BMtaEdvye05WsxLhvbj5MgsrUFn08Vo9d74o5/r/rrZ+Ha
	 VYAhvgiqE9WG6b3LsPWq4V86fdLy0cTUCN79fOm1CbOjTy/TafxyBIBWnhGxjVNPtG
	 lWNBpsM0R30S1EOv8bxdBy/nSoNykqii+FeNJqDI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Simon Horman <horms+renesas@verge.net.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 106/213] serial: sh-sci: Extract sci_dma_rx_chan_invalidate()
Date: Thu, 13 Jun 2024 13:32:34 +0200
Message-ID: <20240613113232.092193210@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.969123070@linuxfoundation.org>
References: <20240613113227.969123070@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 11b3770d54b28dcd905155a6d4aa551187ff00eb ]

The cookies and channel pointer for the DMA receive channel are
invalidated in two places, and one more is planned.
Extract this functionality in a common helper.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Simon Horman <horms+renesas@verge.net.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: aae20f6e34cd ("serial: sh-sci: protect invalidating RXDMA on shutdown")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/sh-sci.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/tty/serial/sh-sci.c b/drivers/tty/serial/sh-sci.c
index dfe9ac3b95af2..8a7592cd1aff9 100644
--- a/drivers/tty/serial/sh-sci.c
+++ b/drivers/tty/serial/sh-sci.c
@@ -1248,12 +1248,22 @@ static int sci_dma_rx_find_active(struct sci_port *s)
 	return -1;
 }
 
+static void sci_dma_rx_chan_invalidate(struct sci_port *s)
+{
+	unsigned int i;
+
+	s->chan_rx = NULL;
+	for (i = 0; i < ARRAY_SIZE(s->cookie_rx); i++)
+		s->cookie_rx[i] = -EINVAL;
+	s->active_rx = 0;
+}
+
 static void sci_rx_dma_release(struct sci_port *s)
 {
 	struct dma_chan *chan = s->chan_rx_saved;
 
-	s->chan_rx_saved = s->chan_rx = NULL;
-	s->cookie_rx[0] = s->cookie_rx[1] = -EINVAL;
+	s->chan_rx_saved = NULL;
+	sci_dma_rx_chan_invalidate(s);
 	dmaengine_terminate_sync(chan);
 	dma_free_coherent(chan->device->dev, s->buf_len_rx * 2, s->rx_buf[0],
 			  sg_dma_address(&s->sg_rx[0]));
@@ -1372,10 +1382,7 @@ static int sci_submit_rx(struct sci_port *s, bool port_lock_held)
 		spin_lock_irqsave(&port->lock, flags);
 	if (i)
 		dmaengine_terminate_async(chan);
-	for (i = 0; i < 2; i++)
-		s->cookie_rx[i] = -EINVAL;
-	s->active_rx = 0;
-	s->chan_rx = NULL;
+	sci_dma_rx_chan_invalidate(s);
 	sci_start_rx(port);
 	if (!port_lock_held)
 		spin_unlock_irqrestore(&port->lock, flags);
-- 
2.43.0



