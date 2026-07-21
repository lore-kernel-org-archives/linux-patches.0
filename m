Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6268046A5ED;
	Tue, 21 Jul 2026 15:46:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648800; cv=none; b=ZhC1/XpQkU805SEp7cfBS3MkEEGdU0VzFRlxC6uw62/2R3vsxF1QYchMIh1PxJG+PIaaA1Kj5gJYulgnxvonHZO4BDUvAhfITw7dvnHqtRJfV8BT0dI/7++NrSFA6H0DjVbK4TJnh6mdA4hLlAtO8Pm/lkaymdJ+kEcZN1SXWXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648800; c=relaxed/simple;
	bh=PfoDN4F8J8SrAoS83T7mI0OOB6H2unkY72mUCsDV2V8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CoQpV87rW2Y9ifIVdD8D2KhMbEiBAfNPh2KjMV+glABON+fPjBow9pZzWsZs0HpVegoPNig1nzGarTIe64nFYvGyQN2RwZwdIaEXvzgNGTXt7eYda01nC8ImDrKg0UiBPbcEMVip9I7SGgdZVFDrbM3qi/baR8ADvJx9+wqkDCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nXdmhlGD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nXdmhlGD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEB631F000E9;
	Tue, 21 Jul 2026 15:46:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648799;
	bh=VOgXikVxOyGcycuFTdF7YWGyu6be2q63bHVBigbt+5I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nXdmhlGD9/nqDJns1dG+Ju0j5Xgx0dW5D1qgR8KtBiMu2DRnAyOcKcKaYyLO6DnIL
	 QRHbU8nDPF3gQE2n40rF8nT8u4OoixHTAK3HgAhKZavxgiC2a0R6MH2PMIAYtqVmgx
	 HVwBEbn+72TNuhIMQNTMvvXjqNGgkhMunUXNOOac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Stephen Suryaputra <ssuryaextr@gmail.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0336/2077] ipv6: guard against possible NULL deref in __in6_dev_stats_get()
Date: Tue, 21 Jul 2026 17:00:09 +0200
Message-ID: <20260721152600.608746613@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 9e96776945e5f6..539bbbe54b14e8 100644
--- a/include/net/addrconf.h
+++ b/include/net/addrconf.h
@@ -369,8 +369,11 @@ static inline struct inet6_dev *__in6_dev_get_rtnl_net(const struct net_device *
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



