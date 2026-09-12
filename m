Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD41733689D;
	Sat, 12 Sep 2026 10:31:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789209104; cv=none; b=lOgHkV8RZwdjW6Fvxr1gqYqmP/9vnbEgEhqHBgIgEVBTB/mRUO8YTN1IhXrXDEesQUrd9gVkvnDUdAxvxQX/lUimRcJRjpOBXuJom39tQMEdzND6gPSGjOyciwoDIXzv1L+/Iu7AG8c4ZjHX0p6ZOlUJ8iqPyr+ic2tQZtTfjYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789209104; c=relaxed/simple;
	bh=ne9Zrug0K3749PuNinDBe23JCQxtBGM3qUfIycbtomA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X/CuNbOqw0crgDYoD8IIMhHVQS3kePw+MO6qscU95gquMe/tREPjS+lQUZx+n9xIXQsJC//CSLP946V/6rNKXlw2mzsPn7ByRMVWpo0wY7mb8oJg7GiyXlLGrvxMx8BXlncSSebUtzo91wlc7L2DfDNChYAcbJdjupWaARab5EA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j6Yu1sLe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j6Yu1sLe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BE841F000FF;
	Sat, 12 Sep 2026 10:31:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789209102;
	bh=/+Zmk3dDPQQVJeDkNspFaRgaO/fKI3i+M6ILTiMwzNQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j6Yu1sLeaO/3UR9zXlZqogWDRTRby0/7vbP5E8e3stPQHJuZIsxgJBTieCJFeHcHz
	 L7pcToHKiUczaq9n2AxnURHtnVccMo9eWvxZUNaNpDFHuNcABivqsCsqCnr6iHqmEx
	 1TQxCh/8uNm4JlLMfzvV/cJDYl3nwvPUm2eqSg7E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chad Monroe <chad@monroe.io>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0736/1518] wifi: mt76: mt7996: fix EAPOL source BSS for non-MLD stations
Date: Sat, 12 Sep 2026 08:48:25 +0200
Message-ID: <20260912065640.085568185@linuxfoundation.org>
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
index e55bb232bdebc..60687064f7368 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
@@ -1069,6 +1069,11 @@ int mt7996_tx_prepare_skb(struct mt76_dev *mdev, void *txwi_ptr,
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



