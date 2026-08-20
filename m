Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7A73481FD7;
	Thu, 20 Aug 2026 17:35:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247308; cv=none; b=UQ/R80jyxjR8dTZmgJ61oxzDfKCa6sQIKqEN0rNP5lGC2lK3r/ERS8+EDJU0jPp5L6ywVU9MMiBl6x08UT/UfCMJLly+LBYI36RVC7V2pi6n98lrFOTMLYgh04lATMKIy7+iaO3spcnkoDTkBC2KC8EaRdavpf47CKK35l0GsuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247308; c=relaxed/simple;
	bh=RiAlhmh+MW9S7uS+9ArHZKjiPgPCjOUrzJX/eDyR/Fo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NUmRf7KPF6fJ16nBzSCdIfMjiEYmT1jed2EKnaDCp/c1MWM1EIZ96bE7hUEqOspDuKWmif5kJVTloOZd1C1KzUhSzVh406M0ojZ5m+MsftC7GZwmLCwJEripYBj/MleX/l3/xQmOcbPpLqod3X3NsfvwB8Bjb0pnFRLOgeAEBp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P8NG0uow; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P8NG0uow"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FFF61F000E9;
	Thu, 20 Aug 2026 17:35:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247306;
	bh=e4TdPTShXvRN6POyweo2I3fMCXRbNo+xttcGUCpF5vo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P8NG0uowmkNmUhILfNATl9gYTH0g9wzmtKnUCjvl3008z3gne65oAH7W0F5stUG1I
	 LydKnI1j5R2CiPkzbw9FWvxw7qGji/rXn/5Mq6tE1BXxYNlRJp9shcrg+oYHj6O4vw
	 rCLqlcVPXU3YOCVOqe5xpoDnzfithbZa7NykWT0g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Guillaume Nault <gnault@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 220/220] ip_tunnel: adapt iptunnel_xmit_stats() to NETDEV_PCPU_STAT_DSTATS
Date: Thu, 20 Aug 2026 16:56:50 +0200
Message-ID: <20260820145230.158834446@linuxfoundation.org>
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

commit 8431c602f551549f082bbfa67f3003f2d8e3e132 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/netdevice.h |    3 +--
 include/net/ip_tunnels.h  |   28 ++++++++++++++++++++++------
 2 files changed, 23 insertions(+), 8 deletions(-)

--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2069,6 +2069,7 @@ struct net_device {
 	unsigned long		state;
 	unsigned int		flags;
 	unsigned short		hard_header_len;
+	enum netdev_stat_type	pcpu_stat_type:8;
 	netdev_features_t	features;
 	struct inet6_dev __rcu	*ip6_ptr;
 	__cacheline_group_end(net_device_read_txrx);
@@ -2314,8 +2315,6 @@ struct net_device {
 	void				*ml_priv;
 	enum netdev_ml_priv_type	ml_priv_type;
 
-	enum netdev_stat_type		pcpu_stat_type:8;
-
 #if IS_ENABLED(CONFIG_GARP)
 	struct garp_port __rcu	*garp_port;
 #endif
--- a/include/net/ip_tunnels.h
+++ b/include/net/ip_tunnels.h
@@ -651,13 +651,29 @@ static inline int iptunnel_pull_offloads
 static inline void iptunnel_xmit_stats(struct net_device *dev, int pkt_len)
 {
 	if (pkt_len > 0) {
-		struct pcpu_sw_netstats *tstats = get_cpu_ptr(dev->tstats);
+		if (dev->pcpu_stat_type == NETDEV_PCPU_STAT_DSTATS) {
+			struct pcpu_dstats *dstats = get_cpu_ptr(dev->dstats);
 
-		u64_stats_update_begin(&tstats->syncp);
-		u64_stats_add(&tstats->tx_bytes, pkt_len);
-		u64_stats_inc(&tstats->tx_packets);
-		u64_stats_update_end(&tstats->syncp);
-		put_cpu_ptr(tstats);
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
 


