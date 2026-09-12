Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2907419FC9;
	Sat, 12 Sep 2026 10:31:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789209081; cv=none; b=sIuzWJ4zyWtMZ7hNoL1/tu+ppBOyIOhkBDAshYhtszspV0LserrrAZFCwded5ybC576fosft5/ap24UwA4R38eTAelfEj8ZPosEs6U9qKwWauEuuy4pS1vbyAdiUMYIM901vxxmEovEYBH39hS9r/WF6JJIMQwb/NmbuBhptkTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789209081; c=relaxed/simple;
	bh=KlvKcP/i1HncgkxCV0mAfFwugvwgSvFL2LPWD1BHokc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vku2FdBoBTFV56plgM5XmsLRETKV+juNHenC7kd1LiUeVKNttbfg69Pa0HMh8iyuqYQMka3sByzLoZYszf/eNa8Gbi1evh1KR7tlLObPkTpscXbRujJbaEVGUbq3HWUqhgy0jJPwtPXUOKzlfxXNumyxIu33P1/EVVRLhMEiJRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DN4ba6T5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DN4ba6T5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95DA91F000FF;
	Sat, 12 Sep 2026 10:31:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789209079;
	bh=WGudW7px5ba6umHqntyBuYbcn66fhWz1NFmN3DsW4rU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DN4ba6T5o583c9v+MUjHwjrRgKW5iaxiKhshNOt1yEjlXV/tiyiA8o12bTHiAWH18
	 ViyXk7S5dWHDLZfTZIUlEnFhl0Q7A/GE+pv2FY7F1eYkf7h22q8cXrEin9XeQ7wQEz
	 c88lCaAngC63TQ3/FmHHE2X8V7uqAvtGoGAnK2n0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0749/1518] wifi: mt76: mt7996: dont report a zero TX bitrate
Date: Sat, 12 Sep 2026 08:48:38 +0200
Message-ID: <20260912065640.375345119@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit d4d92ccded678c92c390003926097ddbb6516bc7 ]

mt7996_sta_statistics() set NL80211_STA_INFO_TX_BITRATE unconditionally
after the block that already sets it, so a station with no rate info yet
was reported to userspace with a valid-but-zero TX rate. Drop the
redundant unconditional assignments; the in-block ones are sufficient.

Fixes: b34f346b917e ("wifi: mt76: mt7996: drop return in mt7996_sta_statistics")
Link: https://patch.msgid.link/20260722082610.2699628-10-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/main.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/main.c b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
index 103851e011583..840a0b7dd20c5 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -1733,8 +1733,6 @@ static void mt7996_sta_statistics(struct ieee80211_hw *hw,
 		sinfo->txrate.flags = txrate->flags;
 		sinfo->filled |= BIT_ULL(NL80211_STA_INFO_TX_BITRATE);
 	}
-	sinfo->txrate.flags = txrate->flags;
-	sinfo->filled |= BIT_ULL(NL80211_STA_INFO_TX_BITRATE);
 
 	sinfo->tx_failed = msta_link->wcid.stats.tx_failed;
 	sinfo->filled |= BIT_ULL(NL80211_STA_INFO_TX_FAILED);
-- 
2.53.0



