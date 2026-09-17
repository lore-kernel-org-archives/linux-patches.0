Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7419E386573;
	Thu, 17 Sep 2026 17:51:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667510; cv=none; b=BK6HGjX12CTH+4TSoOl2QMU+EBuxNlCKtpUfxvJQoO8HUaozN58H4ENr+VFbEB9TuoCezQ2JHOzuL/mtKwmIXkpErm1aYWnLNNOKV6BjPN/i4ugJKqVq5+5w9go3JS+GAMEDn1o92RA+z2zCiGxJSHeRUPs/cAK0ElHbuO4T9JY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667510; c=relaxed/simple;
	bh=zT9nvFqkA29f7AN9unzAqW0laj4kVLKMjRhiUIvWzKU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g1MdAfwpHrDihRXV1M8fypyZ/oLlYu8V2Uj0dSRQmvOCv6hk+wkBg/saFp5csn/njCxgzdPaVGWfFSrK/sDo0WffuG7/PhcjZ7iU4rVenPRDmk5EyEfn2HMF3+PsvE9kZIKV4YXMVWtrFUO8pp3AQ3Sm/n2syGgiPT4mw635zn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y4828v5z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y4828v5z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDB151F000FF;
	Thu, 17 Sep 2026 17:51:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667509;
	bh=YvM+K3mIYDshP164AiBohiS6iNF1tBBLBL+rqWkJepc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y4828v5zF0kUgJH/708e+vABHme6wIWfZ9gh1Y4gKkpOvlj6Ukk2Vs5G6DZGoB2XZ
	 HgO2P9fFy3uH/TgcFOjTFQtffQNMon1UVzA57KfQvuzUv36+0OctKth9A+Cii1xipx
	 ADkLQHJ78tlBpMPk9mWYz3yika+q2bF7a06ys+OY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Sitnicki <jakub@cloudflare.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0116/1102] net: bridge: remove stale rcu_barrier() in br_multicast_dev_del()
Date: Thu, 17 Sep 2026 16:00:59 +0100
Message-ID: <20260917151542.419803475@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 25ae123db10ba9ab890b56bcdb0a4363aee8529a ]

This rcu_barrier() came from a time call_rcu() calls were used in
net/bridge/br_multicast.c.

Now kfree_rcu() is there, we can remove this problematic rcu_barrier()
which causes extreme RTNL pressure in many syzbot reports.

INFO: task syz-executor:77945 is blocked on a mutex likely owned by task kworker/u1024:5:36537.
task:kworker/u1024:5 state:D stack:24616 pid:36537 tgid:36537 ppid:2      task_flags:0x4208060 flags:0x00080000 last_sleep:612797637337
Workqueue: netns cleanup_net
Call Trace:
 <TASK>
  [<ffffffff81914eaa>] context_switch+0xf2a/0x1730 kernel/sched/core.c:6483
  [<ffffffff81201143>] __schedule+0x1133/0x43a0 kernel/sched/core.c:8411
  [<ffffffff8120446b>] __schedule_loop kernel/sched/core.c:8514 [inline]
  [<ffffffff8120446b>] schedule+0xab/0x260 kernel/sched/core.c:8529
  [<ffffffff8121a093>] schedule_timeout+0xc3/0x2b0 kernel/time/sleep_timeout.c:75
  [<ffffffff81205347>] do_wait_for_common kernel/sched/completion.c:100 [inline]
  [<ffffffff81205347>] __wait_for_common kernel/sched/completion.c:121 [inline]
  [<ffffffff81205347>] wait_for_common kernel/sched/completion.c:132 [inline]
  [<ffffffff81205347>] wait_for_completion+0x2c7/0x5d0 kernel/sched/completion.c:153
  [<ffffffff81b8f27f>] rcu_barrier+0x49f/0x620 kernel/rcu/tree.c:3888
  [<ffffffff860091b3>] br_multicast_dev_del+0x303/0x350 net/bridge/br_multicast.c:4459
  [<ffffffff85fb5dbc>] br_dev_uninit+0x1c/0x40 net/bridge/br_device.c:157
  [<ffffffff8568058c>] unregister_netdevice_many_notify+0x1c1c/0x2300 net/core/dev.c:12599
  [<ffffffff8562be43>] ops_exit_rtnl_list net/core/net_namespace.c:187 [inline]
  [<ffffffff8562be43>] ops_undo_list+0x3d3/0x940 net/core/net_namespace.c:248

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
Link: https://patch.msgid.link/20260519095540.2643318-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bridge/br_multicast.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index dff82eb195e82..988014b143643 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -4458,8 +4458,6 @@ void br_multicast_dev_del(struct net_bridge *br)
 	br_multicast_ctx_deinit(&br->multicast_ctx);
 	br_multicast_gc(&deleted_head);
 	cancel_work_sync(&br->mcast_gc_work);
-
-	rcu_barrier();
 }
 
 int br_multicast_set_router(struct net_bridge_mcast *brmctx, unsigned long val)
-- 
2.53.0



