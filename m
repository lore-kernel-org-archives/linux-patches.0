Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB60B22332E;
	Thu, 12 Dec 2024 17:43:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025417; cv=none; b=pw+gS/un/sgoeJ076RiMbiLi0MthP5ATYfZhWFeCQBM0ud7yUpCCE9k1FHhJH+3MunKwhAijXBsZXcYH1/qKbZAT4s5xINhuEFqp7MISMNcZdrj1px5cdZXjK9AHovDAXW5I4sDdLeVYDB7YY8g2GttbaR0sbvXC+WsHm5JrBKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025417; c=relaxed/simple;
	bh=YCP3ytjAIG9Vjksd+mQd6Br4jRtxsjKBwpxfjSHG398=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lCtBhf9REEoLzAVaNr9inK7oMGn/Rg4Zsw2LDJBvDBLr47yNQGnWACXAe8xd47aTMD03PtUzQez4UCFODDw+y5ZQg6ovSxd7BBbCqle8ANXG3ZxUsv9wpkysdMsN5pECHpEyDr6FEjDYIRlp3fBLWefzAxYV6arvLwsIgfMyMpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GTFh5HZT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GTFh5HZT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FC35C4CECE;
	Thu, 12 Dec 2024 17:43:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734025416;
	bh=YCP3ytjAIG9Vjksd+mQd6Br4jRtxsjKBwpxfjSHG398=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GTFh5HZTzKoVKwlv0dEckhwIUq/VLWQ7o6vsHJH/FGZHDvS1pJP9hAPg5zmdKNKj7
	 JtOKs9xL+6pEhriIxEVfH0L3UWR+FHPa+dbUZJsXa8yj5dVRbDkI1ZyGxbtZlBYej3
	 JK1dLG8NoUyDZzD8JS+dCBGMHfeEO7HMsT/4tT9Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bin Liu <b-liu@ti.com>,
	Judith Mendez <jm@ti.com>,
	Kevin Hilman <khilman@baylibre.com>
Subject: [PATCH 5.4 162/321] serial: 8250: omap: Move pm_runtime_get_sync
Date: Thu, 12 Dec 2024 16:01:20 +0100
Message-ID: <20241212144236.380998792@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
References: <20241212144229.291682835@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -652,12 +652,12 @@ static void omap_8250_shutdown(struct ua
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
 
 	up->ier = 0;


