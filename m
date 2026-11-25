Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625896;
	b=SRw70C6zdJqa3STtcrYo/v1JwDzO4TumJxHAdOQiVloVjI6yQ005wRzZQIZes6WvMbwq
	 ZYB/u8EjTNMvkcEvRwK1zPNoT3F4cOGHUk1Y7gLKSNiBxlkQTNCSrAKX+H+y0LRU7ybQA
	 xqUOZ5BJQ5HJxtkcz/Uw2exSzU0kCXmCcTcJbc3/GfuYF/JQwlEERSh26G02UjW48G5uH
	 7tRgr8NVkQiFAmDKl712rrZ71yYYQHxS+D5ER50awAEEgrSfDISvAisMp1wCmhF4sLfas
	 PngOHlTJMcnNnoOXqEMgaIMpm7DglNLMKjp74I6PTd2PEjjUR391d3X4tTVNn6MYDrA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625896;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DaNyOpJRAugOXgt3Yg1zvRHhKWzRhcUC8+iMiB+Wmg4=;
	b=d2/hCy3MxaC1ipjf6A6MBxOUbGvh50BYTO1FU/+qCupCCV4w4nAiMFIALM/KNCA927z7
	 +N6rbyFDOdqCCio7rrBlAwfxaTpD/eVE1pjqys3ff/N4Owuss3qU1ORBq5Ee/v5vZrf2k
	 YHpfw8Od+JTJuMWbGgKHh3GIB+FTnuHImcrcFYKh+4F/YRu4Jdb9Bo+7E/1HSOgq7qr8W
	 J4qYr96Clr0GAdnhQHa5MyUWdBP4N2lP4XkoYmVI+RrgEMoaWNniojOZHHqgCsRRmLoC5
	 gamLiQOqDULBK76iCc9A23EKXtoXUgmMC1uPryw2KfQWAaOnwSzV1LIDgBTLiB5H1RQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="c/BeaY4B";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09D19606A33E;
	Wed, 25 Nov 2026 16:58:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c/BeaY4B
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 231311F000CA;
	Wed, 25 Nov 2026 16:58:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625895;
	bh=DaNyOpJRAugOXgt3Yg1zvRHhKWzRhcUC8+iMiB+Wmg4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c/BeaY4B9JYH9yeBuu8/WnKPxgeyFZonDioZuK8FdBVfAi7IhqaEtxzdqIjBJWmiN
	 4g8L5HAFBU9IiND8Q+TwNehSoveUb2ctYbF+kA8Qrbzp2faMcyP+PrAJtm+KlaiJfP
	 Z4qE3G1ZWzIiiTdkHFzdSCZt048GuXm/geecHaDE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.12 666/816] wifi: mac80211: recheck the IBSS station limit before insertion
Date: Wed, 25 Nov 2026 15:36:54 +0100
Message-ID: <20261125143904.593321135@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1662,8 +1662,12 @@ void ieee80211_ibss_work(struct ieee8021
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


