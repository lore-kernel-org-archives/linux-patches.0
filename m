Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A7143955C7;
	Tue, 12 May 2026 17:51:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608301; cv=none; b=I6aE5Zuou1sOwVjo6emhBxs8YitESX7Cxsy9YX7JqLj/uhoD5skPW3EbUrEBQWebc0k1Vw3hAPDweuVegYOgGhHtHpzncmtsgkb5ao/0KVZNxN/2VGBeQx4n6AqcyjgGMdawGwE7wbBlo/D+6yIl6lmzSHfj4qeNmE6RJiFG6YY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608301; c=relaxed/simple;
	bh=Cuc+aMunHg4snyJg8kNsNHPOxosCtqwGCqpq+8m+lGg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r2jDRRRwtcFHjqQJdOzAxMw62KpA3pxbGCqEadoI0UKX+BT7gucNXja+B6s5+D0NroD2sWZFiht9zf8fkOqWNUEW+LzFJheqvz3jm4JQKEnqafRTgoVW2y9PgqxHFEBOH8nxNlvT/uERd7pgojx1H0D4PqFW3WJMqCI2sVbJD/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bS0EytLe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bS0EytLe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10829C2BCB0;
	Tue, 12 May 2026 17:51:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608301;
	bh=Cuc+aMunHg4snyJg8kNsNHPOxosCtqwGCqpq+8m+lGg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bS0EytLe4WMblxylCvYPzcoCLyf3rg7zXqbLfzexVKIAJI2J7K7uUafVB1x9r4vYr
	 pjR+mtzFBAtiDGvLXB/WECxQ+bZ0imwT88iZ8kytYnpz9MLrgaSANmIgRxC1A+3wzo
	 nlVG2Zu2YQaaRW61HqDA8pr+YmGrqY/dTulxTaWM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quan Zhou <quan.zhou@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>
Subject: [PATCH 6.18 026/270] wifi: mt76: mt7925: fix AMPDU state handling in mt7925_tx_check_aggr
Date: Tue, 12 May 2026 19:37:07 +0200
Message-ID: <20260512173939.007639638@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173938.452574370@linuxfoundation.org>
References: <20260512173938.452574370@linuxfoundation.org>
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
@@ -881,8 +881,10 @@ static void mt7925_tx_check_aggr(struct
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


