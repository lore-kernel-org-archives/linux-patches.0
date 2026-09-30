Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 481503DEFE7;
	Wed, 30 Sep 2026 19:23:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796206; cv=none; b=JkjKi39JFoV6PZztXeGT1WznccF2F2YDIPg2AwCEs+sfWEsYRTq0y8YFsUCDczzr5LRB7KVsPp8kvEC61sVZoHrUbDs6C34wGJTgoRg1VwluS4HJOMFgfAMh8/4xXDrbsxijX4GwRtfzHgIHepkLWW1UEwiropj7ChsPAygkCOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796206; c=relaxed/simple;
	bh=IRVCtzTgb3Z1JiaKceFVF4YZxHcjf2It/jetfZd7vEY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G8pZDl7G5RjqTyMhRGfEXOqrNKkuw4gP5qO8JTPxlegXxYRToNpIUm+zQUiofvsvfCN3j2cD385eQ6cI4rUNpPypsX5HIl4CVD0j+/zXXCgjBRxAkCzcsPT447jcDTwfcbiNgqSvVCfffCGi1LsAaqGEopOcES69q10fEfP1cyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BDnb1+pt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BDnb1+pt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A42EE1F000FF;
	Wed, 30 Sep 2026 19:23:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796205;
	bh=xLJKpBnCtwfY2lLyCBYExMv3mvLD/8Pgjw3Z3a9DVeY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BDnb1+pt37T6HAgX7kVq6Mj0fkE9oke/o7IUM7rLJJ10Bfpml54Ys2ed4d/JRTG70
	 FPzQ+sREUcOLIdgSWTqhK8rCDg8Ks6a1xW+R/gttsEYyPNnFsfc6XxE9LtR3js7tKY
	 iAYYz312z3k2K1M0I1Lr5g9yVrdpwY27+YWhw+Io=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0831/1193] wifi: rtw88: Fix the random "error beacon valid" messages for USB
Date: Wed, 30 Sep 2026 17:25:15 +0200
Message-ID: <20260930152452.706516518@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bitterblue Smith <rtl8821cerfe2@gmail.com>

[ Upstream commit f24d0d8c3cd7e4237f802c4d2f3bd4ac04572948 ]

All the USB devices have a problem in AP mode: uploading the updated
beacon to the chip's reserved page can randomly fail:

[34996.474304] rtw88_8723du 1-2:1.2: error beacon valid
[34996.474788] rtw88_8723du 1-2:1.2: failed to download drv rsvd page
[34999.956369] rtw88_8723du 1-2:1.2: error beacon valid
[34999.956846] rtw88_8723du 1-2:1.2: failed to download drv rsvd page
[34999.956855] rtw88_8723du 1-2:1.2: failed to download beacon
[35017.978296] rtw88_8723du 1-2:1.2: error beacon valid
[35017.978805] rtw88_8723du 1-2:1.2: failed to download drv rsvd page
[35017.978823] rtw88_8723du 1-2:1.2: failed to download beacon
[35023.200395] rtw88_8723du 1-2:1.2: error beacon valid
[35023.200869] rtw88_8723du 1-2:1.2: failed to download drv rsvd page
[35023.200875] rtw88_8723du 1-2:1.2: failed to download beacon
[35478.680547] rtw88_8723du 1-2:1.2: error beacon valid
[35478.681023] rtw88_8723du 1-2:1.2: failed to download drv rsvd page

Disable some beacon-related hardware functions before uploading the
beacon and enable them again after.

Tested with RTL8723DU, RTL8812BU, RTL8822CE.

Signed-off-by: Bitterblue Smith <rtl8821cerfe2@gmail.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/c248c40a-d432-47ed-90e0-d81ee6c32464@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw88/fw.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw88/fw.c b/drivers/net/wireless/realtek/rtw88/fw.c
index 2e0ca3bc5670f..1bb9641ea64ac 100644
--- a/drivers/net/wireless/realtek/rtw88/fw.c
+++ b/drivers/net/wireless/realtek/rtw88/fw.c
@@ -1366,7 +1366,7 @@ void rtw_add_rsvd_page_sta(struct rtw_dev *rtwdev,
 int rtw_fw_write_data_rsvd_page(struct rtw_dev *rtwdev, u16 pg_addr,
 				u8 *buf, u32 size)
 {
-	u8 bckp[2];
+	u8 bckp[3];
 	u8 val;
 	u16 rsvd_pg_head;
 	u32 bcn_valid_addr;
@@ -1378,6 +1378,8 @@ int rtw_fw_write_data_rsvd_page(struct rtw_dev *rtwdev, u16 pg_addr,
 	if (!size)
 		return -EINVAL;
 
+	bckp[2] = rtw_read8(rtwdev, REG_BCN_CTRL);
+
 	if (rtw_chip_wcpu_11n(rtwdev)) {
 		rtw_write32_set(rtwdev, REG_DWBCN0_CTRL, BIT_BCN_VALID);
 	} else {
@@ -1391,6 +1393,9 @@ int rtw_fw_write_data_rsvd_page(struct rtw_dev *rtwdev, u16 pg_addr,
 	val |= BIT_ENSWBCN >> 8;
 	rtw_write8(rtwdev, REG_CR + 1, val);
 
+	rtw_write8(rtwdev, REG_BCN_CTRL,
+		   (bckp[2] & ~BIT_EN_BCN_FUNCTION) | BIT_DIS_TSF_UDT);
+
 	if (rtw_hci_type(rtwdev) == RTW_HCI_TYPE_PCIE) {
 		val = rtw_read8(rtwdev, REG_FWHW_TXQ_CTRL + 2);
 		bckp[1] = val;
@@ -1421,6 +1426,7 @@ int rtw_fw_write_data_rsvd_page(struct rtw_dev *rtwdev, u16 pg_addr,
 	rsvd_pg_head = rtwdev->fifo.rsvd_boundary;
 	rtw_write16(rtwdev, REG_FIFOPAGE_CTRL_2,
 		    rsvd_pg_head | BIT_BCN_VALID_V1);
+	rtw_write8(rtwdev, REG_BCN_CTRL, bckp[2]);
 	if (rtw_hci_type(rtwdev) == RTW_HCI_TYPE_PCIE)
 		rtw_write8(rtwdev, REG_FWHW_TXQ_CTRL + 2, bckp[1]);
 	rtw_write8(rtwdev, REG_CR + 1, bckp[0]);
-- 
2.53.0



