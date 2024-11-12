Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1163213EE9;
	Tue, 12 Nov 2024 10:35:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407741; cv=none; b=D3d83wtYWmijpFkHWJkLmW/pwI/ewJNi4mKtAjKBKQYyamhg75lbXBclL1u5KY7ohzYAFJv/TgGycSGbBlWPXF3tKnw/adAuBmL9z8HpbL1aRGufIVmsGhjd7sMbGlz+cF/ny8dHIrSS6B9WEWzJNwUmUFbT8oGOah+Kj9KbsIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407741; c=relaxed/simple;
	bh=rELOO1B+WkT3IP/xXvf6tirTUc4bqHX/8m140Jfpy/U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GBsk7MT0Q0HkH5ypOT3TPviO1RIsa2ctxDPJ8prFoUO/U8PbkKW35NABhClyiZGoCak8ju054IuvVSydrQIvoeUnrR7Juh7fsYe/n/IYla/5TgTQB62FlrcgeYpoP5tu8iI34rbaiVomBrawKTu7PvBPGK7xbaXUUMwXyxI5SOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Js3bmw8j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Js3bmw8j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21800C4CECD;
	Tue, 12 Nov 2024 10:35:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407741;
	bh=rELOO1B+WkT3IP/xXvf6tirTUc4bqHX/8m140Jfpy/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Js3bmw8j23kgNrscULpZO8fiBhVtoi1ha2LyeYgH5cX+sNpdgnGTTPTkDTPr2vPSL
	 u+30QPT8Bviw6DaLIJAyyYwN5WccUmmhI+7mXaZ+ds730MoPLsMU1nUx5isK654a+6
	 EJohA51Nj6W+/V1Nb9akrE+IyjclJRKKJ46rpjDo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Horman <horms@kernel.org>,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.6 069/119] can: mcp251xfd: mcp251xfd_ring_alloc(): fix coalescing configuration when switching CAN modes
Date: Tue, 12 Nov 2024 11:21:17 +0100
Message-ID: <20241112101851.351411528@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101848.708153352@linuxfoundation.org>
References: <20241112101848.708153352@linuxfoundation.org>
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

commit eb9a839b3d8a989be5970035a5cf29bcd6ffd24d upstream.

Since commit 50ea5449c563 ("can: mcp251xfd: fix ring configuration
when switching from CAN-CC to CAN-FD mode"), the current ring and
coalescing configuration is passed to can_ram_get_layout(). That fixed
the issue when switching between CAN-CC and CAN-FD mode with
configured ring (rx, tx) and/or coalescing parameters (rx-frames-irq,
tx-frames-irq).

However 50ea5449c563 ("can: mcp251xfd: fix ring configuration when
switching from CAN-CC to CAN-FD mode"), introduced a regression when
switching CAN modes with disabled coalescing configuration: Even if
the previous CAN mode has no coalescing configured, the new mode is
configured with active coalescing. This leads to delayed receiving of
CAN-FD frames.

This comes from the fact, that ethtool uses usecs = 0 and max_frames =
1 to disable coalescing, however the driver uses internally
priv->{rx,tx}_obj_num_coalesce_irq = 0 to indicate disabled
coalescing.

Fix the regression by assigning struct ethtool_coalesce
ec->{rx,tx}_max_coalesced_frames_irq = 1 if coalescing is disabled in
the driver as can_ram_get_layout() expects this.

Reported-by: https://github.com/vdh-robothania
Closes: https://github.com/raspberrypi/linux/issues/6407
Fixes: 50ea5449c563 ("can: mcp251xfd: fix ring configuration when switching from CAN-CC to CAN-FD mode")
Cc: stable@vger.kernel.org
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20241025-mcp251xfd-fix-coalesing-v1-1-9d11416de1df@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/spi/mcp251xfd/mcp251xfd-ring.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-ring.c
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-ring.c
@@ -2,7 +2,7 @@
 //
 // mcp251xfd - Microchip MCP251xFD Family CAN controller driver
 //
-// Copyright (c) 2019, 2020, 2021 Pengutronix,
+// Copyright (c) 2019, 2020, 2021, 2024 Pengutronix,
 //               Marc Kleine-Budde <kernel@pengutronix.de>
 //
 // Based on:
@@ -483,9 +483,11 @@ int mcp251xfd_ring_alloc(struct mcp251xf
 		};
 		const struct ethtool_coalesce ec = {
 			.rx_coalesce_usecs_irq = priv->rx_coalesce_usecs_irq,
-			.rx_max_coalesced_frames_irq = priv->rx_obj_num_coalesce_irq,
+			.rx_max_coalesced_frames_irq = priv->rx_obj_num_coalesce_irq == 0 ?
+				1 : priv->rx_obj_num_coalesce_irq,
 			.tx_coalesce_usecs_irq = priv->tx_coalesce_usecs_irq,
-			.tx_max_coalesced_frames_irq = priv->tx_obj_num_coalesce_irq,
+			.tx_max_coalesced_frames_irq = priv->tx_obj_num_coalesce_irq == 0 ?
+				1 : priv->tx_obj_num_coalesce_irq,
 		};
 		struct can_ram_layout layout;
 


