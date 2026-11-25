Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623335;
	b=vrQ/kEZyk4BUsShJlfN45gkcyJxx+3SyFTqnMRkd4zYLQOIv4/103MifJKeSYlgphRQh
	 dVs8jaX7oBESmW6YHs895GXWneleZce3zfJ0u2N0BEsQPSgVBvSVX7p6MpqHQhBtREVww
	 vKpW8qoq+YbPpcV506JO7PlTxQz7GIyVvwp2Tv//1pxpYeb8HZm4ecUlUnNh4zVe+BSR6
	 RYX3HltTr5zmUAizXmtQzGXy2MZgzbCy9puXNdRXgcp0jLDdra7t7/g9vSMnTAov6fv/9
	 33cSixzG92pmvZNFXvTcy1JmzUwervYJfhGgVNW09cuXOIaD2AXrtgkVv212gaKsG5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623335;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PrEloXTYLCef0RaIvC8ueWuYrMUeCeBdtpRxW7N5Lb4=;
	b=l8g2VcZfMXrHF++ZXWUfjDIeuTenBbburFGTB1btIMxdYsLdsyN6jO81lton1SCCV0WX
	 5tdVkj/IHA6DosFwTqEAugpWLy8VX23h99+mwLsgWiARDOulaN4syEMR1/peCz58wQRg+
	 IN21k7kAFBRK168p/36M9eFZyHli87MK9NK0eKH5FJgDh6TeI7xus8hDTL4L9MUjvWRka
	 0oMKK+v4C+ADZR3iXkhQgIlgeuscX1XEa99Q+CmqQJUzekKWD5dOJwv6sPXeqO4XCXa55
	 lHclJb26SuxbJ9Eg6/kzSrR+dHwgdFW4mqESoNHzOCx+XqgQHUz0PQocBUE+Ppz3KCA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M8S5F3jy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5686C606A323;
	Wed, 25 Nov 2026 16:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M8S5F3jy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E15F1F000EB;
	Wed, 25 Nov 2026 16:15:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623335;
	bh=PrEloXTYLCef0RaIvC8ueWuYrMUeCeBdtpRxW7N5Lb4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M8S5F3jycdcm2lQlLDaT6UmZqb/dsWv6LoY5051QlMjz7/4gnbCFjmP9eY6sN1MIi
	 KleQvae61ndN7K/pWfnhEWnkQv5WPjt5MWdLmI3nNp8TNX908JRhtI3IfCRFWQLucG
	 5lp+7Mrsp2Y9xuQCPeTUYsunXaZxND068jGTIZOY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.18 823/990] wifi: mac80211: bound pending OCB station allocations
Date: Wed, 25 Nov 2026 15:36:30 +0100
Message-ID: <20261125143841.314883813@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

From: Zhao Li <enderaoelyther@gmail.com>

commit ee1a5e92dba0a98cabe476c780e3af4f0ab88b27 upstream.

Delaying the OCB station worker while frames arrive from new peers can
retain an unbounded number of station allocations.

The receive-side limit counts installed stations, while new allocations
wait on incomplete_stations until process context inserts them. The list
lock does not cover the interval between allocation and list insertion.

Reserve one of 128 pending slots per interface before allocation. Release
the reservation on allocation failure, after the worker inserts or frees
the station, and when leave frees the pending list.

LLM assistance was used to find the bug and review.

Fixes: 239281f803e2 ("mac80211: 802.11p OCB mode support")
Cc: stable@vger.kernel.org
Signed-off-by: Zhao Li <enderaoelyther@gmail.com>
Link: https://patch.msgid.link/20261028142302.16634-3-enderaoelyther@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/ieee80211_i.h |    2 ++
 net/mac80211/ocb.c         |   13 ++++++++++++-
 2 files changed, 14 insertions(+), 1 deletion(-)

--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -683,6 +683,7 @@ struct ieee80211_if_ibss {
  * @wrkq_flags: OCB deferred task action
  * @incomplete_lock: delayed STA insertion lock
  * @incomplete_stations: list of STAs waiting for delayed insertion
+ * @incomplete_sta_count: pending entries and reserved allocations
  * @joined: indication if the interface is connected to an OCB network
  */
 struct ieee80211_if_ocb {
@@ -691,6 +692,7 @@ struct ieee80211_if_ocb {
 
 	spinlock_t incomplete_lock;
 	struct list_head incomplete_stations;
+	atomic_t incomplete_sta_count;
 
 	bool joined;
 };
--- a/net/mac80211/ocb.c
+++ b/net/mac80211/ocb.c
@@ -70,9 +70,18 @@ void ieee80211_ocb_rx_no_sta(struct ieee
 	band = chanctx_conf->def.chan->band;
 	rcu_read_unlock();
 
+	if (!atomic_add_unless(&ifocb->incomplete_sta_count, 1,
+			       IEEE80211_OCB_MAX_STA_ENTRIES)) {
+		net_info_ratelimited("%s: No room for a new OCB STA entry %pM\n",
+				     sdata->name, addr);
+		return;
+	}
+
 	sta = sta_info_alloc(sdata, addr, GFP_ATOMIC);
-	if (!sta)
+	if (!sta) {
+		atomic_dec(&ifocb->incomplete_sta_count);
 		return;
+	}
 
 	/* Add only mandatory rates for now */
 	sband = local->hw.wiphy->bands[band];
@@ -142,6 +151,7 @@ void ieee80211_ocb_work(struct ieee80211
 			ieee80211_ocb_finish_sta(sta);
 			rcu_read_unlock();
 		}
+		atomic_dec(&ifocb->incomplete_sta_count);
 		spin_lock_bh(&ifocb->incomplete_lock);
 	}
 	spin_unlock_bh(&ifocb->incomplete_lock);
@@ -225,6 +235,7 @@ int ieee80211_ocb_leave(struct ieee80211
 		spin_unlock_bh(&ifocb->incomplete_lock);
 
 		sta_info_free(local, sta);
+		atomic_dec(&ifocb->incomplete_sta_count);
 		spin_lock_bh(&ifocb->incomplete_lock);
 	}
 	spin_unlock_bh(&ifocb->incomplete_lock);


