Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623313;
	b=S15tkur1CUx8rLq23GHjsxdXaqQj6gd2q6LvIW5p9rN9x52tXC8HrrD+o0clIITl+JQb
	 ecQtgHp8lhEukwZAUNiljfl6cdlaaTWDLkpHJOyCP/Iegu7Z3fOb7s8IlGOYNECGBLT/F
	 YG5uDJO8BvRvzdzx5K6bEZExmdmGO4UXzEs+9W+jbB1tVZmFdbg/BQ1T4p14Hzb83guxY
	 YV4quIzicq0AVhvgpne3rCt98ynF0agWdzTZKwzuGj6mIr0VAYYu5YNEJtRJ/lxh6pojK
	 hxeK2ewLbbgb/Gx7WS8zCCgPDZM9JX3j5mTvOOocRIfV4bwRilGpOOpIX1pxNSV5HdQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623313;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BQWNghd9yp1lkfaqGxmeG1M0cIvxpsWdsTj6Y3tSSwM=;
	b=PcqSLXhq7pa927EFptrCAyj4oijVxIWroeJMEC6ZdSa8Ivt3HZtvmhiPurcnhZaXWAeJ
	 QEfk55r8MIJCZXCOY01rIxvkWCi5TfP7eeG4fX9u+8pER6XUq2JLaxrnOEf+jN0TipawC
	 rPvptNpUL3f9TkIzH2Ajinfcn0PRBsmDUPh5kwfgjG4K8DFkJcIM8TSJR5pKNbptCNVhi
	 AaAuN2aiCxJs64xBQUw+qjB3aNIg2aoVp2+sDlpJLs8keiV6eZLutxuYDZDNg7qK3yAPp
	 PKzT99T+odlznPd5ZR4IKCNbPrUQYbXbtyP1AP7DU4LyVMTw1K2jAcHrfO1D/j6PrbQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="j1/XGzrM";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F2B5606A32C;
	Wed, 25 Nov 2026 16:15:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j1/XGzrM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 102BC1F000D1;
	Wed, 25 Nov 2026 16:15:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623312;
	bh=BQWNghd9yp1lkfaqGxmeG1M0cIvxpsWdsTj6Y3tSSwM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j1/XGzrMEKcaIr3zw2YjjpSOUDyVv1j2SYyM2omsKDiMaQaoFhAI4Erv3ooSjqOEc
	 Sl/wQgj9sA6IFavujfkhrYHl9/u6IOsAzcz9qHJvmx/r7thRrfPbU484Hpd3nOEyBS
	 24lTMIL67Ali2B4sNpDNZvQ/+0+T5LliNewHt9HM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.18 817/990] wifi: mac80211: recheck the IBSS station limit before insertion
Date: Wed, 25 Nov 2026 15:36:24 +0100
Message-ID: <20261125143841.178230086@linuxfoundation.org>
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

commit f7670bcdf650b37551a9c5d084521f877d939f11 upstream.

Frames from successive unknown IBSS peers can make the deferred worker
install more than 128 stations.

The receive path checks local->num_sta before allocating each station,
but pending stations are not included in that count. Several allocations
can therefore pass before the worker inserts any of them, and the worker
then drains the list without rechecking the limit.

Recheck the installed-station limit in the worker under the wiphy mutex
and free entries that no longer fit.

LLM assistance was used to find the bug and review.

Fixes: 8bf11d8d0811 ("mac80211: delay IBSS station insertion")
Cc: stable@vger.kernel.org
Signed-off-by: Zhao Li <enderaoelyther@gmail.com>
Link: https://patch.msgid.link/20261028142235.15428-2-enderaoelyther@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/ibss.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -1656,8 +1656,12 @@ void ieee80211_ibss_work(struct ieee8021
 		list_del(&sta->list);
 		spin_unlock_bh(&ifibss->incomplete_lock);
 
-		ieee80211_ibss_finish_sta(sta);
-		rcu_read_unlock();
+		if (sdata->local->num_sta >= IEEE80211_IBSS_MAX_STA_ENTRIES) {
+			sta_info_free(sdata->local, sta);
+		} else {
+			ieee80211_ibss_finish_sta(sta);
+			rcu_read_unlock();
+		}
 		spin_lock_bh(&ifibss->incomplete_lock);
 	}
 	spin_unlock_bh(&ifibss->incomplete_lock);


