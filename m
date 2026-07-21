Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59C75470102;
	Tue, 21 Jul 2026 19:14:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661266; cv=none; b=JMkmcmJB2u8cxBnUX0V85qChHLRc4gqnhSVeJdSa+HuIXcB9p0D2As39HSqy4utXL3eQ8dDKRvhIrDkHU4zQJ0cMfIHe60dpZNJ/lGM2kEOaMy1GT5y+Fw/2E/BDka7UNc/wtkpmz37WdyIUj725/A+8q2nXmHhT4quHrkxK6ZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661266; c=relaxed/simple;
	bh=Slc0nuDEsZ6SOqR+OGK/aIqYodK/Z+Czic2v63z/kiM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YkTbLK30tXX7dmUZW/Aas8YiFjTAqCMsUTHlxxQO8hDY+flcz1U2uAavPdwDfYQs7nw4fIqD79JMzwtbxKqdt0lY2kWcERewe/TzvPzQYxzh9VMp1BmUxoUzsmtSjOCxorPUq2eRCha45XUHhftoChrvgocktNhm7WXQ1bsGi5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BLOwG3Tp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BLOwG3Tp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B502D1F00A3A;
	Tue, 21 Jul 2026 19:14:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661264;
	bh=WIuLoM3bvIPO/1OEkHl12kNxPko/YZup/HXhuRPSqQM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BLOwG3TpmxAH4C0FWLZpKlME9GWGOMnhs9EqllkbAQfxQltu5WFzpyZcsODv4P5fC
	 5lsqElKO2DR8tRgKFblNsXklW05Q2wnJcK9eOmqXB9N8DXU1I7VNSKtizFj/4YBD+p
	 0YT7NKlAc/czw4QLj0EuCtkdg+u0G8zhSFf3qBo0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weiming Shi <bestswngs@gmail.com>,
	Xiang Mei <xmei5@asu.edu>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1250/2077] net, bpf: check master for NULL in xdp_master_redirect()
Date: Tue, 21 Jul 2026 17:15:23 +0200
Message-ID: <20260721152622.296063354@linuxfoundation.org>
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

From: Xiang Mei <xmei5@asu.edu>

[ Upstream commit e82d8cc4321c373dc46e741cd2dfdaa7921fddb7 ]

xdp_master_redirect() dereferences the result of
netdev_master_upper_dev_get_rcu() without a NULL check, but that helper
returns NULL when the receiving device has no upper-master adjacency.

The reach guard only checks netif_is_bond_slave(). On bond slave release
bond_upper_dev_unlink() drops the upper-master adjacency before clearing
IFF_SLAVE, so an XDP_TX reaching xdp_master_redirect() in that window
still passes netif_is_bond_slave() while master is already NULL, and
faults on master->flags at offset 0xb0:

  BUG: kernel NULL pointer dereference, address: 00000000000000b0
  RIP: 0010:xdp_master_redirect (net/core/filter.c:4432)
  Call Trace:
   xdp_master_redirect (net/core/filter.c:4432)
   bpf_prog_run_generic_xdp (include/net/xdp.h:700)
   do_xdp_generic (net/core/dev.c:5608)
   __netif_receive_skb_one_core (net/core/dev.c:6204)
   process_backlog (net/core/dev.c:6319)
   __napi_poll (net/core/dev.c:7729)
   net_rx_action (net/core/dev.c:7792)
   handle_softirqs (kernel/softirq.c:622)
   __dev_queue_xmit (include/linux/bottom_half.h:33)
   packet_sendmsg (net/packet/af_packet.c:3082)
   __sys_sendto (net/socket.c:2252)
  Kernel panic - not syncing: Fatal exception in interrupt

The missing check dates back to the original code; commit 1921f91298d1
("net, bpf: fix null-ptr-deref in xdp_master_redirect() for down master")
later added the master->flags read where the fault now lands but kept the
unconditional deref. Check master for NULL before use; a NULL master is
treated the same as one that is not up.

Fixes: 879af96ffd72 ("net, core: Add support for XDP redirection to slave device")
Reported-by: Weiming Shi <bestswngs@gmail.com>
Signed-off-by: Xiang Mei <xmei5@asu.edu>
Reviewed-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Link: https://patch.msgid.link/20260620201531.180123-1-xmei5@asu.edu
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/filter.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index 77984b5fada4cd..f21aeff99cc983 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -4433,7 +4433,7 @@ u32 xdp_master_redirect(struct xdp_buff *xdp)
 	struct net_device *master, *slave;
 
 	master = netdev_master_upper_dev_get_rcu(xdp->rxq->dev);
-	if (unlikely(!(master->flags & IFF_UP)))
+	if (unlikely(!master || !(master->flags & IFF_UP)))
 		return XDP_ABORTED;
 	slave = master->netdev_ops->ndo_xdp_get_xmit_slave(master, xdp);
 	if (slave && slave != xdp->rxq->dev) {
-- 
2.53.0



