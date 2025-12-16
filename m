Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B1AA34D4E4;
	Tue, 16 Dec 2025 11:46:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885573; cv=none; b=Q1EBLz7jiCrPkcYFox5cYqJlHjxnhohTTiDg7Swle5mipviZ1wLPJGHvOuQcdFXDekFKaNVuFxixwhVnPo5CblmPOH/XWpdxURQB8FFt5Kma00TDuGNvqz0Bp1uogsSNbG7GPf7Qx9LDCXDvp6xULOsQb/c4gWaroeEQQaW/05s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885573; c=relaxed/simple;
	bh=GIxtYbxndGivMtFEiNsihimEWt3v3JhpQycptS0iHtQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=auA7vG5RiI/5VD28R72GZ5wzjb+10b1wXDCJTb2PHM4WQTNDOHD4hbHuLD9rYxv+EEPlfGYN1TRgid8CuvUw6QqRQmlGqrLDHJhC75mnSdUK7WbIsHd3qt5bNG2RNcMilpUXU/PrVqP+y3hBOct3KFDq7CB5LkqyvDcg4NHaje8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JvEf9bNf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JvEf9bNf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5A89C4CEF1;
	Tue, 16 Dec 2025 11:46:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885573;
	bh=GIxtYbxndGivMtFEiNsihimEWt3v3JhpQycptS0iHtQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JvEf9bNfjmIQvyIikBPlZAD2GuxUqgKl/+lM8PiAIgaaswfmNQ6VUEuxEJOmBz0fD
	 PFOa4ZkE4nSPFJMzQfwlZk8jg1o/1e3uLqm4SGQNLTsj8Icyvi3mrTJcIxEX5GFJ7g
	 QrpvUaCTfruNYsLKJ5afgr6ap8snwvr1uOOMhOc4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ping-Ke Shih <pkshih@realtek.com>,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 180/507] wifi: rtw89: usb: use common error path for skbs in rtw89_usb_rx_handler()
Date: Tue, 16 Dec 2025 12:10:21 +0100
Message-ID: <20251216111352.037679175@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fedor Pchelkin <pchelkin@ispras.ru>

[ Upstream commit 28a45575289f3292aa9cb7bacae18ba3ee7a6adf ]

Allow adding rx_skb to rx_free_queue for later reuse on the common error
handling path, otherwise free it.

Found by Linux Verification Center (linuxtesting.org).

Fixes: 2135c28be6a8 ("wifi: rtw89: Add usb.{c,h}")
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20251104135720.321110-2-pchelkin@ispras.ru
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/usb.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/usb.c b/drivers/net/wireless/realtek/rtw89/usb.c
index 6cf89aee252ed..e8e064cf7e0ad 100644
--- a/drivers/net/wireless/realtek/rtw89/usb.c
+++ b/drivers/net/wireless/realtek/rtw89/usb.c
@@ -410,8 +410,7 @@ static void rtw89_usb_rx_handler(struct work_struct *work)
 
 		if (skb_queue_len(&rtwusb->rx_queue) >= RTW89_USB_MAX_RXQ_LEN) {
 			rtw89_warn(rtwdev, "rx_queue overflow\n");
-			dev_kfree_skb_any(rx_skb);
-			continue;
+			goto free_or_reuse;
 		}
 
 		memset(&desc_info, 0, sizeof(desc_info));
@@ -422,7 +421,7 @@ static void rtw89_usb_rx_handler(struct work_struct *work)
 			rtw89_debug(rtwdev, RTW89_DBG_HCI,
 				    "failed to allocate RX skb of size %u\n",
 				    desc_info.pkt_size);
-			continue;
+			goto free_or_reuse;
 		}
 
 		pkt_offset = desc_info.offset + desc_info.rxd_len;
@@ -432,6 +431,7 @@ static void rtw89_usb_rx_handler(struct work_struct *work)
 
 		rtw89_core_rx(rtwdev, &desc_info, skb);
 
+free_or_reuse:
 		if (skb_queue_len(&rtwusb->rx_free_queue) >= RTW89_USB_RX_SKB_NUM)
 			dev_kfree_skb_any(rx_skb);
 		else
-- 
2.51.0



