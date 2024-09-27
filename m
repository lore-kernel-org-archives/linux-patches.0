Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20D351779BD;
	Fri, 27 Sep 2024 12:25:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727439914; cv=none; b=iAgiB4YBsm2wTUdAOIufWc4N1pqMpsSPmYBsTaLFo/y6oHQmYGA6gtVueT8zbIUeovfmVsEyqOd4+7R2kOYblWSu9fzUpvF2uNZFxBGTrmXyysYPDv71HVtByLigI72+cuoS33jlOyZoSo3XA3KMJ3isRgcWHxry9udIvBGbR3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727439914; c=relaxed/simple;
	bh=/gBgbdRTBQ/5bb3v1rQAZqdyWaQY7dHZyZyD0fasySw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eskfcftE95mLVE8WFdbq3Gsj5vdIvstomBu0UCedGLqaFKNSXLEHOCR6ZWqklJT4lWpypbgE7gcsq29HwKP7x0Oa9CbKwdIarCN3KJwnyK/XKPHCCKqt+cQbkol1BvsvIbOswLubwM41ai1xD49qdcv9dPVylKOiSxO83aumO58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HOHnTLIx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HOHnTLIx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1E22C4CEC4;
	Fri, 27 Sep 2024 12:25:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727439914;
	bh=/gBgbdRTBQ/5bb3v1rQAZqdyWaQY7dHZyZyD0fasySw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HOHnTLIxhyPWXE8VfNMx3tq/wqraD1UH8jXkOh478WSykNee2ut4PelsHp+90m+qw
	 so3/58BddShc+wNCmff9Lf07nfdgXk3qz4BuoCVkaSLAB2xmuT2Rhk1YKoyT4bb6oX
	 UrPQa/gwBxxVdE/ujB0fZr1p0Rhmku16wiK6SmrU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 21/54] can: mcp251xfd: mcp251xfd_ring_init(): check TX-coalescing configuration
Date: Fri, 27 Sep 2024 14:23:13 +0200
Message-ID: <20240927121720.560091673@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20240927121719.714627278@linuxfoundation.org>
References: <20240927121719.714627278@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Kleine-Budde <mkl@pengutronix.de>

[ Upstream commit ac2b81eb8b2d104033560daea886ee84531e3d0a ]

When changing the interface from CAN-CC to CAN-FD mode the old
coalescing parameters are re-used. This might cause problem, as the
configured parameters are too big for CAN-FD mode.

During testing an invalid TX coalescing configuration has been seen.
The problem should be been fixed in the previous patch, but add a
safeguard here to ensure that the number of TEF coalescing buffers (if
configured) is exactly the half of all TEF buffers.

Link: https://lore.kernel.org/all/20240805-mcp251xfd-fix-ringconfig-v1-2-72086f0ca5ee@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/spi/mcp251xfd/mcp251xfd-ring.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd-ring.c b/drivers/net/can/spi/mcp251xfd/mcp251xfd-ring.c
index f72582d4d3e8e..83c18035b2a24 100644
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-ring.c
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-ring.c
@@ -290,7 +290,7 @@ int mcp251xfd_ring_init(struct mcp251xfd_priv *priv)
 	const struct mcp251xfd_rx_ring *rx_ring;
 	u16 base = 0, ram_used;
 	u8 fifo_nr = 1;
-	int i;
+	int err = 0, i;
 
 	netdev_reset_queue(priv->ndev);
 
@@ -386,10 +386,18 @@ int mcp251xfd_ring_init(struct mcp251xfd_priv *priv)
 		netdev_err(priv->ndev,
 			   "Error during ring configuration, using more RAM (%u bytes) than available (%u bytes).\n",
 			   ram_used, MCP251XFD_RAM_SIZE);
-		return -ENOMEM;
+		err = -ENOMEM;
 	}
 
-	return 0;
+	if (priv->tx_obj_num_coalesce_irq &&
+	    priv->tx_obj_num_coalesce_irq * 2 != priv->tx->obj_num) {
+		netdev_err(priv->ndev,
+			   "Error during ring configuration, number of TEF coalescing buffers (%u) must be half of TEF buffers (%u).\n",
+			   priv->tx_obj_num_coalesce_irq, priv->tx->obj_num);
+		err = -EINVAL;
+	}
+
+	return err;
 }
 
 void mcp251xfd_ring_free(struct mcp251xfd_priv *priv)
-- 
2.43.0



