Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06D8778F52;
	Mon, 12 May 2025 17:30:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747071048; cv=none; b=B3yCoZr3GTl/FPr/v2nnGXo7i9g6ovr10EGNPamE0pz84C4JepuUlcOCeqGRtzMSa6muEKzYX76puOq4LSTBTeODFEhNqwDERgX22S30Bf4dGwx61dUZu8vKJSRkRI9OuTDVl3Zx9Du5443dG6gt1UD1YQ//jg4LJq6kRSW+aBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747071048; c=relaxed/simple;
	bh=FMOz7LuvCoGW/ruubHOTbdr/4U+Le4ppFD+vdwXDKWc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jUtTwTBNbLZAoppxfim9icmjbWa9YrrJfBT3jLYArd9/koOonQ8+B0zJ4U9Ly5WFteJkmtFqUOaIrMpKlOJsP6dLNV1gW+PobwWQ9taEIjm4jXyF4SbrpRIxguSeWJ86Y6b6um+5D2SKwuZfSB7fuuid7oDdMDpPis0QTVDoFc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zhnq0hek; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zhnq0hek"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CC93C4CEE9;
	Mon, 12 May 2025 17:30:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747071047;
	bh=FMOz7LuvCoGW/ruubHOTbdr/4U+Le4ppFD+vdwXDKWc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zhnq0hekJ7JLx63ouR3knbCk7AKdkw+rwU/4NrtSmAneAjdtMVWX8RUht2iGnd6rc
	 iRUmyC7nG7wr8QbkZ6+SspzSUfsJef9Iw1g/Z6P5lg5ZEXPGMTx2lWle0Yse3RgMus
	 e2cIPWs/X5ZHLX8MePZJBghtlid82xzp+lFbqnlE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.15 02/54] can: mcp251xfd: mcp251xfd_remove(): fix order of unregistration calls
Date: Mon, 12 May 2025 19:29:14 +0200
Message-ID: <20250512172015.744220496@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172015.643809034@linuxfoundation.org>
References: <20250512172015.643809034@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Marc Kleine-Budde <mkl@pengutronix.de>

commit 84f5eb833f53ae192baed4cfb8d9eaab43481fc9 upstream.

If a driver is removed, the driver framework invokes the driver's
remove callback. A CAN driver's remove function calls
unregister_candev(), which calls net_device_ops::ndo_stop further down
in the call stack for interfaces which are in the "up" state.

With the mcp251xfd driver the removal of the module causes the
following warning:

| WARNING: CPU: 0 PID: 352 at net/core/dev.c:7342 __netif_napi_del_locked+0xc8/0xd8

as can_rx_offload_del() deletes the NAPI, while it is still active,
because the interface is still up.

To fix the warning, first unregister the network interface, which
calls net_device_ops::ndo_stop, which disables the NAPI, and then call
can_rx_offload_del().

Fixes: 55e5b97f003e ("can: mcp25xxfd: add driver for Microchip MCP25xxFD SPI CAN")
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20250502-can-rx-offload-del-v1-1-59a9b131589d@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
@@ -3020,8 +3020,8 @@ static int mcp251xfd_remove(struct spi_d
 	struct mcp251xfd_priv *priv = spi_get_drvdata(spi);
 	struct net_device *ndev = priv->ndev;
 
-	can_rx_offload_del(&priv->offload);
 	mcp251xfd_unregister(priv);
+	can_rx_offload_del(&priv->offload);
 	spi->max_speed_hz = priv->spi_max_speed_hz_orig;
 	free_candev(ndev);
 


