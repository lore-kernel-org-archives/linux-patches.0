Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDE991519BE;
	Wed,  5 Feb 2025 14:18:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765092; cv=none; b=cYAZMzqd4Vky3gN1ir905pl2RySHS8WMHhPV132jcb7eG1iV4tdxmPQ0U5qMZi3oEBKQA9Z3Yx7P3SQEZboi1GSh0K/6r8Kaddo7VL0dAfMk0IRaIDKEtrB+BjnqWUVfYpLv393tBeP0i708dTID7rC11ANObzjS8GIlGuzavZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765092; c=relaxed/simple;
	bh=vKkPrJdXoErywOAAxGrw70dnGtlSebcVKPjwBo0n9RQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eefLv2IhCWrrprFNlTu/bdmDvfT2WgF55Uj6/LKSZ/zi0c8XZgeHNS4FVbkd7r8Qu3bR3PmnkHOgLDtwSwsMhUDtQI7MUhyfzlBQyaTYRhvUkFjGAHQ8Jco5NtknzvCNsgQxZR+sY4YT+sxW9Wc0uDnszNVouyaQmy9rMAB6Eeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qbGl5oTL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qbGl5oTL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39B1BC4CED1;
	Wed,  5 Feb 2025 14:18:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765092;
	bh=vKkPrJdXoErywOAAxGrw70dnGtlSebcVKPjwBo0n9RQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qbGl5oTLfeD5nL7P0bfI72ijY3oCAL7xHy+Y9Ne+zHgYpS8kLxbSj03H6u83p3kJK
	 67l8UYw2SqfKw7yYF9+RXbBDhgdS9WmMb7+wBzzBnWSmBZ7ZilxxEsCMtrM3a2+fsT
	 ivImJOIpldji+WSull6W8ipQ6GalrVbMCWbtdl5o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Yen Hsieh <mingyen.hsieh@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 189/590] wifi: mt76: mt7925: Update mt7925_mcu_sta_update for BC in ASSOC state
Date: Wed,  5 Feb 2025 14:39:04 +0100
Message-ID: <20250205134502.511148192@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Ming Yen Hsieh <mingyen.hsieh@mediatek.com>

[ Upstream commit 0e02f6ed6a49577e29e0b1f7900fad3ed8ae870c ]

Update mt7925_mcu_sta_update for broadcast (BC) in the ASSOC state.

Fixes: 86c051f2c418 ("wifi: mt76: mt7925: enabling MLO when the firmware supports it")
Signed-off-by: Ming Yen Hsieh <mingyen.hsieh@mediatek.com>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Link: https://patch.msgid.link/20241211011926.5002-10-sean.wang@kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7925/mcu.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
index 60a12b0e45ee6..4577e838f5872 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
@@ -1903,7 +1903,11 @@ int mt7925_mcu_sta_update(struct mt792x_dev *dev,
 		mlink = mt792x_sta_to_link(msta, link_sta->link_id);
 	}
 	info.wcid = link_sta ? &mlink->wcid : &mvif->sta.deflink.wcid;
-	info.newly = link_sta ? state != MT76_STA_INFO_STATE_ASSOC : true;
+
+	if (link_sta)
+		info.newly = state != MT76_STA_INFO_STATE_ASSOC;
+	else
+		info.newly = state == MT76_STA_INFO_STATE_ASSOC ? false : true;
 
 	if (ieee80211_vif_is_mld(vif))
 		err = mt7925_mcu_mlo_sta_cmd(&dev->mphy, &info);
-- 
2.39.5



