Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C98F46D082;
	Tue, 21 Jul 2026 17:49:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656166; cv=none; b=ffwmNYTPUawL57VGWNavExlUpnsxaCB0UaRSyS7lIlCRSHNYGK76VuhkP6wDchMgh/ACdteuZfBNEhGMpTTfBUeXrPCAyq/TIlohx240TRrGKLaPxnR/0Ratbcg2/0SuWITuzh2Le3mGmsGhJaYYZ0rYUzx3j+1h2THKVPfXrVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656166; c=relaxed/simple;
	bh=SUPMkmCc6YWoJHwt6gOwDKkqblUUYYO7Mpf9iQgbHg0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TjIKaVSzVCdUpV8FFlSoh50pQkmcOTZl+YuiyHfB+C/KLr9c6qOznGVav75u/ul1E94kUx+ScIuIEmdlXcCGnm02XlmMgMNiuxPHTCYEzs0amKINFm1sWLj1/ut7S80h1j9BYZokQQGX1ymrfahFA29LZ8eGGnpYVHXZUuedPVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EDjLYOk5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EDjLYOk5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A2C61F000E9;
	Tue, 21 Jul 2026 17:49:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656165;
	bh=JOQI9K48M/gpETGRbcY2XmyjZUzi+1nXzjXAcFRFpwQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EDjLYOk5Ju9Lbr8iJjrd+YZFrrsc3MkXwE1ztoJqi4F0SIkQnsjoyIYndUzgvSOPW
	 yIPXJzT3XOoSLgTYnNYiPSpsGWoZ8zbRxIQq1NG3Dgo0ZSxiYRDuk2ZDWDy6oFb7yt
	 c17XynnGxaAts4Zzh4NJnuduQTR6U0JrUxJrS630=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Stephen Suryaputra <ssuryaextr@gmail.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0241/1611] ipv6: guard against possible NULL deref in __in6_dev_stats_get()
Date: Tue, 21 Jul 2026 17:05:57 +0200
Message-ID: <20260721152520.437323033@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 507541c2a8eeb76c02bd2511958f73a8cfa3e1bc ]

dev_get_by_index_rcu() could return NULL if the original physical
device is unregistered.

Found by Sashiko.

Fixes: e1ae5c2ea478 ("vrf: Increment Icmp6InMsgs on the original netdev")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Stephen Suryaputra <ssuryaextr@gmail.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20260526145529.3587126-2-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/addrconf.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/net/addrconf.h b/include/net/addrconf.h
index 9e5e95988b9e5d..c5a215ec14215d 100644
--- a/include/net/addrconf.h
+++ b/include/net/addrconf.h
@@ -363,8 +363,11 @@ static inline struct inet6_dev *__in6_dev_get_rtnl_net(const struct net_device *
 static inline struct inet6_dev *__in6_dev_stats_get(const struct net_device *dev,
 						    const struct sk_buff *skb)
 {
-	if (netif_is_l3_master(dev))
+	if (netif_is_l3_master(dev)) {
 		dev = dev_get_by_index_rcu(dev_net(dev), inet6_iif(skb));
+		if (!dev)
+			return NULL;
+	}
 	return __in6_dev_get(dev);
 }
 
-- 
2.53.0



