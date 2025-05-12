Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EDA62580C9;
	Mon, 12 May 2025 17:42:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747071738; cv=none; b=BQHWz493TlmmJYOJfFnczcKmczPs6WMacmdnOU1kSCI6oUU2F/FIXicUvqo9bQho30n/b/9TtLFzv/klglq747fPle8l2JmKI25iN+6VKhvWWtYC5TybsWNgkpVKaYbD3Jn63Z5olPU7xFpJSotjw7k0pGb4hyAWWaqrTWiIOCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747071738; c=relaxed/simple;
	bh=jxe/5PE0sxmbH9HfMGCM8dqORNEW8kve5SetatnQwbU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tyyg3C/K/31waNvbGpidRPoSqxaDF1EWTkIa5ExHEA8p0MArfCpbiYGXuWzCBipoO5QJgF0Q6b5pJEUM1Yo64N6YMMikSULkadms20+VJ0wSUciKK7dWnnIINEWVgOPp36/001bUhqks4BqwsMM3JoKPP3lGxHlkqM6YuEpOWjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a6VJvayM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a6VJvayM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D0B8C4CEE7;
	Mon, 12 May 2025 17:42:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747071737;
	bh=jxe/5PE0sxmbH9HfMGCM8dqORNEW8kve5SetatnQwbU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a6VJvayM1zGJf4zuZWZF8beeQqampDrElTUHSu5q3HIIjtL6LP8T3upI62+EHIXUV
	 jeg050vK9KezF3cABL3QvzjxKSZNPHJvV8SETe4fm7qzIocUheVwDVEpV+YMtqVVYz
	 SIWGrm/UGFmBh6Ak0rvISMl9uBkELJFtPeKRhP3A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.14 011/197] can: mcp251xfd: mcp251xfd_remove(): fix order of unregistration calls
Date: Mon, 12 May 2025 19:37:41 +0200
Message-ID: <20250512172044.805237587@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172044.326436266@linuxfoundation.org>
References: <20250512172044.326436266@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2174,8 +2174,8 @@ static void mcp251xfd_remove(struct spi_
 	struct mcp251xfd_priv *priv = spi_get_drvdata(spi);
 	struct net_device *ndev = priv->ndev;
 
-	can_rx_offload_del(&priv->offload);
 	mcp251xfd_unregister(priv);
+	can_rx_offload_del(&priv->offload);
 	spi->max_speed_hz = priv->spi_max_speed_hz_orig;
 	free_candev(ndev);
 }


