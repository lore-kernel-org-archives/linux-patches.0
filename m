Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0F6850276;
	Tue, 12 May 2026 18:03:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608989; cv=none; b=BO5i3EZ+pJiKzeWa8R660mRgqXYf2QvAjh8WTVPZUnQOuM6FqA+Uluhs2INzb362LSWGEvdfHthSi282j/KARn85zpnlttZe1MWHAjWO7DFZ7zHCDhQGDGysujljatM0+4XCJstbhJyc7U/OVMqborAf6E/uC+tLN3oebEu3HOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608989; c=relaxed/simple;
	bh=Kvp+rxm86rkLoYphZHI6dojFqZ+hniCh4Y3N6NNlr4c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ky8/UOUN1KF6phLClQfPWwt9qqBbIn91TZlp47YM82u0tleIFPknXX3f0YyUcGm1AVwA6N8V4d9D6SHKgira4I6P0MQLhV1G5xDxhCTgFqIg/vi4HG0KESLR4AJj++SuRoCz4SenI6vwvC9neNQYJe7Rz5AN1m3tULrcBfYDS6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AvPAMzu2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AvPAMzu2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57708C2BCB0;
	Tue, 12 May 2026 18:03:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608989;
	bh=Kvp+rxm86rkLoYphZHI6dojFqZ+hniCh4Y3N6NNlr4c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AvPAMzu2zGefJ8sQmhQzP8Gp52Vi4oQkQw2d8VvfIkhxSPWMTtjHWb5x8uRl0NFiT
	 RAJ3GfCnaCLZQaWvGRCT0iQgSj9j6Nyz9w4imkfSYldOOAie9CfQ/NA2+gNhNK2Yvr
	 J6S89blAKPummW2YLSEYkDm080m0jVPLKFOe2QfM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quan Zhou <quan.zhou@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>
Subject: [PATCH 7.0 022/307] wifi: mt76: mt7925: fix AMPDU state handling in mt7925_tx_check_aggr
Date: Tue, 12 May 2026 19:36:57 +0200
Message-ID: <20260512173940.595941163@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Quan Zhou <quan.zhou@mediatek.com>

commit bb8e38fcdbf7290d7f0cd572d2d8fdb2b641b492 upstream.

Previously, the AMPDU state bit for a given TID was set before attempting
to start a BA session, which could result in the AMPDU state being marked
active even if ieee80211_start_tx_ba_session() failed. This patch changes
the logic to only set the AMPDU state bit after successfully starting a BA
session, ensuring proper synchronization between AMPDU state and BA session
status.

This fixes potential issues with aggregation state tracking and improves
compatibility with mac80211 BA session management.

Fixes: 44eb173bdd4f ("wifi: mt76: mt7925: add link handling in mt7925_txwi_free")
Cc: stable@vger.kernel.org

Signed-off-by: Quan Zhou <quan.zhou@mediatek.com>
Reviewed-by: Sean Wang <sean.wang@mediatek.com>
Link: https://patch.msgid.link/d5960fbced0beaf33c30203f7f8fb91d0899c87b.1764228973.git.quan.zhou@mediatek.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/mediatek/mt76/mt7925/mac.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/mediatek/mt76/mt7925/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mac.c
@@ -882,8 +882,10 @@ static void mt7925_tx_check_aggr(struct
 	else
 		mlink = &msta->deflink;
 
-	if (!test_and_set_bit(tid, &mlink->wcid.ampdu_state))
-		ieee80211_start_tx_ba_session(sta, tid, 0);
+	if (!test_and_set_bit(tid, &mlink->wcid.ampdu_state)) {
+		if (ieee80211_start_tx_ba_session(sta, tid, 0))
+			clear_bit(tid, &mlink->wcid.ampdu_state);
+	}
 }
 
 static bool


