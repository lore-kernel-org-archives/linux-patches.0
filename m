Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B9FE3074BA;
	Wed,  3 Dec 2025 15:44:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776681; cv=none; b=NQQAmBxsEuGpDLXgwLLZPb/X/q3AmkF/S10Sq6C6SW8NG5WdCamwQdDmwBMZk7YaFNlTYliMFTqLmIzLuxXKvChIoqxvJUNdJ9/O40XQi04uxZby4mOvgcgvrBpY3NwWi2Pyiuwk6OlMiogHdFHIbCMqOkIEqsNpnlyM246HeJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776681; c=relaxed/simple;
	bh=l2XLaSRyVVuZGjuNfyYU+YGUn0Gx+u5b/gHHWxaKhQ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aUjU7XdRYOEmK6hp+yuKi6BqN0T0epBIASbY5eOIULnEHuX6gZDtcYZZvChCK1qZYD9xrNUGlCdpwZqdDDxOcBliAXr3DIHv4zL5obi9D7rS8MNAzn9EwvYMI487C5HqJ1AxQoAgZjKwTR/pWF1+Y9/FIce4Tx2mooZlj79Lt2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Khm806ku; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Khm806ku"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 441A7C4CEF5;
	Wed,  3 Dec 2025 15:44:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776680;
	bh=l2XLaSRyVVuZGjuNfyYU+YGUn0Gx+u5b/gHHWxaKhQ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Khm806kuYlL1fdXLDC9okTa709kLTUNZRfsO/u6ezMP2V1+Vd9UsYIAOjYIUl05Y0
	 qsUXCvD0jnEEdE3VYhnaz8nopHFJWVDIEa0I+syv60tUf/Ak+7pJJ90XY5RZq99CV8
	 ciCRd5Wx5zxGGAmoNTgkHt6vTelhPV2fxXGGQU1Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Seungjin Bae <eeodqql09@gmail.com>,
	Jimmy Assarsson <extja@kvaser.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 256/300] can: kvaser_usb: leaf: Fix potential infinite loop in command parsers
Date: Wed,  3 Dec 2025 16:27:40 +0100
Message-ID: <20251203152410.122306806@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index f06d63db9077b..df0460e3633c5 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
@@ -609,7 +609,7 @@ static int kvaser_usb_leaf_wait_cmd(const struct kvaser_usb *dev, u8 id,
 			 * for further details.
 			 */
 			if (tmp->len == 0) {
-				pos = round_up(pos,
+				pos = round_up(pos + 1,
 					       le16_to_cpu
 						(dev->bulk_in->wMaxPacketSize));
 				continue;
@@ -1571,7 +1571,7 @@ static void kvaser_usb_leaf_read_bulk_callback(struct kvaser_usb *dev,
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



