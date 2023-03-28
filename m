Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1793A8BE0
	for <patches@lists.linux.dev>; Tue, 28 Mar 2023 14:56:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C837C433EF;
	Tue, 28 Mar 2023 14:56:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680015409;
	bh=wlhbqFtoERqWL/M7yPD7+9cywiy3LE2UZ6bt7j9ScuA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SYsPP6W54y0naww8pqzZwD7fLFATWEV2pELOdaJ1AKE7hZqub4NByrQ4/2b+SfHYw
	 E22otA8UdBKkhhWCc4q5kwkBvd2+UfZ4AItNJKV/KBvRQhbup8U0txSGcFq0KuLuZ9
	 SWlcO6NsQ+Bxh25MJIRE/wK/5i+z+CSSz/0WNyS4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Szymon Heidrich <szymon.heidrich@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 038/224] net: usb: smsc95xx: Limit packet length to skb->len
Date: Tue, 28 Mar 2023 16:40:34 +0200
Message-Id: <20230328142618.936133838@linuxfoundation.org>
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

[ Upstream commit ff821092cf02a70c2bccd2d19269f01e29aa52cf ]

Packet length retrieved from descriptor may be larger than
the actual socket buffer length. In such case the cloned
skb passed up the network stack will leak kernel memory contents.

Fixes: 2f7ca802bdae ("net: Add SMSC LAN9500 USB2.0 10/100 ethernet adapter driver")
Signed-off-by: Szymon Heidrich <szymon.heidrich@gmail.com>
Reviewed-by: Jakub Kicinski <kuba@kernel.org>
Link: https://lore.kernel.org/r/20230316101954.75836-1-szymon.heidrich@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/smsc95xx.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/usb/smsc95xx.c b/drivers/net/usb/smsc95xx.c
index 32d2c60d334dc..563ecd27b93ea 100644
--- a/drivers/net/usb/smsc95xx.c
+++ b/drivers/net/usb/smsc95xx.c
@@ -1833,6 +1833,12 @@ static int smsc95xx_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
 		size = (u16)((header & RX_STS_FL_) >> 16);
 		align_count = (4 - ((size + NET_IP_ALIGN) % 4)) % 4;
 
+		if (unlikely(size > skb->len)) {
+			netif_dbg(dev, rx_err, dev->net,
+				  "size err header=0x%08x\n", header);
+			return 0;
+		}
+
 		if (unlikely(header & RX_STS_ES_)) {
 			netif_dbg(dev, rx_err, dev->net,
 				  "Error header=0x%08x\n", header);
-- 
2.39.2



