Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7179218C039;
	Tue, 10 Sep 2024 10:14:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963277; cv=none; b=D2UM27cuICxkJsUt/L4lDKPy5Il95YRG0JYfh2/xEJHyycrAjSiLFUdflUZVKisc9MdzAxCMEFIA1/U1UKCezhT2heVdCs+eVz8UPqXoXaHkvEnjhsq7gPjJ2TXOlJQDuxU9BehrC6xeBIlm0ihnu4eCJjMb7xlb62YLcGumltY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963277; c=relaxed/simple;
	bh=bc79nCXqHkCvo9ETFb5ijAuBU7njYyIBIz0ik7SbPyg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nUPpA4o4u5CmqN8oAujIhRwJi0C9pnwVQWeia8nF+f007awWw9/BKBOLReK497PWTwzchVNSQKwUp5we95FIFDuSzOQl8HG5Zv00csnzqw4N5z+Y3U8Pg6ApbYotGwVIkcQWPIBDq8HlV+repBrYPMor+W7qAOTt1mbuD91SwWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q3YqceD3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q3YqceD3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E184EC4CEC3;
	Tue, 10 Sep 2024 10:14:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963277;
	bh=bc79nCXqHkCvo9ETFb5ijAuBU7njYyIBIz0ik7SbPyg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q3YqceD3pQtVC+8FxJG2EodQh7Hdk0NRLSPuh0HuMIIutISGZ6UwB6OW0JCk3y9Ru
	 XTKiUejfnEi5csTCP2YjTWe5C2sDtlkpoFMnyOozHDbqdcyHEX5pLDGZvQmTiu+Dbh
	 Q27QAVVCNbff9MHsLHbN1ExzhPm9qdrBLahTCGxY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Stefan=20Alth=C3=B6fer?= <Stefan.Althoefer@janztec.com>,
	Thomas Kopp <thomas.kopp@microchip.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 169/192] can: mcp251xfd: mcp251xfd_handle_rxif_ring_uinc(): factor out in separate function
Date: Tue, 10 Sep 2024 11:33:13 +0200
Message-ID: <20240910092604.857627798@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092557.876094467@linuxfoundation.org>
References: <20240910092557.876094467@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Kleine-Budde <mkl@pengutronix.de>

[ Upstream commit d49184b7b585f9da7ee546b744525f62117019f6 ]

This is a preparation patch.

Sending the UINC messages followed by incrementing the tail pointer
will be called in more than one place in upcoming patches, so factor
this out into a separate function.

Also make mcp251xfd_handle_rxif_ring_uinc() safe to be called with a
"len" of 0.

Tested-by: Stefan Althöfer <Stefan.Althoefer@janztec.com>
Tested-by: Thomas Kopp <thomas.kopp@microchip.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/spi/mcp251xfd/mcp251xfd-rx.c | 48 +++++++++++++-------
 1 file changed, 32 insertions(+), 16 deletions(-)

diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd-rx.c b/drivers/net/can/spi/mcp251xfd/mcp251xfd-rx.c
index ced8d9c81f8c..5e2f39de88f3 100644
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-rx.c
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-rx.c
@@ -197,6 +197,37 @@ mcp251xfd_rx_obj_read(const struct mcp251xfd_priv *priv,
 	return err;
 }
 
+static int
+mcp251xfd_handle_rxif_ring_uinc(const struct mcp251xfd_priv *priv,
+				struct mcp251xfd_rx_ring *ring,
+				u8 len)
+{
+	int offset;
+	int err;
+
+	if (!len)
+		return 0;
+
+	/* Increment the RX FIFO tail pointer 'len' times in a
+	 * single SPI message.
+	 *
+	 * Note:
+	 * Calculate offset, so that the SPI transfer ends on
+	 * the last message of the uinc_xfer array, which has
+	 * "cs_change == 0", to properly deactivate the chip
+	 * select.
+	 */
+	offset = ARRAY_SIZE(ring->uinc_xfer) - len;
+	err = spi_sync_transfer(priv->spi,
+				ring->uinc_xfer + offset, len);
+	if (err)
+		return err;
+
+	ring->tail += len;
+
+	return 0;
+}
+
 static int
 mcp251xfd_handle_rxif_ring(struct mcp251xfd_priv *priv,
 			   struct mcp251xfd_rx_ring *ring)
@@ -210,8 +241,6 @@ mcp251xfd_handle_rxif_ring(struct mcp251xfd_priv *priv,
 		return err;
 
 	while ((len = mcp251xfd_get_rx_linear_len(ring))) {
-		int offset;
-
 		rx_tail = mcp251xfd_get_rx_tail(ring);
 
 		err = mcp251xfd_rx_obj_read(priv, ring, hw_rx_obj,
@@ -227,22 +256,9 @@ mcp251xfd_handle_rxif_ring(struct mcp251xfd_priv *priv,
 				return err;
 		}
 
-		/* Increment the RX FIFO tail pointer 'len' times in a
-		 * single SPI message.
-		 *
-		 * Note:
-		 * Calculate offset, so that the SPI transfer ends on
-		 * the last message of the uinc_xfer array, which has
-		 * "cs_change == 0", to properly deactivate the chip
-		 * select.
-		 */
-		offset = ARRAY_SIZE(ring->uinc_xfer) - len;
-		err = spi_sync_transfer(priv->spi,
-					ring->uinc_xfer + offset, len);
+		err = mcp251xfd_handle_rxif_ring_uinc(priv, ring, len);
 		if (err)
 			return err;
-
-		ring->tail += len;
 	}
 
 	return 0;
-- 
2.43.0



