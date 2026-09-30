Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A636444A708;
	Wed, 30 Sep 2026 18:06:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791583; cv=none; b=nj3ySWwdcOEvzSG6w4I5cHnQbub8r8E57Er25Hil37jVR7Wu7saP7I38xqaWF8I3SWl5nGLifmd5Q0c8YmkbUHwUSaZAviBtS1Yz1oS0UZf+wDxzs3qWbCGA8S2PoYwXneu9nf8rhFBLGhIJghwOrtuwoWAbGHUCjCAeEnmDUWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791583; c=relaxed/simple;
	bh=csyLB33oxAF5CEzs7P29tNep3mR5YBaqpXXNN5J1oYs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=szwAKmBz8v7TwFtZDJqi1dua0xAPUka+WKHLupCXXnkjBw6SgQqefeqaM7gt8G98h3i8Aycz13VOmF7WlDnQS3MwDFQgCfafI3lhQ+rAYKDu5KfbpkyIvSsm/slhKERJFvh8f1Ewxvb/655x4/jJ/YxPGiYGcBewonqDjh0CBn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t2zyxcPH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t2zyxcPH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6D181F000FF;
	Wed, 30 Sep 2026 18:06:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791582;
	bh=g12yNC+DzVOQhJ+7X1Az3xBDPCxxJ5BDrpch1zm7Fg8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t2zyxcPH2Jc2roAdhi6xJSSgZIyyJFA2MRqhSNtgl50hSBmiwHRgfHcuHmc3fCwEm
	 d3ugl3XGojrTAGG1E0fz5KjIMCKmrLO3YieGvLOcwItS04ZyoJDMZCb4SrbGzji8k4
	 Uh4KLoTh6YFZ51hHYjDaVUj0ioV7rXCwtMflEFZ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Taras Madan <tarasmadan@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	hybris@mojatatu.ai,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 352/752] net/sched: cls_api: Dont replay RTM_GETCHAIN in tc_ctl_chain().
Date: Wed, 30 Sep 2026 17:23:42 +0200
Message-ID: <20260930152405.903026647@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@google.com>

[ Upstream commit dff39930ad5e53d202bfdfb14687d1d2fd753b4d ]

If a netlink socket sends RTM_GETCHAIN requests repeatedly
without recv()ing the responses, tc_ctl_chain() hogs CPU and
triggers Hung Task splat. [0]

As caught in the stack trace, netlink_attachskb() could confuse
tc_ctl_chain() by returning -EAGAIN when the userspace netlink
socket's receive buffer is full.

The replay: label exists since commit 32a4f5ecd738 ("net: sched:
introduce chain object to uapi") but was not used initially.

Since commit 9f407f1768d3 ("net: sched: introduce chain templates"),
the label is needed for RTM_NEWCHAIN because tcf_proto_lookup_ops()
may release RTNL to call request_module().

However, the replay logic is unnecessary for RTM_GETCHAIN.

Let's apply the replay logic only for RTM_NEWCHAIN.

[0]:
INFO: task repro:1018 is blocked on a mutex likely owned by task repro:1022.
task:repro           state:R  running task     stack:14096 pid:1022  tgid:1014  ppid:961    task_flags:0x400040 flags:0x00080000
Call Trace:
 <TASK>
 ? clockevents_program_event (kernel/time/clockevents.c:372)
 ? pskb_expand_head (net/core/skbuff.c:615)
 ? skb_release_data (net/core/skbuff.c:1122)
 ? netlink_attachskb (./include/linux/skbuff.h:1323 ./include/linux/skbuff.h:1332 net/netlink/af_netlink.c:1232)
 ? __netlink_lookup (./include/linux/rcupdate.h:882 ./include/linux/rhashtable.h:711 net/netlink/af_netlink.c:499)
 ? tc_chain_notify (net/sched/cls_api.c:3045)
 ? tc_chain_notify (./include/linux/skbuff.h:1384 net/sched/cls_api.c:3041)
 ? netlink_unicast (net/netlink/af_netlink.c:1335)
 ? rtnl_unicast (./include/net/netlink.h:1198 net/core/rtnetlink.c:985)
 ? tc_ctl_chain (net/sched/cls_api.c:3242)
 ? rtnetlink_rcv_msg (net/core/rtnetlink.c:7146)
 ? netlink_unicast (net/netlink/af_netlink.c:1354)
 ? __pfx_rtnetlink_rcv_msg (net/core/rtnetlink.c:7177)
 ? netlink_rcv_skb (net/netlink/af_netlink.c:2556)
 ? netlink_unicast (net/netlink/af_netlink.c:1319)
 ? netlink_sendmsg (net/netlink/af_netlink.c:1900)
 ? __sock_sendmsg (net/socket.c:800)
 ? __sys_sendto (net/socket.c:2281)
 ? __x64_sys_sendto (net/socket.c:2288 net/socket.c:2284 net/socket.c:2284)
 ? do_syscall_64 (arch/x86/entry/syscall_64.c:61 arch/x86/entry/syscall_64.c:84)
 ? entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:121)
 </TASK>

Fixes: 2ed9db3074fc ("net: sched: cls_api: fix dead code in switch")
Reported-by: Taras Madan <tarasmadan@google.com>
Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
Tested-by: hybris@mojatatu.ai
Link: https://patch.msgid.link/20260908205537.863484-1-kuniyu@google.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/cls_api.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 32ccf62940f48..ace3e9e4626c5 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -2936,7 +2936,7 @@ static int tc_ctl_chain(struct sk_buff *skb, struct nlmsghdr *n,
 	tcf_chain_put(chain);
 errout_block:
 	tcf_block_release(q, block, true);
-	if (err == -EAGAIN)
+	if (err == -EAGAIN && n->nlmsg_type == RTM_NEWCHAIN)
 		/* Replay the request. */
 		goto replay;
 	return err;
-- 
2.53.0



