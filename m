Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15BB66025E;
	Tue, 23 Jan 2024 01:51:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974712; cv=none; b=i1LT1ZQ1Qfqys8cNt8LZT/9p27bH7lIWoiGNdZKAXP3zeBAtlfRw/xBufR/9H1roc7tEeBhdc5m47WfKzZpTiHPa8NEQudoq4gKfNwypCTOIIcHu9pUGJoeJjpCPovJoEzjn0fXEv/Po2JKgO1oj6KEEHfFWqTOPdOf2R3VQsFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974712; c=relaxed/simple;
	bh=GRrsjM3sMakmoJoP3GhzZxTZ7H7YKDY5g0XJinlJ4/w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JdIMU9xxujVo97vUkrPIK2oWimVgCnNu84x3ADllZEZvLtIkOEcVZv03fO5SUIrZhm6ijhlo7viw3MLia1NWMhXUF/gEHKEDXhX3Vnb4ytUB/+wDZT/xVSeeJ2ORttdfqnA9U3v5NNl9xIE2PLfzxOgzdUaYzV1AgsFi/6md7+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=STZlfjz+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="STZlfjz+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77400C433C7;
	Tue, 23 Jan 2024 01:51:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974711;
	bh=GRrsjM3sMakmoJoP3GhzZxTZ7H7YKDY5g0XJinlJ4/w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=STZlfjz+c648G/QMycIty0/cP59dVnGDRBTrjlRYSbO5IpkLAsXTPWFmzRimjrmQN
	 v0HO7hkKwzOb0dDWsqDrfYjjkNr5Yerj2FmMsZ9T527gHV2VOoEXVfb8u4vB9XP7Tj
	 hZdkP+t/4cM2n/HutebYu3AjBnS2Wn8zhNO4Fl4M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	MeiChia Chiu <meichia.chiu@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 138/583] wifi: mt76: mt7996: fix rate usage of inband discovery frames
Date: Mon, 22 Jan 2024 15:53:09 -0800
Message-ID: <20240122235816.329971340@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

From: MeiChia Chiu <meichia.chiu@mediatek.com>

[ Upstream commit 1e3f387736c744e73b5398a147b90412f82f54da ]

For UBPR and FILS frames, the BSS_CHANGED_BEACON flag will also be set,
which causes those frames to use the beacon rate in TX descriptors.
Adjust the statement to fix this issue.

Fixes: 98686cd21624 ("wifi: mt76: mt7996: add driver for MediaTek Wi-Fi 7 (802.11be) devices")
Signed-off-by: MeiChia Chiu <meichia.chiu@mediatek.com>
Signed-off-by: Shayne Chen <shayne.chen@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/mac.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
index c43839a20508..26d5675202ba 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
@@ -840,10 +840,10 @@ void mt7996_mac_write_txwi(struct mt7996_dev *dev, __le32 *txwi,
 	struct mt76_vif *mvif;
 	u16 tx_count = 15;
 	u32 val;
-	bool beacon = !!(changed & (BSS_CHANGED_BEACON |
-				    BSS_CHANGED_BEACON_ENABLED));
 	bool inband_disc = !!(changed & (BSS_CHANGED_UNSOL_BCAST_PROBE_RESP |
 					 BSS_CHANGED_FILS_DISCOVERY));
+	bool beacon = !!(changed & (BSS_CHANGED_BEACON |
+				    BSS_CHANGED_BEACON_ENABLED)) && (!inband_disc);
 
 	mvif = vif ? (struct mt76_vif *)vif->drv_priv : NULL;
 	if (mvif) {
-- 
2.43.0



