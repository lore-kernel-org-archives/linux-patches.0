Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 726AE346A18;
	Thu, 30 Jul 2026 14:33:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421995; cv=none; b=MtMaU+99ayX/2NcECrqcwzYh5VCR7+jydsagOUqmBVb5xgl5Wx6xeDhWuvKs0QLfUjPfXoE2jOWeorVREAjcz7T9DHB5YQ/L7KLt98al+wU98WadXtsjKvrIiM6Rhbp2EWtoNxvzecILOXVS7NuDEhFX0GF0V/UdtcxvyXoXLBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421995; c=relaxed/simple;
	bh=90Ntsh5mEBmKmn+YjcYYvYsduc/MyyVebsfXDe+EGaA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MevtQHiwJ2NNLRN2SYus3gvLCNnAXD5zK3P4ufooYBKkA+ip60Og1xGAmdSoV68KxvWWr5+GWtQN570kWqfYwSbp3+wS7JedggJbSxRC7Qh5FSwjELiFChzw4QKUzcywilNHs70MDJ+Ffp5PifYDNxLrd5aecyo4RBZjJDtRhGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zsfkyo/M; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zsfkyo/M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E84E1F000E9;
	Thu, 30 Jul 2026 14:33:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421994;
	bh=5dUIHgIZjLmJKj+pNMaBBcmfQMhUoLteyW+dqZWWovc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zsfkyo/Ms/qekI1mqo5LLqv6+0qK7F4kAuJ6FOT6Al6Yy9HJ1ZGjaBujj7yixIZ/e
	 sRXt/BWwstBQh02HRy/Lp49wypfzuqo3n+/Ac/1aJXJEvmFCr1Tvq4HLqvawJTI4LC
	 SaKmCyb4K9RwbM0FhxxVjyQyVvAJaCXghUHyGyLw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 289/744] wifi: mt76: mt7925: guard link STA in decap offload
Date: Thu, 30 Jul 2026 16:09:22 +0200
Message-ID: <20260730141450.433188124@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 8765121b916a26..e7fb49d0715011 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
@@ -1678,6 +1678,9 @@ static void mt7925_sta_set_decap_offload(struct ieee80211_hw *hw,
 		mconf = mt792x_vif_to_link(mvif, i);
 		mlink = mt792x_sta_to_link(msta, i);
 
+		if (!mlink)
+			continue;
+
 		if (enabled)
 			set_bit(MT_WCID_FLAG_HDR_TRANS, &mlink->wcid.flags);
 		else
-- 
2.53.0



