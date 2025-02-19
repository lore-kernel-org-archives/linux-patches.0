Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B63D41BD9C6;
	Wed, 19 Feb 2025 09:31:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739957502; cv=none; b=jf4P6hwHbq2Z3/sR1BQESHLGd7H0tj5CAJsP1UMSuY5jgNQj9/h2B2LbFTTQhE8ucecmxvrbjhM2YVZFt7zuODCmftNNChzKRwqHUlspqhtIF5V6IXmzKQzwbmbNxAu1+Fap3DgxnPLCGbBDyD8O3hT/MNbbD2tCwZkVZKoja7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739957502; c=relaxed/simple;
	bh=HFNizW6OsImYJKXyP9nwYiczhyTbBZLUbDT65tzgXZ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WQ8feM3RC7SjtC+NzcOouLLA0B8SOTLDwFRlq22JJWU6ZBhBMMYPefH8kRsuOuY8508pEMFNCHGOEDHE3dhRVbAWjHdKghi9ucR2A7kZa5tooQXkU6AQpeOMLqfhzqS00sFBte8ENkXdk6K3OpeRIENDFG2ml48Z3QzTiqdNEGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h0cr4D/p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h0cr4D/p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E325C4CED1;
	Wed, 19 Feb 2025 09:31:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739957502;
	bh=HFNizW6OsImYJKXyP9nwYiczhyTbBZLUbDT65tzgXZ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h0cr4D/p8ddTD5W2aolTqWDC4ZuvRZVr7pX1JSx33wDuAu8HMsbe/64ddO5wnwauq
	 Son9Q+Tqiq4Qu3x/n5sWh0vaoh2DzPg/Drn7VKw40GJRvkrf6FLnjfhvdbfdTZnjU7
	 L/+XQvHRMQ2W1hLMo1qxgDUElXxXvU3/v5vrXzgM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 548/578] ipv6: use RCU protection in ip6_default_advmss()
Date: Wed, 19 Feb 2025 09:29:12 +0100
Message-ID: <20250219082714.521249842@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 3c8ffcd248da34fc41e52a46e51505900115fc2a ]

ip6_default_advmss() needs rcu protection to make
sure the net structure it reads does not disappear.

Fixes: 5578689a4e3c ("[NETNS][IPV6] route6 - make route6 per namespace")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Link: https://patch.msgid.link/20250205155120.1676781-11-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/route.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index f3268bac9f198..17918f411386a 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -3190,13 +3190,18 @@ static unsigned int ip6_default_advmss(const struct dst_entry *dst)
 {
 	struct net_device *dev = dst->dev;
 	unsigned int mtu = dst_mtu(dst);
-	struct net *net = dev_net(dev);
+	struct net *net;
 
 	mtu -= sizeof(struct ipv6hdr) + sizeof(struct tcphdr);
 
+	rcu_read_lock();
+
+	net = dev_net_rcu(dev);
 	if (mtu < net->ipv6.sysctl.ip6_rt_min_advmss)
 		mtu = net->ipv6.sysctl.ip6_rt_min_advmss;
 
+	rcu_read_unlock();
+
 	/*
 	 * Maximal non-jumbo IPv6 payload is IPV6_MAXPLEN and
 	 * corresponding MSS is IPV6_MAXPLEN - tcp_header_size.
-- 
2.39.5



