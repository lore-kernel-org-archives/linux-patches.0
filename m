Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BBCD522E
	for <patches@lists.linux.dev>; Sun,  9 Jul 2023 11:21:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B48B6C433C7;
	Sun,  9 Jul 2023 11:21:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688901667;
	bh=n/nPPCASgNPtiiRJvsdOWFOszVPSlUKJjEtpxQ4+EaU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eX+ng30rfClMOME4fG8IqYUmds9I2auPtrVsOZKl22PZ9Wv5lWYCDnQ48wjYu3mRd
	 MXv4c1EE3S/Bh3BkO3PXOc2azCqLU/gQVpVKbP4SZ3nSh7xhAGA7HJ5CQHNLX9pEhd
	 +yVy5K/TVAhaP/qicdt+Syvfr4ZzJTivrXe37wxg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 102/431] wifi: rtw88: usb: silence log flooding error message
Date: Sun,  9 Jul 2023 13:10:50 +0200
Message-ID: <20230709111453.550068918@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230709111451.101012554@linuxfoundation.org>
References: <20230709111451.101012554@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Sascha Hauer <s.hauer@pengutronix.de>

[ Upstream commit 1f1784a59caf3eefd127908a1a3cf224017ff9c7 ]

When receiving more rx packets than the kernel can handle the driver
drops the packets and issues an error message. This is bad for two
reasons. The logs are flooded with myriads of messages, but then time
consumed for printing messages in that critical code path brings down
the device. After some time of excessive rx load the driver responds
with:

rtw_8822cu 1-1:1.2: failed to get tx report from firmware
rtw_8822cu 1-1:1.2: firmware failed to report density after scan
rtw_8822cu 1-1:1.2: firmware failed to report density after scan

The device stops working until being replugged.

Fix this by lowering the priority to debug level and also by
ratelimiting it.

Fixes: a82dfd33d1237 ("wifi: rtw88: Add common USB chip support")
Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Reviewed-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20230524103934.1019096-1-s.hauer@pengutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw88/usb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw88/usb.c b/drivers/net/wireless/realtek/rtw88/usb.c
index 44a5fafb99055..976eafa739a2d 100644
--- a/drivers/net/wireless/realtek/rtw88/usb.c
+++ b/drivers/net/wireless/realtek/rtw88/usb.c
@@ -535,7 +535,7 @@ static void rtw_usb_rx_handler(struct work_struct *work)
 		}
 
 		if (skb_queue_len(&rtwusb->rx_queue) >= RTW_USB_MAX_RXQ_LEN) {
-			rtw_err(rtwdev, "failed to get rx_queue, overflow\n");
+			dev_dbg_ratelimited(rtwdev->dev, "failed to get rx_queue, overflow\n");
 			dev_kfree_skb_any(skb);
 			continue;
 		}
-- 
2.39.2



