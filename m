Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A9414E73B2;
	Wed, 30 Sep 2026 17:16:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788587; cv=none; b=kA07B5D7ftIknEzdOozT5cOsz/OBceDffoxqt7yEUczPSbwWz5+Gu+LoAlqwLaM8Q0U2axA4I1WkcxOnYZ9rYnLSxg5TvMLc0MkGP9V+kuLlnuPj32hkU7NYs0Uz9PS/dPOqmO4NsuFp1jwrjmmqvtg0f1K96hHOEnL9YvVHhEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788587; c=relaxed/simple;
	bh=RQ0KKr0ODAd0hZ987o/hhG++5500AGieYGycKaHQG8s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UJsvFO75VXjUSroxnDavG6kxR/HUB47DUAeOC+AOnM9wZDGhRZZlvSnFNvxo6NWfD0ESx09hVUUhOHEGjI3ENHiPF6H5GjHNJyFcAnOQ+5s98otMNHcVRkvFFgU7pPFwrGdrxlOU7YUSBFC2o9N8dN01kK2a2OmdAhwELLwLmr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q9rCrJVt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q9rCrJVt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA5F31F000FF;
	Wed, 30 Sep 2026 17:16:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788586;
	bh=mjxarR23pBwyOURrZwesAA8QbpsJ5xb/cFoepjesXLo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q9rCrJVtXGhBBrrqnCJLfSzjTAuDHuMZeGSSNTRyhH8VcIrEn8qHi8mMlRKWnKz8j
	 QxdpjjepajQgTkGeKsTLz0hipFYZqYx4BIJydArS9tlhC1y31Uc+BSjr7OET58sCal
	 +A5KIJqr/hNR/dYih9dt236lEW4wA9kt2WnDR2/M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 160/877] wifi: rtw88: Fix the random "error beacon valid" messages for USB
Date: Wed, 30 Sep 2026 17:17:51 +0200
Message-ID: <20260930152418.172061535@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 43e3df6a48369..fd3bcb4466209 100644
--- a/drivers/net/wireless/realtek/rtw88/fw.c
+++ b/drivers/net/wireless/realtek/rtw88/fw.c
@@ -1446,7 +1446,7 @@ void rtw_add_rsvd_page_sta(struct rtw_dev *rtwdev,
 int rtw_fw_write_data_rsvd_page(struct rtw_dev *rtwdev, u16 pg_addr,
 				u8 *buf, u32 size)
 {
-	u8 bckp[2];
+	u8 bckp[3];
 	u8 val;
 	u16 rsvd_pg_head;
 	u32 bcn_valid_addr;
@@ -1458,6 +1458,8 @@ int rtw_fw_write_data_rsvd_page(struct rtw_dev *rtwdev, u16 pg_addr,
 	if (!size)
 		return -EINVAL;
 
+	bckp[2] = rtw_read8(rtwdev, REG_BCN_CTRL);
+
 	if (rtw_chip_wcpu_11n(rtwdev)) {
 		rtw_write32_set(rtwdev, REG_DWBCN0_CTRL, BIT_BCN_VALID);
 	} else {
@@ -1471,6 +1473,9 @@ int rtw_fw_write_data_rsvd_page(struct rtw_dev *rtwdev, u16 pg_addr,
 	val |= BIT_ENSWBCN >> 8;
 	rtw_write8(rtwdev, REG_CR + 1, val);
 
+	rtw_write8(rtwdev, REG_BCN_CTRL,
+		   (bckp[2] & ~BIT_EN_BCN_FUNCTION) | BIT_DIS_TSF_UDT);
+
 	if (rtw_hci_type(rtwdev) == RTW_HCI_TYPE_PCIE) {
 		val = rtw_read8(rtwdev, REG_FWHW_TXQ_CTRL + 2);
 		bckp[1] = val;
@@ -1501,6 +1506,7 @@ int rtw_fw_write_data_rsvd_page(struct rtw_dev *rtwdev, u16 pg_addr,
 	rsvd_pg_head = rtwdev->fifo.rsvd_boundary;
 	rtw_write16(rtwdev, REG_FIFOPAGE_CTRL_2,
 		    rsvd_pg_head | BIT_BCN_VALID_V1);
+	rtw_write8(rtwdev, REG_BCN_CTRL, bckp[2]);
 	if (rtw_hci_type(rtwdev) == RTW_HCI_TYPE_PCIE)
 		rtw_write8(rtwdev, REG_FWHW_TXQ_CTRL + 2, bckp[1]);
 	rtw_write8(rtwdev, REG_CR + 1, bckp[0]);
-- 
2.53.0



