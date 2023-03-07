Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65C67BA32
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:12:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7D41C4339B;
	Tue,  7 Mar 2023 17:12:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678209179;
	bh=wbxJDDqNdN326wLkTRRJGWducIP1TYrYjoUR+5/1xJU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uuUvicGJN7SQ0g/h52/0Y5v0MenuxBxlgb7IB2f6cbKGkG6wJvppuTho5QrhZlnvf
	 VlPNvLy1VITpBGEr6nxGEx3GrgaWR8yk6VYAzqqhhoG2w+RRx6ZgpwSg4kezeDdM9g
	 hBAiv2hDlh9A3e/PF+Wv4fNT/L1rzV5oRHL3004Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	coverity-bot <keescook+coverity-bot@chromium.org>,
	Ryder Lee <ryder.lee@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0136/1001] wifi: mt76: mt7996: fix insecure data handling of mt7996_mcu_rx_radar_detected()
Date: Tue,  7 Mar 2023 17:48:28 +0100
Message-Id: <20230307170027.964442374@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ryder Lee <ryder.lee@mediatek.com>

[ Upstream commit f37c6e5c75029443bc72c45acf92b2f2de2945be ]

Coverity message:
using tainted "r->band_idx" variable as an index into an array "(*dev).mt76.phys".

Reported-by: coverity-bot <keescook+coverity-bot@chromium.org>
Addresses-Coverity-ID: 1527812 ("Insecure data handling")
Fixes: 98686cd21624 ("wifi: mt76: mt7996: add driver for MediaTek Wi-Fi 7 (802.11be) devices")
Signed-off-by: Ryder Lee <ryder.lee@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/mcu.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
index a90b7ca2df63c..efb245c8ac840 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
@@ -335,6 +335,9 @@ mt7996_mcu_rx_radar_detected(struct mt7996_dev *dev, struct sk_buff *skb)
 
 	r = (struct mt7996_mcu_rdd_report *)skb->data;
 
+	if (r->band_idx >= ARRAY_SIZE(dev->mt76.phys))
+		return;
+
 	mphy = dev->mt76.phys[r->band_idx];
 	if (!mphy)
 		return;
-- 
2.39.2



