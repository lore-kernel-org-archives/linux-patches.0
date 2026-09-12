Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15FF8202F71;
	Sat, 12 Sep 2026 12:39:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789216766; cv=none; b=N82nsaQiFJ6HhD4b9oGUV5+c3oRYFre6D7H8FT6Ws8tfhzavzttP242igw3HsS3zErcPez4c+V2Wsd9MVP6+9yjFO8yjgCOuMlOFjBtcO9xbHGCIKhnvahTfdeJurzYZ3VPVXgqEjnH0iRX91eJ21sFt2eDDURQrvzBBh8rGwxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789216766; c=relaxed/simple;
	bh=xT0XT3DCPEaxH6KZlAhbSlunFB/dWnKfjJ6eVOKMBoo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TBBCDd8QikmBDc27RkrxH5Bxn7G+j9O5LOx4EebVCBNnJy2Z/eDgljBlyv5ovIHPw13R/8iuxG3u8UnNHJcRebJrXqN9SFQ1yjk/lz0XA6bQUPTqdhsgmww3r9rVw7tAwU1Pw/newH42LOJ55mFFQRKiseztO+YS59W0rG9WXeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rGhjoty0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rGhjoty0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C3421F000FF;
	Sat, 12 Sep 2026 12:39:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789216764;
	bh=ZL0kTN1KIdqFbM/6qpwz2WE3M5J5WapbT74ahF+D1tk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rGhjoty0SFE/JkKqULK1aNJxHkL/icK7AM9MsKhYXse90/P4B86rVE1dGrXzgRkKJ
	 SgunbvOXOQsKPsiloRMh/2hY+ttptk95pXCoIjzsxl0/hJZ4ZKnUIh+Tnbo4Uekeum
	 Vet6lG1CncvkHkbLP7uqzWp3GfI+RJD/AGhEa6ps=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jared.Huang" <jared.huang@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0804/1376] wifi: mt76: mt7925: fix msg len mismatch between driver and firmware
Date: Sat, 12 Sep 2026 08:53:50 +0200
Message-ID: <20260912065625.453836324@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jared.Huang <jared.huang@mediatek.com>

[ Upstream commit 9ddb7487aa7cccb6e1880b4151ab5895109eb8d6 ]

The mt7925_tx_power_limit_tlv struct begins with a 4-byte rsv[] field
that acts as a UNI command header prefix. The firmware dispatcher did
not use the 4-byte rsv[] and will only check the payloads after the
4-byte rsv[] As a result, the total message length minus the 4-byte
prefix. Fix this by setting len to msg_len - 4.

Fixes: ccb186326bb6 ("wifi: mt76: mt7925: fix incorrect length field in txpower command")
Signed-off-by: Jared.Huang <jared.huang@mediatek.com>
Link: https://patch.msgid.link/20260617071320.1808499-1-jb.tsai@mediatek.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7925/mcu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
index 910775a2c39fe..ac241c2dfb980 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
@@ -3602,7 +3602,7 @@ mt7925_mcu_rate_txpower_band(struct mt76_phy *phy,
 		memcpy(tx_power_tlv->alpha2, dev->alpha2, sizeof(dev->alpha2));
 		tx_power_tlv->n_chan = num_ch;
 		tx_power_tlv->tag = cpu_to_le16(0x1);
-		tx_power_tlv->len = cpu_to_le16(msg_len);
+		tx_power_tlv->len = cpu_to_le16(msg_len - 4);
 
 		switch (band) {
 		case NL80211_BAND_2GHZ:
-- 
2.53.0



