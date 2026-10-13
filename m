Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 607274F68C4;
	Tue, 13 Oct 2026 11:57:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892631; cv=none; b=XAtgVxtVUibmU4mkGo+6sbiwDY2Nhp4BB+5whuM7qfOrmIdo+23kAW7o+ELtoCaFBkCvT6LznkwKFywd5Bds1OOG+Nrn7jiRqYBviV06vLhHO3tKWwqb17K9UySwSgmL4jW54qA1IaUnHjJdzXMrFMiUPcyTEi2ufc47OqNEd3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892631; c=relaxed/simple;
	bh=+Rj7RfE/xHLTLnBZWj8PheDJHSSSPHJLDgwaET44jUU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iFPo4ctzNRt6jLwD4Q1rL1ddc2w4yGFlqfzC/MtVflnharXpajud85I8XYo8sClejBfGa1Y2ff6B4xhTLJC4aYUrd5IJBRxqcaGdJ8M4Gk/vze6wnTbwLDgi4hafY1nIOnjxmv/CRN8AXq9IaK7ZggTo/jE16ez3+0xAPlbDa0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zsdyrJVk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zsdyrJVk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C7741F000FF;
	Tue, 13 Oct 2026 11:57:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892630;
	bh=+sFJo7nFuUmz7+gBOspE0/lpWaHBVOJLyzjm4aIJOrs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zsdyrJVkd92LCSOkzxsG9bXxBtuBFQLU1MjiR487tno5Ig/Nj8SaXvTZB/gDHZkC1
	 iN6OaUdzRohUYqUuihqa+6zA5GhBoimLfyx3QeaWRTFvRrH7drzNtHWGMtSdCua3UR
	 VeXXSJTu2Q6J+CNWdIg/7OBHK73KqjL/KpqLgPrw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Devin Wittmayer <lucid_duck@justthetip.ca>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 237/281] wifi: mt76: mt7925: dont put the band auto marker in TGID
Date: Tue, 13 Oct 2026 13:39:13 +0200
Message-ID: <20261013112900.901166423@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Devin Wittmayer <lucid_duck@justthetip.ca>

[ Upstream commit 5796b2bf9ff718342773ac760d86eb126c112a4f ]

band_idx starts out as 0xff, which tells the firmware to pick the band on
its own. A remain-on-channel grant normally writes a real index over it
before anything else looks. Two cases never see that: an MLD station
throws the grant away, and an AP has no association to trigger one.

The TX descriptor reads the same field into a two-bit slot, so the marker
comes out as 3. Every data frame from those two goes out tagged band 3.
Beacons are fine, they reach the firmware separately and never build a
descriptor.

Same numbers on an MT7925 and on a Netgear A9000:

                        stock         patched
  station, one link     0x00000001    0x00000001
  station, two links    0x00003001    0x00000001
  AP                    0x00003013    0x00000013
  real band index, STA  0x00001001    0x00001001
  real band index, AP   0x00001013    0x00001013

Only the marker cases move.

Fixes: 0cb349d742d1 ("wifi: mt76: mt7925: update mt7925_mac_link_bss_add for MLO")
Signed-off-by: Devin Wittmayer <lucid_duck@justthetip.ca>
Link: https://patch.msgid.link/20260911024428.65244-1-lucid_duck@justthetip.ca
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7925/mac.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mac.c b/drivers/net/wireless/mediatek/mt76/mt7925/mac.c
index b52b678330604..8603915ddc2ef 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mac.c
@@ -781,7 +781,8 @@ mt7925_mac_write_txwi(struct mt76_dev *dev, __le32 *txwi,
 	val = FIELD_PREP(MT_TXD1_WLAN_IDX, wcid->idx) |
 	      FIELD_PREP(MT_TXD1_OWN_MAC, omac_idx);
 
-	if (band_idx)
+	/* 0xff means BAND_AUTO to the firmware, and TGID cannot encode it */
+	if (band_idx && band_idx != 0xff)
 		val |= FIELD_PREP(MT_TXD1_TGID, band_idx);
 
 	txwi[1] = cpu_to_le32(val);
-- 
2.53.0



