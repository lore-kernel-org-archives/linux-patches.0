Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44E9A3F9280;
	Wed, 20 May 2026 18:23:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301400; cv=none; b=UiKZcBl2U43FouIOzuEsapQOARsN1kM78hK7cRdC/nbJ8DpavlG5G/IXrAnBK7EHuwXh1hjfETIzFqxoS1lpIQg7o9NlA1n9hIDo2AeVgfySEO0jgJlaFtspTkodgwy+vo/KZkA0Fb9q0Mc0KwjifofDfxSBOynUlFZBuVh9MMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301400; c=relaxed/simple;
	bh=LkiwubjZBuWsuldSWwkY5lh/bquiQUa64feMgsMRxe4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YlaRGQMuktC6G/oMxFzya6gAiuVFBLH+SQvVuPVtvmf8FxbyDA2Z9v6Af9c7xt2JUl51nGrFx1A8o6JasP+mmij/0FbreL5kkI3C8iUlllQRWh35myDo6iAI3eAdSQO3XZMjAHNB3tzoxeTPASjea+Mj8p2hLqO1+1v/e+o7rtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wrEPwbsA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wrEPwbsA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A96451F00896;
	Wed, 20 May 2026 18:23:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301399;
	bh=lqIMXylv0RZljaWiPZpPppYFWARmDyfOG5UBU7OzWPc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wrEPwbsATIm0jgIN6+lzXde5YkPtGh2bjDpRYgWxNCWXNgR+sG4irYgZu9Kfq2t/m
	 Vpy/5iebPcDKNthIx8si6ie3oDon8lEOgsW5+bvgbDd/mR4+CY/Mt5zjJJfKw0DQpr
	 U6ssQxWWmxLx4l9rqcLSGNndn6xr+YM68WDpq5W8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+3f46c095ac0ca048cb71@syzkaller.appspotmail.com,
	Andrew Lunn <andrew@lunn.ch>,
	Zhan Jun <zhanjun@uniontech.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 540/666] net: usb: rtl8150: fix use-after-free in rtl8150_start_xmit()
Date: Wed, 20 May 2026 18:22:31 +0200
Message-ID: <20260520162122.974660155@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

From: Zhan Jun <zhanjun@uniontech.com>

[ Upstream commit 23f0e34c64acba15cad4d23e50f41f533da195fa ]

syzbot reported a KASAN slab-use-after-free read in rtl8150_start_xmit()
when accessing skb->len for tx statistics after usb_submit_urb() has
been called:

  BUG: KASAN: slab-use-after-free in rtl8150_start_xmit+0x71f/0x760
    drivers/net/usb/rtl8150.c:712
  Read of size 4 at addr ffff88810eb7a930 by task kworker/0:4/5226

The URB completion handler write_bulk_callback() frees the skb via
dev_kfree_skb_irq(dev->tx_skb). The URB may complete on another CPU
in softirq context before usb_submit_urb() returns in the submitter,
so by the time the submitter reads skb->len the skb has already been
queued to the per-CPU completion_queue and freed by net_tx_action():

  CPU A (xmit)                      CPU B (USB completion softirq)
  ------------                      ------------------------------
  dev->tx_skb = skb;
  usb_submit_urb()      --+
                          |-------> write_bulk_callback()
                          |           dev_kfree_skb_irq(dev->tx_skb)
                          |         net_tx_action()
                          |           napi_skb_cache_put()   <-- free
  netdev->stats.tx_bytes  |
    += skb->len;          <-- UAF read

Fix it by caching skb->len before submitting the URB and using the
cached value when updating the tx_bytes counter.

The pre-existing tx_bytes semantics are preserved: the counter tracks
the original frame length (skb->len), not the ETH_ZLEN/USB-alignment
padded "count" value that is handed to the device.  Changing that
would be a user-visible accounting change and is out of scope for
this UAF fix.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: syzbot+3f46c095ac0ca048cb71@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/69e69ee7.050a0220.24bfd3.002b.GAE@google.com/
Closes: https://syzkaller.appspot.com/bug?extid=3f46c095ac0ca048cb71
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Zhan Jun <zhanjun@uniontech.com>
Link: https://patch.msgid.link/809895186B866C10+20260423004913.136655-1-zhangdandan@uniontech.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/rtl8150.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/usb/rtl8150.c b/drivers/net/usb/rtl8150.c
index e40b0669d9f4b..8700ae392b10a 100644
--- a/drivers/net/usb/rtl8150.c
+++ b/drivers/net/usb/rtl8150.c
@@ -685,6 +685,7 @@ static netdev_tx_t rtl8150_start_xmit(struct sk_buff *skb,
 					    struct net_device *netdev)
 {
 	rtl8150_t *dev = netdev_priv(netdev);
+	unsigned int skb_len;
 	int count, res;
 
 	/* pad the frame and ensure terminating USB packet, datasheet 9.2.3 */
@@ -696,6 +697,8 @@ static netdev_tx_t rtl8150_start_xmit(struct sk_buff *skb,
 		return NETDEV_TX_OK;
 	}
 
+	skb_len = skb->len;
+
 	netif_stop_queue(netdev);
 	dev->tx_skb = skb;
 	usb_fill_bulk_urb(dev->tx_urb, dev->udev, usb_sndbulkpipe(dev->udev, 2),
@@ -711,7 +714,7 @@ static netdev_tx_t rtl8150_start_xmit(struct sk_buff *skb,
 		}
 	} else {
 		netdev->stats.tx_packets++;
-		netdev->stats.tx_bytes += skb->len;
+		netdev->stats.tx_bytes += skb_len;
 		netif_trans_update(netdev);
 	}
 
-- 
2.53.0



