Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C344C847A
	for <patches@lists.linux.dev>; Wed,  1 Mar 2023 18:09:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FDF1C433EF;
	Wed,  1 Mar 2023 18:09:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1677694167;
	bh=lHniOpzs4HdqPnBXOB8sQQfe0Waf7GG9+upik+/4H7M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KWY16IOpXBfTvvGcC5VENN9tqtbs9zdq8G5eeQbrxxsdrjR2EC5gDiILfRSYW5/ZJ
	 ewp4nXtZzFrFU9qie3qCGaehCm7iZYJUPmbgIm6g/93/3U6GhYH0HjWlrzP3LvFUKY
	 +fVpgrO0VoP5YSq8VPfFCBRjJNUyb2bneW/iygzs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Kalle Valo <kvalo@kernel.org>
Subject: [PATCH 6.2 09/16] wifi: rtw88: usb: send Zero length packets if necessary
Date: Wed,  1 Mar 2023 19:07:45 +0100
Message-Id: <20230301180653.639532304@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230301180653.263532453@linuxfoundation.org>
References: <20230301180653.263532453@linuxfoundation.org>
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

commit 07ce9fa6ab0e5e4cb5516a1f7c754ab2758fe5cd upstream.

Zero length packets are necessary when sending URBs with size
multiple of bulkout_size, otherwise the hardware just stalls.

Fixes: a82dfd33d1237 ("wifi: rtw88: Add common USB chip support")
Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Reviewed-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20230210111632.1985205-3-s.hauer@pengutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/realtek/rtw88/usb.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/wireless/realtek/rtw88/usb.c
+++ b/drivers/net/wireless/realtek/rtw88/usb.c
@@ -271,6 +271,7 @@ static int rtw_usb_write_port(struct rtw
 		return -ENOMEM;
 
 	usb_fill_bulk_urb(urb, usbd, pipe, skb->data, skb->len, cb, context);
+	urb->transfer_flags |= URB_ZERO_PACKET;
 	ret = usb_submit_urb(urb, GFP_ATOMIC);
 
 	usb_free_urb(urb);


