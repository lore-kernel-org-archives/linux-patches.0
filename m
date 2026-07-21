Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E765395266;
	Tue, 21 Jul 2026 18:17:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657829; cv=none; b=WWtacF/ZYUFyZ82Yabz1GSua1zFF3gjW5cZm+UAVW//qdoeYqbijJX4QpmE7soyKJC5ksUkksT4UAr+AoZWdnO7uJC99nN4REuf3dVr4qUyvLzVcWw0kYHOBUTyQhBcAlJWy8frFA50HbEMDO0q31uP2jZul1qJ2bT6IR1AAan8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657829; c=relaxed/simple;
	bh=eATErBR4bNtSYW4bOR/JH6Ap5vCDNmMul+yV/Y3nDNI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GyGHPWhGyx/JNo1M+5rKFym16+ocecYRRc6weLqFbD3uDysnkg7Fc1u+oTtEDTBFnj0oX6At1mPoLiIbYVPtq7z8NLRprXdooedosArc0HJ6N5y6VC5iK23YszVvxhBbSlUgYXsUu1RYGAfes8JVlLKt9Kovi/u6cbeBJ9eNbQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=anIJAan5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="anIJAan5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C39A01F000E9;
	Tue, 21 Jul 2026 18:17:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657828;
	bh=nPJWU6uDW/5/1T7vFr0BUfdubwsE8IV7wPymwVRpbSI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=anIJAan5GtLvcnrm0OUh6IGBvWryZuMk2sn9YqMCMi7t0YUW/NS4L58+donTASgY2
	 6FBVSNdZhWAdlHav7OvCEY6NTfd48rFb9DfkQ/ZgI/X8KKnLLIK538UYEz8XfFFKpY
	 jPVgLW53iobebs2d7JMjWIFzb1prIDJRgvbbpG+g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weiming Shi <bestswngs@gmail.com>,
	Xiang Mei <xmei5@asu.edu>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0912/1611] net, bpf: check master for NULL in xdp_master_redirect()
Date: Tue, 21 Jul 2026 17:17:08 +0200
Message-ID: <20260721152535.901103108@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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
index a3e6cd9c4a78bc..42385e79043131 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -4424,7 +4424,7 @@ u32 xdp_master_redirect(struct xdp_buff *xdp)
 	struct net_device *master, *slave;
 
 	master = netdev_master_upper_dev_get_rcu(xdp->rxq->dev);
-	if (unlikely(!(master->flags & IFF_UP)))
+	if (unlikely(!master || !(master->flags & IFF_UP)))
 		return XDP_ABORTED;
 	slave = master->netdev_ops->ndo_xdp_get_xmit_slave(master, xdp);
 	if (slave && slave != xdp->rxq->dev) {
-- 
2.53.0



