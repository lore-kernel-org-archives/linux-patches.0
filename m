Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACABA4F3EAF;
	Tue, 13 Oct 2026 11:56:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892600; cv=none; b=IAmZn/YbYTXbJiGgmoeDCtRj8lSWoZlHQ/HkWyxAf/vNFLQw9IBIyeiNemkcf0d0ZMsa63TuuxjEyThrUd3Yq6uslcxRgUK6RvL2uTAnlqWdDNta70BbWjiMlUN2BfljxSAEN92arHk2mz0r9KofB7LDZu+RPn5nq6arQVli/AU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892600; c=relaxed/simple;
	bh=dB6/ZH2TJC4XK6NqfQAqrfDyMU1cOGO8b5LaOa7MZAE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HCDQHTwDqOxlUZA4+2RSq7q4dyfUeITywHz9V/PrigRIZNo8lfYB7UwiYpe435YytZJ2ziYa+1cvXNKZ5Kmkr/B1wA7jIOf0gj1epefo2INpqZbcR41qpgyV0Es+wIL8z75jek6cmnwbnGl1d/8o/xFBTkwcsBYuuooI2ZSecjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RG5sM+/7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RG5sM+/7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B8AB1F000FF;
	Tue, 13 Oct 2026 11:56:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892599;
	bh=j81G3BOq2/7183B+WTFTJaKFxBJJ5Mkurm2A+4ZniNI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RG5sM+/7wOXn0vvUc66XWgqGRgfMgquk0ZR3xCHGDZufOoFo4Mk0lztxnZC6g9ko1
	 dWA6u3dXliieT+Xk/92NQPd3Nzoe4xAmIpDhojWQ3ae72Dq9KNHAfBjNtR1gfNouq3
	 hUuBC0Kj5WNmnno7nGghlHcwykBzdlpaHWGJiWu4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 228/281] wifi: mt76: mt7996: take over connection monitoring
Date: Tue, 13 Oct 2026 13:39:04 +0200
Message-ID: <20261013112900.687303796@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
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

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 0ec14f8c8c5da1c9c314bce4f0bf53c009fbc998 ]

mt76 runs its own beacon monitor. mt76_beacon_mon_check() counts a miss
for each affiliated link of an MLD, and it stops the count while the phy
is off channel. mt7996 supplies it through mt76_rx_beacon(), but it does
not set CONNECTION_MONITOR. Therefore mac80211 also starts its legacy
monitor.

The legacy monitor knows one interface, not a set of links. It also
counts while the radio serves a different link. After seven beacon
intervals it removes an association that still carries traffic on the
other links.

Set the CONNECTION_MONITOR flag to disable the legacy monitor.

Fixes: 4df75606ece5 ("wifi: mt76: add per-link beacon monitoring for MLO")
Link: https://patch.msgid.link/20260818125825.395538-3-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/init.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/init.c b/drivers/net/wireless/mediatek/mt76/mt7996/init.c
index be6e105f5f063..95fb30404b857 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/init.c
@@ -536,6 +536,7 @@ mt7996_init_wiphy(struct ieee80211_hw *hw, struct mtk_wed_device *wed)
 	ieee80211_hw_set(hw, NO_VIRTUAL_MONITOR);
 	ieee80211_hw_set(hw, SUPPORTS_MULTI_BSSID);
 	ieee80211_hw_set(hw, CHANCTX_STA_CSA);
+	ieee80211_hw_set(hw, CONNECTION_MONITOR);
 
 	hw->max_tx_fragments = 4;
 	wiphy->txq_memory_limit = 32 << 20; /* 32 MiB */
-- 
2.53.0



