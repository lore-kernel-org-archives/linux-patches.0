Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75DA713A244;
	Tue, 27 May 2025 17:06:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365608; cv=none; b=qjB6ktNz/0dweoAOYrOv8NF2FrqKdlRw04S9l4V75ZPQS0LhIBzi8sX1p33HJBSP5gkmCMpeR2hWhlzYUgqlCsSXPnWZn+xa6VpGhVsfM6N8qKZqf4fXelfx8sqoj8OdfbGyKv94YQZjpd1MpNP0sTHtko6bUCr4QsNtVU1giUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365608; c=relaxed/simple;
	bh=pI/6WB2WVs+IYqulkSb7Ku/vOcQ+dgdOq4+WsogpCuk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CYkFb+DheraSPnS/QWuZtRSxqF8dAXFM3enRxgi5W8KHFVwB1H23O+UjegeAOs7F/nhMH0CTUbPrru9Y6beLqhhjCuVKsBOB6s21WDr6IZl0I/7kFR1fpWitdhb58ED4gZedCR96pEbjnsLWPx5JK3Uel5BffIizMIwKoBxObDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QgT8O5co; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QgT8O5co"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95A36C4CEED;
	Tue, 27 May 2025 17:06:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365608;
	bh=pI/6WB2WVs+IYqulkSb7Ku/vOcQ+dgdOq4+WsogpCuk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QgT8O5co+kOSZPOQPNU7VSXsCHQKEY2uO8BlwZ2lsOfhaK5ec9EU7LESlrgPOJkc5
	 hCT9szC1zueELNJGs8xCIB3RiyMQhafsTZ/g8t6BocWDs/VQgBvSoo+pdCLgrClcMc
	 RFGXMz8jyihQxleNoAH71Qy0ZEQSZR/pqWzJH9uQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 431/626] wifi: rtw88: Fix __rtw_download_firmware() for RTL8814AU
Date: Tue, 27 May 2025 18:25:24 +0200
Message-ID: <20250527162502.520350269@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bitterblue Smith <rtl8821cerfe2@gmail.com>

[ Upstream commit 8425f5c8f04dbcf11ade78f984a494fc0b90e7a0 ]

Don't call ltecoex_read_reg() and ltecoex_reg_write() when the
ltecoex_addr member of struct rtw_chip_info is NULL. The RTL8814AU
doesn't have this feature.

Signed-off-by: Bitterblue Smith <rtl8821cerfe2@gmail.com>
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/55b5641f-094e-4f94-9f79-ac053733f2cf@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw88/mac.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/mac.c b/drivers/net/wireless/realtek/rtw88/mac.c
index 564f5988ee82a..d1c4f5cdcb21d 100644
--- a/drivers/net/wireless/realtek/rtw88/mac.c
+++ b/drivers/net/wireless/realtek/rtw88/mac.c
@@ -783,7 +783,8 @@ static int __rtw_download_firmware(struct rtw_dev *rtwdev,
 	if (!check_firmware_size(data, size))
 		return -EINVAL;
 
-	if (!ltecoex_read_reg(rtwdev, 0x38, &ltecoex_bckp))
+	if (rtwdev->chip->ltecoex_addr &&
+	    !ltecoex_read_reg(rtwdev, 0x38, &ltecoex_bckp))
 		return -EBUSY;
 
 	wlan_cpu_enable(rtwdev, false);
@@ -801,7 +802,8 @@ static int __rtw_download_firmware(struct rtw_dev *rtwdev,
 
 	wlan_cpu_enable(rtwdev, true);
 
-	if (!ltecoex_reg_write(rtwdev, 0x38, ltecoex_bckp)) {
+	if (rtwdev->chip->ltecoex_addr &&
+	    !ltecoex_reg_write(rtwdev, 0x38, ltecoex_bckp)) {
 		ret = -EBUSY;
 		goto dlfw_fail;
 	}
-- 
2.39.5



