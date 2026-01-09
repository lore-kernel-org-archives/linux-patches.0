Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EF7D33032C;
	Fri,  9 Jan 2026 12:43:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962623; cv=none; b=uZ/aTX/TJILj8ex2v7qQ0WmZMUT0Rox++qw5WbTZPHJ+DHAdbzD1qvu6hJTOuxjv7ju0mhsBBCEJZfGuYlJ5pUn2Bz6KF8HRAWGuWsKFFWHyEFhJ9FFZDl6+D5Tncwh2JLhW4mo7qu5pU1IOe/7A97/6BjTKN49u42BP74fTuJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962623; c=relaxed/simple;
	bh=OHbehJ2wUBUs1+ofp4fC56bg+ZglTAwbapyq+NoUbW8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kMBR7hAo8e/Ta6RNq9B+P9+ddbNjsujxwFQEcffXl4HWzryVvepoPcD0p8RtPqrHSYR9rSsy4VEbF8Cqcix6W+qF8V2UCk1MIvPJb/ZTvF8D4Q7A36+gyAUSwVBKKi1FEJb1PU46NSC5ERan2rN0ApkZ582j/lWcFzLjgrWe9ak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hkplxKDd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hkplxKDd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D12E7C19422;
	Fri,  9 Jan 2026 12:43:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962623;
	bh=OHbehJ2wUBUs1+ofp4fC56bg+ZglTAwbapyq+NoUbW8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hkplxKDdB850ZgwjJbpg+BdIwTgISJKLvJ8fG9bsa2cc+g+6MCHhc5jVTG3AmgIYV
	 1qTA9F2Ev3XkONpOTp9yUZ7Un3P1OqU16FQduvNDFJOkke3SGmdib5OflsplC9Dj3f
	 Ll/K7Pvsi3IYpeoBE/EU+RAZcxXSy3ah5xyPn7Ww=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Schmidt <mschmidt@redhat.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 431/634] RDMA/irdma: avoid invalid read in irdma_net_event
Date: Fri,  9 Jan 2026 12:41:49 +0100
Message-ID: <20260109112133.762218078@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 8c7617776e58..d236e4a27ca9 100644
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



