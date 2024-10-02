Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1607F16F84F;
	Wed,  2 Oct 2024 13:22:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875359; cv=none; b=WKgLRRS179efE8FnUtlV0BfYMCafCa+1MOTHeaXqmtA4++HVLrnosaTiEHBxOesI+rSH3J0mVs+Gyj2MIQ+R/NaC1Ynl+kljVMVX0vtHMDmL4tygvEovtWCJMyCQK7bvHyqBQo1KsHvV8oqrt1FPR1j71GHf0mX/sXms5MKmcxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875359; c=relaxed/simple;
	bh=y2Sq0D3vznM9QJOUiu37tv4/U1wk+iKBNXeHOcT/BqI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YnP5Soy7Ba7ER+1Cmrbe0fbOSF0+jj38xXl9bntLd5RrJruhJ3YwOGJEOa99SJ9SdJmUzSbKkObFNPr0dctazINwLzk63bri0JK5yQpwRX+GIl1MbSNFvGZavYlcE4qDiYUfSkQmWLD7BGUB3wzcpHqqXyxLbSb2wgbhuy4RpPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EuashNGN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EuashNGN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91D4DC4CEC5;
	Wed,  2 Oct 2024 13:22:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875359;
	bh=y2Sq0D3vznM9QJOUiu37tv4/U1wk+iKBNXeHOcT/BqI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EuashNGNEFBD88Vh9feCgOQsFktQC/EOpJ5lvbsONXdUhfar8ANqGfpwichpHuwV1
	 vqv5B0drdjwtZdSR2dHWLgYmKacrcY+LUqwNBlSGUR3GETw0bSNlZa5C3BxXhoJP8X
	 jbBHRVjP/Iw0TnVoXPUzYFHFDnvDzs9smaNOoub4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Chiu <chui-hao.chiu@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 075/695] wifi: mt76: mt7996: use hweight16 to get correct tx antenna
Date: Wed,  2 Oct 2024 14:51:13 +0200
Message-ID: <20241002125825.477232592@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 2e4fa9f48dfbe..e68724e54013c 100644
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



