Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DC93168A7
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:38:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F8BDC433EF;
	Mon,  8 May 2023 10:38:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683542310;
	bh=lpfKI2YHJdz7GAda496iuHUKRZV56TVYaMGEB9AZ0uQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aan/HsT9Z/7blebOPADInUac3mNsWk5HbzdAhd9XCwWUSPfPzV+7JiSfpvgJiE3lq
	 uZKuxw0+Q9NlZzvRgfN85JBju3IQrxfa6+F0HZs5SXjan30iDqbInmZCY2hq3SR4WK
	 5zyvDCxouxKBNcRS4XKGA7BN4Sbhf/E9lRA92j4Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Chiu <chui-hao.chiu@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 395/663] wifi: mt76: mt7996: fix pointer calculation in ie countdown event
Date: Mon,  8 May 2023 11:43:41 +0200
Message-Id: <20230508094440.913622683@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094428.384831245@linuxfoundation.org>
References: <20230508094428.384831245@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Peter Chiu <chui-hao.chiu@mediatek.com>

[ Upstream commit 8b14ce24a0297175bc4ebdf26d45a22b5a33847f ]

Fix the tail and data pointers. The rxd->len in mt7996_mcu_rxd does not
include the length of general rxd. It only includes the length of
firmware event rxd. Use skb->length to get the correct length.

Fixes: 98686cd21624 ("wifi: mt76: mt7996: add driver for MediaTek Wi-Fi 7 (802.11be) devices")
Signed-off-by: Peter Chiu <chui-hao.chiu@mediatek.com>
Signed-off-by: Shayne Chen <shayne.chen@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/mcu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
index 18c4e7bc4370d..c8c332ed8a402 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
@@ -421,7 +421,8 @@ mt7996_mcu_ie_countdown(struct mt7996_dev *dev, struct sk_buff *skb)
 	if (hdr->band && dev->mt76.phys[hdr->band])
 		mphy = dev->mt76.phys[hdr->band];
 
-	tail = skb->data + le16_to_cpu(rxd->len);
+	tail = skb->data + skb->len;
+	data += sizeof(struct header);
 	while (data + sizeof(struct tlv) < tail && le16_to_cpu(tlv->len)) {
 		switch (le16_to_cpu(tlv->tag)) {
 		case UNI_EVENT_IE_COUNTDOWN_CSA:
-- 
2.39.2



