Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 712903BD643;
	Sat, 17 Oct 2026 18:07:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260466; cv=none; b=WXa1IWgL37Qe3i0/uGGVQrj+tBmZ9AZgx/8LaoBuXQruigrB4gkv/ykjsyb7ihXhrVrJIJ0Mkg1UUOBJKwVbr3DTt+sQDb9v6HXEQiJ7pILlAWiM7vwaRfBlDC3n9E7CQzySSIvHO7s9fD+aW7qM56PU0sUffwd/QbwddLsRq00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260466; c=relaxed/simple;
	bh=u9SWe15kdT5V7ghtDpy+gTSxjlAdMqmiW8HYMkiJcUg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=thWOZsBpAK00tj6QRdbIkb1Use/bugJ4tsSkrv9Xc8WqZAyHUlw3pEUhDMoHCB7imOG+/AJ4Uudh6xNdD5Z8PKxxhuql9+dLaJdsHVjPla9g+zav9/ZQAnK92Iz9TbNdxmjtLGRQxALEvveLuH8vHz0/jhpdhsqo76dFcDP/nbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NgmsKJYv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NgmsKJYv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF8251F000C4;
	Sat, 17 Oct 2026 18:07:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260465;
	bh=roFgdMr9GYa4OHBej92rR7044zo3faucyGcEl88nOyg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NgmsKJYvMr1XaVN40Z9TCcnMTv5VacGxrs4nPaF9cW4En3KxtSKJAOeXqN26kMzSN
	 rVHl//ujknhNxrJfD5XfUV5AxBaXdEHVzYnANKo01FzS0aPIhPUG7GqxhSYTCc6lN/
	 5SLCUv3ho3L64YiI0wqz2ZRHZZiBEztvF66K1dDQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Guillaume Nault <gnault@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1555/1674] ip_tunnel: adapt iptunnel_xmit_stats() to NETDEV_PCPU_STAT_DSTATS
Date: Sat, 17 Oct 2026 18:03:47 +0200
Message-ID: <20261017160511.015395247@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 include/net/ip_tunnels.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/include/net/ip_tunnels.h b/include/net/ip_tunnels.h
index e32e7cbe99167..5e0965212c70e 100644
--- a/include/net/ip_tunnels.h
+++ b/include/net/ip_tunnels.h
@@ -542,6 +542,16 @@ static inline int iptunnel_pull_offloads(struct sk_buff *skb)
 static inline void iptunnel_xmit_stats(struct net_device *dev, int pkt_len)
 {
 	if (pkt_len > 0) {
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
 		struct pcpu_sw_netstats *tstats = get_cpu_ptr(dev->tstats);
 
 		u64_stats_update_begin(&tstats->syncp);
-- 
2.53.0



