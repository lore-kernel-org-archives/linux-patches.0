Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 284EB484226;
	Thu, 20 Aug 2026 17:35:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247319; cv=none; b=slPrTPGdkAmqg5mgSry/WhTQnvfLg/ER60qvi4opLJmwDiWZgKAxcolztQ3CLSAFw3+46O8qg8hVx6nhGFkiQGalPOMTZmuR60jn3+1PtnJy1dj1RXkZiRMkhDg9p00rIWz/OHh8VkhW3WwJcwHzH6vahDhWxBr6jnahQHlJUzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247319; c=relaxed/simple;
	bh=4SgkM6KoSAe2baesRXvCHJPodIlPJWHjfn54AzRDbBg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EyvNnEsJlSbCo+D6cVB6LDnbHASqzGdSf5ZAGBix1tiiOi3vI74BjBK+UPaV7yEkN1/giXCbI1Ep/+gpE+H9XgB3VZq7RQk3onomNxanOsJM2uRqcFTaT7e/obHUp8VjP96dfl4zU/vICzn62zR4hQ4Qfsf/es34susiMd4ZmSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lSCi5qhB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lSCi5qhB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8373C1F000E9;
	Thu, 20 Aug 2026 17:35:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247318;
	bh=blIIkLarU080oA2aGQOdLqVvbwGTL1F43gTk77EB6Cg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lSCi5qhBkx3o4ZJweTHk21CKpIkSkt0Ej84Z7lZe7yv8dAEGZDuOTP1B8LLyQio5w
	 Rk/3+JYHfsO2pRZWSULQYzOQW3uN3C25lZPVFsVwNR/nYm6aD8oamN22i5b+0aXIoe
	 RSc+JofHkgb3GYmfledsuTxRm+Ey5CMlVWcrgQ4k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"thomas.petazzoni@bootlin.com, netdev@vger.kernel.org,  linux-kernel@vger.kernel.org, Miguel Gazquez" <miguel.gazquez@bootlin.com>,
	Eric Dumazet <edumazet@google.com>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Miguel Gazquez <miguel.gazquez@bootlin.com>
Subject: [PATCH 6.12 189/220] ipv4: start using dst_dev_rcu()
Date: Thu, 20 Aug 2026 16:56:19 +0200
Message-ID: <20260820145229.195230707@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145223.480031205@linuxfoundation.org>
References: <20260820145223.480031205@linuxfoundation.org>
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

[ Upstream commit 6ad8de3cefdb6ffa6708b21c567df0dbf82c43a8 ]

Change icmpv4_xrlim_allow(), ip_defrag() to prevent possible UAF.

Change ipmr_prepare_xmit(), ipmr_queue_fwd_xmit(), ip_mr_output(),
ipv4_neigh_lookup() to use lockdep enabled dst_dev_rcu().

Fixes: 4a6ce2b6f2ec ("net: introduce a new function dst_dev_put()")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://patch.msgid.link/20250828195823.3958522-9-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ minor modifications to fix conflict ]
Signed-off-by: Miguel Gazquez <miguel.gazquez@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/icmp.c        |    6 +++---
 net/ipv4/ip_fragment.c |    6 ++++--
 net/ipv4/ipmr.c        |    4 ++--
 net/ipv4/route.c       |    4 ++--
 4 files changed, 11 insertions(+), 9 deletions(-)

--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -320,17 +320,17 @@ static bool icmpv4_xrlim_allow(struct ne
 		return true;
 
 	/* No rate limit on loopback */
-	dev = dst_dev(dst);
+	rcu_read_lock();
+	dev = dst_dev_rcu(dst);
 	if (dev && (dev->flags & IFF_LOOPBACK))
 		goto out;
 
-	rcu_read_lock();
 	peer = inet_getpeer_v4(net->ipv4.peers, fl4->daddr,
 			       l3mdev_master_ifindex_rcu(dev));
 	rc = inet_peer_xrlim_allow(peer,
 				   READ_ONCE(net->ipv4.sysctl_icmp_ratelimit));
-	rcu_read_unlock();
 out:
+	rcu_read_unlock();
 	if (!rc)
 		__ICMP_INC_STATS(net, ICMP_MIB_RATELIMITHOST);
 	else
--- a/net/ipv4/ip_fragment.c
+++ b/net/ipv4/ip_fragment.c
@@ -483,13 +483,15 @@ out_fail:
 /* Process an incoming IP datagram fragment. */
 int ip_defrag(struct net *net, struct sk_buff *skb, u32 user)
 {
-	struct net_device *dev = skb->dev ? : skb_dst_dev(skb);
-	int vif = l3mdev_master_ifindex_rcu(dev);
+	struct net_device *dev;
 	struct ipq *qp;
+	int vif;
 
 	__IP_INC_STATS(net, IPSTATS_MIB_REASMREQDS);
 
 	/* Lookup (or create) queue header */
+	dev = skb->dev ? : skb_dst_dev_rcu(skb);
+	vif = l3mdev_master_ifindex_rcu(dev);
 	qp = ip_find(net, ip_hdr(skb), user, vif);
 	if (qp) {
 		int ret;
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -1906,7 +1906,7 @@ static void ipmr_queue_xmit(struct net *
 		goto out_free;
 	}
 
-	encap += LL_RESERVED_SPACE(dev) + rt->dst.header_len;
+	encap += LL_RESERVED_SPACE(dst_dev_rcu(&rt->dst)) + rt->dst.header_len;
 
 	if (skb_cow(skb, encap)) {
 		ip_rt_put(rt);
@@ -1943,7 +1943,7 @@ static void ipmr_queue_xmit(struct net *
 	 * result in receiving multiple packets.
 	 */
 	NF_HOOK(NFPROTO_IPV4, NF_INET_FORWARD,
-		net, NULL, skb, skb->dev, dev,
+		net, NULL, skb, skb->dev, dst_dev_rcu(&rt->dst),
 		ipmr_forward_finish);
 	return;
 
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -413,11 +413,11 @@ static struct neighbour *ipv4_neigh_look
 					   const void *daddr)
 {
 	const struct rtable *rt = container_of(dst, struct rtable, dst);
-	struct net_device *dev = dst_dev(dst);
+	struct net_device *dev;
 	struct neighbour *n;
 
 	rcu_read_lock();
-
+	dev = dst_dev_rcu(dst);
 	if (likely(rt->rt_gw_family == AF_INET)) {
 		n = ip_neigh_gw4(dev, rt->rt_gw4);
 	} else if (rt->rt_gw_family == AF_INET6) {


