Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6D152580F9;
	Mon,  1 Dec 2025 11:31:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764588689; cv=none; b=EcyVAtRhR435FPZfw8HLRVtgSx7DFEc7kDlFWKLAmfjEJp7wz4wowr3iuQZyLP5iizr4nM0cmDnu2ACleUwVOWiOHiAnf/MzTIaGdeftha92h4mVfjlp/2Zu3HjxIKFdh3NZC+XdooaNtYKz666WLL1MzqAGMBIGf3NK+8PUI7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764588689; c=relaxed/simple;
	bh=eumHjR4eDcZBGiyryAHgnCQLNuZuhEZfAStpowv5+Uk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P7aB7T0m8GzUUly5zjljzm6xJSylPK52dzjN5LfiSxEIj3bvAqC+SHjnOxWpmyDeYE0MIJ+aelikKy3UJ+B71Wrnc2Yq6xmjiOPjszmqAw5hGvZRXIn0GBsu5qTH16JdJ/Gs5NgnUNoj5G+rOUCdCJuKOyOBfVPD4Fij9dnCPuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v/0SLq2Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v/0SLq2Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51F91C113D0;
	Mon,  1 Dec 2025 11:31:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764588689;
	bh=eumHjR4eDcZBGiyryAHgnCQLNuZuhEZfAStpowv5+Uk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v/0SLq2ZHplqaOZmQi22KjQ2Fh9yQPfZgODwXeY8nPnvje5LatI3SK/Tg43v9LYmL
	 1LgfVpSnvbQZ10ISMHYmxY8/20okkEwrruPrXBSxxtdhEivw/Ja6l6r8mfrcKgB8M+
	 30+UstCMYPTi0Gh/fd1Lif2LX0ATGSpPmwzL8hHw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xin Long <lucien.xin@gmail.com>,
	Jon Maloy <jmaloy@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 136/187] tipc: simplify the finalize work queue
Date: Mon,  1 Dec 2025 12:24:04 +0100
Message-ID: <20251201112246.138877333@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251201112241.242614045@linuxfoundation.org>
References: <20251201112241.242614045@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit be07f056396d6bb40963c45a02951c566ddeef8e ]

This patch is to use "struct work_struct" for the finalize work queue
instead of "struct tipc_net_work", as it can get the "net" and "addr"
from tipc_net's other members and there is no need to add extra net
and addr in tipc_net by defining "struct tipc_net_work".

Note that it's safe to get net from tn->bcl as bcl is always released
after the finalize work queue is done.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
Acked-by: Jon Maloy <jmaloy@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 0725e6afb551 ("tipc: Fix use-after-free in tipc_mon_reinit_self().")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tipc/core.c     |  4 ++--
 net/tipc/core.h     |  8 +-------
 net/tipc/discover.c |  4 ++--
 net/tipc/link.c     |  5 +++++
 net/tipc/link.h     |  1 +
 net/tipc/net.c      | 15 +++------------
 6 files changed, 14 insertions(+), 23 deletions(-)

diff --git a/net/tipc/core.c b/net/tipc/core.c
index 58ee5ee707816..cce4cde3f5f18 100644
--- a/net/tipc/core.c
+++ b/net/tipc/core.c
@@ -59,7 +59,7 @@ static int __net_init tipc_init_net(struct net *net)
 	tn->trial_addr = 0;
 	tn->addr_trial_end = 0;
 	tn->capabilities = TIPC_NODE_CAPABILITIES;
-	INIT_WORK(&tn->final_work.work, tipc_net_finalize_work);
+	INIT_WORK(&tn->work, tipc_net_finalize_work);
 	memset(tn->node_id, 0, sizeof(tn->node_id));
 	memset(tn->node_id_string, 0, sizeof(tn->node_id_string));
 	tn->mon_threshold = TIPC_DEF_MON_THRESHOLD;
@@ -101,7 +101,7 @@ static void __net_exit tipc_exit_net(struct net *net)
 
 	tipc_detach_loopback(net);
 	/* Make sure the tipc_net_finalize_work() finished */
-	cancel_work_sync(&tn->final_work.work);
+	cancel_work_sync(&tn->work);
 	tipc_net_stop(net);
 
 	tipc_bcast_stop(net);
