Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CF4C3C4B8D;
	Sat, 17 Oct 2026 17:49:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259362; cv=none; b=nIDyU2raHdbqXMFm0pBTyd7rGvaAd1ODmuGEwgx5SLIuhGxO8xqXWsLaZieUqofNkKKs0XMZDJshn/yZoVwfbNjBxy7Qxf89Psmxp80HoV4tjNFsMQV/OQXp83zxelTI/aTGTOsaoABr1vOyB07tHcEHv0Nf3TV07sGzWlDFs1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259362; c=relaxed/simple;
	bh=5ZkMKGbmBSAnewZReZaSsB/1KtduxrSNvg4sMS8GLI4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G4Uk1kNXfaFzuTolvVyO9SNYuBx8HB7zeovxp973cOTSlWS22TdibW9WmM7wTHPogHfJvosZZfnnCQU8O2xtYbN2Nhu4chYJE9qWWrHV35F1wX8oyVV2yVTujqSLWV5bFsKyU6pISS3sL/DOiCZVikxMZRi474NXy69HGA/9Xws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aBd30I+e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aBd30I+e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DF621F000C6;
	Sat, 17 Oct 2026 17:49:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259360;
	bh=XoV7xCvrYpeeToa7kk3gtYFbDpKP30Jm593aTQktuPs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aBd30I+eK7SlYNUXRivkBydjN6NXAp+nQCoWtPn/RQ1EH7h7R/agarfEhRqbUeIsP
	 Pi/5JqF6NiSJcAaeMDvObM0fHnVWvCFniiz1Exp8NMcBHuQhUa9lhvYvo8/kTeflCb
	 OkyjJmOnskVBUO0jPggPcy4c9EmZTsbA2hnNeUlo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+eca845fb8c18dd6b44c1@syzkaller.appspotmail.com,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1186/1674] net: udp_tunnel: fix memory leak in udp_tunnel_nic_unregister()
Date: Sat, 17 Oct 2026 17:57:38 +0200
Message-ID: <20261017160501.585349822@linuxfoundation.org>
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
 net/ipv4/udp_tunnel_nic.c | 31 +++++++++++++++++--------------
 1 file changed, 17 insertions(+), 14 deletions(-)

diff --git a/net/ipv4/udp_tunnel_nic.c b/net/ipv4/udp_tunnel_nic.c
index 65a4731d6d842..27543fe015b1a 100644
--- a/net/ipv4/udp_tunnel_nic.c
+++ b/net/ipv4/udp_tunnel_nic.c
@@ -31,19 +31,17 @@ struct udp_tunnel_nic_table_entry {
  * @dev:	netdev pointer
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
 
 	u8 need_sync:1;
 	u8 need_replay:1;
-	u8 work_pending:1;
 
 	unsigned int n_tables;
 	unsigned long missed;
@@ -301,7 +299,7 @@ udp_tunnel_nic_device_sync(struct net_device *dev, struct udp_tunnel_nic *utn)
 	const struct udp_tunnel_nic_info *info = dev->udp_tunnel_nic_info;
 	bool may_sleep;
 
-	if (!utn->need_sync || utn->work_pending)
+	if (!utn->need_sync)
 		return;
 
 	/* Drivers which sleep in the callback need to update from
@@ -311,8 +309,7 @@ udp_tunnel_nic_device_sync(struct net_device *dev, struct udp_tunnel_nic *utn)
 	if (!may_sleep)
 		__udp_tunnel_nic_device_sync(dev, utn);
 	if (may_sleep || utn->need_replay) {
-		queue_work(udp_tunnel_nic_workqueue, &utn->work);
-		utn->work_pending = 1;
+		queue_delayed_work(udp_tunnel_nic_workqueue, &utn->work, 0);
 	}
 }
 
@@ -707,10 +704,16 @@ udp_tunnel_nic_replay(struct net_device *dev, struct udp_tunnel_nic *utn)
 static void udp_tunnel_nic_device_sync_work(struct work_struct *work)
 {
 	struct udp_tunnel_nic *utn =
-		container_of(work, struct udp_tunnel_nic, work);
+		container_of(work, struct udp_tunnel_nic, work.work);
 
-	rtnl_lock();
-	utn->work_pending = 0;
+	/* We cannot block on RTNL here, otherwise we would deadlock with
+	 * udp_tunnel_nic_unregister() calling cancel_delayed_work_sync()
+	 * while holding RTNL. Requeue with 1 jiffy delay if RTNL is contended.
+	 */
+	if (!rtnl_trylock()) {
+		queue_delayed_work(udp_tunnel_nic_workqueue, &utn->work, 1);
+		return;
+	}
 	__udp_tunnel_nic_device_sync(utn->dev, utn);
 
 	if (utn->need_replay)
@@ -729,7 +732,7 @@ udp_tunnel_nic_alloc(const struct udp_tunnel_nic_info *info,
 	if (!utn)
 		return NULL;
 	utn->n_tables = n_tables;
-	INIT_WORK(&utn->work, udp_tunnel_nic_device_sync_work);
+	INIT_DELAYED_WORK(&utn->work, udp_tunnel_nic_device_sync_work);
 
 	utn->entries = kmalloc_array(n_tables, sizeof(void *), GFP_KERNEL);
 	if (!utn->entries)
@@ -870,11 +873,11 @@ udp_tunnel_nic_unregister(struct net_device *dev, struct udp_tunnel_nic *utn)
 	 */
 	udp_tunnel_nic_flush(dev, utn);
 
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



