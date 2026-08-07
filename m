Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5D5A47884E;
	Fri,  7 Aug 2026 15:35:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116910; cv=none; b=rj0C1jwSyU8uoNuW2WNqBJkrMsrd9DkJatS1AR9H36v9g0+mwji6pgpl3DKY3BABISghvhIgUN9BXMUJ/wELYWsr0bTDV1W0cfgnwr5Od16+xKcED+aC8XKpWLlsbY/46gSQ+Ea7GuvM6c1pP0rA64PXSJ1FpH5smOBYvbS7XxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116910; c=relaxed/simple;
	bh=/zUK23m4iN8tBkMA3seQVQcb/9rOe3EiZCT0kx1nPSM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LCCA8vhqPwVbqdj6HWb6ixN61L0QHSgOYw3db8lqd6vGdCMu89rVr6dKTNsRC8xBujlHYf8smODZujGp45UqfzWkwkjncb/yR3Gi66fXT69+XHwpT16mZVEfH4PAucTgSWWqj6GCstHedpX2oN7SsZ07B1RoOrfVU9is3Hl0n0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hARA/Z6u; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hARA/Z6u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D47D1F000E9;
	Fri,  7 Aug 2026 15:35:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116908;
	bh=rGSqz/sFJBcX6FkjDaC84lNGSMkY831E/oDftTeP8jI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hARA/Z6uo/wT7SpXhGiA/h+aWbfJtsk+mB04qotcvLc1IP1E165u7N6ujXDO2+FpE
	 wE9NXpumiKvcO7UageELQKF26Pb7CSUUajonzm8NfWO6Mnob4VVNppu3U5aUJmKqlw
	 j2J3fxYIYjUnGLTmXOA/v7KIxL7CkyADlWhBILEM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+eca845fb8c18dd6b44c1@syzkaller.appspotmail.com,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 116/438] net: udp_tunnel: fix memory leak in udp_tunnel_nic_unregister()
Date: Fri,  7 Aug 2026 16:35:12 +0200
Message-ID: <20260807143430.466809214@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 080695e6f005e2396f1207fd69d24c442cb230c6 ]

syzbot reported a memory leak [1] in the UDP tunnel NIC offload code.

When device registration fails (e.g. in register_netdevice()), netdev core
unwinds by sending a single NETDEV_UNREGISTER notification. If work was queued
during NETDEV_REGISTER (utn->work_pending is set), udp_tunnel_nic_unregister()
returns early:

	if (utn->work_pending)
		return;

Because failed registrations do not enter netdev_wait_allrefs_any(), no
subsequent NETDEV_UNREGISTER rebroadcast will ever occur. As a result, the
struct udp_tunnel_nic allocated in udp_tunnel_nic_alloc() is leaked
permanently.

Fix this by removing the early return. Instead, synchronously cancel any
pending work with cancel_delayed_work_sync() before freeing @utn.

To be able to call cancel_delayed_work_sync() while holding RTNL (the work also
needs RTNL), switch udp_tunnel_nic_device_sync_work() to rtnl_trylock(). If RTNL
is contended, requeue the work with a 1 jiffy delay (via queue_delayed_work())
to prevent high CPU contention while waiting for RTNL lock.

The utn->work_pending bookkeeping is no longer needed and is removed, as
the workqueue core already tracks the pending/running state of the work.

[1]
BUG: memory leak
unreferenced object 0xffff888127d5f840 (size 96):
  comm "syz-executor", pid 5806, jiffies 4294942188
  backtrace (crc 99fdb6c8):
    __kmalloc_noprof+0x3bf/0x550
    udp_tunnel_nic_alloc net/ipv4/udp_tunnel_nic.c:756 [inline]
    udp_tunnel_nic_register net/ipv4/udp_tunnel_nic.c:833 [inline]
    udp_tunnel_nic_netdevice_event+0x804/0xab0 net/ipv4/udp_tunnel_nic.c:931
    notifier_call_chain+0x59/0x160 kernel/notifier.c:85
    call_netdevice_notifiers_info+0x7d/0xb0 net/core/dev.c:2250
    register_netdevice+0xc10/0xeb0 net/core/dev.c:11478

