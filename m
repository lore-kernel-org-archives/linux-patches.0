Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705546;
	b=odRNyoEDPV5+55PajA8TOkQyPTpFugzcmXO76KcL6ZR93okEln54OWnPND0rVJqSp2Fs
	 3+38OE6BKporcqhkX8WEV8RczmGE17sjSQDl+UJ+rTPcYBqfvGqpPlF/K7cfqoXw2LFr2
	 KVXIU3NSEL1AIVZxoHmRmyDs208OkfNITM6OcLAby+23+nIwmTBWf5QPCgi0VOTU8QoDl
	 DUxjDspy1qVYY1R6gURb59GF7T4Or9l8gWBx9rNB4swK9Ne104U9UxwcMP3OnSLhZBpHF
	 GtTDMjWL0J6fMAuUQQfMUHIcPtDUDMXgqaGnEqIir3qtcy8dG/ROPLtnFM1zyyNCIAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705546;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=s80iwSRYvrWezuOvRSOX0oj9IORYMXtqFJCpMbMh03Y=;
	b=fpvGqed2Ao3ujVI/oNlzla0QeBVjo3NMJ+eye+OuFbRGPU2S2NknvGT+S2kF75Zm+qmq
	 oUKV6yA/uz2SOcknHkq7+RqNpE/9g2FSJ9s2stmXM7dc1BnbJU2oGHsba2HSHCoeILKMx
	 7GfLBfm1WiW7T73n4kiDDhECnRBt/ezEV5YbATXV+d8pg9l/JZEUwUPTa0AtmCXO7lX9s
	 A90DEnYmULxXEKXrB+ThoTqkmtGDXQERW/qybdUGQ4+07OA72tv7xEDDTmcsVSVtYTBjR
	 1HLKC6qpEp2GZizF62DdzGfpsegmq9AXL0U9G62t2xWiZxZF5tJI4PH3dq5p486iuUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GpHw9SXy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A0F9606A323;
	Thu, 26 Nov 2026 15:05:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GpHw9SXy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78E4E1F000C6;
	Thu, 26 Nov 2026 15:05:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705545;
	bh=s80iwSRYvrWezuOvRSOX0oj9IORYMXtqFJCpMbMh03Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GpHw9SXyciu9UqgqprFbC+jY4E+aPw0eIJGjs2ROXDh/SHmcQilR/UoAGdLK+/oh1
	 StRb4LgXHMjNUHwuoAxFU5gamE61b1tc9j6vU8Nu6kae/vwqyMUh6mI6j5dBAyKiIO
	 9y/MKzE+zam+q66o0td9Kz36boxSkNPOndL+HKlo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.15 235/319] wifi: mac80211: bound pending IBSS station allocations
Date: Thu, 26 Nov 2026 15:40:03 +0100
Message-ID: <20261126144012.052575335@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhao Li <enderaoelyther@gmail.com>

commit 3029ca2112d7bee4d3e3eadd02decdb3eddb9485 upstream.

Delaying the IBSS station worker while frames arrive from new peers can
retain an unbounded number of station allocations.

The receive-side limit counts installed stations, while new allocations
wait on incomplete_stations until process context inserts them. The list
lock does not cover the interval between allocation and list insertion.

Reserve one of 128 pending slots per interface before allocation. Release
the reservation on allocation failure, after the worker inserts or frees
the station, and when disconnect frees the pending list.

LLM assistance was used to find the bug and review.

Fixes: 8bf11d8d0811 ("mac80211: delay IBSS station insertion")
Cc: stable@vger.kernel.org
Signed-off-by: Zhao Li <enderaoelyther@gmail.com>
Link: https://patch.msgid.link/20261028142235.15428-3-enderaoelyther@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/ibss.c        |   13 ++++++++++++-
 net/mac80211/ieee80211_i.h |    1 +
 2 files changed, 13 insertions(+), 1 deletion(-)

--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -706,6 +706,7 @@ static void ieee80211_ibss_disconnect(st
 		spin_unlock_bh(&ifibss->incomplete_lock);
 
 		sta_info_free(local, sta);
+		atomic_dec(&ifibss->incomplete_sta_count);
 		spin_lock_bh(&ifibss->incomplete_lock);
 	}
 	spin_unlock_bh(&ifibss->incomplete_lock);
@@ -1235,9 +1236,18 @@ void ieee80211_ibss_rx_no_sta(struct iee
 	scan_width = cfg80211_chandef_to_scan_width(&chanctx_conf->def);
 	rcu_read_unlock();
 
+	if (!atomic_add_unless(&ifibss->incomplete_sta_count, 1,
+			       IEEE80211_IBSS_MAX_STA_ENTRIES)) {
+		net_info_ratelimited("%s: No room for a new IBSS STA entry %pM\n",
+				     sdata->name, addr);
+		return;
+	}
+
 	sta = sta_info_alloc(sdata, addr, GFP_ATOMIC);
-	if (!sta)
+	if (!sta) {
+		atomic_dec(&ifibss->incomplete_sta_count);
 		return;
+	}
 
 	/* make sure mandatory rates are always added */
 	sband = local->hw.wiphy->bands[band];
@@ -1707,6 +1717,7 @@ void ieee80211_ibss_work(struct ieee8021
 			ieee80211_ibss_finish_sta(sta);
 			rcu_read_unlock();
 		}
+		atomic_dec(&ifibss->incomplete_sta_count);
 		spin_lock_bh(&ifibss->incomplete_lock);
 	}
 	spin_unlock_bh(&ifibss->incomplete_lock);
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -596,6 +596,7 @@ struct ieee80211_if_ibss {
 
 	spinlock_t incomplete_lock;
 	struct list_head incomplete_stations;
+	atomic_t incomplete_sta_count;
 
 	enum {
 		IEEE80211_IBSS_MLME_SEARCH,


