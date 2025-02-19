Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 037D21DED5E;
	Wed, 19 Feb 2025 08:41:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954473; cv=none; b=DS6GNkpKQhGxpp0CZF7iNEprNjdgZL529jgXZmmTiTk5SHBQ+c7xMAcwgg/OersaP5DV6LRK4ASN9amIJyWPi+YMSxmAqRjw877rWQkwCKazgPH0StZAI4PNkIeJO/KT6V7mnGt2z3zGts02HCTAHq+iGIUIICdqiqWK9ctbp8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954473; c=relaxed/simple;
	bh=el+DCZlMeRCzujGn9uji9l8cVLddeTr2IWuU5+IK0HU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X6O6QqOhxmY5L0TZ4s0vda3n9j/2PTMWoLEDI4calCMUChEH/BIZAPib6qhkhtA+nC06Z8TyLf7NULd5qC2L0rZHkOaK/DJ0FwVN3iABdyfL303/gtA5aInXLkOilo9C6/xnKMLpVenrzpn7V8SxnBrZRW1e4uaT+12n3AL9u80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JMmDfkr7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JMmDfkr7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C192C4CED1;
	Wed, 19 Feb 2025 08:41:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954472;
	bh=el+DCZlMeRCzujGn9uji9l8cVLddeTr2IWuU5+IK0HU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JMmDfkr7ePQRfDD80oqvR1Mr3LxR+BCTzbqAzWQWnmbrrXJutDJ5960VEAsix1/1z
	 fPXyDGL8b209lGj1FAzWySH9ixyRWn97In5O0zwOTpEhbDFKaw6c2pYyZCjHDJmyQV
	 g0hVlPOeDQXHLnhyG9eSTjTKf6LrQMY4Nl/PTlXM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 215/274] ipv4: use RCU protection in ip_dst_mtu_maybe_forward()
Date: Wed, 19 Feb 2025 09:27:49 +0100
Message-ID: <20250219082617.992464793@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 071d8012869b6af352acca346ade13e7be90a49f ]

ip_dst_mtu_maybe_forward() must use RCU protection to make
sure the net structure it reads does not disappear.

Fixes: f87c10a8aa1e8 ("ipv4: introduce ip_dst_mtu_maybe_forward and protect forwarding path against pmtu spoofing")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Link: https://patch.msgid.link/20250205155120.1676781-4-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/ip.h | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/include/net/ip.h b/include/net/ip.h
index 0e548c1f2a0ec..23ecb10945b0f 100644
--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -471,9 +471,12 @@ static inline unsigned int ip_dst_mtu_maybe_forward(const struct dst_entry *dst,
 						    bool forwarding)
 {
 	const struct rtable *rt = dst_rtable(dst);
-	struct net *net = dev_net(dst->dev);
-	unsigned int mtu;
+	unsigned int mtu, res;
+	struct net *net;
+
+	rcu_read_lock();
 
+	net = dev_net_rcu(dst->dev);
 	if (READ_ONCE(net->ipv4.sysctl_ip_fwd_use_pmtu) ||
 	    ip_mtu_locked(dst) ||
 	    !forwarding) {
@@ -497,7 +500,11 @@ static inline unsigned int ip_dst_mtu_maybe_forward(const struct dst_entry *dst,
 out:
 	mtu = min_t(unsigned int, mtu, IP_MAX_MTU);
 
-	return mtu - lwtunnel_headroom(dst->lwtstate, mtu);
+	res = mtu - lwtunnel_headroom(dst->lwtstate, mtu);
+
+	rcu_read_unlock();
+
+	return res;
 }
 
 static inline unsigned int ip_skb_dst_mtu(struct sock *sk,
-- 
2.39.5



