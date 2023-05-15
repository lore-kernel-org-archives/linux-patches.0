Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15F4ADF40
	for <patches@lists.linux.dev>; Mon, 15 May 2023 16:40:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F396C433D2;
	Mon, 15 May 2023 16:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684168812;
	bh=9q3V2uXKJCwW/Oj8E79RPaAn/1LEgjFVlwfJ6CvJsec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xiNC8UE4kQmSJOl85/EOUjyAFYAB4GyK6x+KnYeWhIat91SjXwQSHziqPxJ0yrALQ
	 wTc9Y+SkG9j/2+Kv3VA3nd12xDf1BIx/VPs8meO1Q6lRfGb0njpx7Gs/Y3yJLsWbkT
	 pn/ehyf8R4XKN87GCKj8JwqJFFdts2zY1ognd++I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	Alexey Khoroshilov <khoroshilov@ispras.ru>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 049/191] wifi: ath9k: hif_usb: fix memory leak of remain_skbs
Date: Mon, 15 May 2023 18:24:46 +0200
Message-Id: <20230515161708.982527001@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161707.203549282@linuxfoundation.org>
References: <20230515161707.203549282@linuxfoundation.org>
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

[ Upstream commit 7654cc03eb699297130b693ec34e25f77b17c947 ]

hif_dev->remain_skb is allocated and used exclusively in
ath9k_hif_usb_rx_stream(). It is implied that an allocated remain_skb is
processed and subsequently freed (in error paths) only during the next
call of ath9k_hif_usb_rx_stream().

So, if the urbs are deallocated between those two calls due to the device
deinitialization or suspend, it is possible that ath9k_hif_usb_rx_stream()
is not called next time and the allocated remain_skb is leaked. Our local
Syzkaller instance was able to trigger that.

remain_skb makes sense when receiving two consecutive urbs which are
logically linked together, i.e. a specific data field from the first skb
indicates a cached skb to be allocated, memcpy'd with some data and
subsequently processed in the next call to ath9k_hif_usb_rx_stream(). Urbs
deallocation supposedly makes that link irrelevant so we need to free the
cached skb in those cases.

Fix the leak by introducing a function to explicitly free remain_skb (if
it is not NULL) when the rx urbs have been deallocated. remain_skb is NULL
when it has not been allocated at all (hif_dev struct is kzalloced) or
when it has been processed in next call to ath9k_hif_usb_rx_stream().

Found by Linux Verification Center (linuxtesting.org) with Syzkaller.

Fixes: fb9987d0f748 ("ath9k_htc: Support for AR9271 chipset.")
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
Acked-by: Toke Høiland-Jørgensen <toke@toke.dk>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/20230216192301.171225-1-pchelkin@ispras.ru
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath9k/hif_usb.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
index e23d58f83dd6f..3aa915d215545 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -534,6 +534,24 @@ static struct ath9k_htc_hif hif_usb = {
 	.send = hif_usb_send,
 };
 
+/* Need to free remain_skb allocated in ath9k_hif_usb_rx_stream
+ * in case ath9k_hif_usb_rx_stream wasn't called next time to
+ * process the buffer and subsequently free it.
+ */
+static void ath9k_hif_usb_free_rx_remain_skb(struct hif_device_usb *hif_dev)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&hif_dev->rx_lock, flags);
+	if (hif_dev->remain_skb) {
+		dev_kfree_skb_any(hif_dev->remain_skb);
+		hif_dev->remain_skb = NULL;
+		hif_dev->rx_remain_len = 0;
+		RX_STAT_INC(hif_dev, skb_dropped);
+	}
+	spin_unlock_irqrestore(&hif_dev->rx_lock, flags);
+}
+
 static void ath9k_hif_usb_rx_stream(struct hif_device_usb *hif_dev,
 				    struct sk_buff *skb)
 {
@@ -868,6 +886,7 @@ static int ath9k_hif_usb_alloc_tx_urbs(struct hif_device_usb *hif_dev)
 static void ath9k_hif_usb_dealloc_rx_urbs(struct hif_device_usb *hif_dev)
 {
 	usb_kill_anchored_urbs(&hif_dev->rx_submitted);
+	ath9k_hif_usb_free_rx_remain_skb(hif_dev);
 }
 
 static int ath9k_hif_usb_alloc_rx_urbs(struct hif_device_usb *hif_dev)
-- 
2.39.2



