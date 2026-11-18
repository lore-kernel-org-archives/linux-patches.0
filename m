Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025754;
	b=J03m2f2ClJTAEs/UrXcGduXmmSXqTlO0FLFC/NTG1vvXm82QwmLVmYKJYjoOqkar1qUZ
	 Y0KBuJe2OjDeGBfZf3s0/+wLYSsJaPxVJ6WG7ucmtqgRZIfu2DA3HucsngXhk00rKitgA
	 cfydTa+20WAccyrxNgxglf+RbwThS+4rGCshxWDK8JH2NYON4MxwueTrb2lWVvYrUWTC9
	 b3cLjRwD8OOnpL2CW38aCjdF6qwcE3X0/LQB8relh2Dp0z8Pw0QSec8Cit3/z6o2li7+W
	 jLjoM7BVQwNt8f1oTHbi89INqI2cOqIVCRX9rePalSyxtD9gmVgmtUgbNi+ifubW4fg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025754;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GtXNpe3sLuDblbVJlyz4SrUlhWBjPKMVEOcfD0ZBhmA=;
	b=A1Gx6+JkuJxq03EDoo+Uj/feLkdMDcaPSnh2FGJl6LVzDD9n6w8ZzucV9ybSzYQDDere
	 6heZsTQKZKkl9VSj0K/8mieHWWJ5IIds3TzuaT7P5r/v4cYov77be64Cnuo7e1lTCIczW
	 wprP1nuuSqM1suile7KVo9FZx6jG46HNHYubnZfTmTgGoLwNc4/h3r5mZaErSRSTvXyvL
	 0DN419kDvesoD+bD/GUpWbivXpiXoPygM6vB9BxcMLOCD9RFZ8rlg+hNvVzfacv8Z8Rlj
	 WqyV4xyAO/4FdjVoygnmsmoq0RWzvI2bBt72BHD6Bqg/1dJ9Nn1CR2FLdmmbIOG5CbQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="m/GzyO4Y";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10D2C606A320;
	Wed, 18 Nov 2026 18:15:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m/GzyO4Y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 698B11F000C4;
	Wed, 18 Nov 2026 18:15:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025753;
	bh=GtXNpe3sLuDblbVJlyz4SrUlhWBjPKMVEOcfD0ZBhmA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m/GzyO4YTtwAcB2//shKHPeAlh85qez1vthIy/ZTwT+lj/uATwgNWCabClaWFTzXr
	 ePtInc4CYeXRtziTtczUe81A3tk9Pm9Ohhghhz6JXFS0lz43PN5OUPlfvOW0kLsoNF
	 AZvLgofxUuuFdSt1YmYO3AAXmIPy+UT3EynYOrGM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1190/2151] wifi: mt76: check chanctx before restoring channel after ROC
Date: Wed, 18 Nov 2026 15:48:45 +0100
Message-ID: <20261118150205.574996654@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit f0fb9afb74ec5bec49585772502db62613321fc6 ]

mt76_remove_chanctx() sets phy->chanctx to NULL but does not clear
phy->main_chandef. If ROC is later performed on that phy, completion
tries to restore the stale main_chandef channel, programming the
hardware to sit on a channel with no active context.

Add a chanctx check to avoid restoring a channel when no context is
active.

Link: https://patch.msgid.link/20260309060730.87840-4-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Stable-dep-of: 3aaa4871006d ("wifi: mt76: clear offchannel state if a scan has no channel to restore")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/channel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/channel.c b/drivers/net/wireless/mediatek/mt76/channel.c
index 5aeaf964e67b1..08c910bd835f2 100644
--- a/drivers/net/wireless/mediatek/mt76/channel.c
+++ b/drivers/net/wireless/mediatek/mt76/channel.c
@@ -330,7 +330,7 @@ void mt76_roc_complete(struct mt76_phy *phy)
 
 	if (mlink)
 		mlink->mvif->roc_phy = NULL;
-	if (phy->main_chandef.chan && phy->offchannel &&
+	if (phy->chanctx && phy->main_chandef.chan && phy->offchannel &&
 	    !test_bit(MT76_MCU_RESET, &dev->phy.state))
 		__mt76_set_channel(phy, &phy->main_chandef, false);
 	mt76_put_vif_phy_link(phy, phy->roc_vif, phy->roc_link);
-- 
2.53.0



