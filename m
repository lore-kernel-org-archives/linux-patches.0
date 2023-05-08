Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99BCB168CF
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:15:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0620C433EF;
	Mon,  8 May 2023 11:15:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683544542;
	bh=AXkYpCRFf4ALJNaNUAL+0cZeWOMLuoEOBVfr0KKNhWQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YRYeJqNLGxKN+ty76d/IP1dBQXnuEouHxIPxNrefFdBKBpo2VwU8GdiTo+x57cJDs
	 cz7kM8qxRI7ib0ObTk5jcBuj6bM/MQXXRMEVzmGAOiBiAmCZsHA0ohT0YjxW62hOr9
	 QmVa/SjBjiKyVda3HjzfKHokhldA0QjLx+C2EYIs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Chen <yn.chen@mediatek.com>,
	Deren Wu <deren.wu@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 442/694] wifi: mt76: mt7921: use driver flags rather than mac80211 flags to mcu
Date: Mon,  8 May 2023 11:44:37 +0200
Message-Id: <20230508094447.828279842@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094432.603705160@linuxfoundation.org>
References: <20230508094432.603705160@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Neil Chen <yn.chen@mediatek.com>

[ Upstream commit a5af1481a85679a9812f728ee5cf64ee7edbe669 ]

FIF_* flags from mac80211 is not ABI. mt7921 should not pass it into mcu
directly. Remap FIF_* to driver defined flags as mcu command input.

Fixes: c222f77fd421 ("wifi: mt76: mt7921: fix rx filter incorrect by drv/fw inconsistent")
Signed-off-by: Neil Chen <yn.chen@mediatek.com>
Signed-off-by: Deren Wu <deren.wu@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt7921/main.c    | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/main.c b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
index 058aa581ff4f3..2c5e4ad3a0c69 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
@@ -702,10 +702,25 @@ static void mt7921_configure_filter(struct ieee80211_hw *hw,
 				    unsigned int *total_flags,
 				    u64 multicast)
 {
+#define MT7921_FILTER_FCSFAIL    BIT(2)
+#define MT7921_FILTER_CONTROL    BIT(5)
+#define MT7921_FILTER_OTHER_BSS  BIT(6)
+#define MT7921_FILTER_ENABLE     BIT(31)
+
 	struct mt7921_dev *dev = mt7921_hw_dev(hw);
+	u32 flags = MT7921_FILTER_ENABLE;
+
+#define MT7921_FILTER(_fif, _type) do {			\
+		if (*total_flags & (_fif))		\
+			flags |= MT7921_FILTER_##_type;	\
+	} while (0)
+
+	MT7921_FILTER(FIF_FCSFAIL, FCSFAIL);
+	MT7921_FILTER(FIF_CONTROL, CONTROL);
+	MT7921_FILTER(FIF_OTHER_BSS, OTHER_BSS);
 
 	mt7921_mutex_acquire(dev);
-	mt7921_mcu_set_rxfilter(dev, *total_flags, 0, 0);
+	mt7921_mcu_set_rxfilter(dev, flags, 0, 0);
 	mt7921_mutex_release(dev);
 
 	*total_flags &= (FIF_OTHER_BSS | FIF_FCSFAIL | FIF_CONTROL);
-- 
2.39.2



