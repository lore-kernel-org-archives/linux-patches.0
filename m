Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C70732248A4;
	Mon,  2 Jun 2025 14:46:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875617; cv=none; b=C9MW9sLU0spFzXxbKm/O+7HCHpYsTm80Kqa5DFb68vEKT8ZmmPcFVTMYeb/mUqBjDyIFGUeNy92g//PJCQldOc0CSIQSi08ZmzFAziHw5aHoFD9vqpuONMJlsIH1hpAzqItWCQ0nYdmXwUL8BV2LzO7Peo+Bah+yvnVNMrqcLAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875617; c=relaxed/simple;
	bh=UUV4uUJEeLMnQJAmHBc2JrI/Fn4qs4eJA9SJCxC5BVo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RjIZcPsxmOCg9nUzkoCj1XgJQHxu69lK7XsjyhSDguNW++RDW5K+VH80x5xt7si1z9cjZ4fzMhJVRC1vKjMqB6dAXKT16sJobX0qo98Yf88IcCm+Snecr4n8GPBaEd7FrmMrSmukqauzWb85Dcg4wyFtEoJ7aLI8QAKpKbJwz3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S8T/1cPV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S8T/1cPV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48A5FC4CEEB;
	Mon,  2 Jun 2025 14:46:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875617;
	bh=UUV4uUJEeLMnQJAmHBc2JrI/Fn4qs4eJA9SJCxC5BVo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S8T/1cPV4m6cIpYa0VazFOuytCwIThwwVJGyr8SnafrMxr4Ez7U7nF2yxvYxcTJHp
	 fzZhiLQzhIhQJI1V+hb2LUecxQdzvP8XgSQ0g38HEyCtmTDrdDJIRYYt7lpInGUl15
	 Opi5N9NM7x9BH/3G/iX9sBPMjGPr3nTFwjx0Jky0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 189/270] wifi: rtw88: Fix rtw_init_ht_cap() for RTL8814AU
Date: Mon,  2 Jun 2025 15:47:54 +0200
Message-ID: <20250602134314.933565493@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134307.195171844@linuxfoundation.org>
References: <20250602134307.195171844@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index ea70b55150388..ab302e2ce9a2e 100644
--- a/drivers/net/wireless/realtek/rtw88/main.c
+++ b/drivers/net/wireless/realtek/rtw88/main.c
@@ -1141,6 +1141,7 @@ static void rtw_init_ht_cap(struct rtw_dev *rtwdev,
 			    struct ieee80211_sta_ht_cap *ht_cap)
 {
 	struct rtw_efuse *efuse = &rtwdev->efuse;
+	int i;
 
 	ht_cap->ht_supported = true;
 	ht_cap->cap = 0;
@@ -1158,17 +1159,11 @@ static void rtw_init_ht_cap(struct rtw_dev *rtwdev,
 	ht_cap->ampdu_factor = IEEE80211_HT_MAX_AMPDU_64K;
 	ht_cap->ampdu_density = IEEE80211_HT_MPDU_DENSITY_16;
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



