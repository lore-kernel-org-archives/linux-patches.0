Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1652198837;
	Wed,  2 Oct 2024 13:57:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877450; cv=none; b=To4w/3Yv4sYveo+LvLD9LYlFP4Zf8vLWL/rndDx6exAnTQbOH0lxFov5JSAVj6OATKJ3s8dczCeuGhpqMXLBfnJ5Y9xcK6hPymhHziIKiXxDJ6Qskj4QAXk9WtmcRWoy7VbaRHOiCPOYhb4Dw2+21O2wmnPjZWpKL0M8VI2P5/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877450; c=relaxed/simple;
	bh=oRvfH7DQkBIgGeRFNxhWwrx6+D1czkncSdY3Vxrpkgw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fol6Q+MQp5zt4vCB8Jy3KKSK7pqJgZltjr5cWRWinrxc04ccGsth7wzDYjxDyFU3v2haulJI2h5rU/6PgX60n7xxuMrHBvRDeDihsVX0H9V1yR0p9O/oiIgJ3LaVdkZf7DazSFWzCp1UPp+rcrOeNLUo4PLSDR+pjrcboszEMAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f/OOX7MO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f/OOX7MO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 296B5C4AF09;
	Wed,  2 Oct 2024 13:57:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877450;
	bh=oRvfH7DQkBIgGeRFNxhWwrx6+D1czkncSdY3Vxrpkgw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f/OOX7MObJ9aY9iNhud+hLPNWdp8MkX50QoHeAquSrWw1tS8EXzSUSVUET0NqXdEc
	 5BR02Ojo9u06E8URo5cIGwztiqwzs7Ki7K2t+Dj7/UqGNb0fR8/YcHSmLpHMoQoL6B
	 jrZ7uL5gxK8x+O/ADdZgz5X/r0O6i/fXOZmNHosI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Chiu <chui-hao.chiu@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 065/634] wifi: mt76: mt7996: use hweight16 to get correct tx antenna
Date: Wed,  2 Oct 2024 14:52:45 +0200
Message-ID: <20241002125813.674122121@linuxfoundation.org>
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

[ Upstream commit f98c3de92bb05dac4a4969df8a4595ed380b4604 ]

The chainmask is u16 so using hweight8 cannot get correct tx_ant.
Without this patch, the tx_ant of band 2 would be -1 and lead to the
following issue:
BUG: KASAN: stack-out-of-bounds in mt7996_mcu_add_sta+0x12e0/0x16e0 [mt7996e]

Fixes: 98686cd21624 ("wifi: mt76: mt7996: add driver for MediaTek Wi-Fi 7 (802.11be) devices")
Signed-off-by: Peter Chiu <chui-hao.chiu@mediatek.com>
Signed-off-by: Shayne Chen <shayne.chen@mediatek.com>
Link: https://patch.msgid.link/20240816094635.2391-1-shayne.chen@mediatek.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/mcu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
index 2c85786778009..7220bcee6fae9 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
@@ -1653,7 +1653,7 @@ mt7996_mcu_sta_bfer_tlv(struct mt7996_dev *dev, struct sk_buff *skb,
 {
 	struct mt7996_vif *mvif = (struct mt7996_vif *)vif->drv_priv;
 	struct mt7996_phy *phy = mvif->phy;
-	int tx_ant = hweight8(phy->mt76->chainmask) - 1;
+	int tx_ant = hweight16(phy->mt76->chainmask) - 1;
 	struct sta_rec_bf *bf;
 	struct tlv *tlv;
 	static const u8 matrix[4][4] = {
-- 
2.43.0



