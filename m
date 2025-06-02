Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4359D23BD04;
	Mon,  2 Jun 2025 14:22:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874133; cv=none; b=ZhQ4GNynWKPU3V5L1FiYb3Uv11g37MQPV6ltMqMRi1NJzbk8sc4xjVZoZsVUjhRKJxxlyypFWoH5hGvhQllbeogsxMIzm8AhJ2pI34La4o4ylIddmZhMgYmk7YbSbRu0btGYis+TmGmCHmCxLoDdtCWTty/vMLeAzOxZL40MWYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874133; c=relaxed/simple;
	bh=YNUEzpCWd1Mjf74kDdMcVLJVkFwfqO0rpxkBAYFGjEM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ehrIIrvlpEAj+y0mizobJb1HkUtwmgubYlci9NK4JKrDp9uYEcdAFPmyQAPRP6SEC8CrCCO9KQqxMd2eZK8uILFQAzeCz1+F0yLpjFI0t4lNe44BqY66dngeZZWDD50fkr6jgpxzwfxn9ozlBcjVGypu21UmzeeVLItsR1p2I6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RFB91P7G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RFB91P7G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6A75C4CEEB;
	Mon,  2 Jun 2025 14:22:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874133;
	bh=YNUEzpCWd1Mjf74kDdMcVLJVkFwfqO0rpxkBAYFGjEM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RFB91P7GJzhG5merCh2/rnGyYsQMsH9IuRoxI8nn5K0Zhd+KVYHzARJW1n9t8VeDu
	 Kgbkc9zgA8bC6osvCtn2eWl2TxHDX6Rc/pzGznEdzJpAC3CYfKzWLcR2sPo5GYkbYk
	 P6GvLHdWx2WVrxvxt4N4ZedEVjZD9jlrHGrkLjZU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Axel Forsman <axfo@kvaser.com>,
	Jimmy Assarsson <extja@kvaser.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.6 367/444] can: kvaser_pciefd: Continue parsing DMA buf after dropped RX
Date: Mon,  2 Jun 2025 15:47:11 +0200
Message-ID: <20250602134355.812024067@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Axel Forsman <axfo@kvaser.com>

commit 6d820b81c4dc4a4023e45c3cd6707a07dd838649 upstream.

Going bus-off on a channel doing RX could result in dropped packets.

As netif_running() gets cleared before the channel abort procedure,
the handling of any last RDATA packets would see netif_rx() return
non-zero to signal a dropped packet. kvaser_pciefd_read_buffer() dealt
with this "error" by breaking out of processing the remaining DMA RX
buffer.

Only return an error from kvaser_pciefd_read_buffer() due to packet
corruption, otherwise handle it internally.

Cc: stable@vger.kernel.org
Signed-off-by: Axel Forsman <axfo@kvaser.com>
Tested-by: Jimmy Assarsson <extja@kvaser.com>
Reviewed-by: Jimmy Assarsson <extja@kvaser.com>
Link: https://patch.msgid.link/20250520114332.8961-4-axfo@kvaser.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/kvaser_pciefd.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/net/can/kvaser_pciefd.c
+++ b/drivers/net/can/kvaser_pciefd.c
@@ -1137,7 +1137,7 @@ static int kvaser_pciefd_handle_data_pac
 		skb = alloc_canfd_skb(priv->dev, &cf);
 		if (!skb) {
 			priv->dev->stats.rx_dropped++;
-			return -ENOMEM;
+			return 0;
 		}
 
 		cf->len = can_fd_dlc2len(dlc);
@@ -1149,7 +1149,7 @@ static int kvaser_pciefd_handle_data_pac
 		skb = alloc_can_skb(priv->dev, (struct can_frame **)&cf);
 		if (!skb) {
 			priv->dev->stats.rx_dropped++;
-			return -ENOMEM;
+			return 0;
 		}
 		can_frame_set_cc_len((struct can_frame *)cf, dlc, priv->ctrlmode);
 	}
@@ -1167,7 +1167,9 @@ static int kvaser_pciefd_handle_data_pac
 	priv->dev->stats.rx_packets++;
 	kvaser_pciefd_set_skb_timestamp(pcie, skb, p->timestamp);
 
-	return netif_rx(skb);
+	netif_rx(skb);
+
+	return 0;
 }
 
 static void kvaser_pciefd_change_state(struct kvaser_pciefd_can *can,


