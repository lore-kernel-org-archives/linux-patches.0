Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44766227E8A;
	Mon, 12 May 2025 17:57:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072640; cv=none; b=JZg/dGOJ/XFAVRzv31fht+6MzCfyvVa9YpwvUUzmMYMGE0r4l0OGyFeYHStfZOfvkg87xDEVqEYEvsBGZ/AxI+wz94MR7oZWTQFRt7rWKBJejS0T3sCnrNEnQ+FeCz0a0TkV5SSMmEg9vy1c1y4U9Y/ftPIc9Efc31jsL1U2nOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072640; c=relaxed/simple;
	bh=LY0KHrXqugcZKtXlUxXDn0z+Ws/PaA+texdsIfNzo7s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h39E4Us1LKWeM/RHVXtCkE+f0w7EbsCcO1R31tAcAZPNU0P9nEpz1++5Qme1fQqN6JgwoOuJJFkBcoIAv2T3j+kj0jZMAzlGNTyIrdqWoUadzmQBZaylsPyehpB8uEOIUPNa6kWNFa8HcieSdsdMEwGJ/td7hcclEH+NhFRORlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K7UOuciR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K7UOuciR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E5A0C4CEE7;
	Mon, 12 May 2025 17:57:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072639;
	bh=LY0KHrXqugcZKtXlUxXDn0z+Ws/PaA+texdsIfNzo7s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K7UOuciRZl1OX4vDEKzBJVES/oBKHpU4/GW2nnB4TKRq4gb98d1f/ayG408ER8zw3
	 /KFYXCa6PQrLBrMIKpQ91GqtL8GKJThU3y+Zv0agsgylRdWhV2llqMfEMJ4kYmG+tS
	 INDQbiLQFatlvAhlhwST3nzyg1We6A7HmiYxzQlI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.12 011/184] can: mcp251xfd: mcp251xfd_remove(): fix order of unregistration calls
Date: Mon, 12 May 2025 19:43:32 +0200
Message-ID: <20250512172042.118559306@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172041.624042835@linuxfoundation.org>
References: <20250512172041.624042835@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


