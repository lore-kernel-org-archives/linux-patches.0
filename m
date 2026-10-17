Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E52523B388C;
	Sat, 17 Oct 2026 17:42:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258949; cv=none; b=tFI4wzfTw4tiYGUhSiror9Y6a4W70V+jA/NdwhI46Lx85+ZHkXn1BnbtHTNRybWPTVodS6FKQ3zb54sKF5FfioOxddu3PX+iwf5v/W5vLh47xkzH/12tmDqJvxbcRJYHg0JrhKoecnNJmFb6iVSTPGYFWBw4WJ86L9d56lwfVLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258949; c=relaxed/simple;
	bh=i4fcf7riUnDyi2ByhpETMiE7BAfDsG187ltdbfeX4FU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h2gENqCeS1y600bIZ/woNAhxhdrxUwAs39MV8iuuCMzNwFcoGTx8c11spolg1ttrY71WV7EA08+5dnD6b5TwUdoDSqkiFSTpSx8W23kWH2T+mm2Q8+HpD8lvcFf8OWWHbX8F0x5xS49nJLvO/l65Ri87poGWNg3xmLi6itMQLMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BUGl9S8f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BUGl9S8f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D9911F000C4;
	Sat, 17 Oct 2026 17:42:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258948;
	bh=/RVsHQYOit1jasxgQEvq4ndm4/4fHlxRboajKDomk6o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BUGl9S8fM7GXo3+96G5E1JvQFZRIRUAtSJ6AJeuozy31U+lHhS6fVfIZu2Ape9/Vy
	 AQlZA78i6QSpRdxDIVNlxTgqoBo5/iEQTtfEwFn4izaNp3AEgZZiGKcRy/cM2oJDSn
	 Bl08bHEMNyZoKVlZqdrZ7IIgwE9kzmGh7lsP8g+I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sarika Sharma <sarika.sharma@oss.qualcomm.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1051/1674] wifi: mac80211: fix missing RX bitrate update for mesh forwarding path
Date: Sat, 17 Oct 2026 17:55:23 +0200
Message-ID: <20261017160458.107819258@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sarika Sharma <sarika.sharma@oss.qualcomm.com>

[ Upstream commit cc18fffa3a51792637169872886df3407bd5bb84 ]

Currently, RX bitrate statistics are not updated for packets received
on the mesh forwarding path during fast RX processing. This results in
incomplete RX rate tracking in station dump outputs for mesh scenarios.

Update ieee80211_invoke_fast_rx() to record the RX rate using
sta_stats_encode_rate() and store it in the last_rate field of
ieee80211_sta_rx_stats when RX_QUEUED is returned from
ieee80211_rx_mesh_data(). This ensures that RX bitrate is properly
accounted for in both RSS and non-RSS paths.

Signed-off-by: Sarika Sharma <sarika.sharma@oss.qualcomm.com>
Link: https://patch.msgid.link/20251024043627.1640447-1-sarika.sharma@oss.qualcomm.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Stable-dep-of: d71c841be5d9 ("wifi: mac80211: capture fast-RX rate before mesh reuses skb->cb")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/rx.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index b0f975dbdde0d..52b2b2b097d56 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -4906,6 +4906,11 @@ static bool ieee80211_invoke_fast_rx(struct ieee80211_rx_data *rx,
 
 	/* after this point, don't punt to the slowpath! */
 
+	if (fast_rx->uses_rss)
+		stats = this_cpu_ptr(rx->link_sta->pcpu_rx_stats);
+	else
+		stats = &rx->link_sta->rx_stats;
+
 	if (rx->key && !(status->flag & RX_FLAG_MIC_STRIPPED) &&
 	    pskb_trim(skb, skb->len - fast_rx->icv_len))
 		goto drop;
@@ -4940,6 +4945,8 @@ static bool ieee80211_invoke_fast_rx(struct ieee80211_rx_data *rx,
 	res = ieee80211_rx_mesh_data(rx->sdata, rx->sta, rx->skb);
 	switch (res) {
 	case RX_QUEUED:
+		stats->last_rx = jiffies;
+		stats->last_rate = sta_stats_encode_rate(status);
 		return true;
 	case RX_CONTINUE:
 		break;
@@ -4953,11 +4960,6 @@ static bool ieee80211_invoke_fast_rx(struct ieee80211_rx_data *rx,
  drop:
 	dev_kfree_skb(skb);
 
-	if (fast_rx->uses_rss)
-		stats = this_cpu_ptr(rx->link_sta->pcpu_rx_stats);
-	else
-		stats = &rx->link_sta->rx_stats;
-
 	stats->dropped++;
 	return true;
 }
-- 
2.53.0



