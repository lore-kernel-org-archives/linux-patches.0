Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1639E30E0DC;
	Tue, 31 Mar 2026 16:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774974421; cv=none; b=i/6tG1MCCLNDRmW88PdO3qYBqCxMKG/NvHr9QnKOfuPe8pCW+yaqF+lws8VYHA2egjz4IZY2CjJXJVrNeI7wEZ5Ixoa79d1mg6OXrOxiSwkcxN2stR20GXot5c8h0e5gl6wH46Do0PK5hBHTNgTzVQSPo9f9SpXVYkqYQl717/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774974421; c=relaxed/simple;
	bh=b76Nj/gc/dLLUyWQYZKHoWWalJCd5U2DdtMzvni6tTE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rbOcpe5vl5HfzeTSvV6ypsRiCKRzDjejbj+d3BchcPCqQ/8tKeebJJVG65k4y02/s5RCgEvY1wOv0dgQK7ddd6/EajAqBD1V+8U+tHcb/cppKFvHu0bAxZO9ylp7ZcuCdi8XUscBpE2Bka4jwm9r0st2y5+ubwRDZmzV5C31v3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DuzMkmtZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DuzMkmtZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FC10C19423;
	Tue, 31 Mar 2026 16:27:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774974420;
	bh=b76Nj/gc/dLLUyWQYZKHoWWalJCd5U2DdtMzvni6tTE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DuzMkmtZK3r8rDBzyNHI5HOewhAnBFP1flax+ms+lhVNuY6D+CfHSswkNG5jYztN8
	 KPUGlXSNkcatQwX1mBJzYzzcHC3fpO/0WyA1FjheqyWofoqlrfXjFuWWBq2G+GDts/
	 J0nE1bCOoBdTvioko3eNSGtV2bOaHAr/hgQUpRyQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Minxi Hou <mhou@redhat.com>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 046/175] net: openvswitch: Avoid releasing netdev before teardown completes
Date: Tue, 31 Mar 2026 18:20:30 +0200
Message-ID: <20260331161731.478058719@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161729.779738837@linuxfoundation.org>
References: <20260331161729.779738837@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Toke Høiland-Jørgensen <toke@redhat.com>

[ Upstream commit 7c770dadfda5cbbde6aa3c4363ed513f1d212bf8 ]

The patch cited in the Fixes tag below changed the teardown code for
OVS ports to no longer unconditionally take the RTNL. After this change,
the netdev_destroy() callback can proceed immediately to the call_rcu()
invocation if the IFF_OVS_DATAPATH flag is already cleared on the
netdev.

The ovs_netdev_detach_dev() function clears the flag before completing
the unregistration, and if it gets preempted after clearing the flag (as
can happen on an -rt kernel), netdev_destroy() can complete and the
device can be freed before the unregistration completes. This leads to a
splat like:

