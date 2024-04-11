Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85BF313FD94;
	Thu, 11 Apr 2024 10:27:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831269; cv=none; b=BEP9kGyLyHHOMtoSO/WOkszz0jp/g6erNpTqnt1DejTOy7O52TejYbUdkZmducGJ5Kok4DpbMyaoRpU8a5tLff5OXi5FjKbjVJ06Hc/BgZ9nOU6glgqoZC/0RiywshycmGfu6c+/OcMAZLUeZpbvoQYth4i0rN+MJpnBa5qgHmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831269; c=relaxed/simple;
	bh=JFpZaJHgfB3/lWzrw+SA8TDLuwco7EqQfXKfEko23j4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZHsYVMGkVMoDld2fi0MUoABdxUhqaa/1Pgqy4XVIYZ5q3xM42iYy7JTk4i/HMVJuqhjvvlg+uzeuxvEfUkckifirxGX8NMMuf4D4x+nFjV/SXTGNb4EJKOcC1E/CCm/WJjreuMk62Xhdgw4JgjaOzjaRaw57KGG77u5HlBlPLBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YVrUjHxL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YVrUjHxL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E6A2C433C7;
	Thu, 11 Apr 2024 10:27:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831269;
	bh=JFpZaJHgfB3/lWzrw+SA8TDLuwco7EqQfXKfEko23j4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YVrUjHxLizYL32Or9my7IOIynur4Ybb+qStuknMS22eR+1vTO9IcXKEzCoQC6HDQ4
	 7q9KP6BTO1JLFhxuM2R9CT5DDhF+/a56EXaY2VGiRcEsd3MgAlbSF7iRYqlUOi2P9p
	 IzY6ggvKNH4efYRjLVmHUcTD34zxwROiYBkntEgs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Chiu <chui-hao.chiu@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 026/114] wifi: mt76: mt7996: disable AMSDU for non-data frames
Date: Thu, 11 Apr 2024 11:55:53 +0200
Message-ID: <20240411095417.659043379@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095416.853744210@linuxfoundation.org>
References: <20240411095416.853744210@linuxfoundation.org>
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

[ Upstream commit 5d5edc09197cd8c705b42a73cdf8ba03db53c033 ]

Disable AMSDU for non-data frames to prevent TX token leak issues.

Signed-off-by: Peter Chiu <chui-hao.chiu@mediatek.com>
Signed-off-by: Shayne Chen <shayne.chen@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/mac.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
index b0d0ae5080e82..73d46ec1181ae 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
@@ -757,6 +757,9 @@ mt7996_mac_write_txwi_8023(struct mt7996_dev *dev, __le32 *txwi,
 	      FIELD_PREP(MT_TXD2_SUB_TYPE, fc_stype);
 
 	txwi[2] |= cpu_to_le32(val);
+
+	if (wcid->amsdu)
+		txwi[3] |= cpu_to_le32(MT_TXD3_HW_AMSDU);
 }
 
 static void
@@ -887,8 +890,6 @@ void mt7996_mac_write_txwi(struct mt7996_dev *dev, __le32 *txwi,
 		val |= MT_TXD3_PROTECT_FRAME;
 	if (info->flags & IEEE80211_TX_CTL_NO_ACK)
 		val |= MT_TXD3_NO_ACK;
-	if (wcid->amsdu)
-		val |= MT_TXD3_HW_AMSDU;
 
 	txwi[3] = cpu_to_le32(val);
 	txwi[4] = 0;
-- 
2.43.0



