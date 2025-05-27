Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0973A27D786;
	Tue, 27 May 2025 17:37:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367449; cv=none; b=u4xu9i1tO5Do0ve/hm6/g7yuLPCh7vTFnr/I3hf2VrTCwGCz9c2McGe23u10aWY/yE7qKO1QHa2X9gYGcBQ//Og00CVoM4Dg1SZX8k/1BOoKWfgh9re+9M3pKp1hRZ6tpIy3NoxXPBZHS/bJDsKzoBeSNlcCOHHB+5Mgxj0WsBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367449; c=relaxed/simple;
	bh=AmrQ0oaYaFWfi5zEYWbVmb/S0SOXHVOO6wH9zTVTH0Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ckkTt9pGzyPh+doHF8a1UHg5ItdR8RLc+CVxs4h0WeXAv8jbtnZbf3SQDxJ1XPK+sX6p2VuHGkgq3GME23qEEJMCeULy+dpHdYCYugevcd5csfMjYli4uSJ0gy1ty5Pm6r+Ex3609X+BhcStK4pBAee3Az3sEnhiFp4FQezj5X4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ypKja+aS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ypKja+aS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 837BEC4CEE9;
	Tue, 27 May 2025 17:37:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367448;
	bh=AmrQ0oaYaFWfi5zEYWbVmb/S0SOXHVOO6wH9zTVTH0Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ypKja+aSaY3BPksp9ZD3DPlgN+CYI0rCBmHVk+PA/82SJ22oTrwjnI9tX2cse7rai
	 lxgyqVeFZ9Qw6htvYJjmSifS2L8cAiqGznlWpgslVasqJGbcUm4A88eMFi1puIVq7Q
	 OZ2A0/N1t5QWLX6xUXpPSrdUQ7BjfHXXXiyEKka8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 392/783] wifi: rtw88: Fix rtw_init_vht_cap() for RTL8814AU
Date: Tue, 27 May 2025 18:23:09 +0200
Message-ID: <20250527162529.055312143@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bitterblue Smith <rtl8821cerfe2@gmail.com>

[ Upstream commit 6be7544d19fcfcb729495e793bc6181f85bb8949 ]

Set the MCS maps and the highest rates according to the number of
spatial streams the chip has. For RTL8814AU that is 3.

Signed-off-by: Bitterblue Smith <rtl8821cerfe2@gmail.com>
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/e86aa009-b5bf-4b3a-8112-ea5e3cd49465@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw88/main.c | 23 +++++++++--------------
 1 file changed, 9 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/main.c b/drivers/net/wireless/realtek/rtw88/main.c
index 0cee0fd8c0ef0..d66abb31f091b 100644
--- a/drivers/net/wireless/realtek/rtw88/main.c
+++ b/drivers/net/wireless/realtek/rtw88/main.c
@@ -1597,8 +1597,9 @@ static void rtw_init_vht_cap(struct rtw_dev *rtwdev,
 			     struct ieee80211_sta_vht_cap *vht_cap)
 {
 	struct rtw_efuse *efuse = &rtwdev->efuse;
-	u16 mcs_map;
+	u16 mcs_map = 0;
 	__le16 highest;
+	int i;
 
 	if (efuse->hw_cap.ptcl != EFUSE_HW_CAP_IGNORE &&
 	    efuse->hw_cap.ptcl != EFUSE_HW_CAP_PTCL_VHT)
@@ -1621,21 +1622,15 @@ static void rtw_init_vht_cap(struct rtw_dev *rtwdev,
 	if (rtw_chip_has_rx_ldpc(rtwdev))
 		vht_cap->cap |= IEEE80211_VHT_CAP_RXLDPC;
 
-	mcs_map = IEEE80211_VHT_MCS_SUPPORT_0_9 << 0 |
-		  IEEE80211_VHT_MCS_NOT_SUPPORTED << 4 |
-		  IEEE80211_VHT_MCS_NOT_SUPPORTED << 6 |
-		  IEEE80211_VHT_MCS_NOT_SUPPORTED << 8 |
-		  IEEE80211_VHT_MCS_NOT_SUPPORTED << 10 |
-		  IEEE80211_VHT_MCS_NOT_SUPPORTED << 12 |
-		  IEEE80211_VHT_MCS_NOT_SUPPORTED << 14;
-	if (efuse->hw_cap.nss > 1) {
-		highest = cpu_to_le16(780);
-		mcs_map |= IEEE80211_VHT_MCS_SUPPORT_0_9 << 2;
-	} else {
-		highest = cpu_to_le16(390);
-		mcs_map |= IEEE80211_VHT_MCS_NOT_SUPPORTED << 2;
+	for (i = 0; i < 8; i++) {
+		if (i < efuse->hw_cap.nss)
+			mcs_map |= IEEE80211_VHT_MCS_SUPPORT_0_9 << (i * 2);
+		else
+			mcs_map |= IEEE80211_VHT_MCS_NOT_SUPPORTED << (i * 2);
 	}
 
+	highest = cpu_to_le16(390 * efuse->hw_cap.nss);
+
 	vht_cap->vht_mcs.rx_mcs_map = cpu_to_le16(mcs_map);
 	vht_cap->vht_mcs.tx_mcs_map = cpu_to_le16(mcs_map);
 	vht_cap->vht_mcs.rx_highest = highest;
-- 
2.39.5



