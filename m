Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98F351C688F;
	Tue, 27 Aug 2024 15:33:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772799; cv=none; b=HWiAoJ293gPG2pZnCxnAVjvzKpdTpJ2VJDb5UrpvvTY7zzRunThsH8UAZqlHhx027UFDqb/RblKCfqlBlbo9tE4Pt16c4PIpypWZJriwQjKfETIMgRIis5aHY2xgDbsBqswq3LWBYphiM5ntLEuXihWMo1qAM7RGPBB+R4zvRo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772799; c=relaxed/simple;
	bh=h6rrhIL7RAugV/BIVdwbKePmwWlfAHqu8V+8hRjtnXQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z4FvSH+LZXdD4KOv1df5Ze6UwGDeY830rpM09nuCEaTML4bzyW+ATOMf8tBcUfbPr9MIQQGZHrGxvxOgQH5AL1JMXXJqmnIc7GrkFYzU4jvQnWlDKaCDvoxrw9DLA2bqKvfO3lw9ZreKQZ+IMDmplEmUs/crK7IdKrJ/d7cx9pY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qhQwQJlI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qhQwQJlI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05120C61050;
	Tue, 27 Aug 2024 15:33:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772799;
	bh=h6rrhIL7RAugV/BIVdwbKePmwWlfAHqu8V+8hRjtnXQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qhQwQJlIuG4fEtGd3/GLbvpUBL5ASsha1oVkvsXvixGCVVwC+3Nu88xn+qlmPjZFz
	 3fmBNt1c+TzB2a38+ai8wx7H9VYmy9dbk2f5OFFPrh6OGDA55mwoA/S5cTd4MUds13
	 KUdvKMHqgIY0bjnDDz4jbIYIqHSEXO0aymcWL5Ik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.1 305/321] wifi: mac80211: fix mesh path discovery based on unicast packets
Date: Tue, 27 Aug 2024 16:40:13 +0200
Message-ID: <20240827143849.866144472@linuxfoundation.org>
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

commit f355f70145744518ca1d9799b42f4a8da9aa0d36 upstream.

If a packet has reached its intended destination, it was bumped to the code
that accepts it, without first checking if a mesh_path needs to be created
based on the discovered source.
Fix this by moving the destination address check further down.

Cc: stable@vger.kernel.org
Fixes: 986e43b19ae9 ("wifi: mac80211: fix receiving A-MSDU frames on mesh interfaces")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Link: https://lore.kernel.org/r/20230314095956.62085-3-nbd@nbd.name
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/rx.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2770,17 +2770,6 @@ ieee80211_rx_mesh_data(struct ieee80211_
 	    mesh_rmc_check(sdata, eth->h_source, mesh_hdr))
 		return RX_DROP_MONITOR;
 
-	/* Frame has reached destination.  Don't forward */
-	if (ether_addr_equal(sdata->vif.addr, eth->h_dest))
-		goto rx_accept;
-
-	if (!ifmsh->mshcfg.dot11MeshForwarding) {
-		if (is_multicast_ether_addr(eth->h_dest))
-			goto rx_accept;
-
-		return RX_DROP_MONITOR;
-	}
-
 	/* forward packet */
 	if (sdata->crypto_tx_tailroom_needed_cnt)
 		tailroom = IEEE80211_ENCRYPT_TAILROOM;
@@ -2819,6 +2808,17 @@ ieee80211_rx_mesh_data(struct ieee80211_
 		rcu_read_unlock();
 	}
 
+	/* Frame has reached destination.  Don't forward */
+	if (ether_addr_equal(sdata->vif.addr, eth->h_dest))
+		goto rx_accept;
+
+	if (!ifmsh->mshcfg.dot11MeshForwarding) {
+		if (is_multicast_ether_addr(eth->h_dest))
+			goto rx_accept;
+
+		return RX_DROP_MONITOR;
+	}
+
 	skb_set_queue_mapping(skb, ieee802_1d_to_ac[skb->priority]);
 
 	ieee80211_fill_mesh_addresses(&hdr, &hdr.frame_control,


