Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B36A0324B24;
	Mon, 27 Oct 2025 18:49:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761590943; cv=none; b=D3UMPkjHh0BZqbOV9W2qCqZt6W0dY8Mt8PpHUw9zBtkNUH67fGHO7fm5k5s0Dvp0Z+TafhcEBH7JI9gqE+IF5nifrVpotV+u+W7QhHnMKzWNu7F86ifiuTydwWHcDQi/KUXWHTD2rcLJhqpEp37H5tpZUtMgW5C8SscHZCj+4Ag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761590943; c=relaxed/simple;
	bh=ty0ZMLeGslOetsCRqU9ydELgFOnxvO3h+Q+oz3BYSzE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UgXIRoJoA58dK+W3RnKIrFqwbaGb7+JMCugOjaoRnOVujel+zxtlHGR8C4Iv6t+lreO/M7bktEjpa0drijTwAYDPpuuTXWIFqWIXsbqN3erFcd3H44PfuINU6GimDmnfZZW7hbke9RPZ0PrxuxjpD2zEbjPudsgC/u5sxTSd3Jo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RhA4PRct; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RhA4PRct"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42E3BC4CEF1;
	Mon, 27 Oct 2025 18:49:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761590943;
	bh=ty0ZMLeGslOetsCRqU9ydELgFOnxvO3h+Q+oz3BYSzE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RhA4PRct3p5FFofpjebm6ugvxMsjLKrGiAHtgv5rfIgp6CAEzBQhBTmG0XcLg6oTn
	 0CWB5XKdyA6KamLpAsRniyhyNmXqv4vwTfAi5Blg0vPq78UXRX69+2zytoZeKdN52P
	 tG8fkKBfkgdcbBCEHv2OwO7xuCUpKbTrtvw1ybls=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Pecio <michal.pecio@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 198/224] net: usb: rtl8150: Fix frame padding
Date: Mon, 27 Oct 2025 19:35:44 +0100
Message-ID: <20251027183514.106607164@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183508.963233542@linuxfoundation.org>
References: <20251027183508.963233542@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Pecio <michal.pecio@gmail.com>

commit 75cea9860aa6b2350d90a8d78fed114d27c7eca2 upstream.

TX frames aren't padded and unknown memory is sent into the ether.

Theoretically, it isn't even guaranteed that the extra memory exists
and can be sent out, which could cause further problems. In practice,
I found that plenty of tailroom exists in the skb itself (in my test
with ping at least) and skb_padto() easily succeeds, so use it here.

In the event of -ENOMEM drop the frame like other drivers do.

The use of one more padding byte instead of a USB zero-length packet
is retained to avoid regression. I have a dodgy Etron xHCI controller
which doesn't seem to support sending ZLPs at all.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Michal Pecio <michal.pecio@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20251014203528.3f9783c4.michal.pecio@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/rtl8150.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/drivers/net/usb/rtl8150.c
+++ b/drivers/net/usb/rtl8150.c
@@ -705,9 +705,16 @@ static netdev_tx_t rtl8150_start_xmit(st
 	rtl8150_t *dev = netdev_priv(netdev);
 	int count, res;
 
+	/* pad the frame and ensure terminating USB packet, datasheet 9.2.3 */
+	count = max(skb->len, ETH_ZLEN);
+	if (count % 64 == 0)
+		count++;
+	if (skb_padto(skb, count)) {
+		netdev->stats.tx_dropped++;
+		return NETDEV_TX_OK;
+	}
+
 	netif_stop_queue(netdev);
-	count = (skb->len < 60) ? 60 : skb->len;
-	count = (count & 0x3f) ? count : count + 1;
 	dev->tx_skb = skb;
 	usb_fill_bulk_urb(dev->tx_urb, dev->udev, usb_sndbulkpipe(dev->udev, 2),
 		      skb->data, count, write_bulk_callback, dev);


