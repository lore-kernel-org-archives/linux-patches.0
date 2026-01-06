Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9796035FF65;
	Tue,  6 Jan 2026 17:49:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721772; cv=none; b=t9cksN+DDejLRZe7w5KQSeG4au8rkfSQzYXVGARYBmCpsLSVvWZwPgo4vLuue1fHE9xrnu7VDrdzCVSa7jYUR3HmBH4hJI23ARFHb1him8sowFKBt2xe0eHEdD+Q4f+mD9C+GyuXNIGZQ2Qi1BjAImXbv1FrBcT+UmnwX1M+lNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721772; c=relaxed/simple;
	bh=vODT1hQwdj2TvsIIFXiLX7F9VIt/A2jjEhEji/n3SEk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m2ocUx89/l+5MjdiZi2q2krCrQIcrhekr3vYvBfUen61D/wahgAj47B/iHzR1VOWJLO42JzuGE3wLuDuFe8A2jiJ/cinG5gw4anKAzw5VbcH3xMao39vCkhGc3y8xaXSdIyrTQAFwE+sABsA/yfEVZWKfTt/aGvJtCHA03h6bLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q0LZn8Hg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q0LZn8Hg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 040E8C116C6;
	Tue,  6 Jan 2026 17:49:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721772;
	bh=vODT1hQwdj2TvsIIFXiLX7F9VIt/A2jjEhEji/n3SEk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q0LZn8HgflKgGWutR/osd/Eu4cSBMiD0BPbrzjTDV2NuiECZAnQndAJOIfMhsGOSa
	 35TQUmZZMlJkQCmNNou1fS9ZwmxgVk0AhccGMFzGuru3mv/VkOQxBN6YkCyr9PvrzP
	 qwOsK+zQHh9DfqIOffnY+64K10gxVPkjSodROLAc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Schmidt <mschmidt@redhat.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 068/312] RDMA/irdma: avoid invalid read in irdma_net_event
Date: Tue,  6 Jan 2026 18:02:22 +0100
Message-ID: <20260106170550.310331245@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

From: Michal Schmidt <mschmidt@redhat.com>

[ Upstream commit 6f05611728e9d0ab024832a4f1abb74a5f5d0bb0 ]

irdma_net_event() should not dereference anything from "neigh" (alias
"ptr") until it has checked that the event is NETEVENT_NEIGH_UPDATE.
Other events come with different structures pointed to by "ptr" and they
may be smaller than struct neighbour.

Move the read of neigh->dev under the NETEVENT_NEIGH_UPDATE case.

The bug is mostly harmless, but it triggers KASAN on debug kernels:

 BUG: KASAN: stack-out-of-bounds in irdma_net_event+0x32e/0x3b0 [irdma]
 Read of size 8 at addr ffffc900075e07f0 by task kworker/27:2/542554

 CPU: 27 PID: 542554 Comm: kworker/27:2 Kdump: loaded Not tainted 5.14.0-630.el9.x86_64+debug #1
 Hardware name: [...]
 Workqueue: events rt6_probe_deferred
 Call Trace:
  <IRQ>
  dump_stack_lvl+0x60/0xb0
  print_address_description.constprop.0+0x2c/0x3f0
  print_report+0xb4/0x270
  kasan_report+0x92/0xc0
  irdma_net_event+0x32e/0x3b0 [irdma]
  notifier_call_chain+0x9e/0x180
  atomic_notifier_call_chain+0x5c/0x110
  rt6_do_redirect+0xb91/0x1080
  tcp_v6_err+0xe9b/0x13e0
  icmpv6_notify+0x2b2/0x630
  ndisc_redirect_rcv+0x328/0x530
  icmpv6_rcv+0xc16/0x1360
  ip6_protocol_deliver_rcu+0xb84/0x12e0
  ip6_input_finish+0x117/0x240
  ip6_input+0xc4/0x370
  ipv6_rcv+0x420/0x7d0
  __netif_receive_skb_one_core+0x118/0x1b0
  process_backlog+0xd1/0x5d0
  __napi_poll.constprop.0+0xa3/0x440
  net_rx_action+0x78a/0xba0
  handle_softirqs+0x2d4/0x9c0
  do_softirq+0xad/0xe0
  </IRQ>

Fixes: 915cc7ac0f8e ("RDMA/irdma: Add miscellaneous utility definitions")
Link: https://patch.msgid.link/r/20251127143150.121099-1-mschmidt@redhat.com
Signed-off-by: Michal Schmidt <mschmidt@redhat.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/irdma/utils.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/irdma/utils.c b/drivers/infiniband/hw/irdma/utils.c
index 8b94d87b0192..b6c4ccf38eb7 100644
--- a/drivers/infiniband/hw/irdma/utils.c
+++ b/drivers/infiniband/hw/irdma/utils.c
@@ -251,7 +251,7 @@ int irdma_net_event(struct notifier_block *notifier, unsigned long event,
 		    void *ptr)
 {
 	struct neighbour *neigh = ptr;
-	struct net_device *real_dev, *netdev = (struct net_device *)neigh->dev;
+	struct net_device *real_dev, *netdev;
 	struct irdma_device *iwdev;
 	struct ib_device *ibdev;
 	__be32 *p;
@@ -260,6 +260,7 @@ int irdma_net_event(struct notifier_block *notifier, unsigned long event,
 
 	switch (event) {
 	case NETEVENT_NEIGH_UPDATE:
+		netdev = neigh->dev;
 		real_dev = rdma_vlan_dev_real_dev(netdev);
 		if (!real_dev)
 			real_dev = netdev;
-- 
2.51.0



