Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC03B30C342;
	Tue, 16 Dec 2025 11:35:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884955; cv=none; b=RgGz9ezG9AaKCfPAP7KMNu6nYRuODU3TcAjfbxU3rBAnWblHQInA3wAB4+/kpXD35XmyGScANG+dVd7v16DLExeFvHN3cXkjW/Ozm2ZNHSG1qmSPKe+wrDmO81uNj/ZUpms+hKp+D3JHUmS9SH/as4S0qhGF0FX6gNhtD8Q6jOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884955; c=relaxed/simple;
	bh=lxXnJgWKNH5utqnac7X9QibnT8kuu/lAyghRPkcS1UU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SzzuUhWre76fQUwsZivCB8jgEBqVtcI26Qvd1qXoJclAvU0puBAFmyJWQ8dNhocZWkhTU7cnHpX48VE9LLkC2+bK5/lWXYeCjmiqeN8vMxtCKQdc4FES/KrCQ/FL4EQslH39zYTJ0nn7e2/vwnm+MISErguCoEcigyaQN4wxq8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0mFgFipi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0mFgFipi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD8D8C4CEF1;
	Tue, 16 Dec 2025 11:35:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884955;
	bh=lxXnJgWKNH5utqnac7X9QibnT8kuu/lAyghRPkcS1UU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0mFgFipinxNXPvXuVNv21FU+IhO5KBUDHnirptGIh58ydA7zbfvnG+cyuM6wgH0Jy
	 n9MuoQBdueHiZxXmOSbxnjFar9DaiqN30LNtjFehzc4aXjimKTWpVLyoPAh7rQ8cpK
	 em/Fh7fkuLsy/OzlSQlz6e7H1PCCndayaeBaKxZc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Gyokhan Kochmarla <gyokhan@amazon.com>
Subject: [PATCH 6.12 348/354] net: dst: introduce dst->dev_rcu
Date: Tue, 16 Dec 2025 12:15:15 +0100
Message-ID: <20251216111333.514680228@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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

[ Upstream commit caedcc5b6df1b2e2b5f39079e3369c1d4d5c5f50 ]

Followup of commit 88fe14253e1818 ("net: dst: add four helpers
to annotate data-races around dst->dev").

We want to gradually add explicit RCU protection to dst->dev,
including lockdep support.

Add an union to alias dst->dev_rcu and dst->dev.

Add dst_dev_net_rcu() helper.

Fixes: 4a6ce2b6f2ec ("net: introduce a new function dst_dev_put()")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://patch.msgid.link/20250828195823.3958522-2-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 50c127a69cd62 ("Replace three dst_dev() with a lockdep enabled helper.")
Signed-off-by: Gyokhan Kochmarla <gyokhan@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/dst.h |   16 +++++++++++-----
 net/core/dst.c    |    2 +-
 net/ipv4/route.c  |    4 ++--
 3 files changed, 14 insertions(+), 8 deletions(-)

--- a/include/net/dst.h
+++ b/include/net/dst.h
@@ -24,7 +24,10 @@
 struct sk_buff;
 
 struct dst_entry {
-	struct net_device       *dev;
+	union {
+		struct net_device       *dev;
+		struct net_device __rcu *dev_rcu;
+	};
 	struct  dst_ops	        *ops;
 	unsigned long		_metrics;
 	unsigned long           expires;
@@ -568,9 +571,12 @@ static inline struct net_device *dst_dev
 
 static inline struct net_device *dst_dev_rcu(const struct dst_entry *dst)
 {
-	/* In the future, use rcu_dereference(dst->dev) */
-	WARN_ON_ONCE(!rcu_read_lock_held());
-	return READ_ONCE(dst->dev);
+	return rcu_dereference(dst->dev_rcu);
+}
+
+static inline struct net *dst_dev_net_rcu(const struct dst_entry *dst)
+{
+	return dev_net_rcu(dst_dev_rcu(dst));
 }
 
 static inline struct net_device *skb_dst_dev(const struct sk_buff *skb)
@@ -590,7 +596,7 @@ static inline struct net *skb_dst_dev_ne
 
 static inline struct net *skb_dst_dev_net_rcu(const struct sk_buff *skb)
 {
-	return dev_net_rcu(skb_dst_dev(skb));
+	return dev_net_rcu(skb_dst_dev_rcu(skb));
 }
 
 struct dst_entry *dst_blackhole_check(struct dst_entry *dst, u32 cookie);
--- a/net/core/dst.c
+++ b/net/core/dst.c
@@ -150,7 +150,7 @@ void dst_dev_put(struct dst_entry *dst)
 		dst->ops->ifdown(dst, dev);
 	WRITE_ONCE(dst->input, dst_discard);
 	WRITE_ONCE(dst->output, dst_discard_out);
-	WRITE_ONCE(dst->dev, blackhole_netdev);
+	rcu_assign_pointer(dst->dev_rcu, blackhole_netdev);
 	netdev_ref_replace(dev, blackhole_netdev, &dst->dev_tracker,
 			   GFP_ATOMIC);
 }
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -1030,7 +1030,7 @@ static void __ip_rt_update_pmtu(struct r
 		return;
 
 	rcu_read_lock();
-	net = dev_net_rcu(dst_dev(dst));
+	net = dst_dev_net_rcu(dst);
 	if (mtu < net->ipv4.ip_rt_min_pmtu) {
 		lock = true;
 		mtu = min(old_mtu, net->ipv4.ip_rt_min_pmtu);
@@ -1328,7 +1328,7 @@ static unsigned int ipv4_default_advmss(
 	struct net *net;
 
 	rcu_read_lock();
-	net = dev_net_rcu(dst_dev(dst));
+	net = dst_dev_net_rcu(dst);
 	advmss = max_t(unsigned int, ipv4_mtu(dst) - header_size,
 				   net->ipv4.ip_rt_min_advmss);
 	rcu_read_unlock();


