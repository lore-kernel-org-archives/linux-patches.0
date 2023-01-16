Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67CA16FA0
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 17:03:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DECF6C433F0;
	Mon, 16 Jan 2023 17:03:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673888601;
	bh=rHBFQesYUOXAmnDft7BlQyQ/pP0pLIpcvU3sN9lYMIw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b2IWRjN7a26jp3FP0d/EeVjKyNjFyxYyWE7h01ywhpclD/PgSwJPS0zDfwyIPdRVK
	 vi72yDezZeD1YSF756rao8PIQNyptHKt1vdw89WJ3KMdP/52td86tiE0JlXE3d15MU
	 ImSvTGd4xx75sG2/orfs2B5h/XzqDZoS+ecu66E8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	Alexey Khoroshilov <khoroshilov@ispras.ru>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 067/338] wifi: ath9k: hif_usb: Fix use-after-free in ath9k_hif_usb_reg_in_cb()
Date: Mon, 16 Jan 2023 16:49:00 +0100
Message-Id: <20230116154823.780989835@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154820.689115727@linuxfoundation.org>
References: <20230116154820.689115727@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Fedor Pchelkin <pchelkin@ispras.ru>

[ Upstream commit dd95f2239fc846795fc926787c3ae0ca701c9840 ]

It is possible that skb is freed in ath9k_htc_rx_msg(), then
usb_submit_urb() fails and we try to free skb again. It causes
use-after-free bug. Moreover, if alloc_skb() fails, urb->context becomes
NULL but rx_buf is not freed and there can be a memory leak.

The patch removes unnecessary nskb and makes skb processing more clear: it
is supposed that ath9k_htc_rx_msg() either frees old skb or passes its
managing to another callback function.

Found by Linux Verification Center (linuxtesting.org) with Syzkaller.

Fixes: 3deff76095c4 ("ath9k_htc: Increase URB count for REG_IN pipe")
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
Acked-by: Toke Høiland-Jørgensen <toke@toke.dk>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/20221008114917.21404-1-pchelkin@ispras.ru
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath9k/hif_usb.c | 28 +++++++++++++-----------
 1 file changed, 15 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
index 039f5d76685e..3ff78e9b06c2 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -707,14 +707,13 @@ static void ath9k_hif_usb_reg_in_cb(struct urb *urb)
 	struct rx_buf *rx_buf = (struct rx_buf *)urb->context;
 	struct hif_device_usb *hif_dev = rx_buf->hif_dev;
 	struct sk_buff *skb = rx_buf->skb;
-	struct sk_buff *nskb;
 	int ret;
 
 	if (!skb)
 		return;
 
 	if (!hif_dev)
-		goto free;
+		goto free_skb;
 
 	switch (urb->status) {
 	case 0:
@@ -723,7 +722,7 @@ static void ath9k_hif_usb_reg_in_cb(struct urb *urb)
 	case -ECONNRESET:
 	case -ENODEV:
 	case -ESHUTDOWN:
-		goto free;
+		goto free_skb;
 	default:
 		skb_reset_tail_pointer(skb);
 		skb_trim(skb, 0);
@@ -734,25 +733,27 @@ static void ath9k_hif_usb_reg_in_cb(struct urb *urb)
 	if (likely(urb->actual_length != 0)) {
 		skb_put(skb, urb->actual_length);
 
-		/* Process the command first */
+		/*
+		 * Process the command first.
+		 * skb is either freed here or passed to be
+		 * managed to another callback function.
+		 */
 		ath9k_htc_rx_msg(hif_dev->htc_handle, skb,
 				 skb->len, USB_REG_IN_PIPE);
 
-
-		nskb = alloc_skb(MAX_REG_IN_BUF_SIZE, GFP_ATOMIC);
-		if (!nskb) {
+		skb = alloc_skb(MAX_REG_IN_BUF_SIZE, GFP_ATOMIC);
+		if (!skb) {
 			dev_err(&hif_dev->udev->dev,
 				"ath9k_htc: REG_IN memory allocation failure\n");
-			urb->context = NULL;
-			return;
+			goto free_rx_buf;
 		}
 
-		rx_buf->skb = nskb;
+		rx_buf->skb = skb;
 
 		usb_fill_int_urb(urb, hif_dev->udev,
 				 usb_rcvintpipe(hif_dev->udev,
 						 USB_REG_IN_PIPE),
-				 nskb->data, MAX_REG_IN_BUF_SIZE,
+				 skb->data, MAX_REG_IN_BUF_SIZE,
 				 ath9k_hif_usb_reg_in_cb, rx_buf, 1);
 	}
 
@@ -761,12 +762,13 @@ static void ath9k_hif_usb_reg_in_cb(struct urb *urb)
 	ret = usb_submit_urb(urb, GFP_ATOMIC);
 	if (ret) {
 		usb_unanchor_urb(urb);
-		goto free;
+		goto free_skb;
 	}
 
 	return;
-free:
+free_skb:
 	kfree_skb(skb);
+free_rx_buf:
 	kfree(rx_buf);
 	urb->context = NULL;
 }
-- 
2.35.1