[  998.393867] Oops: general protection fault, probably for non-canonical address 0xff00000001000239: 0000 [#1] SMP PTI
[  998.393877] CPU: 42 UID: 0 PID: 55177 Comm: ip Kdump: loaded Not tainted 6.12.0-211.1.1.el10_2.x86_64+rt #1 PREEMPT_RT
[  998.393886] Hardware name: Dell Inc. PowerEdge R740/0JMK61, BIOS 2.24.0 03/27/2025
[  998.393889] RIP: 0010:dev_set_promiscuity+0x8d/0xa0
[  998.393901] Code: 00 00 75 d8 48 8b 53 08 48 83 ba b0 02 00 00 00 75 ca 48 83 c4 08 5b c3 cc cc cc cc 48 83 bf 48 09 00 00 00 75 91 48 8b 47 08 <48> 83 b8 b0 02 00 00 00 74 97 eb 81 0f 1f 80 00 00 00 00 90 90 90
[  998.393906] RSP: 0018:ffffce5864a5f6a0 EFLAGS: 00010246
[  998.393912] RAX: ff00000000ffff89 RBX: ffff894d0adf5a05 RCX: 0000000000000000
[  998.393917] RDX: 0000000000000000 RSI: 00000000ffffffff RDI: ffff894d0adf5a05
[  998.393921] RBP: ffff894d19252000 R08: ffff894d19252000 R09: 0000000000000000
[  998.393924] R10: ffff894d19252000 R11: ffff894d192521b8 R12: 0000000000000006
[  998.393927] R13: ffffce5864a5f738 R14: 00000000ffffffe2 R15: 0000000000000000
[  998.393931] FS:  00007fad61971800(0000) GS:ffff894cc0140000(0000) knlGS:0000000000000000
[  998.393936] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  998.393940] CR2: 000055df0a2a6e40 CR3: 000000011c7fe003 CR4: 00000000007726f0
[  998.393944] PKRU: 55555554
[  998.393946] Call Trace:
[  998.393949]  <TASK>
[  998.393952]  ? show_trace_log_lvl+0x1b0/0x2f0
[  998.393961]  ? show_trace_log_lvl+0x1b0/0x2f0
[  998.393975]  ? dp_device_event+0x41/0x80 [openvswitch]
[  998.394009]  ? __die_body.cold+0x8/0x12
[  998.394016]  ? die_addr+0x3c/0x60
[  998.394027]  ? exc_general_protection+0x16d/0x390
[  998.394042]  ? asm_exc_general_protection+0x26/0x30
[  998.394058]  ? dev_set_promiscuity+0x8d/0xa0
[  998.394066]  ? ovs_netdev_detach_dev+0x3a/0x80 [openvswitch]
[  998.394092]  dp_device_event+0x41/0x80 [openvswitch]
[  998.394102]  notifier_call_chain+0x5a/0xd0
[  998.394106]  unregister_netdevice_many_notify+0x51b/0xa60
[  998.394110]  rtnl_dellink+0x169/0x3e0
[  998.394121]  ? rt_mutex_slowlock.constprop.0+0x95/0xd0
[  998.394125]  rtnetlink_rcv_msg+0x142/0x3f0
[  998.394128]  ? avc_has_perm_noaudit+0x69/0xf0
[  998.394130]  ? __pfx_rtnetlink_rcv_msg+0x10/0x10
[  998.394132]  netlink_rcv_skb+0x50/0x100
[  998.394138]  netlink_unicast+0x292/0x3f0
[  998.394141]  netlink_sendmsg+0x21b/0x470
[  998.394145]  ____sys_sendmsg+0x39d/0x3d0
[  998.394149]  ___sys_sendmsg+0x9a/0xe0
[  998.394156]  __sys_sendmsg+0x7a/0xd0
[  998.394160]  do_syscall_64+0x7f/0x170
[  998.394162]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[  998.394165] RIP: 0033:0x7fad61bf4724
[  998.394188] Code: 89 02 b8 ff ff ff ff eb bb 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 f3 0f 1e fa 80 3d c5 e9 0c 00 00 74 13 b8 2e 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 54 c3 0f 1f 00 48 83 ec 28 89 54 24 1c 48 89
[  998.394189] RSP: 002b:00007ffd7e2f7cb8 EFLAGS: 00000202 ORIG_RAX: 000000000000002e
[  998.394191] RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 00007fad61bf4724
[  998.394193] RDX: 0000000000000000 RSI: 00007ffd7e2f7d20 RDI: 0000000000000003
[  998.394194] RBP: 00007ffd7e2f7d90 R08: 0000000000000010 R09: 000000000000003f
[  998.394195] R10: 000055df11558010 R11: 0000000000000202 R12: 00007ffd7e2f8380
[  998.394196] R13: 0000000069b233d7 R14: 000055df0a256040 R15: 0000000000000000
[  998.394200]  </TASK>

To fix this, reorder the operations in ovs_netdev_detach_dev() to only
clear the flag after completing the other operations, and introduce an
smp_wmb() to make the ordering requirement explicit. The smp_wmb() is
paired with a full smp_mb() in netdev_destroy() to make sure the
call_rcu() invocation does not happen before the unregister operations
are visible.

Reported-by: Minxi Hou <mhou@redhat.com>
Tested-by: Minxi Hou <mhou@redhat.com>
Fixes: 549822767630 ("net: openvswitch: Avoid needlessly taking the RTNL on vport destroy")
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
Link: https://patch.msgid.link/20260318155554.1133405-1-toke@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/openvswitch/vport-netdev.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/net/openvswitch/vport-netdev.c b/net/openvswitch/vport-netdev.c
index 3c41d53bb9e99..18376e10aeedc 100644
--- a/net/openvswitch/vport-netdev.c
+++ b/net/openvswitch/vport-netdev.c
@@ -144,11 +144,15 @@ static void vport_netdev_free(struct rcu_head *rcu)
 void ovs_netdev_detach_dev(struct vport *vport)
 {
 	ASSERT_RTNL();
-	vport->dev->priv_flags &= ~IFF_OVS_DATAPATH;
 	netdev_rx_handler_unregister(vport->dev);
 	netdev_upper_dev_unlink(vport->dev,
 				netdev_master_upper_dev_get(vport->dev));
 	dev_set_promiscuity(vport->dev, -1);
+
+	/* paired with smp_mb() in netdev_destroy() */
+	smp_wmb();
+
+	vport->dev->priv_flags &= ~IFF_OVS_DATAPATH;
 }
 
 static void netdev_destroy(struct vport *vport)
@@ -167,6 +171,9 @@ static void netdev_destroy(struct vport *vport)
 		rtnl_unlock();
 	}
 
+	/* paired with smp_wmb() in ovs_netdev_detach_dev() */
+	smp_mb();
+
 	call_rcu(&vport->rcu, vport_netdev_free);
 }
 
-- 
2.51.0



