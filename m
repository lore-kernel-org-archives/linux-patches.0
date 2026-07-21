Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A7BF46D098;
	Tue, 21 Jul 2026 19:22:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661727; cv=none; b=lfOyHM5MhHPgRSrRseHZcM9SM74DABWLx8m5CHhxnu6ckXZ+QPZbNcD6tgmxL64CJ75AJDTPunZmJGPlomvOInprlTr0qQKSuvQkcGj3FhxkPFhFrS6Bo7qYT8dSPfp0yikATctNe2aqmnKef2Sfzl98T6HZqWpRNF+G5kuyuok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661727; c=relaxed/simple;
	bh=GYZpXOZJnNht0zRxuCH2KeIYhtU2fgmUt7Bkgtrdm3Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VJ/umFa0jBBl8cxV3UBGKAn6cs0U7zrRe4clxp9uNcw9Hq+fVXmWvOk0IOOuFozql+/otuIOuljo+j9ROCPp96HCAapJox/IU9eL7/BNCd5Up2pBcbSP+9tflSrcDin4By03M3LJ2YB+5ZlUFCYoakrHCleJGqUMBj/o9wTYEsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PQqYvsON; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PQqYvsON"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 881C61F000E9;
	Tue, 21 Jul 2026 19:22:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661726;
	bh=l8HJk0xcRFSJrE8Ozo2Vk32ekEwkl/vRLn/oFrWgl+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PQqYvsONNk++QCtDd105xZHKi+ZnoQNl+cZd5jQWPFF4TwTEHfMxE5wMQPctJuufN
	 J73+s8HY3svTVcmMP/oLMWyctdQ03iYqcPYQTAQMiW7HMWDkrZ5ylSeIk6kKdCpR6m
	 u8RqMgald10tbLS7evyOwiTajGIOPPDU9wL+6g1I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Stephen Suryaputra <ssuryaextr@gmail.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0174/1276] ipv6: guard against possible NULL deref in __in6_dev_stats_get()
Date: Tue, 21 Jul 2026 17:10:17 +0200
Message-ID: <20260721152449.990530371@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 363dd63babe72f..779a1049fa1b98 100644
--- a/include/net/addrconf.h
+++ b/include/net/addrconf.h
@@ -341,8 +341,11 @@ static inline struct inet6_dev *__in6_dev_get(const struct net_device *dev)
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



