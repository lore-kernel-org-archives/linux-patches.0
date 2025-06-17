Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A09D32ED174;
	Tue, 17 Jun 2025 16:25:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177547; cv=none; b=eUxvb/x4v1j77lPeRO65MOKB3Pm/o8DDBFjXnEoiHxR7FisDjT64CYA+eURu98Ri2PMbhcTAM+yEwd6jDcKXf4FOrCLsstCgYkUjePiJB9JYC/BN6O1xGKNLZdchaNEo1uJiEEEfttiFfXsjoDvzX9klYbKvY4XpXhkESsy2VjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177547; c=relaxed/simple;
	bh=WWSLFjI+2GUR5v/EHJtj91SrNTJTG2p7TUEHr1Bcfew=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RUfJpnhu9nMrBw6rd9npycqiU3HZItypzMKfu/T42+huAVVG7lbPXM0ZRiM394fxGLIBom/u8wI3i2T28+O3s/4nVlu+Dug9m9myQ8QZAOWrezoUZ+PjozdGnbpYnIR/ppXklQ7/TZ49vWt6He2vB9m0ZJqeY4ybT9YvVCXhTwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ddFhZpI8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ddFhZpI8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2F12C4CEE3;
	Tue, 17 Jun 2025 16:25:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177546;
	bh=WWSLFjI+2GUR5v/EHJtj91SrNTJTG2p7TUEHr1Bcfew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ddFhZpI80y9j4DEmB4y52KZ9JWQ94C/sxYfTIGturel+sbiibQfEvjSdatUALJCkM
	 tE1wkCpH97ejFGGrJ3ZjDlg561Vg2GtMspNHDytkHV7Q6N5hucTe3o3FgVr4KhA7bl
	 Xmzycrqav3nA9TLMLXzK5GKDszQ4Sn2vc4qI+58g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+b191b5ccad8d7a986286@syzkaller.appspotmail.com,
	Stanislav Fomichev <stfomichev@gmail.com>,
	Willem de Bruijn <willemb@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 322/780] af_packet: move notifiers packet_dev_mc out of rcu critical section
Date: Tue, 17 Jun 2025 17:20:30 +0200
Message-ID: <20250617152504.565248588@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanislav Fomichev <stfomichev@gmail.com>

[ Upstream commit d8d85ef0a631df9127f202e6371bb33a0b589952 ]

Syzkaller reports the following issue:

 BUG: sleeping function called from invalid context at kernel/locking/mutex.c:578
 __mutex_lock+0x106/0xe80 kernel/locking/mutex.c:746
 team_change_rx_flags+0x38/0x220 drivers/net/team/team_core.c:1781
 dev_change_rx_flags net/core/dev.c:9145 [inline]
 __dev_set_promiscuity+0x3f8/0x590 net/core/dev.c:9189
 netif_set_promiscuity+0x50/0xe0 net/core/dev.c:9201
 dev_set_promiscuity+0x126/0x260 net/core/dev_api.c:286 packet_dev_mc net/packet/af_packet.c:3698 [inline]
 packet_dev_mclist_delete net/packet/af_packet.c:3722 [inline]
 packet_notifier+0x292/0xa60 net/packet/af_packet.c:4247
 notifier_call_chain+0x1b3/0x3e0 kernel/notifier.c:85
 call_netdevice_notifiers_extack net/core/dev.c:2214 [inline]
 call_netdevice_notifiers net/core/dev.c:2228 [inline]
 unregister_netdevice_many_notify+0x15d8/0x2330 net/core/dev.c:11972
 rtnl_delete_link net/core/rtnetlink.c:3522 [inline]
 rtnl_dellink+0x488/0x710 net/core/rtnetlink.c:3564
 rtnetlink_rcv_msg+0x7cf/0xb70 net/core/rtnetlink.c:6955
 netlink_rcv_skb+0x219/0x490 net/netlink/af_netlink.c:2534

