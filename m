Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF06A1D1745;
	Wed,  2 Oct 2024 14:18:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878734; cv=none; b=ewzKjWWskiyjFfIZ3UOy8uYXjwI2H4vZecKKZctcsI5IFU90LqljbtwUZ23hqNng5SClhgiBgwpbMW7rBKARy2EIn6K2KuRwFydUnKiF6I9jjDsIFgNqh1JKm9HO8GEY34lbumdk8UtewdOOT6+8htf4Y3+pySsY6JDO63uPlsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878734; c=relaxed/simple;
	bh=RnSY22KKaqPvVDfznivRC3/n2lsOmUxCJ1hRD3xl1zQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T/nKRGZOT+Jxngy4NbWdc0RTqUI56wOIs1yBiHxRI/rqqhFcbhqKqIU/ebsnZsl6OOHV3z6jVXDCfynMUj/7cPhPZLbSNRoqgGvtnoHuVh+moPAbJeETxrHJJZug/aPzplP/4vWcJ9zUU4fTBiUjpm1+graxwMso+ej+t6hOPuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fsJnwOa5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fsJnwOa5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4CC2C4CEC2;
	Wed,  2 Oct 2024 14:18:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878734;
	bh=RnSY22KKaqPvVDfznivRC3/n2lsOmUxCJ1hRD3xl1zQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fsJnwOa5bDhVJmCUa0MNQUJLxGv3x63wtAkyGOAulp4z+ZuhYRy432s5jaWl5GUCf
	 1AAzSpBd45C4mOGVNmLvUou20zrLHFs1QcnTpuVqQMD0h+pUjYjBdjXudpHbWjocvj
	 l0opiRvrCZUlvWMjCxcHgEYrsLGhdEMWbrZWXwOY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>
Subject: [PATCH 6.10 515/634] wifi: rtw88: Fix USB/SDIO devices not transmitting beacons
Date: Wed,  2 Oct 2024 15:00:15 +0200
Message-ID: <20241002125831.436454075@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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


