Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 948D021C166;
	Thu, 12 Dec 2024 17:03:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023023; cv=none; b=dClMjPasH6bFTab8TeDmvI3z6LIEgKcIJ5hS7U9/oShTJ3vZWBqkgDKmqoAKQuoQuSOECxkYjL9Z4QGHgvPsPi+0RFEjNFfRpQ7OXx8Gn2AIpMwrptpTJhPT0tXwwXZ7Dnmkw8KXrGopObWF6k+tviukJiR0hFyXbnlbFwfB5aA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023023; c=relaxed/simple;
	bh=Nug4wWLupGD9h2ZlyFZy7tqWvtnqrv2UbVt6yNnPtbo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=K/9uU/sBs8MJiWhYVfRjr1IaRiptv4olx5rpKBPR4bbAot/ZuYOBltTcR5Z6wLq03/82++XIrVg1OPfiAZqwnR+h71AMWXwtAZBUjaIlKKUnLB+gQzrT1fRckmlnMItmhpjOwTJ1VDih+c/7ihM6uro/vIHkSp/l/uIWkZeIVlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vGQdN1Gp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vGQdN1Gp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 320CDC4CECE;
	Thu, 12 Dec 2024 17:03:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023023;
	bh=Nug4wWLupGD9h2ZlyFZy7tqWvtnqrv2UbVt6yNnPtbo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vGQdN1GprD5w8/G2WODP3AqFnSK0xFmfA8FE4wSjiW66MLpaL0EuuNKoEWc5fyPjk
	 2nwTkZFg1tYeFYyfb4jn6Wi2xmXWhp5UMkj8pUG5VJRNc6dh3zi5RgOeg/tOF65lX5
	 NkL+JgV7x6h56mCHIyvsA1OYBTViueq5JQ9C6AWQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephane Grosjean <s.grosjean@peak-system.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 400/565] can: peak_usb: CANFD: store 64-bits hw timestamps
Date: Thu, 12 Dec 2024 15:59:55 +0100
Message-ID: <20241212144327.461942596@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephane Grosjean <s.grosjean@peak-system.com>

[ Upstream commit 28e0a70cede3fa6835e36302207776831cc41b8b ]

This patch allows to use the whole 64-bit timestamps received from the
CAN-FD device (expressed in µs) rather than only its low part, in the
hwtstamp structure of the skb transferred to the network layer, when a
CAN/CANFD frame has been received.

Link: https://lore.kernel.org/all/20210930094603.23134-1-s.grosjean@peak-system.com
Signed-off-by: Stephane Grosjean <s.grosjean@peak-system.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Stable-dep-of: 9e66242504f4 ("can: c_can: c_can_handle_bus_err(): update statistics if skb allocation fails")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/usb/peak_usb/pcan_usb_core.c | 13 +++++++++++++
 drivers/net/can/usb/peak_usb/pcan_usb_core.h |  1 +
 drivers/net/can/usb/peak_usb/pcan_usb_fd.c   |  9 ++++++---
 3 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/drivers/net/can/usb/peak_usb/pcan_usb_core.c b/drivers/net/can/usb/peak_usb/pcan_usb_core.c
index e8f43ed90b722..6107fef9f4a03 100644
--- a/drivers/net/can/usb/peak_usb/pcan_usb_core.c
+++ b/drivers/net/can/usb/peak_usb/pcan_usb_core.c
@@ -205,6 +205,19 @@ int peak_usb_netif_rx(struct sk_buff *skb,
 	return netif_rx(skb);
 }
 
+/* post received skb with native 64-bit hw timestamp */
+int peak_usb_netif_rx_64(struct sk_buff *skb, u32 ts_low, u32 ts_high)
+{
+	struct skb_shared_hwtstamps *hwts = skb_hwtstamps(skb);
+	u64 ns_ts;
+
+	ns_ts = (u64)ts_high << 32 | ts_low;
+	ns_ts *= NSEC_PER_USEC;
+	hwts->hwtstamp = ns_to_ktime(ns_ts);
+
+	return netif_rx(skb);
+}
+
 /*
  * callback for bulk Rx urb
  */
diff --git a/drivers/net/can/usb/peak_usb/pcan_usb_core.h b/drivers/net/can/usb/peak_usb/pcan_usb_core.h
index b00a4811bf61f..daa19f57e7422 100644
--- a/drivers/net/can/usb/peak_usb/pcan_usb_core.h
+++ b/drivers/net/can/usb/peak_usb/pcan_usb_core.h
@@ -143,6 +143,7 @@ void peak_usb_set_ts_now(struct peak_time_ref *time_ref, u32 ts_now);
 void peak_usb_get_ts_time(struct peak_time_ref *time_ref, u32 ts, ktime_t *tv);
 int peak_usb_netif_rx(struct sk_buff *skb,
 		      struct peak_time_ref *time_ref, u32 ts_low);
+int peak_usb_netif_rx_64(struct sk_buff *skb, u32 ts_low, u32 ts_high);
 void peak_usb_async_complete(struct urb *urb);
 void peak_usb_restart_complete(struct peak_usb_device *dev);
 
diff --git a/drivers/net/can/usb/peak_usb/pcan_usb_fd.c b/drivers/net/can/usb/peak_usb/pcan_usb_fd.c
index 09029a3bad1ac..6bd12549f1014 100644
--- a/drivers/net/can/usb/peak_usb/pcan_usb_fd.c
+++ b/drivers/net/can/usb/peak_usb/pcan_usb_fd.c
@@ -515,7 +515,8 @@ static int pcan_usb_fd_decode_canmsg(struct pcan_usb_fd_if *usb_if,
 	netdev->stats.rx_packets++;
 	netdev->stats.rx_bytes += cfd->len;
 
-	peak_usb_netif_rx(skb, &usb_if->time_ref, le32_to_cpu(rm->ts_low));
+	peak_usb_netif_rx_64(skb, le32_to_cpu(rm->ts_low),
+			     le32_to_cpu(rm->ts_high));
 
 	return 0;
 }
@@ -579,7 +580,8 @@ static int pcan_usb_fd_decode_status(struct pcan_usb_fd_if *usb_if,
 	netdev->stats.rx_packets++;
 	netdev->stats.rx_bytes += cf->len;
 
-	peak_usb_netif_rx(skb, &usb_if->time_ref, le32_to_cpu(sm->ts_low));
+	peak_usb_netif_rx_64(skb, le32_to_cpu(sm->ts_low),
+			     le32_to_cpu(sm->ts_high));
 
 	return 0;
 }
@@ -629,7 +631,8 @@ static int pcan_usb_fd_decode_overrun(struct pcan_usb_fd_if *usb_if,
 	cf->can_id |= CAN_ERR_CRTL;
 	cf->data[1] |= CAN_ERR_CRTL_RX_OVERFLOW;
 
-	peak_usb_netif_rx(skb, &usb_if->time_ref, le32_to_cpu(ov->ts_low));
+	peak_usb_netif_rx_64(skb, le32_to_cpu(ov->ts_low),
+			     le32_to_cpu(ov->ts_high));
 
 	netdev->stats.rx_over_errors++;
 	netdev->stats.rx_errors++;
-- 
2.43.0



