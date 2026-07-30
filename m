Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5E8543E4BA;
	Thu, 30 Jul 2026 15:07:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424060; cv=none; b=GTuik6TeKlVs4V5Lmj6bTj8PzIXbsI5k3p9chLd7jkoNDSpthMg7nypTVpXlT2rAT6psnBjsjxfDmI+jUoB0Ff7elhc4WR/mcSLghVuTszCLTTvq691V2N5a5LKixfLYt/MkpqXF05n0BW6F5noILANckxyqqxo7CeopkSxU1Zk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424060; c=relaxed/simple;
	bh=5eufumB5UpPKSwcEEgH/Kg0HjlvggiFbYKfus8BDqzk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dff+T3M1G1GvP69R2KYk62yI66ikyPyff9jZ7HmLdDBK1uL+JF0y3bX6U912GQ59mUVtu5FhHaOzmAVr3aZKdXLRKhnY9l7HGT8inXBHVO6h2WUoMeoEnPFt90dzKR//YXaVHCa+v5KHaOaw/Yd/THlKi3kt8idtgwJ36JMwzOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AJPfR1tl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AJPfR1tl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40D301F000E9;
	Thu, 30 Jul 2026 15:07:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424058;
	bh=4ddbRah4tNR7+pSjtQhEoeEbDfcdZScbfzXz6/seNyE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AJPfR1tly//hSzG/sYh2L/k/vorElhHLChfCP/Y427+pCIWyEqX8E0HlfMhkhojTW
	 8N7m9wvK3en4Ez6j9WPzzkGwQrgVjc8pVqucjcTbPze+mY6r8lWHAmaokMyFngFWwG
	 AreMSa7ZAQHZmQQLGJpgNrqemUUXgNq9wEKIDAvw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 259/675] wifi: mt76: mt7925: guard link STA in decap offload
Date: Thu, 30 Jul 2026 16:09:49 +0200
Message-ID: <20260730141450.642634258@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

From: Guangshuo Li <lgs201920130244@gmail.com>

[ Upstream commit 96ea44f2269f30364cffa054ee3a87e595bef0d4 ]

mt7925_sta_set_decap_offload() iterates over the vif valid_links mask
when updating decap offload state for an MLO station. The station may not
have a link STA for every valid link of the vif, so mt792x_sta_to_link()
can return NULL for a link that belongs to the vif but not to the station.

The function currently dereferences mlink before checking whether the
link WCID is ready. If mlink is NULL, setting or clearing
MT_WCID_FLAG_HDR_TRANS dereferences a NULL pointer.

Skip links without a station link before touching mlink->wcid.

Fixes: b859ad65309a ("wifi: mt76: mt7925: add link handling in mt7925_sta_set_decap_offload")
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Link: https://patch.msgid.link/20260708075539.726200-1-lgs201920130244@gmail.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7925/main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/main.c b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
index 6c0dc72efc3928..910713e62e14a5 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
@@ -1573,6 +1573,9 @@ static void mt7925_sta_set_decap_offload(struct ieee80211_hw *hw,
 
 		mlink = mt792x_sta_to_link(msta, i);
 
+		if (!mlink)
+			continue;
+
 		if (enabled)
 			set_bit(MT_WCID_FLAG_HDR_TRANS, &mlink->wcid.flags);
 		else
-- 
2.53.0



