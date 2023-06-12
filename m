Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34CDD8828
	for <patches@lists.linux.dev>; Mon, 12 Jun 2023 10:37:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B208EC433EF;
	Mon, 12 Jun 2023 10:37:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686566226;
	bh=oXResC91VdN7eCvf90K4ovTtAdv43tdV262UchwJIrM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iN1U30OH9Eulgph+zyCvwtyQAtgXIgDgzEYjrtUS/BZUyj0sEX5n/wQZADnZdWb2+
	 etdxAgvArYxSxOqTffTkpT2GeACDajF4AhTLbtEZXuQZ89q26YOmbApL5iBgpzVHnE
	 3pt2tZcVDIc6AzHWusOW37AIPySMU/E8o7Du5Ho8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 14/91] wifi: mt76: mt7615: fix possible race in mt7615_mac_sta_poll
Date: Mon, 12 Jun 2023 12:26:03 +0200
Message-ID: <20230612101702.686974767@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230612101702.085813286@linuxfoundation.org>
References: <20230612101702.085813286@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 30bc32c7c1f975cc3c14e1c7dc437266311282cf ]

Grab sta_poll_lock spinlock in mt7615_mac_sta_poll routine in order to
avoid possible races with mt7615_mac_add_txs() or mt7615_mac_fill_rx()
removing msta pointer from sta_poll_list.

Fixes: a621372a04ac ("mt76: mt7615: rework mt7615_mac_sta_poll for usb code")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/48b23404b759de4f1db2ef85975c72a4aeb1097c.1684938695.git.lorenzo@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7615/mac.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/mac.c b/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
index 37bc307c19719..2f0ba8a75d71b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
@@ -869,7 +869,10 @@ void mt7615_mac_sta_poll(struct mt7615_dev *dev)
 
 		msta = list_first_entry(&sta_poll_list, struct mt7615_sta,
 					poll_list);
+
+		spin_lock_bh(&dev->sta_poll_lock);
 		list_del_init(&msta->poll_list);
+		spin_unlock_bh(&dev->sta_poll_lock);
 
 		addr = mt7615_mac_wtbl_addr(dev, msta->wcid.idx) + 19 * 4;
 
-- 
2.39.2



