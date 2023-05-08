Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27352168A7
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:34:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D2C1C433EF;
	Mon,  8 May 2023 10:34:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683542061;
	bh=RTRnU4UMupNEc1dlEDn+cU8wfJuHpYTRTC1O1DwNU6U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IrEuh1TbP6S3fqtapgyY1POVDYddMO59q5/0uR43qS8GaEjkjwx34qTx82w36vTfu
	 3lId1e8ycmrFNRNkEhpayS1KhMd4cbko5KkChEZ0eu+acDD2eE4Kn6/n/VGoeDv8aC
	 FuLG1GOaV89hj9Ni92zVtNPYRGIFo6ZAl73yxC3A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	Alexey Khoroshilov <khoroshilov@ispras.ru>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 281/663] wifi: ath9k: hif_usb: fix memory leak of remain_skbs
Date: Mon,  8 May 2023 11:41:47 +0200
Message-Id: <20230508094437.345509134@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094428.384831245@linuxfoundation.org>
References: <20230508094428.384831245@linuxfoundation.org>
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
index f521dfa2f1945..e0130beb304df 100644
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



