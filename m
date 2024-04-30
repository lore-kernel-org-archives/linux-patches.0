Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68CB412D776;
	Tue, 30 Apr 2024 10:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714473827; cv=none; b=pIRD4Yl43I6A6lB5IILiF8eEkS580xguiVCcbqCwxLV4AYCs/9R4OAruT2E5etEyxlNwf7D55IFsuEKpmOSZbNPSCj8SY6Y2Fc5JEPl4rMjltI1xoa7J1qqaxo8lndRe5e+qHibgrBnyFuVfzbKp8NC72/72S1OQ35VN7dUeXNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714473827; c=relaxed/simple;
	bh=DPu+xG3+QvX7gVbiN6MnRTaJJcWWva2sxNubpexPhdw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=drrEo1YLG/h0CybJ6o3l5ERg3zJiI/B22H6XBaUu7X6ndgNoEIP7n9niVwtYRQLupsC9mV5q7sVbFCI98MH4gwjLZmBVPEH0fc8o3Us0zNjv5LrhckLxxaluHr0fLRY9ejsCb5VRc8pbUoxVUGhjRa4t1E8x4svPpcc2L6XhKjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gfPWSj1H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gfPWSj1H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 814D5C4AF1B;
	Tue, 30 Apr 2024 10:43:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714473826;
	bh=DPu+xG3+QvX7gVbiN6MnRTaJJcWWva2sxNubpexPhdw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gfPWSj1HV8ozb/9YW33IUvscVm5Ad5Pc1MxVDNgmUe/wDMQsiQFv58tyjiNevIkYh
	 8Br79LjbCvsAlOJn/HIHBzvjjDwtc+HtS1x7GRCIjLDrLnQUsggwFDJTodA+fKULZF
	 elrjrDnknHOLH6kSGINyZVUuEVzYLeNDtZ5itE9w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pravin B Shelar <pshelar@ovn.org>,
	Yi-Hung Wei <yihung.wei@gmail.com>,
	syzbot+7ef50afd3a211f879112@syzkaller.appspotmail.com,
	Tonghao Zhang <xiangxia.m.yue@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 50/77] net: openvswitch: ovs_ct_exit to be done under ovs_lock
Date: Tue, 30 Apr 2024 12:39:29 +0200
Message-ID: <20240430103042.613609956@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103041.111219002@linuxfoundation.org>
References: <20240430103041.111219002@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>

[ Upstream commit 27de77cec985233bdf6546437b9761853265c505 ]

syzbot wrote:
| =============================
| WARNING: suspicious RCU usage
| 5.7.0-rc1+ #45 Not tainted
| -----------------------------
| net/openvswitch/conntrack.c:1898 RCU-list traversed in non-reader section!!
|
| other info that might help us debug this:
| rcu_scheduler_active = 2, debug_locks = 1
| ...
|
| stack backtrace:
| Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.12.0-0-ga698c8995f-prebuilt.qemu.org 04/01/2014
| Workqueue: netns cleanup_net
| Call Trace:
| ...
| ovs_ct_exit
| ovs_exit_net
| ops_exit_list.isra.7
| cleanup_net
| process_one_work
| worker_thread

To avoid that warning, invoke the ovs_ct_exit under ovs_lock and add
lockdep_ovsl_is_held as optional lockdep expression.

Link: https://lore.kernel.org/lkml/000000000000e642a905a0cbee6e@google.com
Fixes: 11efd5cb04a1 ("openvswitch: Support conntrack zone limit")
Cc: Pravin B Shelar <pshelar@ovn.org>
Cc: Yi-Hung Wei <yihung.wei@gmail.com>
Reported-by: syzbot+7ef50afd3a211f879112@syzkaller.appspotmail.com
Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
Acked-by: Pravin B Shelar <pshelar@ovn.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 5ea7b72d4fac ("net: openvswitch: Fix Use-After-Free in ovs_ct_exit")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/openvswitch/conntrack.c | 3 ++-
 net/openvswitch/datapath.c  | 4 +++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
index 0777c8d416f1b..352e80e6cd75c 100644
--- a/net/openvswitch/conntrack.c
+++ b/net/openvswitch/conntrack.c
@@ -1837,7 +1837,8 @@ static void ovs_ct_limit_exit(struct net *net, struct ovs_net *ovs_net)
 		struct hlist_head *head = &info->limits[i];
 		struct ovs_ct_limit *ct_limit;
 
-		hlist_for_each_entry_rcu(ct_limit, head, hlist_node)
+		hlist_for_each_entry_rcu(ct_limit, head, hlist_node,
+					 lockdep_ovsl_is_held())
 			kfree_rcu(ct_limit, rcu);
 	}
 	kfree(ovs_net->ct_limit_info->limits);
diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
index 0551915519d9f..db27a43f5c5ab 100644
--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -2390,8 +2390,10 @@ static void __net_exit ovs_exit_net(struct net *dnet)
 	struct net *net;
 	LIST_HEAD(head);
 
-	ovs_ct_exit(dnet);
 	ovs_lock();
+
+	ovs_ct_exit(dnet);
+
 	list_for_each_entry_safe(dp, dp_next, &ovs_net->dps, list_node)
 		__dp_destroy(dp);
 
-- 
2.43.0



