Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABEB519C553;
	Wed,  3 Dec 2025 15:47:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776860; cv=none; b=FeHQfSR3fmWv4fF55AAsDpn2El8kMrAqppz+s34uigiKEwJzWEZIz8TdRPFDuUw/t4ljFCC4jN9AmWvFataceiSALQIC+fZyky4Ga5fxLq1+KUl9NPvXVf0i8qptIe+F9MqkujR/Xx+Kog23Yh/NoGQ5Pu4f9dNa+rHPkuhHL+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776860; c=relaxed/simple;
	bh=CvspgXB0UbGKqcX/59E56fSA1J/LHhSpaYqAvYBbOl0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JB5Qcf9b0k30NOFNuSvsppmE5hCo/PI0A1MQLJnodAQRv79dBGj+1DM6ihcxzufQJ65iUdoyvni+Guki2eHm4VYVtMa4VHBqpxLncA8bWxuSW0X3+NWgRBG2AstcN3eBkl8/MIADxlXVg5n4rWe/d9DcwvS0YT0NqcHAZoB9jCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qn2Q3Zh0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qn2Q3Zh0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0707AC4CEF5;
	Wed,  3 Dec 2025 15:47:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776860;
	bh=CvspgXB0UbGKqcX/59E56fSA1J/LHhSpaYqAvYBbOl0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qn2Q3Zh0pEgLr5OnZ8XrrNOHZnlkkYHLLg5fnp3/u7TONTxFhRa7rDLnVZMyegTdt
	 a7KxN/eJP5PEwxyZrqOODJKnyTl5IvVspH4K80xT2b6pAcmiJ4Ng7RBcymxG2rjdkL
	 cNHz7dyJ16Jxp1MPD2kmNWtayE68DaTdJT9Reqo0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Seungjin Bae <eeodqql09@gmail.com>,
	Jimmy Assarsson <extja@kvaser.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 001/146] can: kvaser_usb: leaf: Fix potential infinite loop in command parsers
Date: Wed,  3 Dec 2025 16:26:19 +0100
Message-ID: <20251203152346.513843262@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152346.456176474@linuxfoundation.org>
References: <20251203152346.456176474@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Seungjin Bae <eeodqql09@gmail.com>

[ Upstream commit 0c73772cd2b8cc108d5f5334de89ad648d89b9ec ]

The `kvaser_usb_leaf_wait_cmd()` and `kvaser_usb_leaf_read_bulk_callback`
functions contain logic to zero-length commands. These commands are used
to align data to the USB endpoint's wMaxPacketSize boundary.

The driver attempts to skip these placeholders by aligning the buffer
position `pos` to the next packet boundary using `round_up()` function.

However, if zero-length command is found exactly on a packet boundary
(i.e., `pos` is a multiple of wMaxPacketSize, including 0), `round_up`
function will return the unchanged value of `pos`. This prevents `pos`
to be increased, causing an infinite loop in the parsing logic.

This patch fixes this in the function by using `pos + 1` instead.
This ensures that even if `pos` is on a boundary, the calculation is
based on `pos + 1`, forcing `round_up()` to always return the next
aligned boundary.

Fixes: 7259124eac7d ("can: kvaser_usb: Split driver into kvaser_usb_core.c and kvaser_usb_leaf.c")
Signed-off-by: Seungjin Bae <eeodqql09@gmail.com>
Reviewed-by: Jimmy Assarsson <extja@kvaser.com>
Tested-by: Jimmy Assarsson <extja@kvaser.com>
Link: https://patch.msgid.link/20251023162709.348240-1-eeodqql09@gmail.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c b/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
index c29828a94ad0e..1167d38344f1d 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
@@ -685,7 +685,7 @@ static int kvaser_usb_leaf_wait_cmd(const struct kvaser_usb *dev, u8 id,
 			 * for further details.
 			 */
 			if (tmp->len == 0) {
-				pos = round_up(pos,
+				pos = round_up(pos + 1,
 					       le16_to_cpu
 						(dev->bulk_in->wMaxPacketSize));
 				continue;
@@ -1732,7 +1732,7 @@ static void kvaser_usb_leaf_read_bulk_callback(struct kvaser_usb *dev,
 		 * number of events in case of a heavy rx load on the bus.
 		 */
 		if (cmd->len == 0) {
-			pos = round_up(pos, le16_to_cpu
+			pos = round_up(pos + 1, le16_to_cpu
 						(dev->bulk_in->wMaxPacketSize));
 			continue;
 		}
-- 
2.51.0



