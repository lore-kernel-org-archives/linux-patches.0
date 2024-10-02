Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18F331CFEB3;
	Wed,  2 Oct 2024 14:27:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879224; cv=none; b=bwqzxbf1y2pYOxEQopKjNxXfbN2k9ynzyfaR1rGFRKRYMSTUC/eDU6D+Phb7PD/+qVNeZdkLVM8bhlPEeHvn00ZS8qCY6Ntlctv5YJsUuLSkIepX2XOHeqtBuC6bQ66HE4R2RjLBvWdmzItZ2HwTHNZWYsKHPEurhQJYRmlpOZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879224; c=relaxed/simple;
	bh=pZ47enPdAczYJvY7cmm3C7tgQeochDHbOmnTnnAtOwY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AiDCu6AwTj0gw0ZqPHiIdkAjAQ7yymZ3jvmNT7R1qCqlFZeDErFB19Gk9lQEIWAWnY3My5oT+D+x5JbonNuRPfHUiloSZwAdfdPqYdqVHTFAIueWcfsyH6pwQIvBgcG4dYPuQNGS4dycL3QSCeT1piM1pqZqR/yr3sGH3AMTnHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kLdfZ7Hb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kLdfZ7Hb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A5B6C4CEC2;
	Wed,  2 Oct 2024 14:27:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879223;
	bh=pZ47enPdAczYJvY7cmm3C7tgQeochDHbOmnTnnAtOwY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kLdfZ7HbHSut1//3YqOhhFU00dy5kNgBNVjX6PBW4q47D6L+NN3SVu5Q1HodHw8+G
	 2RKzVSGKg5PeYswiLAlkld1LiAqiWKzHRTPjLrnYoeZLG0tzf2ZdgxAPWogqDWNqjb
	 6f5GfVzne90d3P6TiLyAKv59aU7m/fl0BM74nQ/o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Chiu <chui-hao.chiu@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 045/538] wifi: mt76: mt7996: fix traffic delay when switching back to working channel
Date: Wed,  2 Oct 2024 14:54:44 +0200
Message-ID: <20241002125753.808150126@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Peter Chiu <chui-hao.chiu@mediatek.com>

[ Upstream commit 376200f095d0c3a7096199b336204698d7086279 ]

During scanning, UNI_CHANNEL_RX_PATH tag is necessary for the firmware to
properly stop and resume MAC TX queue. Without this tag, HW needs more time
to resume traffic when switching back to working channel.

Fixes: 98686cd21624 ("wifi: mt76: mt7996: add driver for MediaTek Wi-Fi 7 (802.11be) devices")
Signed-off-by: Peter Chiu <chui-hao.chiu@mediatek.com>
Signed-off-by: Shayne Chen <shayne.chen@mediatek.com>
Link: https://patch.msgid.link/20240816094635.2391-2-shayne.chen@mediatek.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/main.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/main.c b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
index 7fea9f0d409bf..85f6a9f4f188c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -287,6 +287,10 @@ int mt7996_set_channel(struct mt7996_phy *phy)
 	if (ret)
 		goto out;
 
+	ret = mt7996_mcu_set_chan_info(phy, UNI_CHANNEL_RX_PATH);
+	if (ret)
+		goto out;
+
 	ret = mt7996_dfs_init_radar_detector(phy);
 	mt7996_mac_cca_stats_reset(phy);
 
-- 
2.43.0



