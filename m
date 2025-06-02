Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D298C22A4EF;
	Mon,  2 Jun 2025 14:16:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873766; cv=none; b=BDPVvgricysunMPjLta702K7uXrtZ4O8hzwgAYlIonPfIm8PenOJtqT9CQ7gbaM8kOYRDoRqIrZYAX0genWmH6kLeUzmzU3YoE7TEOZSbnFnl2aAbg3vaOZN0e2QXbZFp3RTPyd7mF8ErOP1Ny42CUpNcEN6grwINY97dXi/udQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873766; c=relaxed/simple;
	bh=6fQZWATQ4tMN+Uv3+++zVrjBQvD6WZCz/ZJft6xf1V4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H+F+jkmWYj69I0adr22lvd2YWRNtBNYrkA58aazIcwhORfiEoQIJBItX6HORiFuWEBqdpvMq4MgotpZ0uptNS/nWnHKvSWHNcYuwuGghPf2iyuo3oM+6Gn8F1nFWiBsrmJdWI0iDQFcFudQyLVGYRQwmS7mT5PtfZkT8bXWODCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L+1zhD2v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L+1zhD2v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56071C4CEEB;
	Mon,  2 Jun 2025 14:16:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873766;
	bh=6fQZWATQ4tMN+Uv3+++zVrjBQvD6WZCz/ZJft6xf1V4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L+1zhD2vi4W+yvZLwBOxyzosf4zMWZocLKSX38oCO0c0G157ZcZsVt6Elf49nKOCN
	 UjvQm823CDlAUklX8qjumhO1OUxnJuQKOqjDi5FDj2UBtnROSL4/hXF7jXtDXIbS+K
	 OVbDlISeZTXP/6vghbpMBPX4uOvr3DZs0ayW2Xyc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 204/444] wifi: rtw88: Fix rtw_init_ht_cap() for RTL8814AU
Date: Mon,  2 Jun 2025 15:44:28 +0200
Message-ID: <20250602134349.184265831@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
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

From: Bitterblue Smith <rtl8821cerfe2@gmail.com>

[ Upstream commit c7eea1ba05ca5b0dbf77a27cf2e1e6e2fb3c0043 ]

Set the RX mask and the highest RX rate according to the number of
spatial streams the chip can receive. For RTL8814AU that is 3.

Signed-off-by: Bitterblue Smith <rtl8821cerfe2@gmail.com>
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/4e786f50-ed1c-4387-8b28-e6ff00e35e81@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw88/main.c | 17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/main.c b/drivers/net/wireless/realtek/rtw88/main.c
index 557526e0eb7f3..0d0b5123b5fe2 100644
--- a/drivers/net/wireless/realtek/rtw88/main.c
+++ b/drivers/net/wireless/realtek/rtw88/main.c
@@ -1544,6 +1544,7 @@ static void rtw_init_ht_cap(struct rtw_dev *rtwdev,
 {
 	const struct rtw_chip_info *chip = rtwdev->chip;
 	struct rtw_efuse *efuse = &rtwdev->efuse;
+	int i;
 
 	ht_cap->ht_supported = true;
 	ht_cap->cap = 0;
@@ -1563,17 +1564,11 @@ static void rtw_init_ht_cap(struct rtw_dev *rtwdev,
 	ht_cap->ampdu_factor = IEEE80211_HT_MAX_AMPDU_64K;
 	ht_cap->ampdu_density = chip->ampdu_density;
 	ht_cap->mcs.tx_params = IEEE80211_HT_MCS_TX_DEFINED;
-	if (efuse->hw_cap.nss > 1) {
-		ht_cap->mcs.rx_mask[0] = 0xFF;
-		ht_cap->mcs.rx_mask[1] = 0xFF;
-		ht_cap->mcs.rx_mask[4] = 0x01;
-		ht_cap->mcs.rx_highest = cpu_to_le16(300);
-	} else {
-		ht_cap->mcs.rx_mask[0] = 0xFF;
-		ht_cap->mcs.rx_mask[1] = 0x00;
-		ht_cap->mcs.rx_mask[4] = 0x01;
-		ht_cap->mcs.rx_highest = cpu_to_le16(150);
-	}
+
+	for (i = 0; i < efuse->hw_cap.nss; i++)
+		ht_cap->mcs.rx_mask[i] = 0xFF;
+	ht_cap->mcs.rx_mask[4] = 0x01;
+	ht_cap->mcs.rx_highest = cpu_to_le16(150 * efuse->hw_cap.nss);
 }
 
 static void rtw_init_vht_cap(struct rtw_dev *rtwdev,
-- 
2.39.5



