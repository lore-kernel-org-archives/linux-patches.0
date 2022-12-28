Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D22A71875
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:59:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 574ADC433D2;
	Wed, 28 Dec 2022 15:59:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672243184;
	bh=oGeNAZgohyZQFne1ziJJO76MGyKtUscUNWfwi4Rdi7o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YoqvvkllTTtaZLyBgLtKtHq0nasugNeEI4USzLekLmJuwEc0HtbRUVfKKyZg8qciG
	 gCDux9T3bvMTHCYCtH0aAOz8S2Hx91eRjwa3xcAoKDwiA8pAPFnbuqdB8qRPUtjPOS
	 j+Zc15CBawi2coEOsr4ngMLoU2aRLFhPn5v4A3R0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	YN Chen <YN.Chen@mediatek.com>,
	Deren Wu <deren.wu@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0460/1146] wifi: mt76: mt7921: fix wrong power after multiple SAR set
Date: Wed, 28 Dec 2022 15:33:19 +0100
Message-Id: <20221228144342.676856526@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: YN Chen <YN.Chen@mediatek.com>

[ Upstream commit 7eefb93d4a6fbccd859e538d208c50fd10b44cb7 ]

We should update CLC config before SAR set to synchronize all
related settings.

Fixes: 23bdc5d8cadf ("wifi: mt76: mt7921: introduce Country Location Control support")
Signed-off-by: YN Chen <YN.Chen@mediatek.com>
Signed-off-by: Deren Wu <deren.wu@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7921/init.c   | 1 +
 drivers/net/wireless/mediatek/mt76/mt7921/main.c   | 6 ++++++
 drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h | 2 ++
 3 files changed, 9 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/init.c b/drivers/net/wireless/mediatek/mt76/mt7921/init.c
index dcdb3cf04ac1..4ad66b344383 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/init.c
@@ -37,6 +37,7 @@ mt7921_regd_notifier(struct wiphy *wiphy,
 
 	memcpy(dev->mt76.alpha2, request->alpha2, sizeof(dev->mt76.alpha2));
 	dev->mt76.region = request->dfs_region;
+	dev->country_ie_env = request->country_ie_env;
 
 	mt7921_mutex_acquire(dev);
 	mt7921_mcu_set_clc(dev, request->alpha2, request->country_ie_env);
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/main.c b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
index 7e409ac7d9a8..111d9221b94f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
@@ -1504,7 +1504,13 @@ static int mt7921_set_sar_specs(struct ieee80211_hw *hw,
 	int err;
 
 	mt7921_mutex_acquire(dev);
+	err = mt7921_mcu_set_clc(dev, dev->mt76.alpha2,
+				 dev->country_ie_env);
+	if (err < 0)
+		goto out;
+
 	err = mt7921_set_tx_sar_pwr(hw, sar);
+out:
 	mt7921_mutex_release(dev);
 
 	return err;
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h b/drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h
index eaba114a9c7e..2babaeff72ba 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h
@@ -244,6 +244,8 @@ struct mt7921_dev {
 	struct work_struct ipv6_ns_work;
 	/* IPv6 addresses for WoWLAN */
 	struct sk_buff_head ipv6_ns_list;
+
+	enum environment_cap country_ie_env;
 };
 
 enum {
-- 
2.35.1



