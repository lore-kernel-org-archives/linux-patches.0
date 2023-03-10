Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A28A9847E
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 13:47:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC475C4339E;
	Fri, 10 Mar 2023 13:47:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678456059;
	bh=5AqFIXHo3XPoCCjNXubvIOZGKq2Wd7n5trrl0V2l9lY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=12j9nDu2khT2N3k7fLjVtGuJLufDGmj/Rp3Wk0fYGnICUalyuRPQJpQAWcmv+4id8
	 +7NP9deZYc4/yGEOotFOXsibd+oHGHgYC1/5KV1/qwGFXP0+ouwNPl3PvMl5KIqCdm
	 XI4LMHlZb0PAAxoq+DtfIPWxucEHmAJDUh6M3/AI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+e008dccab31bd3647609@syzkaller.appspotmail.com,
	syzbot+6692c72009680f7c4eb2@syzkaller.appspotmail.com,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	Alexey Khoroshilov <khoroshilov@ispras.ru>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 037/193] wifi: ath9k: htc_hst: free skb in ath9k_htc_rx_msg() if there is no callback function
Date: Fri, 10 Mar 2023 14:36:59 +0100
Message-Id: <20230310133712.195210343@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133710.926811681@linuxfoundation.org>
References: <20230310133710.926811681@linuxfoundation.org>
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

[ Upstream commit 9b25e3985477ac3f02eca5fc1e0cc6850a3f7e69 ]

It is stated that ath9k_htc_rx_msg() either frees the provided skb or
passes its management to another callback function. However, the skb is
not freed in case there is no another callback function, and Syzkaller was
able to cause a memory leak. Also minor comment fix.

Found by Linux Verification Center (linuxtesting.org) with Syzkaller.

Fixes: fb9987d0f748 ("ath9k_htc: Support for AR9271 chipset.")
Reported-by: syzbot+e008dccab31bd3647609@syzkaller.appspotmail.com
Reported-by: syzbot+6692c72009680f7c4eb2@syzkaller.appspotmail.com
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
Acked-by: Toke Høiland-Jørgensen <toke@toke.dk>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/20230104123546.51427-1-pchelkin@ispras.ru
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath9k/htc_hst.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_hst.c b/drivers/net/wireless/ath/ath9k/htc_hst.c
index 6d69cf69fd86e..6331c98088e03 100644
--- a/drivers/net/wireless/ath/ath9k/htc_hst.c
+++ b/drivers/net/wireless/ath/ath9k/htc_hst.c
@@ -394,7 +394,7 @@ static void ath9k_htc_fw_panic_report(struct htc_target *htc_handle,
  * HTC Messages are handled directly here and the obtained SKB
  * is freed.
  *
- * Service messages (Data, WMI) passed to the corresponding
+ * Service messages (Data, WMI) are passed to the corresponding
  * endpoint RX handlers, which have to free the SKB.
  */
 void ath9k_htc_rx_msg(struct htc_target *htc_handle,
@@ -481,6 +481,8 @@ void ath9k_htc_rx_msg(struct htc_target *htc_handle,
 		if (endpoint->ep_callbacks.rx)
 			endpoint->ep_callbacks.rx(endpoint->ep_callbacks.priv,
 						  skb, epid);
+		else
+			goto invalid;
 	}
 }
 
-- 
2.39.2