Calling `PACKET_ADD_MEMBERSHIP` on an ops-locked device can trigger
the `NETDEV_UNREGISTER` notifier, which may require disabling promiscuous
and/or allmulti mode. Both of these operations require acquiring
the netdev instance lock.

Move the call to `packet_dev_mc` outside of the RCU critical section.
The `mclist` modifications (add, del, flush, unregister) are protected by
the RTNL, not the RCU. The RCU only protects the `sklist` and its
associated `sks`. The delayed operation on the `mclist` entry remains
within the RTNL.

Reported-by: syzbot+b191b5ccad8d7a986286@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=b191b5ccad8d7a986286
Fixes: ad7c7b2172c3 ("net: hold netdev instance lock during sysfs operations")
Signed-off-by: Stanislav Fomichev <stfomichev@gmail.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20250522031129.3247266-1-stfomichev@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/packet/af_packet.c | 21 ++++++++++++++++-----
 net/packet/internal.h  |  1 +
 2 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index d4dba06297c33..20be2c47cf419 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -3713,15 +3713,15 @@ static int packet_dev_mc(struct net_device *dev, struct packet_mclist *i,
 }
 
 static void packet_dev_mclist_delete(struct net_device *dev,
-				     struct packet_mclist **mlp)
+				     struct packet_mclist **mlp,
+				     struct list_head *list)
 {
 	struct packet_mclist *ml;
 
 	while ((ml = *mlp) != NULL) {
 		if (ml->ifindex == dev->ifindex) {
-			packet_dev_mc(dev, ml, -1);
+			list_add(&ml->remove_list, list);
 			*mlp = ml->next;
-			kfree(ml);
 		} else
 			mlp = &ml->next;
 	}
@@ -3769,6 +3769,7 @@ static int packet_mc_add(struct sock *sk, struct packet_mreq_max *mreq)
 	memcpy(i->addr, mreq->mr_address, i->alen);
 	memset(i->addr + i->alen, 0, sizeof(i->addr) - i->alen);
 	i->count = 1;
+	INIT_LIST_HEAD(&i->remove_list);
 	i->next = po->mclist;
 	po->mclist = i;
 	err = packet_dev_mc(dev, i, 1);
@@ -4233,9 +4234,11 @@ static int packet_getsockopt(struct socket *sock, int level, int optname,
 static int packet_notifier(struct notifier_block *this,
 			   unsigned long msg, void *ptr)
 {
-	struct sock *sk;
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
 	struct net *net = dev_net(dev);
+	struct packet_mclist *ml, *tmp;
+	LIST_HEAD(mclist);
+	struct sock *sk;
 
 	rcu_read_lock();
 	sk_for_each_rcu(sk, &net->packet.sklist) {
@@ -4244,7 +4247,8 @@ static int packet_notifier(struct notifier_block *this,
 		switch (msg) {
 		case NETDEV_UNREGISTER:
 			if (po->mclist)
-				packet_dev_mclist_delete(dev, &po->mclist);
+				packet_dev_mclist_delete(dev, &po->mclist,
+							 &mclist);
 			fallthrough;
 
 		case NETDEV_DOWN:
@@ -4277,6 +4281,13 @@ static int packet_notifier(struct notifier_block *this,
 		}
 	}
 	rcu_read_unlock();
+
+	/* packet_dev_mc might grab instance locks so can't run under rcu */
+	list_for_each_entry_safe(ml, tmp, &mclist, remove_list) {
+		packet_dev_mc(dev, ml, -1);
+		kfree(ml);
+	}
+
 	return NOTIFY_DONE;
 }
 
diff --git a/net/packet/internal.h b/net/packet/internal.h
index d5d70712007ad..1e743d0316fdd 100644
--- a/net/packet/internal.h
+++ b/net/packet/internal.h
@@ -11,6 +11,7 @@ struct packet_mclist {
 	unsigned short		type;
 	unsigned short		alen;
 	unsigned char		addr[MAX_ADDR_LEN];
+	struct list_head	remove_list;
 };
 
 /* kbdq - kernel block descriptor queue */
-- 
2.39.5



