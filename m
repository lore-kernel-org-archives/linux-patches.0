Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFBDC172BAE;
	Tue, 10 Sep 2024 09:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962175; cv=none; b=bOvvmTYQ6H+fz0Jpm4e8zjpz4AqC2syAEz2s02J7eod1bFVazTUGMY6YI6Y2+jKQX0sbLLejrDjsBjqowoMC8nnRMyAfN9ZvZt8jy29sFm7WCdp21TEVVluQDQEGYgVM0HohKEZnZ7jblWbdugDzH/fNGmbfUKHvOX9Sbz+AqNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962175; c=relaxed/simple;
	bh=3aGLPJnIlHcd+F7S2nCnS2SFyNM866lA79Tp6iSK2jE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=D2xZiia7n5TTcIghoEbmY2zCbp8PABjO8vLlroM1LEyA1odJzksqt1FMS4pJC6P7Bwce5d9NK20it8bGJq6bVFAi0/Z/mdJw5utqg8GZxJR1rXu4L0Ok1sEAtMk4ndr8Q53VvR1mKXoNZFbHC+P2f2mSlR659YpkeeQvvEjiyZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yo2nD1Aj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yo2nD1Aj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59C9DC4CEC3;
	Tue, 10 Sep 2024 09:56:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962175;
	bh=3aGLPJnIlHcd+F7S2nCnS2SFyNM866lA79Tp6iSK2jE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yo2nD1Aj0Ebb4WfXhh/GEGjqXUts3SWVndmlXTIAsxK0V9lVT2olF5DHTuQQQbUgi
	 WW6ccC5F45EzMJsMwNufgtbtbKBdLSSOoOZfRdu/axwjUjFvMnrtlz6jww//S5JQks
	 H1J4VSBu9HeeU0uxXnimb45Zd9qQeQkR3fgdReAo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Stefan=20Alth=C3=B6fer?= <Stefan.Althoefer@janztec.com>,
	Thomas Kopp <thomas.kopp@microchip.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 321/375] can: mcp251xfd: mcp251xfd_handle_rxif_ring_uinc(): factor out in separate function
Date: Tue, 10 Sep 2024 11:31:58 +0200
Message-ID: <20240910092633.348662836@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
Stable-dep-of: 85505e585637 ("can: mcp251xfd: rx: prepare to workaround broken RX FIFO head index erratum")
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



