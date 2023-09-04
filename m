Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D683C142
	for <patches@lists.linux.dev>; Mon,  4 Sep 2023 18:32:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C57B2C433C9;
	Mon,  4 Sep 2023 18:32:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693852354;
	bh=K6tqkHjoNKKHn/bJFgv/yfEzFFsKwpFxFPtERHwWVF0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j5eOE2kluqci9S361ksYCkUSBvQR5uMKnOZnhPqUE65joADDZYmNFz8GBE1LThIdS
	 BN8F4MO6yQuChlaasDWBtJf1LgJPhOLWPo125kozb2yO+/SHjyKHvxff9EGBlMZVRG
	 dngrQ/ebW0Z9ueTZAwvBIyVv2eghBfYCFkvYVNdg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilgaz=20=C3=96cal?= <ilgaz@ilgaz.gen.tr>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Kalle Valo <kvalo@kernel.org>
Subject: [PATCH 6.5 21/34] wifi: rtw88: usb: kill and free rx urbs on probe failure
Date: Mon,  4 Sep 2023 19:30:08 +0100
Message-ID: <20230904182949.584425602@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230904182948.594404081@linuxfoundation.org>
References: <20230904182948.594404081@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sascha Hauer <s.hauer@pengutronix.de>

commit 290564367ab7fa7e2048bdc00d9c0ad016b41eea upstream.

After rtw_usb_alloc_rx_bufs() has been called rx urbs have been
allocated and must be freed in the error path. After rtw_usb_init_rx()
has been called they are submitted, so they also must be killed.

Add these forgotten steps to the probe error path.

Besides the lost memory this also fixes a problem when the driver
fails to download the firmware in rtw_chip_info_setup(). In this
case it can happen that the completion of the rx urbs handler runs
at a time when we already freed our data structures resulting in
a kernel crash.

Fixes: a82dfd33d123 ("wifi: rtw88: Add common USB chip support")
Cc: stable@vger.kernel.org
Reported-by: Ilgaz Öcal <ilgaz@ilgaz.gen.tr>
Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Acked-by: Larry Finger <Larry.Finger@lwfinger.net>
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20230823075021.588596-1-s.hauer@pengutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/realtek/rtw88/usb.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/realtek/rtw88/usb.c
+++ b/drivers/net/wireless/realtek/rtw88/usb.c
@@ -844,7 +844,7 @@ int rtw_usb_probe(struct usb_interface *
 
 	ret = rtw_core_init(rtwdev);
 	if (ret)
-		goto err_release_hw;
+		goto err_free_rx_bufs;
 
 	ret = rtw_usb_intf_init(rtwdev, intf);
 	if (ret) {
@@ -890,6 +890,9 @@ err_destroy_usb:
 err_deinit_core:
 	rtw_core_deinit(rtwdev);
 
+err_free_rx_bufs:
+	rtw_usb_free_rx_bufs(rtwusb);
+
 err_release_hw:
 	ieee80211_free_hw(hw);
 


