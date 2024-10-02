Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EA8C16F84F;
	Wed,  2 Oct 2024 13:47:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876840; cv=none; b=I2WvO8wS0H9Y7Huyb9W9TWGLjhuvcBWzbooO37JBGbilK8y3gyugG3ZA9p67NGLh5lmUrC5CN4IGhL2DGosRs8liMPjkiyj34PDfR0WcczKq5ahGO/S7W3iCBjG/W4JI8AGT0DN0pdFGQ/8tHxOMZSvygdGZr+mRHXoQ8B0fPI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876840; c=relaxed/simple;
	bh=rzZMKV4RbIFb+wdKybk8j/aIv+cPOfBzXskMEUEXqrU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uuKUmI2HHvMfKNnR4aZNrZ3lvlW7tjcf48E2uTNut5X0ZSWOxwqvud+S51c1AZPzCtW2C3O3UoRdV+Rn/KcFR46Ngrwqlu53jLnEHjjjIiK6pIAibjcct2cBjWxCNexln0O02wYL1KflkEIJLv3ZbNF0xuHN9/xUfXWM33RyERw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lJoulpKY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lJoulpKY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D37EC4CEC2;
	Wed,  2 Oct 2024 13:47:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876839;
	bh=rzZMKV4RbIFb+wdKybk8j/aIv+cPOfBzXskMEUEXqrU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lJoulpKYPGiKILYneDqDGRgepKzKkhZCgfG9LUmKBGDB9v9+MQmRqMIM42foImWRu
	 8iw9uPxhl2YlAsZBDewvu9v7Z1VzkuaaczkxlQEScqC+4ipuYdSAZDRL0zWxj32zAI
	 OZCS7NoRTrGLngPHacYXiZrjIX61FgjVjpa/puD8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>
Subject: [PATCH 6.11 577/695] wifi: rtw88: Fix USB/SDIO devices not transmitting beacons
Date: Wed,  2 Oct 2024 14:59:35 +0200
Message-ID: <20241002125845.543440309@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bitterblue Smith <rtl8821cerfe2@gmail.com>

commit faa2e484b393c56bc1243dca6676a70bc485f775 upstream.

All USB devices supported by rtw88 have the same problem: they don't
transmit beacons in AP mode. (Some?) SDIO devices are also affected.
The cause appears to be clearing BIT_EN_BCNQ_DL of REG_FWHW_TXQ_CTRL
before uploading the beacon reserved page, so don't clear the bit for
USB and SDIO devices.

Tested with RTL8811CU and RTL8723DU.

Cc: <stable@vger.kernel.org> # 6.6.x
Signed-off-by: Bitterblue Smith <rtl8821cerfe2@gmail.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/49de73b5-698f-4865-ab63-100e28dfc4a1@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/realtek/rtw88/fw.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/drivers/net/wireless/realtek/rtw88/fw.c
+++ b/drivers/net/wireless/realtek/rtw88/fw.c
@@ -1468,10 +1468,12 @@ int rtw_fw_write_data_rsvd_page(struct r
 	val |= BIT_ENSWBCN >> 8;
 	rtw_write8(rtwdev, REG_CR + 1, val);
 
-	val = rtw_read8(rtwdev, REG_FWHW_TXQ_CTRL + 2);
-	bckp[1] = val;
-	val &= ~(BIT_EN_BCNQ_DL >> 16);
-	rtw_write8(rtwdev, REG_FWHW_TXQ_CTRL + 2, val);
+	if (rtw_hci_type(rtwdev) == RTW_HCI_TYPE_PCIE) {
+		val = rtw_read8(rtwdev, REG_FWHW_TXQ_CTRL + 2);
+		bckp[1] = val;
+		val &= ~(BIT_EN_BCNQ_DL >> 16);
+		rtw_write8(rtwdev, REG_FWHW_TXQ_CTRL + 2, val);
+	}
 
 	ret = rtw_hci_write_data_rsvd_page(rtwdev, buf, size);
 	if (ret) {
@@ -1496,7 +1498,8 @@ restore:
 	rsvd_pg_head = rtwdev->fifo.rsvd_boundary;
 	rtw_write16(rtwdev, REG_FIFOPAGE_CTRL_2,
 		    rsvd_pg_head | BIT_BCN_VALID_V1);
-	rtw_write8(rtwdev, REG_FWHW_TXQ_CTRL + 2, bckp[1]);
+	if (rtw_hci_type(rtwdev) == RTW_HCI_TYPE_PCIE)
+		rtw_write8(rtwdev, REG_FWHW_TXQ_CTRL + 2, bckp[1]);
 	rtw_write8(rtwdev, REG_CR + 1, bckp[0]);
 
 	return ret;


