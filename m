Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82D64168A7
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:38:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08132C433D2;
	Mon,  8 May 2023 10:38:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683542304;
	bh=5kcGwruRUB4YLkzfCyxdJ97CgKP2Mk4mSsIeZNBq+CQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fy9Kgj/9rNFnDeIOTNIvtg6EqX8XQp2pHEtfH5V/2AMAkNNUcsSRW3Si1jj3zBSED
	 HoduK7sI73Ol3ENzrPc1g0BINpybE9CEq0SIjBLXd8OAHUvfYznRhO1gRcw0/ShvBp
	 6MPOHJj+S5a3GJI96SG+CQL794fd/PFQEOeydzws=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kang Chen <void0red@gmail.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 393/663] wifi: mt76: handle failure of vzalloc in mt7615_coredump_work
Date: Mon,  8 May 2023 11:43:39 +0200
Message-Id: <20230508094440.851556770@linuxfoundation.org>
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

From: Kang Chen <void0red@gmail.com>

[ Upstream commit 9e47dd9f64a47ae00ca0123017584c37209ee900 ]

vzalloc may fails, dump might be null and will cause
illegal address access later.

Link: https://lore.kernel.org/all/Y%2Fy5Asxw3T3m4jCw@lore-desk
Fixes: d2bf7959d9c0 ("mt76: mt7663: introduce coredump support")
Signed-off-by: Kang Chen <void0red@gmail.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7615/mac.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/mac.c b/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
index 5c41ad5955f4b..eafa0f204c1f8 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
@@ -2355,7 +2355,7 @@ void mt7615_coredump_work(struct work_struct *work)
 			break;
 
 		skb_pull(skb, sizeof(struct mt7615_mcu_rxd));
-		if (data + skb->len - dump > MT76_CONNAC_COREDUMP_SZ) {
+		if (!dump || data + skb->len - dump > MT76_CONNAC_COREDUMP_SZ) {
 			dev_kfree_skb(skb);
 			continue;
 		}
@@ -2365,6 +2365,8 @@ void mt7615_coredump_work(struct work_struct *work)
 
 		dev_kfree_skb(skb);
 	}
-	dev_coredumpv(dev->mt76.dev, dump, MT76_CONNAC_COREDUMP_SZ,
-		      GFP_KERNEL);
+
+	if (dump)
+		dev_coredumpv(dev->mt76.dev, dump, MT76_CONNAC_COREDUMP_SZ,
+			      GFP_KERNEL);
 }
-- 
2.39.2



