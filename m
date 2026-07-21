Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC5953D16EF;
	Tue, 21 Jul 2026 22:39:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673565; cv=none; b=TTiRfryNbqo6hnS2RtVTdDBrEATzEq3NKHnb3W9wHS88OIdN/76AWrBNCv80b2OSj3f9VWAWBZEXTjb1n+Ipvo2CNXZV10BccnLYev2iloh3kezgOtgTEFD6HyHpux/cUWsuu5FFi2ZekO3LXvlAUBYl4n6j1cTm6Vm3jLOdBpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673565; c=relaxed/simple;
	bh=riUOjoe1La55yqYKeOgy9FTOhtNoZHHNfNXOqBJTieI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N2ghikBFtrsf5Bb11InVE4rlGqSgpVfW9I97fG3M5MMhOi535h/LWqZAf+Uq/R9qfMNKyyp4t/lhskAjnSYKphTp9WThREFaRmFJfiYSeRUAVBvA5tOr/vSf74GUIWt6Kgd0B/jdWu1d5NNT4G8h1wnHLTAjZCz0MZFkFslM+DM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mrv4Axru; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mrv4Axru"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D68F1F000E9;
	Tue, 21 Jul 2026 22:39:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673564;
	bh=akY02BESHKR8ols6VVMK575RGvw2gWAnh7pEg1Mnb1s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mrv4AxruH72dZUixOR+bQTFE6DuSN/5SfUr9PZiNRAnH/1OMrwNyQux1OabS3H8CG
	 0xtpRcPArOHl28JQx0mO/oTER+ChB7jxdy2GcmEi9LhX93QIXcGJ5ZU/4HEj2SQW2l
	 frXmHqTIfeSvgf5ljG7PqiQpXvJqPkc2xQmfRr5M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Stephen Suryaputra <ssuryaextr@gmail.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 209/699] ipv6: guard against possible NULL deref in __in6_dev_stats_get()
Date: Tue, 21 Jul 2026 17:19:28 +0200
Message-ID: <20260721152400.413495854@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index f666d3628d6aa8..0d6a20841d3ac8 100644
--- a/include/net/addrconf.h
+++ b/include/net/addrconf.h
@@ -334,8 +334,11 @@ static inline struct inet6_dev *__in6_dev_get(const struct net_device *dev)
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



