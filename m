Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705549;
	b=NR2jcWJPwLxP0xEtctWxRGa2/an5Ed1ZQMQC+8CsSq+qWKJPCHPoeryRNnmHuI+UilWN
	 iUftoMcCveKpsypg8L9YaPaE0RfZx1QSOO0h3whLPx+ukA+qXMCbWTGHP7qZ6/TwNpBS+
	 024zo0wJuPEnXz3S8vliZThLn6jHSnojyuSI6bZq0hMx2ZTVBgY/id55BoHXz+MxM/ScW
	 wsH/gY1dU+NlZid+7CdQehEb/m2yIopOaF/JJlpcUghUC4BDZxC6SZQuWf02PKgxyTj/Y
	 hS2rESRP45A3qPOACC/3xcOL5aMq5/aaU5stF5E3a7YVOMN/Fy69gityFH7fcblBT1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705549;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iM3eQqqbSTMhOECk0D0vnaWdy9l/n7wkrV5IOVx6g70=;
	b=opShld7F+irsdcuofl2NC0arDJWYraCZYm1Uzl9yW3AXjL+hqATTPbjYPui82vHSLKwJ
	 EdFN/dEQBd7b/d6KUoy50zj81Z/zpJpqijfA+UV2+o8ymJJxW4W7H3iei38QivmSWkGKf
	 jmNnVFi++TuawbvN0b19bdWZCZ6rIv3ta3zHQx6mw9CJb3kv/4Pc7+6Wf9mapjL5j+u4a
	 oRjAaFU8A4SX1deH7rH0IbP7Ccmqc906DCHCUJKx7CMA8JbwyPQiNFaBh+MWq42L9+eba
	 f2AzsuBw8tzWEqe760tsgD69V1+7E6llqwPA6Qdk4r0EYpDKHZDrIlNAz5Kk+w7DBJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kCmmlRf6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BB3D606A31E;
	Thu, 26 Nov 2026 15:05:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kCmmlRf6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64B391F000C4;
	Thu, 26 Nov 2026 15:05:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705549;
	bh=iM3eQqqbSTMhOECk0D0vnaWdy9l/n7wkrV5IOVx6g70=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kCmmlRf6wDwkntxzy8ySD8X5sStWjPYhx7/8eGq8ZkL6KrutB1CXEpsQHc9g6LFwe
	 WgpQ7sCWXzSJcnqXfztVFCeVzqaSLJTiV3Xxx3mnhlftOzek3WV3Cz6nzIxfD5JOc0
	 MJqZiU5y+xXumr/nzKz8U35FOd3gVkd1O19+orBo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.15 236/319] wifi: mac80211: bound pending OCB station allocations
Date: Thu, 26 Nov 2026 15:40:04 +0100
Message-ID: <20261126144012.074552550@linuxfoundation.org>
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
@@ -611,6 +611,7 @@ struct ieee80211_if_ibss {
  * @wrkq_flags: OCB deferred task action
  * @incomplete_lock: delayed STA insertion lock
  * @incomplete_stations: list of STAs waiting for delayed insertion
+ * @incomplete_sta_count: pending entries and reserved allocations
  * @joined: indication if the interface is connected to an OCB network
  */
 struct ieee80211_if_ocb {
@@ -619,6 +620,7 @@ struct ieee80211_if_ocb {
 
 	spinlock_t incomplete_lock;
 	struct list_head incomplete_stations;
+	atomic_t incomplete_sta_count;
 
 	bool joined;
 };
--- a/net/mac80211/ocb.c
+++ b/net/mac80211/ocb.c
@@ -71,9 +71,18 @@ void ieee80211_ocb_rx_no_sta(struct ieee
 	scan_width = cfg80211_chandef_to_scan_width(&chanctx_conf->def);
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
@@ -144,6 +153,7 @@ void ieee80211_ocb_work(struct ieee80211
 			ieee80211_ocb_finish_sta(sta);
 			rcu_read_unlock();
 		}
+		atomic_dec(&ifocb->incomplete_sta_count);
 		spin_lock_bh(&ifocb->incomplete_lock);
 	}
 	spin_unlock_bh(&ifocb->incomplete_lock);
@@ -226,6 +236,7 @@ int ieee80211_ocb_leave(struct ieee80211
 		spin_unlock_bh(&ifocb->incomplete_lock);
 
 		sta_info_free(local, sta);
+		atomic_dec(&ifocb->incomplete_sta_count);
 		spin_lock_bh(&ifocb->incomplete_lock);
 	}
 	spin_unlock_bh(&ifocb->incomplete_lock);


