Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE1F21E3DCF;
	Tue,  3 Dec 2024 16:14:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242473; cv=none; b=L22PxJtVO5nqq3M538LR+/eyA4tWmn7bZbykKqayilXQQg4AW06iBJxEPWZPYeF/kqjRo9HgoqEsUfcaki103rLnXHcJ78azMxJCf27b621R3fGagLQ+igoWkPsyhN+xvfs6XWtrNv8imHZTE7LtyrpEw6je/0OM3zOlfePP0vg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242473; c=relaxed/simple;
	bh=2Z514t5JWiyqkxp8ysje2g9aBw5vFJjvj3LzJj/B74E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q74Hr6AF5kOsQeFLSgLXyHd7uuTV86gm9HHzO4s1ifSVRiUqLdK7fyW/+vDtsgcMoRY2SmBFyncFyWmtUJx8jQ8eMjd8EVzOduND1A3mGk/qvO+Q2FQjlulsWOo7weBtTHemapUwn4Rgg5gX2Ul9TOtn4sg7K14Rw9KTJlxhFpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fMlC3ajC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fMlC3ajC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FAABC4CED6;
	Tue,  3 Dec 2024 16:14:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242472;
	bh=2Z514t5JWiyqkxp8ysje2g9aBw5vFJjvj3LzJj/B74E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fMlC3ajCZ+nEWs9mjmlAK8zMNYcdaSfaBsdp7Tcfnsgr2+RfsY+MIxH8nfCkivvLJ
	 JvitkXOREjpJJfKGAHqV2KgGDkPVDoCzGUhr4CJd3MN6OCQWChcHed8q5gHITDxOAJ
	 3ZwlduQsjQkTWrr5jmLj7TAQb4GY5meUTR59GhBg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bin Liu <b-liu@ti.com>,
	Judith Mendez <jm@ti.com>,
	Kevin Hilman <khilman@baylibre.com>
Subject: [PATCH 6.12 713/826] serial: 8250: omap: Move pm_runtime_get_sync
Date: Tue,  3 Dec 2024 15:47:20 +0100
Message-ID: <20241203144811.573062075@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -776,12 +776,12 @@ static void omap_8250_shutdown(struct ua
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


