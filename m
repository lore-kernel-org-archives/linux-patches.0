Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86FB6296FC6;
	Mon, 12 May 2025 18:07:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073253; cv=none; b=JBfjyt0EiGjaGss+MzNyaO+XI8buD2SCt3EmgjJBuzfDyp2dPJF2akMGD3XafWdJSOw1t7o1lbCEKgi22HGW5Fhs9Wu3Tpp7mIVv8Z4kJ3FZGQCpvDt2CfxTKKM5y2AP1deIZAhlySM2M3x1trGA9ApX4xhVfBnWAKHyH/w/40c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073253; c=relaxed/simple;
	bh=8OTIPI/tMwZ7hJ0zz0UT+DqhVQ7GI38c6uDVmlxl34g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GyQEalVV4tcKDf0sUASAUmAntC4XN0GidfUO5knZN6kJqfJfzjiw8MZ0sa0l1sKwvZAILE7iwx6rPv1XlXdU0uRNanHgdO4eRu66vsGm0ZApCkxa0sCJHVPMUQLaoWwLxMmfhThdPQNHz8I/C0EqM0NjxksMc7iorY4dL3fMvJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WeE1UZc1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WeE1UZc1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A0A5C4CEE7;
	Mon, 12 May 2025 18:07:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747073253;
	bh=8OTIPI/tMwZ7hJ0zz0UT+DqhVQ7GI38c6uDVmlxl34g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WeE1UZc1icBzk3jI6df1JwxOrSG58JvevzDeGM0z0Xme7hrF4IJephr3B/fjH0fzt
	 GEAo2G1Mg7TKwyWbc78P2VidDLn9HYYW5VhYuF8UklzieUFbEzpXY/akQUOAtyxo2t
	 mDOHxq73tDoIclz06S3lodzniI7Q5JgojlmIKVCs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.6 005/113] can: mcp251xfd: mcp251xfd_remove(): fix order of unregistration calls
Date: Mon, 12 May 2025 19:44:54 +0200
Message-ID: <20250512172027.920657945@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172027.691520737@linuxfoundation.org>
References: <20250512172027.691520737@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2179,8 +2179,8 @@ static void mcp251xfd_remove(struct spi_
 	struct mcp251xfd_priv *priv = spi_get_drvdata(spi);
 	struct net_device *ndev = priv->ndev;
 
-	can_rx_offload_del(&priv->offload);
 	mcp251xfd_unregister(priv);
+	can_rx_offload_del(&priv->offload);
 	spi->max_speed_hz = priv->spi_max_speed_hz_orig;
 	free_candev(ndev);
 }


