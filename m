Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0196228003C;
	Tue, 27 May 2025 17:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748368525; cv=none; b=K2EdZoZ73P+xI0z4/9ztqV//90CK6UxvKHC2JGTyZ0AL6WvTmPutii9PvW6Uqc0HfJ6ZrUy+Pa9Nw3IBwr8kuILej8BmJ3xI8K9U+Xk6MDEJUulhOiX+auc2OgV61q95LveRwmiX+XxftGiFjjuXl7SXJ0nlTI5POueODUNo59U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748368525; c=relaxed/simple;
	bh=T/2dsk1C+gEx9T0+Btd0wkBKWub9sKVt0JCKGBl16o0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bh0WVldWxCRT6ez8OIHn3wihPGzQavdsnE4plNp6OuA8Po4DnRMYhHO81Val/FT0pYfff3VL6vciL4TJ6+X7/LOZ/jj+UR9UNaku6YzOYWgFFsJIhtg0ZZ795pfUceAcdGDHv9y4cULYsaU1BV/CDcNcIrlmxc/5Y+8aokFxc7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qS17vSEz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qS17vSEz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71082C4CEE9;
	Tue, 27 May 2025 17:55:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748368524;
	bh=T/2dsk1C+gEx9T0+Btd0wkBKWub9sKVt0JCKGBl16o0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qS17vSEzuTeCKx0Vl/YBdY4B8eL0Mg09FZHlJ6VpWnrL/4wy9Z8yrKsGD+Zb5td9v
	 09YnVdkqe2fWidJvvYRNP9ucis30+J5nV/LwCuSRXEcgYCuP37AR63RDpkX9TV1Tux
	 RCQbXX3zin2n/ghaCXVhYNVnHWjP8Q1hFpKx5xZs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Axel Forsman <axfo@kvaser.com>,
	Jimmy Assarsson <extja@kvaser.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.14 734/783] can: kvaser_pciefd: Continue parsing DMA buf after dropped RX
Date: Tue, 27 May 2025 18:28:51 +0200
Message-ID: <20250527162543.015947626@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1201,7 +1201,7 @@ static int kvaser_pciefd_handle_data_pac
 		skb = alloc_canfd_skb(priv->dev, &cf);
 		if (!skb) {
 			priv->dev->stats.rx_dropped++;
-			return -ENOMEM;
+			return 0;
 		}
 
 		cf->len = can_fd_dlc2len(dlc);
@@ -1213,7 +1213,7 @@ static int kvaser_pciefd_handle_data_pac
 		skb = alloc_can_skb(priv->dev, (struct can_frame **)&cf);
 		if (!skb) {
 			priv->dev->stats.rx_dropped++;
-			return -ENOMEM;
+			return 0;
 		}
 		can_frame_set_cc_len((struct can_frame *)cf, dlc, priv->ctrlmode);
 	}
@@ -1231,7 +1231,9 @@ static int kvaser_pciefd_handle_data_pac
 	priv->dev->stats.rx_packets++;
 	kvaser_pciefd_set_skb_timestamp(pcie, skb, p->timestamp);
 
-	return netif_rx(skb);
+	netif_rx(skb);
+
+	return 0;
 }
 
 static void kvaser_pciefd_change_state(struct kvaser_pciefd_can *can,


