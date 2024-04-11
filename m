Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3845F1448F3;
	Thu, 11 Apr 2024 10:08:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830099; cv=none; b=k0nxS3QhMis8RE4FXnctTSHukoJdU7UmHt4fo1UEM7z6pwrJkyKZIDXxtLXv4vWV8+q9V3zikC2pHGAvSu9m5Wa1hBpz8uWdKzP2tx1Hv7ppIWGo91TQzOksn+Zil7LcAfqciBlSB8rY4PQuCDyQ9az4SOrpHePkBqTi6co5KeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830099; c=relaxed/simple;
	bh=fAhiJjEZ3CkYEzdk1BYRsp/jslGRFGU6GPSUgAekDzk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qr8GtRA5/tCHBzQrmbWclexQpJb5KFT223qOSzUnrEkZaaF/AV269BNvI9Wt0ua4BbRkKNdh54ETpc1mPMnaZ1vlTcP0iCXN9lNEPLHD4pho1NjeFQVI5Km+GFojwjt2uONqpKwG3mSGtjqCV7oKfM0JslLOMmQwom/rswC5mD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DdjKAXSG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DdjKAXSG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0BD4C433C7;
	Thu, 11 Apr 2024 10:08:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830099;
	bh=fAhiJjEZ3CkYEzdk1BYRsp/jslGRFGU6GPSUgAekDzk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DdjKAXSGzn+z78Q/gXxXfCQxa3ZAeUErhKK0lqWZZhZiiHFekFbVxaZr1BkH8ihMu
	 cfEeHMUHNEiSD3rRkNnUZxIF4CtJDZH/gD5aH41CKzToEq8oueW5p9rjiHdKVFQX1J
	 lOYJuiyWGj/NqoItyHbmrpyE2QH3RyVrci4dInyA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Chiu <chui-hao.chiu@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 034/143] wifi: mt76: mt7996: disable AMSDU for non-data frames
Date: Thu, 11 Apr 2024 11:55:02 +0200
Message-ID: <20240411095421.938790768@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095420.903937140@linuxfoundation.org>
References: <20240411095420.903937140@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index 63d34844c1223..0384fb059ddfc 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
@@ -732,6 +732,9 @@ mt7996_mac_write_txwi_8023(struct mt7996_dev *dev, __le32 *txwi,
 	      FIELD_PREP(MT_TXD2_SUB_TYPE, fc_stype);
 
 	txwi[2] |= cpu_to_le32(val);
+
+	if (wcid->amsdu)
+		txwi[3] |= cpu_to_le32(MT_TXD3_HW_AMSDU);
 }
 
 static void
@@ -862,8 +865,6 @@ void mt7996_mac_write_txwi(struct mt7996_dev *dev, __le32 *txwi,
 		val |= MT_TXD3_PROTECT_FRAME;
 	if (info->flags & IEEE80211_TX_CTL_NO_ACK)
 		val |= MT_TXD3_NO_ACK;
-	if (wcid->amsdu)
-		val |= MT_TXD3_HW_AMSDU;
 
 	txwi[3] = cpu_to_le32(val);
 	txwi[4] = 0;
-- 
2.43.0



