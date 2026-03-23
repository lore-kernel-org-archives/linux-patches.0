Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9FBF1D5CF2;
	Mon, 23 Mar 2026 13:56:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274161; cv=none; b=UoWKjPNjd3o4xKVVfAQTdSpwvln3r5Om5UR8/rBFzE3LcAs9RI35EHTb+OWlo8a3imynMuX7FcuTRM8McExCKofhlhM5eNUQP3zCC5wOluU+oNXqhKfrnME+y16brP4fAH8CkID7LwDVZJOa+g+S1kdm0lO6G/+Sk+A/ew/jkSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274161; c=relaxed/simple;
	bh=NPMvhvUGAhUiuPc0jf3LHyahIzMo6uyYyOll9z0r6jc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H0n7ETOA0MiAx31o/1XCKsAiDb54iQ1dCWGGWF/+2EoMYHGHhpt+TU/V7hxEKgEuLB+0EkhL84GbhliVFSy/3Txg3biqv1lzJVZz6jKmXtokVkZIFJ266X6F4DdgLKbrdxR4jxDAXV6kmOoNNjJE1ThQs8PRB2BE+vJoArk/Iec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Def3D7Dh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Def3D7Dh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3373FC2BCB3;
	Mon, 23 Mar 2026 13:56:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274161;
	bh=NPMvhvUGAhUiuPc0jf3LHyahIzMo6uyYyOll9z0r6jc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Def3D7Dh4ZEzsZUW7th6FB7BKzisgqY8rFFe/FhGAyKUje75sdt0XJJeFbkpBmKqv
	 2O6ttF5UwG7F9eSDMPwWciUx9fwQMj4gyd6rCmjg8noI+HI9ETqasTuodaAWnZktdI
	 GuTQ1qXWu+63si0Hms73jtq2N0VU4+qGbFe0Hgc4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Guillaume Nault <gnault@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 130/220] ip_tunnel: adapt iptunnel_xmit_stats() to NETDEV_PCPU_STAT_DSTATS
Date: Mon, 23 Mar 2026 14:45:07 +0100
Message-ID: <20260323134508.695450734@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134504.575022936@linuxfoundation.org>
References: <20260323134504.575022936@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 8431c602f551549f082bbfa67f3003f2d8e3e132 ]

Blamed commits forgot that vxlan/geneve use udp_tunnel[6]_xmit_skb() which
call iptunnel_xmit_stats().

iptunnel_xmit_stats() was assuming tunnels were only using
NETDEV_PCPU_STAT_TSTATS.

@syncp offset in pcpu_sw_netstats and pcpu_dstats is different.

32bit kernels would either have corruptions or freezes if the syncp
sequence was overwritten.

This patch also moves pcpu_stat_type closer to dev->{t,d}stats to avoid
a potential cache line miss since iptunnel_xmit_stats() needs to read it.

Fixes: 6fa6de302246 ("geneve: Handle stats using NETDEV_PCPU_STAT_DSTATS.")
Fixes: be226352e8dc ("vxlan: Handle stats using NETDEV_PCPU_STAT_DSTATS.")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Guillaume Nault <gnault@redhat.com>
Link: https://patch.msgid.link/20260311123110.1471930-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/netdevice.h |  3 +--
 include/net/ip_tunnels.h  | 30 +++++++++++++++++++++++-------
 2 files changed, 24 insertions(+), 9 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 65d85dc9c8f05..444e52eb8ed99 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2153,6 +2153,7 @@ struct net_device {
 	unsigned long		state;
 	unsigned int		flags;
 	unsigned short		hard_header_len;
+	enum netdev_stat_type	pcpu_stat_type:8;
 	netdev_features_t	features;
 	struct inet6_dev __rcu	*ip6_ptr;
 	__cacheline_group_end(net_device_read_txrx);
@@ -2401,8 +2402,6 @@ struct net_device {
 	void				*ml_priv;
 	enum netdev_ml_priv_type	ml_priv_type;
 
-	enum netdev_stat_type		pcpu_stat_type:8;
-
 #if IS_ENABLED(CONFIG_GARP)
 	struct garp_port __rcu	*garp_port;
 #endif
diff --git a/include/net/ip_tunnels.h b/include/net/ip_tunnels.h
index 80662f8120803..1f577a4f8ce9b 100644
--- a/include/net/ip_tunnels.h
+++ b/include/net/ip_tunnels.h
@@ -665,13 +665,29 @@ static inline int iptunnel_pull_offloads(struct sk_buff *skb)
 static inline void iptunnel_xmit_stats(struct net_device *dev, int pkt_len)
 {
 	if (pkt_len > 0) {
-		struct pcpu_sw_netstats *tstats = get_cpu_ptr(dev->tstats);
-
-		u64_stats_update_begin(&tstats->syncp);
-		u64_stats_add(&tstats->tx_bytes, pkt_len);
-		u64_stats_inc(&tstats->tx_packets);
-		u64_stats_update_end(&tstats->syncp);
-		put_cpu_ptr(tstats);
+		if (dev->pcpu_stat_type == NETDEV_PCPU_STAT_DSTATS) {
+			struct pcpu_dstats *dstats = get_cpu_ptr(dev->dstats);
+
+			u64_stats_update_begin(&dstats->syncp);
+			u64_stats_add(&dstats->tx_bytes, pkt_len);
+			u64_stats_inc(&dstats->tx_packets);
+			u64_stats_update_end(&dstats->syncp);
+			put_cpu_ptr(dstats);
+			return;
+		}
+		if (dev->pcpu_stat_type == NETDEV_PCPU_STAT_TSTATS) {
+			struct pcpu_sw_netstats *tstats = get_cpu_ptr(dev->tstats);
+
+			u64_stats_update_begin(&tstats->syncp);
+			u64_stats_add(&tstats->tx_bytes, pkt_len);
+			u64_stats_inc(&tstats->tx_packets);
+			u64_stats_update_end(&tstats->syncp);
+			put_cpu_ptr(tstats);
+			return;
+		}
+		pr_err_once("iptunnel_xmit_stats pcpu_stat_type=%d\n",
+			    dev->pcpu_stat_type);
+		WARN_ON_ONCE(1);
 		return;
 	}
 
-- 
2.51.0



