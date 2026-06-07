Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C250A212564;
	Sun,  7 Jun 2026 10:15:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780827318; cv=none; b=BJIWB0uutBvgcXsWUH3MBO5s6MQLcJNDhkXYPHp3Z7hQb/nPFRLbw60SsYCdMYvXIsU7FywM7Fypl9jpeDvhOAPW6dBvGl29Srvrs0FLj+p/0IJlxJMULUbAhDZXKj8kQkyDEg+3jyD7ZB4IJKoptV31yWBQ+oLBazNJ+eMKXXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780827318; c=relaxed/simple;
	bh=6UQfS3GMESgy6YC9ovpkwNXOamNji0H7X1h2lAiwAC4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D4KC9hFmiEh8Z2v5aryAkvicpXnAOYsALcmkEIwvJ+eU/U3AXKB5NDwyVt/sevpYyuoFpy7tSrozI2yv1oCrNxdY96jQa/YI3GKPMHy4qQCWd3r3ITaM1OGBeiYVE17amaguakRe/Hj5+LEEb5pYIG3hx2yZIv0u5/B3QiuwNTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sQQEWw9a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sQQEWw9a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 050551F00893;
	Sun,  7 Jun 2026 10:15:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780827316;
	bh=nMnBxdnRROr59+einaZmazmNNRFJ86GX5AWa04Y542A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sQQEWw9awWlhuO0gw9iL3eYeqbmfmOxEXhniUSq9IdIzSGblaLq7hOgLP8OM6V0s8
	 H020OeR0axF9wl9dLXkAVj4eIwA//9wWaIJNHQrMDPKCscX78ftVlWsZ6t2x8+zzag
	 jxnfAZV0vTG94qGfCAYP10P4ii5lbyHlExDPbyC8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolay Aleksandrov <nikolay@nvidia.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 063/315] bridge: Fix sleep in atomic context in sysfs path
Date: Sun,  7 Jun 2026 11:57:30 +0200
Message-ID: <20260607095729.921695464@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.528828913@linuxfoundation.org>
References: <20260607095727.528828913@linuxfoundation.org>
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

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit 6d34594cc619d0d4b07d5afcad8b5984f3526dcf ]

Since the start of the git history, brport_store() always acquired the
bridge lock. Back then this decision made sense: The bridge lock
protects the STP state of the bridge and its ports and at that time the
function was only used by two STP related attributes (cost and
priority).

Nowadays, brport_store() processes a lot more attributes and most of
them do not need the bridge lock:

* Bridge flags: Only require RTNL. Read locklessly by the data path.
  Annotations can be added in net-next.

* FDB port flushing: Only requires the FDB lock.

* Multicast attributes: Only require the multicast lock.

* Group forward mask: Only requires RTNL. Read locklessly by the data
  path. Annotations can be added in net-next.

* Backup port: Only requires RTNL. Read locklessly by the data path.

This is a problem as the bridge calls dev_set_promiscuity() when certain
bridge port flags change and this function can sleep since the commit
cited below, resulting in a splat such as [1].

Fix this by reducing the scope of the bridge lock and only take it when
processing the two STP related attributes that require it. Remove the
now stale comment from br_switchdev_set_port_flag(). The
SWITCHDEV_F_DEFER flag can be removed in net-next.

[1]
BUG: sleeping function called from invalid context at net/core/dev_addr_lists.c:1262
in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 372, name: bash
preempt_count: 201, expected: 0
RCU nest depth: 0, expected: 0
5 locks held by bash/372:
#0: ffff88810c51c3f0 (sb_writers#7){.+.+}-{0:0}, at: ksys_write (fs/read_write.c:740)
#1: ffff888115ce9480 (&of->mutex){+.+.}-{4:4}, at: kernfs_fop_write_iter (fs/kernfs/file.c:343)
#2: ffff88810b9fd330 (kn->active#37){.+.+}-{0:0}, at: kernfs_fop_write_iter (fs/kernfs/file.c:80 fs/kernfs/file.c:344)
#3: ffffffffa59473a0 (rtnl_mutex){+.+.}-{4:4}, at: brport_store (net/bridge/br_sysfs_if.c:326)
#4: ffff8881099d2d58 (&br->lock){+...}-{3:3}, at: brport_store (./include/linux/spinlock.h:348 net/bridge/br_sysfs_if.c:345)
Preemption disabled at:
 0x0
Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
Call Trace:
<TASK>
dump_stack_lvl (lib/dump_stack.c:94 lib/dump_stack.c:120)
__might_resched.cold (kernel/sched/core.c:9163)
netif_rx_mode_run (net/core/dev_addr_lists.c:1262)
netif_rx_mode_sync (net/core/dev_addr_lists.c:1428)
dev_set_promiscuity (net/core/dev_api.c:289)
br_manage_promisc (net/bridge/br_if.c:135 net/bridge/br_if.c:172)
br_port_flags_change (net/bridge/br_if.c:242 net/bridge/br_if.c:747)
store_learning (net/bridge/br_sysfs_if.c:79 net/bridge/br_sysfs_if.c:235)
brport_store (net/bridge/br_sysfs_if.c:346)
kernfs_fop_write_iter (fs/kernfs/file.c:352)
new_sync_write (fs/read_write.c:595)
vfs_write (fs/read_write.c:688)
ksys_write (fs/read_write.c:740)
do_syscall_64 (arch/x86/entry/syscall_64.c:63 arch/x86/entry/syscall_64.c:94)
entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:121)

