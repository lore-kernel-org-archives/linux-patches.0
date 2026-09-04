Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 761B93EC6AE;
	Fri,  4 Sep 2026 05:39:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500353; cv=none; b=VZ1F3wqaM7b7rvG/1EcYtbQqcEmujsHIJoCdBwMkppJtNMeNMN4OVXv2drn6Zco09+DuWKqY/HcPc1o10br0bNT8WRNFKzla0On7XTVNLf51CnJnSZ+Xv7hSI1Svumt0wrP6isSFk6yjl6tSQyzCltHrf0Rx7gxQvC/084Yy8KY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500353; c=relaxed/simple;
	bh=uasSsacPkLCLZ+wYpmocoRjk1PXUhv01QzkFKF0hMXw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eXhJWoCVoIAT8z3qNftPWQJ4H7wv8DVfAmaTXsITDqh6mrKXwkKTmK6TB5EyVnMCWNw/Dx+SjT2TJ998oUjqvcvGvvHpZv6Zb9vc0QDODPHoIPMsadWjvJBLeUvQ4UJwe5Jo9gk4PmnVW7ljiiu6v55Vg2zY41lWQgYhPqOLMw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mcg0O5BU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mcg0O5BU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 911D31F00A3E;
	Fri,  4 Sep 2026 05:39:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500352;
	bh=SmX3zZ9f76x+67owRBMo8K605tyuxVQOqHrETZTJoGM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Mcg0O5BUCVzwHuMXH1xnZbjD+o79utxon4a5Q+L2qgMGjq4ULF6lNtRIDgLTDmTQW
	 SZR5KxOmYfiYYjSNpGUDC16Webs+fGHHddwt5RFxE6Ktvfv4UkmEkRB/98pYqW4wh9
	 kZnNZegXEyI2S4nUBd6QqtY5ya2vEIoxtHVbH6m0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Guillaume Nault <gnault@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 005/552] ip_tunnel: adapt iptunnel_xmit_stats() to NETDEV_PCPU_STAT_DSTATS
Date: Fri,  4 Sep 2026 06:52:42 +0200
Message-ID: <20260904045747.946965932@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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
index c13f759374bed..7be5b78b2bff7 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2145,6 +2145,7 @@ struct net_device {
 	unsigned long		state;
 	unsigned int		flags;
 	unsigned short		hard_header_len;
+	enum netdev_stat_type	pcpu_stat_type:8;
 	netdev_features_t	features;
 	struct inet6_dev __rcu	*ip6_ptr;
 	__cacheline_group_end(net_device_read_txrx);
@@ -2396,8 +2397,6 @@ struct net_device {
 	void				*ml_priv;
 	enum netdev_ml_priv_type	ml_priv_type;
 
-	enum netdev_stat_type		pcpu_stat_type:8;
-
 #if IS_ENABLED(CONFIG_GARP)
 	struct garp_port __rcu	*garp_port;
 #endif
diff --git a/include/net/ip_tunnels.h b/include/net/ip_tunnels.h
index 253ed3930f6ef..d708b66e55cda 100644
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
2.53.0



