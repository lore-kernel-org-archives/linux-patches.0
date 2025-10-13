Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AE8C3093DD;
	Mon, 13 Oct 2025 15:03:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367826; cv=none; b=sx00jmmAQS8MwRw6p5Qd89iKMxkqrdYriMjava9uTt6n2xQFIqp3D0E4w4fD1dP93KjY+ouYeJcmf9vHwlP3XT1jRwqOzlFJpB7QEaK91sLWBTNC9w5K6UZMwG6PO9W+Y3GtjPJReyBBFisJcoH6o5P/2iddxM357fYmOeXMWYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367826; c=relaxed/simple;
	bh=SewuOOZ2UnIp9qEe539bIv6sJjZgrwF8haygyXrT5zM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hwGIapB/nfybIrDdml7/e3e+0kHD3jtw0WOc9NTm4Fg4xdvBkKLIKXj5v33yQGEeQFvjcF//Oc63t/UqnXwD8sfNSBmkH1/5M7xJ6Fq+2hxO6LLDw4jbYqXkpFAqGnaWT5DdxaPrwHpr2p+Revf/JwHkPI5k2algv8X07/Xmdxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vx1ZRHN+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vx1ZRHN+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E951AC4CEE7;
	Mon, 13 Oct 2025 15:03:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367826;
	bh=SewuOOZ2UnIp9qEe539bIv6sJjZgrwF8haygyXrT5zM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vx1ZRHN+ics5Y8f8Y+eU5i2RXfmVrDCSL0tRStdgVa2d+PUVWvBdTr9lrkCRYz0F6
	 CZOIpA0JM0Q/payuzURBk9iJQ3WjDbOXFCKebzLV21mmf+Cdwa3tCr7G09WydJuXLS
	 HZHfAer0vXrY7l07sIY+lY0p20FUjOIvH9aJoqI4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Pecio <michal.pecio@gmail.com>,
	I Viswanath <viswanathiyyappan@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	syzbot+78cae3f37c62ad092caa@syzkaller.appspotmail.com
Subject: [PATCH 6.6 148/196] net: usb: Remove disruptive netif_wake_queue in rtl8150_set_multicast
Date: Mon, 13 Oct 2025 16:45:39 +0200
Message-ID: <20251013144320.666086537@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144315.184275491@linuxfoundation.org>
References: <20251013144315.184275491@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: I Viswanath <viswanathiyyappan@gmail.com>

[ Upstream commit 958baf5eaee394e5fd976979b0791a875f14a179 ]

syzbot reported WARNING in rtl8150_start_xmit/usb_submit_urb.
This is the sequence of events that leads to the warning:

rtl8150_start_xmit() {
	netif_stop_queue();
	usb_submit_urb(dev->tx_urb);
}

rtl8150_set_multicast() {
	netif_stop_queue();
	netif_wake_queue();		<-- wakes up TX queue before URB is done
}

rtl8150_start_xmit() {
	netif_stop_queue();
	usb_submit_urb(dev->tx_urb);	<-- double submission
}

rtl8150_set_multicast being the ndo_set_rx_mode callback should not be
calling netif_stop_queue and notif_start_queue as these handle
TX queue synchronization.

The net core function dev_set_rx_mode handles the synchronization
for rtl8150_set_multicast making it safe to remove these locks.

Reported-and-tested-by: syzbot+78cae3f37c62ad092caa@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=78cae3f37c62ad092caa
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Tested-by: Michal Pecio <michal.pecio@gmail.com>
Signed-off-by: I Viswanath <viswanathiyyappan@gmail.com>
Link: https://patch.msgid.link/20250924134350.264597-1-viswanathiyyappan@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/rtl8150.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/usb/rtl8150.c b/drivers/net/usb/rtl8150.c
index ddff6f19ff98e..92add3daadbb1 100644
--- a/drivers/net/usb/rtl8150.c
+++ b/drivers/net/usb/rtl8150.c
@@ -664,7 +664,6 @@ static void rtl8150_set_multicast(struct net_device *netdev)
 	rtl8150_t *dev = netdev_priv(netdev);
 	u16 rx_creg = 0x9e;
 
-	netif_stop_queue(netdev);
 	if (netdev->flags & IFF_PROMISC) {
 		rx_creg |= 0x0001;
 		dev_info(&netdev->dev, "%s: promiscuous mode\n", netdev->name);
@@ -678,7 +677,6 @@ static void rtl8150_set_multicast(struct net_device *netdev)
 		rx_creg &= 0x00fc;
 	}
 	async_set_registers(dev, RCR, sizeof(rx_creg), rx_creg);
-	netif_wake_queue(netdev);
 }
 
 static netdev_tx_t rtl8150_start_xmit(struct sk_buff *skb,
-- 
2.51.0



