Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16C2A34E75A;
	Wed, 30 Sep 2026 19:11:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795513; cv=none; b=E8JYEoE61qfupwdS6G4w68Ebg+W1n47+uyQVR/MSIHg36aZSD/3q8AuzSa/lteMAriUKFxuMphgJXgBJ4aKnDsjwU/kkLY0l29ykWf4SCs5m7pRmQuCCfT9oAEUjnNYwxwn4Ew4IAqlpTlbS2sQrX5z69RS9nOtQz6JRCUGLDQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795513; c=relaxed/simple;
	bh=ff3VSAFEaQB40ebyx+JlKaOxMFXYzMfOf/RTfDOLNc4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O7qUbgERSuXwqfSTbJ2/pb571Si0NK9QsDTGGDeVfOpB5r3x1iFZA0IhJm+Y12Rl2bGCtk88hqEcjMv6MJi7pP1yTyNlgkzWT0oYnwTTBKiExoQSW1wrakiO0Zg7cMHgG40rargSB6FTzjRjEZTvhUlRPVCm52ttUtvEXBJUHaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x4ZQ5PdC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x4ZQ5PdC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51E481F00898;
	Wed, 30 Sep 2026 19:11:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795511;
	bh=O+v+eXpOoAc/ZXcsHDO7/LATshDTw3+3JOVMv0JUV1M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x4ZQ5PdCrE/x9khs9D8+ONeT5duwzi40wIKAnQ9wtHCVSDuHwwO5lufCDhIyikp81
	 gCdlhCztD9vrN40jt14JNM4N/hF10XEZH0k5nl/9Is5NsybdMDYnYxp3TwJFWBEYt0
	 9W78ehtoNfB+cxWAOuEgcnGx4wBgro2Uu0QIbAdM=
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
Subject: [PATCH 6.6 0587/1193] net/sched: cls_api: Dont replay RTM_GETCHAIN in tc_ctl_chain().
Date: Wed, 30 Sep 2026 17:21:11 +0200
Message-ID: <20260930152447.287117316@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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
index ac6d27172c84b..539228eb06c60 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -3224,7 +3224,7 @@ static int tc_ctl_chain(struct sk_buff *skb, struct nlmsghdr *n,
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



