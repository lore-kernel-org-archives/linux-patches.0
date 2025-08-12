Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C5C826FA77;
	Tue, 12 Aug 2025 19:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025778; cv=none; b=d+5D8zdgJ0M83Ly+enl2wU/Ac9ZbduJa4IG7Y4J1hUyReKodoNrmZp4KhJmRATs+3mxAGhq0xWi+TH592+TWJfcVAS0Edst/fALtuHPQNlJqRPzCVqdKFYvcttRQOYqdoP9neIsQOkN7VpH/ihODhmaSlZJKVG2mCx7nzRE3bgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025778; c=relaxed/simple;
	bh=UNjsXnq9ueaEWqgcLXKrsg3ktl6pNqSqaYEJEJHV/Vo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kl4U2Yd6VUg4idRPUH/Q5X62mRO+YRsbyf+/8aKmQLKEqUxQhIZHKhFDWTIZbfWobC6q+oDv1pKhSsyZpsIQmE9ZP7gp4UKne8tp3lZNpaqdk8gRqHpCb+J7LbAOqnChfGFTIVtJPXNtfpDtxvxXwxm8aYjQGgHr35U3sC70YsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZQqqdPdx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZQqqdPdx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ED06C4CEF1;
	Tue, 12 Aug 2025 19:09:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025775;
	bh=UNjsXnq9ueaEWqgcLXKrsg3ktl6pNqSqaYEJEJHV/Vo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZQqqdPdx4i+rEzpFOoiCwxDagtJm3idzfocfrudM4PcXeJh37LFBvH1dp4AbO0dbt
	 zg506MiXr6YZbnGtICsbnaltFw/cJx043DsdGP9PjdtRqV3HawJkqpsIvx3fIaRHMQ
	 AkFa6jFFB/mnPyW10S3MS7u0lFHVvl6gEzapzZTY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 140/480] wifi: mt76: mt7996: Fix valid_links bitmask in mt7996_mac_sta_{add,remove}
Date: Tue, 12 Aug 2025 19:45:48 +0200
Message-ID: <20250812174403.297865336@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit a59650a2270190905fdab79431140371feb35251 ]

sta->valid_links bitmask can be set even for non-MLO client.

Fixes: dd82a9e02c054 ("wifi: mt76: mt7996: Rely on mt7996_sta_link in sta_add/sta_remove callbacks")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/20250704-mt7996-mlo-fixes-v1-7-356456c73f43@kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/main.c b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
index 631ad0f9ff93..45ef0f309135 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -1061,7 +1061,7 @@ mt7996_mac_sta_add(struct mt76_phy *mphy, struct ieee80211_vif *vif,
 	struct mt7996_dev *dev = container_of(mdev, struct mt7996_dev, mt76);
 	struct mt7996_sta *msta = (struct mt7996_sta *)sta->drv_priv;
 	struct mt7996_vif *mvif = (struct mt7996_vif *)vif->drv_priv;
-	unsigned long links = sta->mlo ? sta->valid_links : BIT(0);
+	unsigned long links = sta->valid_links ? sta->valid_links : BIT(0);
 	int err;
 
 	mutex_lock(&mdev->mutex);
@@ -1155,7 +1155,7 @@ mt7996_mac_sta_remove(struct mt76_phy *mphy, struct ieee80211_vif *vif,
 {
 	struct mt76_dev *mdev = mphy->dev;
 	struct mt7996_dev *dev = container_of(mdev, struct mt7996_dev, mt76);
-	unsigned long links = sta->mlo ? sta->valid_links : BIT(0);
+	unsigned long links = sta->valid_links ? sta->valid_links : BIT(0);
 
 	mutex_lock(&mdev->mutex);
 
-- 
2.39.5



