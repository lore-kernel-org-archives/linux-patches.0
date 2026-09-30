Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A2C94FECE0;
	Wed, 30 Sep 2026 16:03:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784186; cv=none; b=pZXbqz08a+PzzQYVC8/IacA3Pjngb4jy4weEuspA4iU+wlCarddYns+USHakClcTB52elcG3AlfM3m1OZtFsVfrD/+4iEP2F69Y65mVYau25jfsX0l/hTp6xc+g3VdURM7vW9tyH32xltWk7/x2Rkrw2VPBJTL4adlvGU/BXx+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784186; c=relaxed/simple;
	bh=omubTYGi2rodMW8vGOjndCRpfSaJV3RNAsR+MhTnH90=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CsFiDlXeXowFao4qpN3/TwYVka+G5ebYGHy4bAZfAaTH8TQMn00KA8Uv+QBuBPTZQI4LPnj5YshS7SEak40rZluHVmJ1tsQF/4VcQkKFmzaDhBDnXa3SmMWhxUtALUtsnbqLW8DAoF8sMNKMAY9jEa42MwNa64s29BwJK0cYO3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OuCQ0hJ1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OuCQ0hJ1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 437C11F000FF;
	Wed, 30 Sep 2026 16:03:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784181;
	bh=PKCJScLbBMIqsHWEHo/3Z2u0ybAZNnEZjOAxSs6b9Sc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OuCQ0hJ1p1jdSiuKfsnWH2d6bJzjpIPeySoD/sbDjAIOX+4ZodPCDbZO6UtwINsds
	 l+jQWozK2W5r6nMhtgGq+4vL3J4AutqEYlOLn40B2ZSg658+L4fPW/454JGo0Cq/tQ
	 LmP73gEfKavyeFVbG9FomBptAi/AfAFcNxGrdzzU=
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
Subject: [PATCH 6.1 063/982] net: bridge: remove stale rcu_barrier() in br_multicast_dev_del()
Date: Wed, 30 Sep 2026 17:13:19 +0200
Message-ID: <20260930152418.150711929@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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
index f5f6da322227e..4245d8d7767d8 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -4284,8 +4284,6 @@ void br_multicast_dev_del(struct net_bridge *br)
 	br_multicast_ctx_deinit(&br->multicast_ctx);
 	br_multicast_gc(&deleted_head);
 	cancel_work_sync(&br->mcast_gc_work);
-
-	rcu_barrier();
 }
 
 int br_multicast_set_router(struct net_bridge_mcast *brmctx, unsigned long val)
-- 
2.53.0



