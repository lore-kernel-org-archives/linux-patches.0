Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C871133989;
	Tue, 23 Jan 2024 00:21:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969292; cv=none; b=sbcYIdNqn84GcmZJN3OT2OxmRDwAt6Lgx5TrG22o7YBJKilX5HBXdt0aOSe+YuTUBA3Mwczuel5hbcaJQmTstbZq48O7r/W1eHaoWsohuJD+B4pyInYDXoieJvdH4f2fADp4Ql5BlSCAd2ONQqwnIZRuQb34V2cLneBXLT9a3pA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969292; c=relaxed/simple;
	bh=a6HKtZssunlaM6whor4ESy4I/SpCq/3J6OkKFkRnzc4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LVe035GUjtAz1FmfVM/Dr6Fn3oTCCZODiyX8yQgS9mkMb0teqiFaAaeKC2Bv01WcPme0yO0n3FpgqZR5PNnt1vevcTHBtwqGqQPlwmOhex+ffBgHIyI1FXIq0OGu6/IqX5gyYpb2D9/a20Ki0F7p2lg9xsdwQt7vXSjpkOzQ+Jk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sKTXcDqF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sKTXcDqF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE959C43394;
	Tue, 23 Jan 2024 00:21:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969291;
	bh=a6HKtZssunlaM6whor4ESy4I/SpCq/3J6OkKFkRnzc4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sKTXcDqFO1Zjm9MJisJ8ngTRDLsNDPBofZwQY0eZm82/OYkcgFL4RfDPh11erbBoE
	 WjFC++4VQ18kCzBLFW/M7gBWi9h0Jd+j373gmrkyLFORADtsFwOA7VCGRtgJ+RI8zC
	 ukLo8/rHU5+R+Go9JX+08qotVqksOxPthTo14Pxk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	MeiChia Chiu <meichia.chiu@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 150/641] wifi: mt76: mt7996: fix rate usage of inband discovery frames
Date: Mon, 22 Jan 2024 15:50:54 -0800
Message-ID: <20240122235822.736065575@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index 59ab07b89087..fa3001e59a36 100644
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



