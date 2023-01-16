Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B18AD6FA3
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 17:03:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39977C433F0;
	Mon, 16 Jan 2023 17:03:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673888598;
	bh=S040irBgOTf69HQRXgmfdaVxhGrH5G+wOC9zTXVmor4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lSW9PXlBkTViKfgU8GU6N5zVgYSfZFn9+5Vy2R2PJW58kWGnmG8sTIRhZmJlO8O+D
	 P6iHMWhzcIItEcb/jNDAMd1WVS/uqkWQTrpm8KzLBm/E5ESCgnmDEd2anea5827BC4
	 kqvq2pEEmkgmO6LVq2keSoKV1JoRCVFLCg8KMb9I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	Alexey Khoroshilov <khoroshilov@ispras.ru>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 066/338] wifi: ath9k: hif_usb: fix memory leak of urbs in ath9k_hif_usb_dealloc_tx_urbs()
Date: Mon, 16 Jan 2023 16:48:59 +0100
Message-Id: <20230116154823.726379950@linuxfoundation.org>
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

[ Upstream commit c2a94de38c74e86f49124ac14f093d6a5c377a90 ]

Syzkaller reports a long-known leak of urbs in
ath9k_hif_usb_dealloc_tx_urbs().

The cause of the leak is that usb_get_urb() is called but usb_free_urb()
(or usb_put_urb()) is not called inside usb_kill_urb() as urb->dev or
urb->ep fields have not been initialized and usb_kill_urb() returns
immediately.

The patch removes trying to kill urbs located in hif_dev->tx.tx_buf
because hif_dev->tx.tx_buf is not supposed to contain urbs which are in
pending state (the pending urbs are stored in hif_dev->tx.tx_pending).
The tx.tx_lock is acquired so there should not be any changes in the list.

Found by Linux Verification Center (linuxtesting.org) with Syzkaller.

Fixes: 03fb92a432ea ("ath9k: hif_usb: fix race condition between usb_get_urb() and usb_kill_anchored_urbs()")
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
Acked-by: Toke Høiland-Jørgensen <toke@toke.dk>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/20220725151359.283704-1-pchelkin@ispras.ru
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath9k/hif_usb.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
index 8125f1752651..039f5d76685e 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -779,14 +779,10 @@ static void ath9k_hif_usb_dealloc_tx_urbs(struct hif_device_usb *hif_dev)
 	spin_lock_irqsave(&hif_dev->tx.tx_lock, flags);
 	list_for_each_entry_safe(tx_buf, tx_buf_tmp,
 				 &hif_dev->tx.tx_buf, list) {
-		usb_get_urb(tx_buf->urb);
-		spin_unlock_irqrestore(&hif_dev->tx.tx_lock, flags);
-		usb_kill_urb(tx_buf->urb);
 		list_del(&tx_buf->list);
 		usb_free_urb(tx_buf->urb);
 		kfree(tx_buf->buf);
 		kfree(tx_buf);
-		spin_lock_irqsave(&hif_dev->tx.tx_lock, flags);
 	}
 	spin_unlock_irqrestore(&hif_dev->tx.tx_lock, flags);
 
-- 
2.35.1



