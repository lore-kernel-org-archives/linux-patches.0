Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CBB5212F1D;
	Tue, 12 Nov 2024 10:43:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731408186; cv=none; b=BWISV05VXzPy7GKKF1ysGTvnViqVJNWkYy0mzxQK/ofDTjcRoXx7vupdIe4lElrFGAatbVPsPJZqG7yxNKEK7AyPY8dcEZ/TttE9ZfaNPfgFjdJ6TQ6UvYSogQKqin91wY6jPNDZUCIE0D7z3dG6zD72mDmoWyOFlMWhv89RVe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731408186; c=relaxed/simple;
	bh=kQr1lr/VtQ0MwmXLass/7hHt5h/PTtsE/SsvqfTT/ks=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fzPa3/5hGL4iQ/5waQCLol9Ox6AYmP9pwqkus8w+3CQ1Aw4AulEK/UfjCRd5qCy2TBZjMZME1EKg7hwuZdJgc7J/ymiVSjN79Dcx0JUJvsEzlog8H6XpyROfYEMUm/q33z0BGzKrKBRWlNz+M8NHHCaDPlAb+aEHdBdv8F1av+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IUqyNpL5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IUqyNpL5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C37C7C4CECD;
	Tue, 12 Nov 2024 10:43:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731408186;
	bh=kQr1lr/VtQ0MwmXLass/7hHt5h/PTtsE/SsvqfTT/ks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IUqyNpL5jJgeHZ7Qlv/eY+K61+Tm3FQaVkyOeqelazQthtEKeWSI2cJdHkjzKXE4c
	 Ubgph7LVkmO30eMircYQVhovj7HjbFMDEth7d0v85JrzlOqD1hni7Zw4i/zo9DXNCB
	 Eb7B5vKuXm+sdWBYam28N/Sfod4reBgZNwSrnEwQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Schuchmann <schuchmann@schleissheimer.de>,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.11 086/184] can: mcp251xfd: mcp251xfd_get_tef_len(): fix length calculation
Date: Tue, 12 Nov 2024 11:20:44 +0100
Message-ID: <20241112101904.160288657@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101900.865487674@linuxfoundation.org>
References: <20241112101900.865487674@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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