Fixes: 78cd408356fe ("net: add missing instance lock to dev_set_promiscuity")
Reviewed-by: Nikolay Aleksandrov <nikolay@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20260526064818.272516-3-idosch@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bridge/br_switchdev.c |  1 -
 net/bridge/br_sysfs_if.c  | 30 ++++++++++++++++++++++--------
 2 files changed, 22 insertions(+), 9 deletions(-)

diff --git a/net/bridge/br_switchdev.c b/net/bridge/br_switchdev.c
index fe3f7bbe86ee62..b5c6e314204f94 100644
--- a/net/bridge/br_switchdev.c
+++ b/net/bridge/br_switchdev.c
@@ -99,7 +99,6 @@ int br_switchdev_set_port_flag(struct net_bridge_port *p,
 	attr.u.brport_flags.val = flags;
 	attr.u.brport_flags.mask = mask;
 
-	/* We run from atomic context here */
 	err = call_switchdev_notifiers(SWITCHDEV_PORT_ATTR_SET, p->dev,
 				       &info.info, extack);
 	err = notifier_to_errno(err);
diff --git a/net/bridge/br_sysfs_if.c b/net/bridge/br_sysfs_if.c
index 74fdd8105dca9e..3fe664fd1f5b82 100644
--- a/net/bridge/br_sysfs_if.c
+++ b/net/bridge/br_sysfs_if.c
@@ -86,16 +86,34 @@ static ssize_t show_path_cost(struct net_bridge_port *p, char *buf)
 	return sprintf(buf, "%d\n", p->path_cost);
 }
 
-static BRPORT_ATTR(path_cost, 0644,
-		   show_path_cost, br_stp_set_path_cost);
+static int store_path_cost(struct net_bridge_port *p, unsigned long v)
+{
+	int ret;
+
+	spin_lock_bh(&p->br->lock);
+	ret = br_stp_set_path_cost(p, v);
+	spin_unlock_bh(&p->br->lock);
+	return ret;
+}
+
+static BRPORT_ATTR(path_cost, 0644, show_path_cost, store_path_cost);
 
 static ssize_t show_priority(struct net_bridge_port *p, char *buf)
 {
 	return sprintf(buf, "%d\n", p->priority);
 }
 
-static BRPORT_ATTR(priority, 0644,
-			 show_priority, br_stp_set_port_priority);
+static int store_priority(struct net_bridge_port *p, unsigned long v)
+{
+	int ret;
+
+	spin_lock_bh(&p->br->lock);
+	ret = br_stp_set_port_priority(p, v);
+	spin_unlock_bh(&p->br->lock);
+	return ret;
+}
+
+static BRPORT_ATTR(priority, 0644, show_priority, store_priority);
 
 static ssize_t show_designated_root(struct net_bridge_port *p, char *buf)
 {
@@ -334,17 +352,13 @@ static ssize_t brport_store(struct kobject *kobj,
 			ret = -ENOMEM;
 			goto out_unlock;
 		}
-		spin_lock_bh(&p->br->lock);
 		ret = brport_attr->store_raw(p, buf_copy);
-		spin_unlock_bh(&p->br->lock);
 		kfree(buf_copy);
 	} else if (brport_attr->store) {
 		val = simple_strtoul(buf, &endp, 0);
 		if (endp == buf)
 			goto out_unlock;
-		spin_lock_bh(&p->br->lock);
 		ret = brport_attr->store(p, val);
-		spin_unlock_bh(&p->br->lock);
 	}
 
 	if (!ret) {
-- 
2.53.0



