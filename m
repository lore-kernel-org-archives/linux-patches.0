Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56BDC46EF60;
	Tue, 21 Jul 2026 19:43:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662986; cv=none; b=l4Uw0mrBRqXnOv0K1Ybfyk9H88YskgJytW1CxLC36O8ku5ZV4lKe6knMQVBtbQsfISzx+dzxk5BLTer409aq2I8h1arxy920hhbuhaLryAeDu1xGOJPbJqslMnq3epNPgwDSXbTHtfpVJOAOzObFEWN9VtcXLCDbghorpdZEMMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662986; c=relaxed/simple;
	bh=uKZSKfY2/hW0HbKa1N/lr2JvevOCPnmMowviWlDpk9w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ksRBwqkbW/GkIVP/xUjwBnYwZPEloWmQlIdnAIV41YLBbP1ekIS09ul8PEFlBvIlWXHDIUn0sZoBkwp/5zcp2Dco/er4xbWHZG+/yBVuyUL1RC+3iLZ4ETR1OwRu6bw3tQv9HNMy2K2K68ay0LufZLWTFpmV4PDRI0K3QYpfneQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UqsVlbP9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UqsVlbP9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA71F1F000E9;
	Tue, 21 Jul 2026 19:43:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662985;
	bh=y0dcn50Ft/iKrbwyXcxui7p7krmwQOUjS2W3iNrPYRE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UqsVlbP9EMwpOWxRZqL2/ALaXyutLONkwt+pUlPkaEIZgnvF4PieZMp6qf346P0HT
	 HV77XIhveYwH7LiKU6n+Q4DSBk6UJnerd7vVkHuS7ajgTNC0prmZCp7FsD0edDA29Q
	 S8xPVXa2Qjybl0aChlTP8A7C10aEOs+PeusRhUP8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weiming Shi <bestswngs@gmail.com>,
	Xiang Mei <xmei5@asu.edu>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0653/1276] net, bpf: check master for NULL in xdp_master_redirect()
Date: Tue, 21 Jul 2026 17:18:16 +0200
Message-ID: <20260721152500.722534633@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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
index 6450aa2ea44efc..f54e7152d68798 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -4427,7 +4427,7 @@ u32 xdp_master_redirect(struct xdp_buff *xdp)
 	struct net_device *master, *slave;
 
 	master = netdev_master_upper_dev_get_rcu(xdp->rxq->dev);
-	if (unlikely(!(master->flags & IFF_UP)))
+	if (unlikely(!master || !(master->flags & IFF_UP)))
 		return XDP_ABORTED;
 	slave = master->netdev_ops->ndo_xdp_get_xmit_slave(master, xdp);
 	if (slave && slave != xdp->rxq->dev) {
-- 
2.53.0



