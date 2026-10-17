Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8A6D384CED;
	Sat, 17 Oct 2026 16:22:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254178; cv=none; b=lmLxk98KwUlUcQVx4A85pyOx8kY/aibuzcReZIWwOVOhHCObihWIHY1tAaG70OxxG48iT6Vtk/5egMo/sfZb+D3ULsbYV3zmIwZeNI83KPPwwcpb2eatUyuLOwxafVkMBHTAs1IEVlmCcx4g4eFm1Vr3/YPebUfSv4Ii1jb0N4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254178; c=relaxed/simple;
	bh=oLo27py/iCzqS8biisA8rxH+ZlBTtsACIf9y6fSYWxs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IXlD9rij/EER7Lr8bDAPo6L4OatAB97ct2yydmDF2jlW0oKt7CNWsJKpyAq9EjxyWD5Nq2yyqJL3ANRTjqECKiVPTZu1e9P2B99DQZjTcVZujEMQHBQ03BK494Kvoo/Gd9hFO1uFDMa65HtG0EytVbzpk4YjuXlMohnBtsB1MjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UBBhF2ZN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UBBhF2ZN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F40A11F000C4;
	Sat, 17 Oct 2026 16:22:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254177;
	bh=0R0C1E+03gNvEqlNZ59ViDQSW56KWsM7Z4wE+hh4hc8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UBBhF2ZNVSQTkitvsDn9mm/TM1CiwAzBIcvE1WvB4P6K1Zs+KdyCpAID5xebNp6qX
	 do4PpThC0QE1slhvaWVotP9VJr49t8lyMFWJji6TKOVndKNlmnqpRQj2NJbnpJlpvC
	 ddNx/DhFsAuKo/YV0cSpI5dsujmIC8xOlvrPu1jI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sarika Sharma <sarika.sharma@oss.qualcomm.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 361/869] wifi: mac80211: fix missing RX bitrate update for mesh forwarding path
Date: Sat, 17 Oct 2026 17:53:22 +0200
Message-ID: <20261017160046.362860768@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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
index 7e3bcd709c579..7b4528e858bb8 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -4968,6 +4968,11 @@ static bool ieee80211_invoke_fast_rx(struct ieee80211_rx_data *rx,
 
 	/* after this point, don't punt to the slowpath! */
 
+	if (fast_rx->uses_rss)
+		stats = this_cpu_ptr(rx->link_sta->pcpu_rx_stats);
+	else
+		stats = &rx->link_sta->rx_stats;
+
 	if (rx->key && !(status->flag & RX_FLAG_MIC_STRIPPED) &&
 	    pskb_trim(skb, skb->len - fast_rx->icv_len))
 		goto drop;
@@ -5002,6 +5007,8 @@ static bool ieee80211_invoke_fast_rx(struct ieee80211_rx_data *rx,
 	res = ieee80211_rx_mesh_data(rx->sdata, rx->sta, rx->skb);
 	switch (res) {
 	case RX_QUEUED:
+		stats->last_rx = jiffies;
+		stats->last_rate = sta_stats_encode_rate(status);
 		return true;
 	case RX_CONTINUE:
 		break;
@@ -5015,11 +5022,6 @@ static bool ieee80211_invoke_fast_rx(struct ieee80211_rx_data *rx,
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



