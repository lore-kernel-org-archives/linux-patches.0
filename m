Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B8FB217F55;
	Thu, 12 Dec 2024 15:09:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016163; cv=none; b=AdfKSQMoEn0R90amDyloOFPrN6QlPa33FOfaRliGgyn3hCxVuTcz71fO/uOp2Uxq0qPUIJYCvq1J3XFLzOKi1/knEQY2ZVac5bJFg+7yMa4mYzjvFtNzmXyJGP5Gds/kjLKs6SYRpSlJaDULj2E1GJVy2lRSBIH5gKHrIIG4zYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016163; c=relaxed/simple;
	bh=aRwRw5hL4tOv6+/CrR9Vewqs/Uowp3R0H075TmX9KfQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ldKPfN2V2/hUtjToc8bnuQDqTTUZSTa7G42Svd30pX9iIyqY5/D7A1fch2EfiISOh3oMp8a8pcdODv3AVg9XM/jKlw8Hcyxduy83bhtpzhlKFI+2jtTgzhIMTfEcPut9GrktcG2Wp0QTkiQOAaN4UoREYUdJ4ggu/O7OXOlcHps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uvyhLhzM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uvyhLhzM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DE98C4CECE;
	Thu, 12 Dec 2024 15:09:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016163;
	bh=aRwRw5hL4tOv6+/CrR9Vewqs/Uowp3R0H075TmX9KfQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uvyhLhzMLwDgVLR9A0n9IkVD6uDEG/fp7DkS53XOcQ0te/Ze3iQm67StnCrQx2/RY
	 CEK4Ez9jx4moE/DiK2QOh1FU3l0+t1s7cLJ48Pyc6JGfYIGXzLzwH4ZxTzkz1bROAs
	 ZVyQecj5tdWPBYQ/trNuTOxZmeipJ4zXA4+LSc6g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Renjaya Raga Zenta <renjaya.zenta@formulatrix.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.12 130/466] can: mcp251xfd: mcp251xfd_get_tef_len(): work around erratum DS80000789E 6.
Date: Thu, 12 Dec 2024 15:54:59 +0100
Message-ID: <20241212144311.940148395@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Kleine-Budde <mkl@pengutronix.de>

commit 30447a1bc0e066e492552b3e5ffeb63c1605dfe2 upstream.

Commit b8e0ddd36ce9 ("can: mcp251xfd: tef: prepare to workaround
broken TEF FIFO tail index erratum") introduced
mcp251xfd_get_tef_len() to get the number of unhandled transmit events
from the Transmit Event FIFO (TEF).

As the TEF has no head index, the driver uses the TX-FIFO's tail index
instead, assuming that send frames are completed.

When calculating the number of unhandled TEF events, that commit
didn't take mcp2518fd erratum DS80000789E 6. into account. According
to that erratum, the FIFOCI bits of a FIFOSTA register, here the
TX-FIFO tail index might be corrupted.

However here it seems the bit indicating that the TX-FIFO is
empty (MCP251XFD_REG_FIFOSTA_TFERFFIF) is not correct while the
TX-FIFO tail index is.

Assume that the TX-FIFO is indeed empty if:
- Chip's head and tail index are equal (len == 0).
- The TX-FIFO is less than half full.
  (The TX-FIFO empty case has already been checked at the
   beginning of this function.)
- No free buffers in the TX ring.

If the TX-FIFO is assumed to be empty, assume that the TEF is full and
return the number of elements in the TX-FIFO (which equals the number
of TEF elements).

If these assumptions are false, the driver might read to many objects
from the TEF. mcp251xfd_handle_tefif_one() checks the sequence numbers
and will refuse to process old events.

Reported-by: Renjaya Raga Zenta <renjaya.zenta@formulatrix.com>
Closes: https://patch.msgid.link/CAJ7t6HgaeQ3a_OtfszezU=zB-FqiZXqrnATJ3UujNoQJJf7GgA@mail.gmail.com
Fixes: b8e0ddd36ce9 ("can: mcp251xfd: tef: prepare to workaround broken TEF FIFO tail index erratum")
Tested-by: Renjaya Raga Zenta <renjaya.zenta@formulatrix.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20241126-mcp251xfd-fix-length-calculation-v2-1-c2ed516ed6ba@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/spi/mcp251xfd/mcp251xfd-tef.c |   29 +++++++++++++++++++++++++-
 1 file changed, 28 insertions(+), 1 deletion(-)

--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-tef.c
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-tef.c
@@ -21,6 +21,11 @@ static inline bool mcp251xfd_tx_fifo_sta
 	return fifo_sta & MCP251XFD_REG_FIFOSTA_TFERFFIF;
 }
 
+static inline bool mcp251xfd_tx_fifo_sta_less_than_half_full(u32 fifo_sta)
+{
+	return fifo_sta & MCP251XFD_REG_FIFOSTA_TFHRFHIF;
+}
+
 static inline int
 mcp251xfd_tef_tail_get_from_chip(const struct mcp251xfd_priv *priv,
 				 u8 *tef_tail)
@@ -147,7 +152,29 @@ mcp251xfd_get_tef_len(struct mcp251xfd_p
 	BUILD_BUG_ON(sizeof(tx_ring->obj_num) != sizeof(len));
 
 	len = (chip_tx_tail << shift) - (tail << shift);
-	*len_p = len >> shift;
+	len >>= shift;
+
+	/* According to mcp2518fd erratum DS80000789E 6. the FIFOCI
+	 * bits of a FIFOSTA register, here the TX-FIFO tail index
+	 * might be corrupted.
+	 *
+	 * However here it seems the bit indicating that the TX-FIFO
+	 * is empty (MCP251XFD_REG_FIFOSTA_TFERFFIF) is not correct
+	 * while the TX-FIFO tail index is.
+	 *
+	 * We assume the TX-FIFO is empty, i.e. all pending CAN frames
+	 * haven been send, if:
+	 * - Chip's head and tail index are equal (len == 0).
+	 * - The TX-FIFO is less than half full.
+	 *   (The TX-FIFO empty case has already been checked at the
+	 *    beginning of this function.)
+	 * - No free buffers in the TX ring.
+	 */
+	if (len == 0 && mcp251xfd_tx_fifo_sta_less_than_half_full(fifo_sta) &&
+	    mcp251xfd_get_tx_free(tx_ring) == 0)
+		len = tx_ring->obj_num;
+
+	*len_p = len;
 
 	return 0;
 }


