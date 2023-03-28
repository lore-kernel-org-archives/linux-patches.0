Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C93AB8BE0
	for <patches@lists.linux.dev>; Tue, 28 Mar 2023 14:58:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CC99C433EF;
	Tue, 28 Mar 2023 14:58:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680015538;
	bh=BVtxsmtcpvbvJZQxTRNlHwtbhkWm99TROxK6CHRu3Fs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1xnVflY4FZik8P4kISFm1NlIEzpSWOTa3sTOSwy3bqfWtWPUIMvfQQqP2vJifaa8I
	 UJFRqBozUXn23IZTFEzEBMYr/gaw4LM+zScIqhbzlJzjcTY9ZMPyL1GKlfb+xh3DGs
	 Yo6mTAaLlvqAd8+svtwFU3zSgN5FfgCcKCZfAjIU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Szymon Heidrich <szymon.heidrich@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 054/224] net: usb: lan78xx: Limit packet length to skb->len
Date: Tue, 28 Mar 2023 16:40:50 +0200
Message-Id: <20230328142619.624950807@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142617.205414124@linuxfoundation.org>
References: <20230328142617.205414124@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Szymon Heidrich <szymon.heidrich@gmail.com>

[ Upstream commit 7f247f5a2c18b3f21206cdd51193df4f38e1b9f5 ]

Packet length retrieved from descriptor may be larger than
the actual socket buffer length. In such case the cloned
skb passed up the network stack will leak kernel memory contents.

Additionally prevent integer underflow when size is less than
ETH_FCS_LEN.

Fixes: 55d7de9de6c3 ("Microchip's LAN7800 family USB 2/3 to 10/100/1000 Ethernet device driver")
Signed-off-by: Szymon Heidrich <szymon.heidrich@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/lan78xx.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
index 068488890d57b..c458c030fadf6 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -3579,13 +3579,29 @@ static int lan78xx_rx(struct lan78xx_net *dev, struct sk_buff *skb,
 		size = (rx_cmd_a & RX_CMD_A_LEN_MASK_);
 		align_count = (4 - ((size + RXW_PADDING) % 4)) % 4;
 
+		if (unlikely(size > skb->len)) {
+			netif_dbg(dev, rx_err, dev->net,
+				  "size err rx_cmd_a=0x%08x\n",
+				  rx_cmd_a);
+			return 0;
+		}
+
 		if (unlikely(rx_cmd_a & RX_CMD_A_RED_)) {
 			netif_dbg(dev, rx_err, dev->net,
 				  "Error rx_cmd_a=0x%08x", rx_cmd_a);
 		} else {
-			u32 frame_len = size - ETH_FCS_LEN;
+			u32 frame_len;
 			struct sk_buff *skb2;
 
+			if (unlikely(size < ETH_FCS_LEN)) {
+				netif_dbg(dev, rx_err, dev->net,
+					  "size err rx_cmd_a=0x%08x\n",
+					  rx_cmd_a);
+				return 0;
+			}
+
+			frame_len = size - ETH_FCS_LEN;
+
 			skb2 = napi_alloc_skb(&dev->napi, frame_len);
 			if (!skb2)
 				return 0;
-- 
2.39.2



