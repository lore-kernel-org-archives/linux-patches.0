Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704715;
	b=vCGi+AA1UPpkIGUMiD38HMVN4/eendSeJV43GfOVdxd5iteGXtOcCvRlKfJQVdVNADj2
	 qtpaqRoleFJ3mvhWkT4Z5SAiRBfbBWWx9M3vPhvREzdO+2jRRo+08B8SMs0pItNbL68dx
	 ysWS+6jait0Oi2PGWrPIKRwVG7sRrzNpwwNlPPGKM5Ws1wHwZXtXS0StnnqMQduTwXtwV
	 CZf0yjh/YeMZ7fAA8gOaDJztwNssB3YxLnOBwciYWDfkYBScKuHLnePJLp2+Kxra8WRZ4
	 Mom+qRBDa3trKAxuSRSnk5JjE7USRhcm8TpWGa0OCsNYTfMwHbav/INWVlso+hpz8jQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704715;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=e9AczpSqba22uo7K9lLFxgGQ/PGRIhc+sXSL/xSYH3U=;
	b=nJP3X1ORF1eqKu/BnQcb+0h837jlOYZ78usqbEEpdQY3vmaT4W8kk81iGNBYWbVr6Y43
	 Fs+iu1XbMqe9CXTaUMKXDu+EPNOl66tdrEFjZdl+13b7T4O1rKWfKWBuQ2q6DvLi0JPp/
	 deSHv9/ZVJPbt4fKKL5QVg2g3b+heBHfO7x+sVeLQD7qzKA5+sNJhNvjcQUelq57ysmhE
	 ccRjX5WHnNkF3WBs8Q5F/SOLPIhJR3PxzGy81xROiUGOLxq3RoHz13aWBmIzkb6AATtLC
	 7JJSzQxIqeJVtX8InNZNd5mUJmMNZ5WpjFHnt3NlzQWEYMhtWB3Gpz7S/Ze52fxO2tA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AUBYPwCl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 338BB606A31C;
	Thu, 26 Nov 2026 14:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AUBYPwCl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B8681F000C4;
	Thu, 26 Nov 2026 14:51:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704715;
	bh=e9AczpSqba22uo7K9lLFxgGQ/PGRIhc+sXSL/xSYH3U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AUBYPwClk992DQ325GBY4Qv3yPLVuxmUdDsOHmVDbubLuC2uwNe+f04+NkeqEXgob
	 s7AU0wjJzamEpyTpZmVrhq/24Ri7LCLp8QoRTM3krtX/mFW3aVvzXwDp/gRI0pVK95
	 7kTXxkN/AGoMNjLVmfCQa42hd62yTYDgNK+48prw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.10 192/265] wifi: mac80211: recheck the IBSS station limit before insertion
Date: Thu, 26 Nov 2026 15:38:42 +0100
Message-ID: <20261126143618.605488092@linuxfoundation.org>
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
@@ -1703,8 +1703,12 @@ void ieee80211_ibss_work(struct ieee8021
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


