Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B29C1BD031;
	Tue, 12 Nov 2024 10:35:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407738; cv=none; b=GIIVwG2aI6moJge7AZqGzsMh1WoWARVSmAITMU8qVP8p9cu3svsE1slVFkjb24MT06Y1yVpy1kLLhd0aMqXbPy/cN5iuRXLKbjerOxEcw9avv465opzZNnsdE3IBpAyLtZUr8csbs3ur6kUAxRpuDYNTc5kiVPUZSV8owMcWnFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407738; c=relaxed/simple;
	bh=4by0597Gx6ocyiukH7gi1Yy/euNTQp8NdgEUYkvRhq4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TFXqeI6kUTYUYCCfs5kmAiYK0gsDdTKctvsspOTbvgeulSqG5L7aMJUltUfVPPmMJHEBzp6rWteAMh357cS+YQIA7MKGde9+bbxE+1xnx/6hSFvdA31Z7PS8//jJZc7e4G9G7+bv4FnFS4bNbhybBwxsQOfR+G8d4kswL4PC/2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VPGYmHQA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VPGYmHQA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28398C4CED4;
	Tue, 12 Nov 2024 10:35:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407738;
	bh=4by0597Gx6ocyiukH7gi1Yy/euNTQp8NdgEUYkvRhq4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VPGYmHQAppKV4t4qsbflO8cyP6T5aIU+LBn4j/8hMX6EM0GoJVJddPC8ey6QItH/Y
	 UU6B/YanAN79tnRkZHndDpXeTdJcUGSlyjLp1Ze72HoydAlLPT880cY32Kt7sVEmWO
	 YyQVEqcKjJI2Qtapf5HY4RpzIRMPxQIJNp5BwvXo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Schuchmann <schuchmann@schleissheimer.de>,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.6 068/119] can: mcp251xfd: mcp251xfd_get_tef_len(): fix length calculation
Date: Tue, 12 Nov 2024 11:21:16 +0100
Message-ID: <20241112101851.312693799@linuxfoundation.org>
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

commit 3c1c18551e6ac1b988d0a05c5650e3f6c95a1b8a upstream.

Commit b8e0ddd36ce9 ("can: mcp251xfd: tef: prepare to workaround
broken TEF FIFO tail index erratum") introduced
mcp251xfd_get_tef_len() to get the number of unhandled transmit events
from the Transmit Event FIFO (TEF).

As the TEF has no head pointer, the driver uses the TX FIFO's tail
pointer instead, assuming that send frames are completed. However the
check for the TEF being full was not correct. This leads to the driver
stop working if the TEF is full.

Fix the TEF full check by assuming that if, from the driver's point of
view, there are no free TX buffers in the chip and the TX FIFO is
empty, all messages must have been sent and the TEF must therefore be
full.

Reported-by: Sven Schuchmann <schuchmann@schleissheimer.de>
Closes: https://patch.msgid.link/FR3P281MB155216711EFF900AD9791B7ED9692@FR3P281MB1552.DEUP281.PROD.OUTLOOK.COM
Fixes: b8e0ddd36ce9 ("can: mcp251xfd: tef: prepare to workaround broken TEF FIFO tail index erratum")
Tested-by: Sven Schuchmann <schuchmann@schleissheimer.de>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20241104-mcp251xfd-fix-length-calculation-v3-1-608b6e7e2197@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/spi/mcp251xfd/mcp251xfd-tef.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-tef.c
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-tef.c
@@ -16,9 +16,9 @@
 
 #include "mcp251xfd.h"
 
-static inline bool mcp251xfd_tx_fifo_sta_full(u32 fifo_sta)
+static inline bool mcp251xfd_tx_fifo_sta_empty(u32 fifo_sta)
 {
-	return !(fifo_sta & MCP251XFD_REG_FIFOSTA_TFNRFNIF);
+	return fifo_sta & MCP251XFD_REG_FIFOSTA_TFERFFIF;
 }
 
 static inline int
@@ -122,7 +122,11 @@ mcp251xfd_get_tef_len(struct mcp251xfd_p
 	if (err)
 		return err;
 
-	if (mcp251xfd_tx_fifo_sta_full(fifo_sta)) {
+	/* If the chip says the TX-FIFO is empty, but there are no TX
+	 * buffers free in the ring, we assume all have been sent.
+	 */
+	if (mcp251xfd_tx_fifo_sta_empty(fifo_sta) &&
+	    mcp251xfd_get_tx_free(tx_ring) == 0) {
 		*len_p = tx_ring->obj_num;
 		return 0;
 	}


