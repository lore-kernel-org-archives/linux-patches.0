Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46147329C7B;
	Mon, 27 Oct 2025 19:28:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761593323; cv=none; b=e8S9VVWS1XBLSOahBxAF8HGEqFSdKFFoRI3kEyJ0uo/qYqCGTZcS+Lqh2j8tVtAAcuUq0njrftzksgKlxBcsQLXP1v8XHFHBnql2iNKom8tC9eD2ySD0T8nXLgPFInJQLQj1JN0IA1kaDggIjqgZIdEe7nRrAMgrqsmQjWisoKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761593323; c=relaxed/simple;
	bh=pMLFwJ/41cvXwFLIHE7dCSeVZM3lwRBwVfYZVTLNIvY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p77Ednww5CzaS+ZI6n48FyVmUqIVRdvNJ55gsv6LnsQ1ZjlF5u/PGOuX+Krxl8/DUzsn9z3tV6qub6dSG8qZx/UkzvWA0tTYA2XaTNBmQ5ZDi7hCNVqiiM08BlLojKwm65ewc2F558PnqYn5kd2BUXalvi6R5ZBbL00gqeRMCbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wG4z/3mQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wG4z/3mQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5572C4CEF1;
	Mon, 27 Oct 2025 19:28:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761593323;
	bh=pMLFwJ/41cvXwFLIHE7dCSeVZM3lwRBwVfYZVTLNIvY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wG4z/3mQ3HJqB5ewdhpbSa+LsEv+DhDmWcjU7gmQdXWAwzQgrcQL564NR9Fs0wHgp
	 eRv5+5intefYg80slxqiqCQ/P+7MdF+ZLeRwc7Ag1lEbcw1t/1bsh6nBqLVGAI5ssO
	 uu+wpJ3V15mA6PM7SoRfxRdHOZ2vtNeD2fUImGUE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Pecio <michal.pecio@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.17 098/184] net: usb: rtl8150: Fix frame padding
Date: Mon, 27 Oct 2025 19:36:20 +0100
Message-ID: <20251027183517.548880109@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183514.934710872@linuxfoundation.org>
References: <20251027183514.934710872@linuxfoundation.org>
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
@@ -685,9 +685,16 @@ static netdev_tx_t rtl8150_start_xmit(st
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


