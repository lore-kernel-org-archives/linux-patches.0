Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FE1437C92C;
	Thu, 30 Jul 2026 15:37:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425827; cv=none; b=kurKE2en+sCo0iJCzl3nA5ld0QbAS+MuiP74Ya8N3PrZQVEbC6y25xyubHVNZu3hW8gbswJ/aToU4MPb6SB8+4jODf6bzfNMP1jOPKczfV5koir5vkjFM4n1pdE3cg9qHdc2vjMs1opl0innFRTYLdWOFDDmZtOUonqdyOSO8lY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425827; c=relaxed/simple;
	bh=QyJpMLx8ZCK3rhlLEQF2pc103fVgMSu/mxXq7P/Jf1k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uHa8KQ/RBTmyTau2w4xtLk6+N3hY9iRtlhoTqzzgsBzF+UubtwAT9pWl4q0BqEf/ltG8+MoB872OhGm7LRjkjWFDcELJaqpxKl3aW2wmS8zk7VSAuwH5mnUebN5O90ZbOCBZUH9NAGp+J5K0VjNgMv1BoiXF7gDbPyFdlAPDTY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tdaZD4K0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tdaZD4K0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB4541F000E9;
	Thu, 30 Jul 2026 15:37:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425826;
	bh=afkbpa8KJbpJUTPph46z2hH5rorQUiJPWtsdqWxTXGs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tdaZD4K0oeoW+l+Fgm5KAVjfpluxu0ofwrKU4bdQlrQgMr+uSMYle6eX/OAD7LLX8
	 kQ0l2HSsZfhVrzB8z4VyNktY289uU3GYZ/BqIylRncR34p/KrG6VJGTvpFvtthNXhP
	 Fxf5+AvW2+Osc0Pcng1fCxCb3MSMuYXlZAX+eXEs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 205/602] wifi: mt76: mt7925: guard link STA in decap offload
Date: Thu, 30 Jul 2026 16:09:57 +0200
Message-ID: <20260730141440.265022315@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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
index 98ec76cf2fe8b4..1dbc6d22b06661 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
@@ -1583,6 +1583,9 @@ static void mt7925_sta_set_decap_offload(struct ieee80211_hw *hw,
 
 		mlink = mt792x_sta_to_link(msta, i);
 
+		if (!mlink)
+			continue;
+
 		if (enabled)
 			set_bit(MT_WCID_FLAG_HDR_TRANS, &mlink->wcid.flags);
 		else
-- 
2.53.0



