Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704772;
	b=qIqCnOw/W8o24rsufylf7Vq/wlXo7q9gjRQM1gZEnhbInTeF4Tj+6p8zx7CbkP7TTgEY
	 aymwdDZp7F63P/wBpTv046xWGCWt37ZkzHwKvWKfs/0ebL/xTlLz5A2sPSLyvDet8tNkP
	 I7NpQqfwZSn5dbaCQloDyoUyoUBiW+JaduKjPljCftCXBbJCFSOTaBBI7aWOtfxu9ts3K
	 xzi4dTJkE5DZ8OIc3QcqHFO/PTTJ0NyNp94n98qv+V3Y3LIzWKiQzBbqM1gm4sFeVndN5
	 OCVysDfVM+HirmPBEuTXBeo2jzbhtLdzlsNiMUx6yqsecvETDOc2BqZUVSJzSPAnOyw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704772;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LquG5UhLIJSOKzCX6tzIQ+tTFE4t4oKV9c5y2nUpynU=;
	b=5KxaEefHA+Xt2rRWLx0sVy9OzARDl2RhOyZJDf/fDMhgdtWH2e80hArTNY7BEuohLrLa
	 ajojIqG9M24+A+Sv44AWl0lToDRU6bw8ymFSmh2BCzDym12ZVbwbsqSr5iZZ2UXq42qAa
	 RbPxm8IUs8RN0SgExNi6XcQ6vWZexKb77HHWuG5ZrxdT7+n7xvss5WJrQVCRsF2dxVHV8
	 gEZET5/x1lQcvWXaFNJQtqs25yVCv7r/TY2k/Qxcq0VEQj6YiJt0LbW+kL23lKZ687xJf
	 TFFA9l4LeufzTMnToiAE9WXkiaj8sKQ4DwoN9jjnC1ndVHbqJmZYGz73kgyPeiBPYjA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WY+Kzsg+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 688C1606A32C;
	Thu, 26 Nov 2026 14:52:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WY+Kzsg+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0AF71F000D2;
	Thu, 26 Nov 2026 14:52:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704772;
	bh=LquG5UhLIJSOKzCX6tzIQ+tTFE4t4oKV9c5y2nUpynU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WY+Kzsg+XhojTJpOIM4/t83qykeo2P7bPEIUik+qrcz3iM2FAFT7n9/Cfpg5cjQia
	 94eLYCB6efnkx1NnpRVLb6j4ngVZ3BM+28RvrW8TB8clbPXoVd9rKfjFd+W7v6Mxrj
	 7y8u4rXyHNuPoLlFC2lVYtbz0EyKkAwt4Y031xAg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.10 194/265] wifi: mac80211: bound pending IBSS station allocations
Date: Thu, 26 Nov 2026 15:38:44 +0100
Message-ID: <20261126143618.753427717@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -713,6 +713,7 @@ static void ieee80211_ibss_disconnect(st
 		spin_unlock_bh(&ifibss->incomplete_lock);
 
 		sta_info_free(local, sta);
+		atomic_dec(&ifibss->incomplete_sta_count);
 		spin_lock_bh(&ifibss->incomplete_lock);
 	}
 	spin_unlock_bh(&ifibss->incomplete_lock);
@@ -1242,9 +1243,18 @@ void ieee80211_ibss_rx_no_sta(struct iee
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
@@ -1709,6 +1719,7 @@ void ieee80211_ibss_work(struct ieee8021
 			ieee80211_ibss_finish_sta(sta);
 			rcu_read_unlock();
 		}
+		atomic_dec(&ifibss->incomplete_sta_count);
 		spin_lock_bh(&ifibss->incomplete_lock);
 	}
 	spin_unlock_bh(&ifibss->incomplete_lock);
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -592,6 +592,7 @@ struct ieee80211_if_ibss {
 
 	spinlock_t incomplete_lock;
 	struct list_head incomplete_stations;
+	atomic_t incomplete_sta_count;
 
 	enum {
 		IEEE80211_IBSS_MLME_SEARCH,


