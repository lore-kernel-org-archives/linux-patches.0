Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705540;
	b=GhH9RxFXeCJ99U62aPjvfu1zKy8+ZkuXddSuyZjmNkluYhW6kD7QzloztNbPCH0Q317e
	 EeSCJgrhdt4IE6ePQq0JVuLmOpmIllikA2SGmOz+TBqIbXQ57QUh8WNyGir8HIfxjBAKw
	 ETzfX0MpM9swOp/Zfa1xX0dkRZBaQ7bw5HoHM965Rj082bMnYqNOb81SZ5s13BqW0qhYp
	 ZYkHEaQFRRohhp1A86FD6AO0+rnQXbib/2gL5MbW+tWKEQ/N/RjYIURel9vZPURGkzvYn
	 TPo6iMDnWTbxpsnSYcWSS9cwjHG5NM897qsWGhIbXqeLG++kAuKTpob0QIpMqrCb70A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705540;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nxfAgwxBfHGyX3rDGywXO2LzOhj2LIO3NBJGYiH1yG8=;
	b=m75k3VWTwechk8YtrKOB7f6MqNhS+t3jA7sT6shOh9shxD8q17tFysI0+y7J7aYfTY3m
	 qoukWHnSI0xeRmfQaZsdw1jn3iK4wRc3MwD56/8/rW7yzXu0nvasaJbIWO6kdQlYZxQH5
	 PHV6p9DI82iO57xV6YhN+nteUEtSZa5iQKavWJrqHYunSW+EhbX+zoY1WH10XhM1oqh7D
	 xmAd7N+sIfkbzHwH3dLadNtN2ZFcDXk8zcjmXBQM1QF4k90eVdcSXtVCmPxR94OGjm3Zs
	 mC7NtfIGAhUP6UNKpwM2xr4/NneGqjgA4DRSz+nVNpNn11gh4tP/Xs52Y+vXIbcxf+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="VL+AFo/B";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B676606A31C;
	Thu, 26 Nov 2026 15:05:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VL+AFo/B
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5213A1F000D0;
	Thu, 26 Nov 2026 15:05:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705539;
	bh=nxfAgwxBfHGyX3rDGywXO2LzOhj2LIO3NBJGYiH1yG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VL+AFo/Bi6zt1GjdW9qfYPBR/HqSRoU0PrXkCMyMZ7ioeEC/kAFg1B1e/6C4vIrC5
	 2f+emntfjbJFiynqvjC8zraMwP6al3c+10A2YmGAzoYqhftAY8TQX65wRL5tuzRAq6
	 uziwS5Ke7JcIYVsXcSIXIpFrxQ9NkAgcnXf5gOlk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.15 233/319] wifi: mac80211: recheck the IBSS station limit before insertion
Date: Thu, 26 Nov 2026 15:40:01 +0100
Message-ID: <20261126144012.007578871@linuxfoundation.org>
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
@@ -1701,8 +1701,12 @@ void ieee80211_ibss_work(struct ieee8021
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


