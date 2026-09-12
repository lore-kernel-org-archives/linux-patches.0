Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C44143859E6;
	Sat, 12 Sep 2026 08:17:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201048; cv=none; b=c3+A3sd2zsKRixz4326n16UaoHlXd5kiCYCP1rdj0ReqULhAo/3CzTirDdZVaW+V8k/cMobwnO6IREkku8MyC3giNjSitv/aCBcldedLaaPZS3mzHT+St+LSeqj56biPeEkCKsnhjJBQZ6Up/c19FkAxw7ZJMMV7HcmSDgfARSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201048; c=relaxed/simple;
	bh=kx7szNLnYmM6p7THJSUb6AZ35uhLV2zbLJ/DzpOY9pg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P3736ihTmqnrvHysAYloIKEtR2kGw7BrqAg9I659YjMV0TgzTWwZDNsZIYsAK+UCCKgBH3R4f3PrYa1sFsupLD6p1ulxb4qfoVX5jhxoBm2pVK59A06O7S5DsmOPyhqOk7U+EKrWiIl7WIphuyEXW1iNorEmp3dpd0PyepPfNzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gZNdd+GR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gZNdd+GR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E24331F000FF;
	Sat, 12 Sep 2026 08:17:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201047;
	bh=KBTL9wOt1jBwjuteTEXKHWZBd0prs+XJ8tFuN7PswzA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gZNdd+GRNr5n3SDX1wcafJ5FhNUS/032p8ca+D95Fgm0XpgVtUOc93Ey+7rfjX9MA
	 JRk00APK6RW0a1sQUjDVLpaC1pYkZmROEjhSi6jJ/ckTlv+hGwBLJRceX6h6S0fI7Q
	 xW52v8CIQXQh1qrEVDY/EekEa+dntloJqmX4U2xA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chad Monroe <chad@monroe.io>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0873/1815] wifi: mt76: mt7996: fix EAPOL source BSS for non-MLD stations
Date: Sat, 12 Sep 2026 08:43:43 +0200
Message-ID: <20260912065709.416808060@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

From: Chad Monroe <chad@monroe.io>

[ Upstream commit 6bb5066cfcd4296ac5e0b6872f43f96a43bfe566 ]

A non-MLD station's EAPOL and data frames are tagged with link_id ==
IEEE80211_LINK_UNSPECIFIED, which now skips the per-link lookup in
mt7996_mac_write_txwi() and leaves omac_idx/band_idx/wmm_idx at slot
0. When the radio also runs AP VAPs the station's omac is non-zero
(get_omac_idx() prefers HW BSSID slots 1-3), so its EAPOL frames
egress from the wrong BSS and the 4-way handshake times out even
though association succeeds.

In mt7996_tx_prepare_skb(), resolve the link from the peer wcid when
link_id is UNSPECIFIED and the wcid is not the global entry, restoring
the pre-MLO behaviour for station traffic.

Fixes: 729c83a3330c ("wifi: mt76: mt7996: fix reading zeroed info->control.flags after mt76_tx_status_skb_add()")
Signed-off-by: Chad Monroe <chad@monroe.io>
Link: https://patch.msgid.link/20260721185333.2419297-1-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/mac.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
index 730fd8e2fa057..49d778d76e675 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
@@ -1030,6 +1030,11 @@ int mt7996_tx_prepare_skb(struct mt76_dev *mdev, void *txwi_ptr,
 				       IEEE80211_TX_CTRL_MLO_LINK);
 	}
 
+	/* non-MLD frames are LINK_UNSPECIFIED; use the wcid's own link */
+	if (link_id == IEEE80211_LINK_UNSPECIFIED &&
+	    wcid != &dev->mt76.global_wcid)
+		link_id = wcid->link_id;
+
 	if (link_id != wcid->link_id && link_id != IEEE80211_LINK_UNSPECIFIED) {
 		if (msta) {
 			struct mt7996_sta_link *msta_link =
-- 
2.53.0