diff --git a/net/tipc/core.h b/net/tipc/core.h
index 59f97ef12e60d..32c5945c89338 100644
--- a/net/tipc/core.h
+++ b/net/tipc/core.h
@@ -87,12 +87,6 @@ extern unsigned int tipc_net_id __read_mostly;
 extern int sysctl_tipc_rmem[3] __read_mostly;
 extern int sysctl_tipc_named_timeout __read_mostly;
 
-struct tipc_net_work {
-	struct work_struct work;
-	struct net *net;
-	u32 addr;
-};
-
 struct tipc_net {
 	u8  node_id[NODE_ID_LEN];
 	u32 node_addr;
@@ -143,7 +137,7 @@ struct tipc_net {
 	struct packet_type loopback_pt;
 
 	/* Work item for net finalize */
-	struct tipc_net_work final_work;
+	struct work_struct work;
 	/* The numbers of work queues in schedule */
 	atomic_t wq_count;
 };
diff --git a/net/tipc/discover.c b/net/tipc/discover.c
index 9c64567f8a741..a6aa9ecc4a0bb 100644
--- a/net/tipc/discover.c
+++ b/net/tipc/discover.c
@@ -167,7 +167,7 @@ static bool tipc_disc_addr_trial_msg(struct tipc_discoverer *d,
 
 	/* Apply trial address if we just left trial period */
 	if (!trial && !self) {
-		tipc_sched_net_finalize(net, tn->trial_addr);
+		schedule_work(&tn->work);
 		msg_set_prevnode(buf_msg(d->skb), tn->trial_addr);
 		msg_set_type(buf_msg(d->skb), DSC_REQ_MSG);
 	}
@@ -310,7 +310,7 @@ static void tipc_disc_timeout(struct timer_list *t)
 	if (!time_before(jiffies, tn->addr_trial_end) && !tipc_own_addr(net)) {
 		mod_timer(&d->timer, jiffies + TIPC_DISC_INIT);
 		spin_unlock_bh(&d->lock);
-		tipc_sched_net_finalize(net, tn->trial_addr);
+		schedule_work(&tn->work);
 		return;
 	}
 
diff --git a/net/tipc/link.c b/net/tipc/link.c
index 2052649fb537e..bf7e6fd855485 100644
--- a/net/tipc/link.c
+++ b/net/tipc/link.c
@@ -332,6 +332,11 @@ char tipc_link_plane(struct tipc_link *l)
 	return l->net_plane;
 }
 
+struct net *tipc_link_net(struct tipc_link *l)
+{
+	return l->net;
+}
+
 void tipc_link_update_caps(struct tipc_link *l, u16 capabilities)
 {
 	l->peer_caps = capabilities;
diff --git a/net/tipc/link.h b/net/tipc/link.h
index adcad65e761ce..5ac43acce958a 100644
--- a/net/tipc/link.h
+++ b/net/tipc/link.h
@@ -151,4 +151,5 @@ int tipc_link_bc_sync_rcv(struct tipc_link *l,   struct tipc_msg *hdr,
 int tipc_link_bc_nack_rcv(struct tipc_link *l, struct sk_buff *skb,
 			  struct sk_buff_head *xmitq);
 bool tipc_link_too_silent(struct tipc_link *l);
+struct net *tipc_link_net(struct tipc_link *l);
 #endif
diff --git a/net/tipc/net.c b/net/tipc/net.c
index 2498ce8b83c1a..3807ead54d3d5 100644
--- a/net/tipc/net.c
+++ b/net/tipc/net.c
@@ -41,6 +41,7 @@
 #include "socket.h"
 #include "node.h"
 #include "bcast.h"
+#include "link.h"
 #include "netlink.h"
 #include "monitor.h"
 
@@ -138,19 +139,9 @@ static void tipc_net_finalize(struct net *net, u32 addr)
 
 void tipc_net_finalize_work(struct work_struct *work)
 {
-	struct tipc_net_work *fwork;
+	struct tipc_net *tn = container_of(work, struct tipc_net, work);
 
-	fwork = container_of(work, struct tipc_net_work, work);
-	tipc_net_finalize(fwork->net, fwork->addr);
-}
-
-void tipc_sched_net_finalize(struct net *net, u32 addr)
-{
-	struct tipc_net *tn = tipc_net(net);
-
-	tn->final_work.net = net;
-	tn->final_work.addr = addr;
-	schedule_work(&tn->final_work.work);
+	tipc_net_finalize(tipc_link_net(tn->bcl), tn->trial_addr);
 }
 
 void tipc_net_stop(struct net *net)
-- 
2.51.0



