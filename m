Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA2781D04B4;
	Wed,  2 Oct 2024 13:58:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877482; cv=none; b=Xdhr/hoVqTPAzTFnoeyzzNZcl30moqp2TSmsuYzkiajqsLA/w3JI05wOVUXytrtl4CQ9BB6h2sO1YUJo6whtGa61enMov4hP8iAFFmQN/rowBudbNSKa5F9tw0dx1ue5XfbQmdeJceEoT19S3fQFfNCLeu3X45TA1h6X3LtPHx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877482; c=relaxed/simple;
	bh=1lIvZkWkWLHW8ppICaPEh8Cjr0f7rcUdnDS+1GjYf8s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=huFDs+Z2UuVq5RkEX/M+nJjC725UJUpj50M3Lsf34pDCfHvTn5TiPfxo/4etW2AHMzlS9AVrEqOQmehXTBUyAYBf/JdFvAxQdTDstgb+LOxZGZwbE3VIuH5u6b06iegaJ2XjtV50UohyViTGEpCLFZW3MMu6E+yqVItweA365Jg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DQb+blHX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DQb+blHX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4780BC4CECD;
	Wed,  2 Oct 2024 13:58:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877482;
	bh=1lIvZkWkWLHW8ppICaPEh8Cjr0f7rcUdnDS+1GjYf8s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DQb+blHX4nVOA9Zpn6b/bjQjQ1xGhl4CheNzwesrB+BnQPptdPr0/5Wv4kx6XrzA+
	 tbx0nifAGDyppU9EKi8Tr0x8Yr/AsqUY4ERGzKU47hho4LhXulI10pb5FiScjiT4fL
	 uxx0Jb08k7sIUC5rPnKbqCEam8cbEEb8MkGK2I+s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Chiu <chui-hao.chiu@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 066/634] wifi: mt76: mt7996: fix traffic delay when switching back to working channel
Date: Wed,  2 Oct 2024 14:52:46 +0200
Message-ID: <20241002125813.712710904@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index 7c97140d8255a..15d880ef0d922 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -307,6 +307,10 @@ int mt7996_set_channel(struct mt7996_phy *phy)
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



