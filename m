Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69B9429A3CA;
	Wed, 23 Apr 2025 15:35:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745422518; cv=none; b=g2cMQTNK9ySk29bICffzRYwtlrNboWufNN/sxXrD9f7p7xSHeoeYN7C5QJFJcJEnNDfGHcznuHxNiZdvCOYbuFD9kW2fUcEEtTTFFIHRT7ROjm/yN0DQoFBgSof1QKHfvxpDQQYy0pKLns6jQZ7qI4DtYHK5ySXMNVM2Gb/JJRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745422518; c=relaxed/simple;
	bh=ZB0wnSdE1F9rLx5Nc+1XmhYyg3HkUWuj5GcR7XF4g2Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lQu/krNC/tQRK9kEk9QBDzaeQUp/oMKQ2AGRP2dj8GdMjUUaiIrcrOkpp8PykXqf04T4nS18D+7SFgBl19GM6ILleBMo0/GwPYVnZt/IphmvwPQ0NhABv6qDnCMvrpwcPqdVDf0dKlL0WHKgE7CvbfQU40VFZTHOBMH9oW3Mnak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k/XASpew; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k/XASpew"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98101C4CEE2;
	Wed, 23 Apr 2025 15:35:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745422516;
	bh=ZB0wnSdE1F9rLx5Nc+1XmhYyg3HkUWuj5GcR7XF4g2Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k/XASpewt4t3xn1dKIQaSG7MDm+hQegt/xMjWoxKJjfwZyyZuLVu+zxHr7gf4bRGZ
	 6hCWWkWw85PMLbIb3Nrl7iA6krziW0V8Jg5w45izcNxYYChydtvxCqgInN+gMN1zTG
	 wrqJPDUlO1BVX8F57ZK4XmpQscswqfxGEuCYZRp4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ping-Ke Shih <pkshih@realtek.com>,
	Kalle Valo <kvalo@kernel.org>,
	Zenm Chen <zenmchen@gmail.com>
Subject: [PATCH 6.6 380/393] wifi: rtw89: pci: add pre_deinit to be called after probe complete
Date: Wed, 23 Apr 2025 16:44:36 +0200
Message-ID: <20250423142659.024336799@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ping-Ke Shih <pkshih@realtek.com>

commit 9e1aff437a560cd72cb6a60ee33fe162b0afdaf1 upstream.

At probe stage, we only do partial initialization to enable ability to
download firmware and read capabilities. After that, we use this pre_deinit
to disable HCI to save power.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20231110012319.12727-4-pkshih@realtek.com
[ Zenm: The rtw89 driver in recent kernel versions supports both Wi-Fi 6/6E
        and Wi-Fi 7, however the rtw89 driver in kernel 6.6 supports
        Wi-Fi 6/6E only, so remove the unnecessary code for Wi-Fi 7 from
        the upstream patch to make it apply on 6.6.y. ]
Signed-off-by: Zenm Chen <zenmchen@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/realtek/rtw89/core.c |    2 ++
 drivers/net/wireless/realtek/rtw89/core.h |    6 ++++++
 drivers/net/wireless/realtek/rtw89/pci.c  |    8 ++++++++
 3 files changed, 16 insertions(+)

--- a/drivers/net/wireless/realtek/rtw89/core.c
+++ b/drivers/net/wireless/realtek/rtw89/core.c
@@ -3807,6 +3807,8 @@ static int rtw89_chip_efuse_info_setup(s
 	rtw89_core_setup_phycap(rtwdev);
 	rtw89_core_setup_rfe_parms(rtwdev);
 
+	rtw89_hci_mac_pre_deinit(rtwdev);
+
 	rtw89_mac_pwr_off(rtwdev);
 
 	return 0;
--- a/drivers/net/wireless/realtek/rtw89/core.h
+++ b/drivers/net/wireless/realtek/rtw89/core.h
@@ -2989,6 +2989,7 @@ struct rtw89_hci_ops {
 	void (*write32)(struct rtw89_dev *rtwdev, u32 addr, u32 data);
 
 	int (*mac_pre_init)(struct rtw89_dev *rtwdev);
+	int (*mac_pre_deinit)(struct rtw89_dev *rtwdev);
 	int (*mac_post_init)(struct rtw89_dev *rtwdev);
 	int (*deinit)(struct rtw89_dev *rtwdev);
 
@@ -4515,6 +4516,11 @@ static inline void rtw89_hci_tx_kick_off
 	return rtwdev->hci.ops->tx_kick_off(rtwdev, txch);
 }
 
+static inline int rtw89_hci_mac_pre_deinit(struct rtw89_dev *rtwdev)
+{
+	return rtwdev->hci.ops->mac_pre_deinit(rtwdev);
+}
+
 static inline void rtw89_hci_flush_queues(struct rtw89_dev *rtwdev, u32 queues,
 					  bool drop)
 {
--- a/drivers/net/wireless/realtek/rtw89/pci.c
+++ b/drivers/net/wireless/realtek/rtw89/pci.c
@@ -2568,6 +2568,13 @@ static int rtw89_pci_ops_mac_pre_init(st
 	return 0;
 }
 
+static int rtw89_pci_ops_mac_pre_deinit(struct rtw89_dev *rtwdev)
+{
+	rtw89_pci_power_wake(rtwdev, false);
+
+	return 0;
+}
+
 int rtw89_pci_ltr_set(struct rtw89_dev *rtwdev, bool en)
 {
 	u32 val;
@@ -3812,6 +3819,7 @@ static const struct rtw89_hci_ops rtw89_
 	.write32	= rtw89_pci_ops_write32,
 
 	.mac_pre_init	= rtw89_pci_ops_mac_pre_init,
+	.mac_pre_deinit = rtw89_pci_ops_mac_pre_deinit,
 	.mac_post_init	= rtw89_pci_ops_mac_post_init,
 	.deinit		= rtw89_pci_ops_deinit,
 


