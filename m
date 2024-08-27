Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 764A91C5792;
	Tue, 27 Aug 2024 15:19:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771962; cv=none; b=n6waJDjInyxMizt0AH0xJz76vAtoqrPFHTtvXHp4PyslT/XsM23Cw6tGyB/xcs0qmHE0e33nIqP2s+Gr558Cl3ogP4SF5UtKxQ/mLik0v1LyBpNIyqv22etAjq9LSLd7T4i3vg5iBSvTocaWTr0vYW/fouWkTqK3YmfPUd3jrhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771962; c=relaxed/simple;
	bh=kYK9+Xj4pYIhuR8VYGXq32j9JHM8NZghIkhoB5nEHkU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sQXhbOxkLrB+xJaz7d20fAg9HXCTjdBEHXiQYIW9t7ODaDdIVAQBiIiywZiJsp1+x+LUSVkboQaoXublsCRfHmwxgcuCG+ocwNC9PLbWskAEnshm7zuG7v4NQ/ddq4Y2sVd+QFWbZJK1Cx0WPZ2Sz5kRK12Wkr/9JyFmxDFkMQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UKOdY+xl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UKOdY+xl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD85FC61067;
	Tue, 27 Aug 2024 15:19:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771962;
	bh=kYK9+Xj4pYIhuR8VYGXq32j9JHM8NZghIkhoB5nEHkU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UKOdY+xlf97b6X4kk8/DuwRr3v6NLwpizhrjui161cch5v5nN7D1TqfhNGhYkDp+3
	 XY7FYZvc+gNY0rwKqXdTjnT+UL0OaxFZZaEhvb0xaXsKDGs2sz0FpqtMCt/W3ts7tq
	 BLT7rujvSCO+QBE1/E2tIJ4oCGxSC4AnYu3jeacA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 065/321] wifi: mac80211: remove mesh forwarding congestion check
Date: Tue, 27 Aug 2024 16:36:13 +0200
Message-ID: <20240827143840.713296877@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 5c1e269aa5ebafeec69b68ff560522faa5bcb6c1 ]

Now that all drivers use iTXQ, it does not make sense to check to drop
tx forwarding packets when the driver has stopped the queues.
fq_codel will take care of dropping packets when the queues fill up

Signed-off-by: Felix Fietkau <nbd@nbd.name>
Link: https://lore.kernel.org/r/20230213100855.34315-3-nbd@nbd.name
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Stable-dep-of: 9ad797485692 ("wifi: cfg80211: check A-MSDU format more carefully")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/debugfs_netdev.c | 3 ---
 net/mac80211/ieee80211_i.h    | 1 -
 net/mac80211/rx.c             | 5 -----
 3 files changed, 9 deletions(-)

diff --git a/net/mac80211/debugfs_netdev.c b/net/mac80211/debugfs_netdev.c
index 08a1d7564b7f2..8ced615add712 100644
--- a/net/mac80211/debugfs_netdev.c
+++ b/net/mac80211/debugfs_netdev.c
@@ -603,8 +603,6 @@ IEEE80211_IF_FILE(fwded_mcast, u.mesh.mshstats.fwded_mcast, DEC);
 IEEE80211_IF_FILE(fwded_unicast, u.mesh.mshstats.fwded_unicast, DEC);
 IEEE80211_IF_FILE(fwded_frames, u.mesh.mshstats.fwded_frames, DEC);
 IEEE80211_IF_FILE(dropped_frames_ttl, u.mesh.mshstats.dropped_frames_ttl, DEC);
-IEEE80211_IF_FILE(dropped_frames_congestion,
-		  u.mesh.mshstats.dropped_frames_congestion, DEC);
 IEEE80211_IF_FILE(dropped_frames_no_route,
 		  u.mesh.mshstats.dropped_frames_no_route, DEC);
 
@@ -741,7 +739,6 @@ static void add_mesh_stats(struct ieee80211_sub_if_data *sdata)
 	MESHSTATS_ADD(fwded_frames);
 	MESHSTATS_ADD(dropped_frames_ttl);
 	MESHSTATS_ADD(dropped_frames_no_route);
-	MESHSTATS_ADD(dropped_frames_congestion);
 #undef MESHSTATS_ADD
 }
 
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 709eb7bfcf194..8a3af4144d3f0 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -327,7 +327,6 @@ struct mesh_stats {
 	__u32 fwded_frames;		/* Mesh total forwarded frames */
 	__u32 dropped_frames_ttl;	/* Not transmitted since mesh_ttl == 0*/
 	__u32 dropped_frames_no_route;	/* Not transmitted, no route found */
-	__u32 dropped_frames_congestion;/* Not forwarded due to congestion */
 };
 
 #define PREQ_Q_F_START		0x1
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index b68a9200403e7..1d50126aebbc8 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2931,11 +2931,6 @@ ieee80211_rx_h_mesh_fwding(struct ieee80211_rx_data *rx)
 		return RX_CONTINUE;
 
 	ac = ieee802_1d_to_ac[skb->priority];
-	q = sdata->vif.hw_queue[ac];
-	if (ieee80211_queue_stopped(&local->hw, q)) {
-		IEEE80211_IFSTA_MESH_CTR_INC(ifmsh, dropped_frames_congestion);
-		return RX_DROP_MONITOR;
-	}
 	skb_set_queue_mapping(skb, ac);
 
 	if (!--mesh_hdr->ttl) {
-- 
2.43.0



