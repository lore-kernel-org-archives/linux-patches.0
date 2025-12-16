Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26EA536A007;
	Tue, 16 Dec 2025 12:16:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887384; cv=none; b=u5ZGt1o2VtwkffFY0wXTr7cDTyygoZDo978kihP7o0ebUGkpOmRE6E6d2Rzv8uW1NOpy8hb5dimxxOmp5JiDGPV8BmDH/kwMrpDPPsax3gIUUxwY9vTO71yochS4px7ZVdCCWXdDu/bKaoos82E3KB3fFzZblC/yA30UecZ6UOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887384; c=relaxed/simple;
	bh=7tRkci2JoKpFtLhfaHrVd4ynIZOiPOncbBF04BLtqX8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cct6wgwzSwvqbgVZHLb3mlPTmyzeMaiCvn6TqrzhEtVDJ0x05POfwNSsUEBCxrrerIK0GeDSwH+7yhmOk1ulCGUTdPHmsJS5YVlrVqKBdNz3w2StSMGJFFLnolp+PE/bvLQvJoJWiyjRr9Anm3LeO2h+6pbQIkycNbkXYrCL8Vg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X3h9pPNW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X3h9pPNW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 900E1C4CEF1;
	Tue, 16 Dec 2025 12:16:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887383;
	bh=7tRkci2JoKpFtLhfaHrVd4ynIZOiPOncbBF04BLtqX8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X3h9pPNWNW/c0TsDd3lHrOZ5cNOfTqasIRXxWikeS9PFPNXgh+SgSuZagj1RRecKe
	 ZBZm8AMSs9H2xSdqIbRlCI8fKYTseBHC76x3MPIDCtKPjg8gXrAsg09mgdNbrnlaGH
	 LHmM7hXvpKjyX40mALynnStYNtb1KNB4I/dHDGjs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ping-Ke Shih <pkshih@realtek.com>,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 214/614] wifi: rtw89: usb: fix leak in rtw89_usb_write_port()
Date: Tue, 16 Dec 2025 12:09:41 +0100
Message-ID: <20251216111409.130251549@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fedor Pchelkin <pchelkin@ispras.ru>

[ Upstream commit 7543818e97d5d54b3b2f75f1c4dedee298d7d914 ]

When there is an attempt to write data and RTW89_FLAG_UNPLUGGED is set,
this means device is disconnected and no urb is submitted.  Return
appropriate error code to the caller to properly free the allocated
resources.

Found by Linux Verification Center (linuxtesting.org).

Fixes: 2135c28be6a8 ("wifi: rtw89: Add usb.{c,h}")
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20251104135720.321110-3-pchelkin@ispras.ru
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/usb.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/usb.c b/drivers/net/wireless/realtek/rtw89/usb.c
index e8e064cf7e0ad..512a46dd9d06a 100644
--- a/drivers/net/wireless/realtek/rtw89/usb.c
+++ b/drivers/net/wireless/realtek/rtw89/usb.c
@@ -256,7 +256,7 @@ static int rtw89_usb_write_port(struct rtw89_dev *rtwdev, u8 ch_dma,
 	int ret;
 
 	if (test_bit(RTW89_FLAG_UNPLUGGED, rtwdev->flags))
-		return 0;
+		return -ENODEV;
 
 	urb = usb_alloc_urb(0, GFP_ATOMIC);
 	if (!urb)
@@ -305,8 +305,9 @@ static void rtw89_usb_ops_tx_kick_off(struct rtw89_dev *rtwdev, u8 txch)
 		ret = rtw89_usb_write_port(rtwdev, txch, skb->data, skb->len,
 					   txcb);
 		if (ret) {
-			rtw89_err(rtwdev, "write port txch %d failed: %d\n",
-				  txch, ret);
+			if (ret != -ENODEV)
+				rtw89_err(rtwdev, "write port txch %d failed: %d\n",
+					  txch, ret);
 
 			skb_dequeue(&txcb->tx_ack_queue);
 			kfree(txcb);
-- 
2.51.0