Fixes: cc4e3835eff4 ("udp_tunnel: add central NIC RX port offload infrastructure")
Reported-by: syzbot+eca845fb8c18dd6b44c1@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/netdev/6a632b15.dde6c935.cf6c8.0011.GAE@google.com/T/#u
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20260724091137.1792543-1-edumazet@google.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/udp_tunnel_nic.c | 32 +++++++++++++++++---------------
 1 file changed, 17 insertions(+), 15 deletions(-)

diff --git a/net/ipv4/udp_tunnel_nic.c b/net/ipv4/udp_tunnel_nic.c
index 3b32a0afa9798..53a1a9c1f8bff 100644
--- a/net/ipv4/udp_tunnel_nic.c
+++ b/net/ipv4/udp_tunnel_nic.c
@@ -32,13 +32,12 @@ struct udp_tunnel_nic_table_entry {
  * @lock:	protects all fields
  * @need_sync:	at least one port start changed
  * @need_replay: space was freed, we need a replay of all ports
- * @work_pending: @work is currently scheduled
  * @n_tables:	number of tables under @entries
  * @missed:	bitmap of tables which overflown
  * @entries:	table of tables of ports currently offloaded
  */
 struct udp_tunnel_nic {
-	struct work_struct work;
+	struct delayed_work work;
 
 	struct net_device *dev;
 
@@ -46,7 +45,6 @@ struct udp_tunnel_nic {
 
 	u8 need_sync:1;
 	u8 need_replay:1;
-	u8 work_pending:1;
 
 	unsigned int n_tables;
 	unsigned long missed;
@@ -301,11 +299,10 @@ __udp_tunnel_nic_device_sync(struct net_device *dev, struct udp_tunnel_nic *utn)
 static void
 udp_tunnel_nic_device_sync(struct net_device *dev, struct udp_tunnel_nic *utn)
 {
-	if (!utn->need_sync || utn->work_pending)
+	if (!utn->need_sync)
 		return;
 
-	queue_work(udp_tunnel_nic_workqueue, &utn->work);
-	utn->work_pending = 1;
+	queue_delayed_work(udp_tunnel_nic_workqueue, &utn->work, 0);
 }
 
 static bool
@@ -731,12 +728,17 @@ udp_tunnel_nic_replay(struct net_device *dev, struct udp_tunnel_nic *utn)
 static void udp_tunnel_nic_device_sync_work(struct work_struct *work)
 {
 	struct udp_tunnel_nic *utn =
-		container_of(work, struct udp_tunnel_nic, work);
+		container_of(work, struct udp_tunnel_nic, work.work);
 
-	rtnl_lock();
+	/* We cannot block on RTNL here, otherwise we would deadlock with
+	 * udp_tunnel_nic_unregister() calling cancel_delayed_work_sync()
+	 * while holding RTNL. Requeue with 1 jiffy delay if RTNL is contended.
+	 */
+	if (!rtnl_trylock()) {
+		queue_delayed_work(udp_tunnel_nic_workqueue, &utn->work, 1);
+		return;
+	}
 	mutex_lock(&utn->lock);
-
-	utn->work_pending = 0;
 	__udp_tunnel_nic_device_sync(utn->dev, utn);
 
 	if (utn->need_replay)
@@ -757,7 +759,7 @@ udp_tunnel_nic_alloc(const struct udp_tunnel_nic_info *info,
 	if (!utn)
 		return NULL;
 	utn->n_tables = n_tables;
-	INIT_WORK(&utn->work, udp_tunnel_nic_device_sync_work);
+	INIT_DELAYED_WORK(&utn->work, udp_tunnel_nic_device_sync_work);
 	mutex_init(&utn->lock);
 
 	for (i = 0; i < n_tables; i++) {
@@ -901,11 +903,11 @@ udp_tunnel_nic_unregister(struct net_device *dev, struct udp_tunnel_nic *utn)
 	udp_tunnel_nic_flush(dev, utn);
 	udp_tunnel_nic_unlock(dev);
 
-	/* Wait for the work to be done using the state, netdev core will
-	 * retry unregister until we give up our reference on this device.
+	/* Make sure no work is running or queued before freeing @utn.
+	 * The work handler uses rtnl_trylock(), so it will not deadlock
+	 * against the RTNL we are holding here.
 	 */
-	if (utn->work_pending)
-		return;
+	cancel_delayed_work_sync(&utn->work);
 
 	udp_tunnel_nic_free(utn);
 release_dev:
-- 
2.53.0



