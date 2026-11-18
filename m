Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025860;
	b=RqXHUCqC/tEdMI1ZOYF5aza3un36Nz2AdFZodc1pQ+B/3f3lvx5YgP6sSjs0dxtYEkA8
	 jIJNP6xaaRso1RkZy4H9/4ro3YxwlPJg3KnzZDrOe3zICfJuCrnQ5mld74eWAnOtn9W+t
	 i1spOwU1CNhR5RvdrRhku19aLzgOU5D9Du9t6+k92SB8Dp6orB7/srpoSMks3h8nLudVM
	 TnddAIMKn4xKlHzpzqYJZFfFvnryPRYvc1ttg1el+8fyjiz88URE7q3Jtk8Yc2nzFj+hJ
	 HIwtJRsDlmmPpqKrmRCTlV2uoI6EmJV94ZyMYou4CIWASHTHyuuA71TQXq3tWCzJ//A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025860;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kOGfRyu3QsZ88HGOWpXsO3ME+uNjPhjxwjLvSTn4YJg=;
	b=jsN9BLKOZmJflHUaxiPM5USA30/ZyFFsYEy5VOCxDQ4ClrOQZJ8LCXNbr2xgDA6m3i26
	 uiF+kIiCR1aGhSBX8hGOLsDYZUu4QTB+rAUuRv5BPp7VzFhDErb8cneDDzjNi/c1xc2la
	 vicFoNG5ZWUsRbCrnmgbOQLkzcJVdonW1twELAWhhfiJxOXgPPMRGHBGMIwNUuxqHVkzw
	 HMBiXVVqQD5h9wfxnIYSJo411KDcBO8fiTlG6gzDvW/nY1r0Tk+YdJ3C77vMwavABA9Qo
	 6F/pmw/TC8y7tXAnifk2Wq7mnfGoTqD1UFtjf3szVn5yg/GM+MYevMRlhbs7LCA12SQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r85mYWdA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43C3D606A31C;
	Wed, 18 Nov 2026 18:17:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r85mYWdA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E2D21F000C4;
	Wed, 18 Nov 2026 18:17:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025860;
	bh=kOGfRyu3QsZ88HGOWpXsO3ME+uNjPhjxwjLvSTn4YJg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r85mYWdAwn7kO6h0D2NPc3Vmvv45ctD7cT8bhU7+25ce65tqfPTDQ99rnhs5C52QX
	 mQlwxQvdkfRl1Vd9HEEm8UolVjkfJF9cpOMCgiFsSZld18e005XGBVx5xvoZu67bzv
	 wOySN/+hCg4Ez1+n6kWkjMBdVLvqTimRgDEt80YE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1228/2151] wifi: mt76: mt7996: upload only the keys of the link being set up
Date: Wed, 18 Nov 2026 15:49:23 +0100
Message-ID: <20261118150206.921138841@linuxfoundation.org>
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

[ Upstream commit 2ec14ab42dfd195976bd834fecbcea00ae7da600 ]

mt7996_vif_link_add() and mt7996_vif_link_destroy() walk the vif keys
through mt7996_key_iter(), which passes every group key to
mt7996_set_hw_key() for the link being set up. On an MLD interface each
group key belongs to one link, as key->link_id says, so a new link gets
the GTK and BIGTK of the other links written to its group WTBL entry,
and its hw_key_idx set to their key index.

Skip keys that belong to a different link, as mt7996_set_key() already
does for keys that mac80211 installs.

Fixes: eddc7286f6bb ("wifi: mt76: mt7996: fix key add/remove imbalance")
Link: https://patch.msgid.link/20261006205936.669125-7-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/main.c b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
index c18ac44968c37..ed6f704a27cbc 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -288,6 +288,9 @@ mt7996_key_iter(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	if (sta)
 		return;
 
+	if (key->link_id >= 0 && key->link_id != it->link_id)
+		return;
+
 	WARN_ON(mt7996_set_hw_key(hw, it->cmd, vif, NULL, it->link_id, key));
 }
 
-- 
2.53.0



