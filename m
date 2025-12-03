Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15E7B36BCE0;
	Wed,  3 Dec 2025 16:48:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780514; cv=none; b=Q/rR1rmc/ciAUqP2QzCq2JBO/5eEJHu791L3P8zPvtb2fG107WMjZnw00M50rGmT/USXkmnyYcu9KhiNLAEmu6AEzz2FAKMgO3WIm9bNFyYtPJHSc9G7+E+adH4WG/2ky+RYjV7c+nX+UhIuKaQXX65DyYJngIOHwrebUB1hxW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780514; c=relaxed/simple;
	bh=o5pEj82BwJ0hSdbCY1TQ8IlrFbOMgMbfGNK93zvh738=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H9lPucHOXmeHJDhA1Nyrq/k7/lMMXfnDyqOqgItcbPS9MCqDz1iIn3B7upkVHA5A6MhCPpk5EA/0vxVGDLVBEzTl+rv6VxosnK7YEP3kuqW+T/yXydSsWP5e0p7aeQ7mnhsxH4P1NALTfevkGreKIXaJ32tt2nKvulhF0AeG6bY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GF6qKViB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GF6qKViB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48F3FC4CEF5;
	Wed,  3 Dec 2025 16:48:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780513;
	bh=o5pEj82BwJ0hSdbCY1TQ8IlrFbOMgMbfGNK93zvh738=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GF6qKViB8V+sp3aCyPAtxPt+UIiMmx7meMUkzFCjYUC8Gs8EsYwhtMC2dkdoBORg6
	 vpkNwEog0lTQXVK57094IGmaU8EaLUwaZfKHEiTXHc89wLy+/5Uko/W127f8SsMYnN
	 W5GvWMMI/Kyrz13mRX6kh4M+/i1bnVQrtxt5qyGw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Seungjin Bae <eeodqql09@gmail.com>,
	Jimmy Assarsson <extja@kvaser.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 001/132] can: kvaser_usb: leaf: Fix potential infinite loop in command parsers
Date: Wed,  3 Dec 2025 16:28:00 +0100
Message-ID: <20251203152343.344574964@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152343.285859633@linuxfoundation.org>
References: <20251203152343.285859633@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 6b9122ab1464f..b7f6935686c96 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
@@ -662,7 +662,7 @@ static int kvaser_usb_leaf_wait_cmd(const struct kvaser_usb *dev, u8 id,
 			 * for further details.
 			 */
 			if (tmp->len == 0) {
-				pos = round_up(pos,
+				pos = round_up(pos + 1,
 					       le16_to_cpu
 						(dev->bulk_in->wMaxPacketSize));
 				continue;
@@ -1672,7 +1672,7 @@ static void kvaser_usb_leaf_read_bulk_callback(struct kvaser_usb *dev,
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



