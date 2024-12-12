Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA75D2236FC;
	Thu, 12 Dec 2024 16:16:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734020191; cv=none; b=K2wCESEaiQy7GCS1ScpoSJ410jcvYN+fl/FqH1KOll1EOj3dXWRRY8CSHVRcev0rTd4Nnru631ZWUGytAITij0IuaPlPirzsGgDCBeN8LnqZbzWkcQsdntabUzv57s8g0qklvzmi7JgCFbi/YxC2qp+swWElCLkKPfz/4qKW2/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734020191; c=relaxed/simple;
	bh=MdEdgCnwqW/NRT9XKR7pyi0lls/N26JC71kKjx1Z4n0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q9jtrFAKgIHTgtJmyc276L3L2lXUlkHaR1axIW3aKwvDKFF8Tk0va8a8KUoWV9UdL4Thfyll5Lck3wjke82YumJ8XG+VJMgMsx9BAvo+8hoTNbSpZJqljCCP3/OdWoxqICyJzprD6GQ5yoROwLppKWv5P0YnD5ne5ml7zEyonyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=thqkB8m4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="thqkB8m4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7942C4CECE;
	Thu, 12 Dec 2024 16:16:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734020191;
	bh=MdEdgCnwqW/NRT9XKR7pyi0lls/N26JC71kKjx1Z4n0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=thqkB8m41Wz5b/zF7LtxZXaL2/V8vEysfCnEoN02J9kPdfON1sHDeenC1lTkPYRda
	 +Vy5YGj48euIYj5g9EiD54YuUabcA/pHPJqVJINe+REoaua0BGNNrSvQ+bByM5+m3K
	 xmvkg3IAklKpyYGxapzu7AOyOjZuVZfZyX97ffBY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bin Liu <b-liu@ti.com>,
	Judith Mendez <jm@ti.com>,
	Kevin Hilman <khilman@baylibre.com>
Subject: [PATCH 6.1 402/772] serial: 8250: omap: Move pm_runtime_get_sync
Date: Thu, 12 Dec 2024 15:55:47 +0100
Message-ID: <20241212144406.531174683@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bin Liu <b-liu@ti.com>

commit bcc7ba668818dcadd2f1db66b39ed860a63ecf97 upstream.

Currently in omap_8250_shutdown, the dma->rx_running flag is
set to zero in omap_8250_rx_dma_flush. Next pm_runtime_get_sync
is called, which is a runtime resume call stack which can
re-set the flag. When the call omap_8250_shutdown returns, the
flag is expected to be UN-SET, but this is not the case. This
is causing issues the next time UART is re-opened and
omap_8250_rx_dma is called. Fix by moving pm_runtime_get_sync
before the omap_8250_rx_dma_flush.

cc: stable@vger.kernel.org
Fixes: 0e31c8d173ab ("tty: serial: 8250_omap: add custom DMA-RX callback")
Signed-off-by: Bin Liu <b-liu@ti.com>
[Judith: Add commit message]
Signed-off-by: Judith Mendez <jm@ti.com>
Reviewed-by: Kevin Hilman <khilman@baylibre.com>
Tested-by: Kevin Hilman <khilman@baylibre.com>
Link: https://lore.kernel.org/r/20241031172315.453750-1-jm@ti.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250_omap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/tty/serial/8250/8250_omap.c
+++ b/drivers/tty/serial/8250/8250_omap.c
@@ -749,12 +749,12 @@ static void omap_8250_shutdown(struct ua
 	struct uart_8250_port *up = up_to_u8250p(port);
 	struct omap8250_priv *priv = port->private_data;
 
+	pm_runtime_get_sync(port->dev);
+
 	flush_work(&priv->qos_work);
 	if (up->dma)
 		omap_8250_rx_dma_flush(up);
 
-	pm_runtime_get_sync(port->dev);
-
 	serial_out(up, UART_OMAP_WER, 0);
 	if (priv->habit & UART_HAS_EFR2)
 		serial_out(up, UART_OMAP_EFR2, 0x0);


