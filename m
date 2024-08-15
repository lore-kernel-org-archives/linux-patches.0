Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74E111B9B4E;
	Thu, 15 Aug 2024 14:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730975; cv=none; b=JnDxSsagzPJxqx+w17Oyd2JHV+LmZwnqO4ixNXZeK8+8cJOz8e9d49W/tKhFCerSi59FgcUGTHBxVobgWmX4Dg2K+gfsL7xA8WUkvisfg5YobohzheDadyFO0BS32tW8Zs9Xl6FTOaZwefvKpQ1NxxuRDFT57kEMvMxOpAp/10M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730975; c=relaxed/simple;
	bh=c92FfXh7XgBbLkpclnsiAbrFuvGAAnP2DWRU6xYRBIo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R9zeXI1Q4SmxZe+nbDz1snLH1xmeLXy7soiRCt49rURWdPeoDud0DL6Gu+Vf4id3AK8WEHFDyhe1aKkmtf+AQBJMI+haFHQBV2OQuDTFF85CDWG5OhgVvPXVwPDWpaOEbebNpzkZ7WqDKPh/dmCoA8FdJx1vL4G4kBwy6oguQtY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rbr0u3P1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rbr0u3P1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1CBAC4AF0C;
	Thu, 15 Aug 2024 14:09:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730975;
	bh=c92FfXh7XgBbLkpclnsiAbrFuvGAAnP2DWRU6xYRBIo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rbr0u3P1wJEg1v54RAUjPRNcfyS88+S4Vn3OxSJtE1Xi7S2SonKiRygG2NXa9hql/
	 jopvPfWB8/KuvGI626+LqF3KBvoJLpVP8KiZLUldOhNYSZdhOIZC7X0jQ5zKfnRdL1
	 zOR0jRz8P4SmyP7dRBx/9ieRBRB7LSWeVr1BycF8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 50/67] wifi: cfg80211: restrict NL80211_ATTR_TXQ_QUANTUM values
Date: Thu, 15 Aug 2024 15:26:04 +0200
Message-ID: <20240815131840.234152488@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131838.311442229@linuxfoundation.org>
References: <20240815131838.311442229@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit d1cba2ea8121e7fdbe1328cea782876b1dd80993 ]

syzbot is able to trigger softlockups, setting NL80211_ATTR_TXQ_QUANTUM
to 2^31.

We had a similar issue in sch_fq, fixed with commit
d9e15a273306 ("pkt_sched: fq: do not accept silly TCA_FQ_QUANTUM")

watchdog: BUG: soft lockup - CPU#1 stuck for 26s! [kworker/1:0:24]
Modules linked in:
irq event stamp: 131135
 hardirqs last  enabled at (131134): [<ffff80008ae8778c>] __exit_to_kernel_mode arch/arm64/kernel/entry-common.c:85 [inline]
 hardirqs last  enabled at (131134): [<ffff80008ae8778c>] exit_to_kernel_mode+0xdc/0x10c arch/arm64/kernel/entry-common.c:95
 hardirqs last disabled at (131135): [<ffff80008ae85378>] __el1_irq arch/arm64/kernel/entry-common.c:533 [inline]
 hardirqs last disabled at (131135): [<ffff80008ae85378>] el1_interrupt+0x24/0x68 arch/arm64/kernel/entry-common.c:551
 softirqs last  enabled at (125892): [<ffff80008907e82c>] neigh_hh_init net/core/neighbour.c:1538 [inline]
 softirqs last  enabled at (125892): [<ffff80008907e82c>] neigh_resolve_output+0x268/0x658 net/core/neighbour.c:1553
 softirqs last disabled at (125896): [<ffff80008904166c>] local_bh_disable+0x10/0x34 include/linux/bottom_half.h:19
CPU: 1 PID: 24 Comm: kworker/1:0 Not tainted 6.9.0-rc7-syzkaller-gfda5695d692c #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 03/27/2024
Workqueue: mld mld_ifc_work
pstate: 80400005 (Nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
 pc : __list_del include/linux/list.h:195 [inline]
 pc : __list_del_entry include/linux/list.h:218 [inline]
 pc : list_move_tail include/linux/list.h:310 [inline]
 pc : fq_tin_dequeue include/net/fq_impl.h:112 [inline]
 pc : ieee80211_tx_dequeue+0x6b8/0x3b4c net/mac80211/tx.c:3854
 lr : __list_del_entry include/linux/list.h:218 [inline]
 lr : list_move_tail include/linux/list.h:310 [inline]
 lr : fq_tin_dequeue include/net/fq_impl.h:112 [inline]
 lr : ieee80211_tx_dequeue+0x67c/0x3b4c net/mac80211/tx.c:3854
sp : ffff800093d36700
x29: ffff800093d36a60 x28: ffff800093d36960 x27: dfff800000000000
x26: ffff0000d800ad50 x25: ffff0000d800abe0 x24: ffff0000d800abf0
x23: ffff0000e0032468 x22: ffff0000e00324d4 x21: ffff0000d800abf0
x20: ffff0000d800abf8 x19: ffff0000d800abf0 x18: ffff800093d363c0
x17: 000000000000d476 x16: ffff8000805519dc x15: ffff7000127a6cc8
x14: 1ffff000127a6cc8 x13: 0000000000000004 x12: ffffffffffffffff
x11: ffff7000127a6cc8 x10: 0000000000ff0100 x9 : 0000000000000000
x8 : 0000000000000000 x7 : 0000000000000000 x6 : 0000000000000000
x5 : ffff80009287aa08 x4 : 0000000000000008 x3 : ffff80008034c7fc
x2 : ffff0000e0032468 x1 : 00000000da0e46b8 x0 : ffff0000e0032470
Call trace:
  __list_del include/linux/list.h:195 [inline]
  __list_del_entry include/linux/list.h:218 [inline]
  list_move_tail include/linux/list.h:310 [inline]
  fq_tin_dequeue include/net/fq_impl.h:112 [inline]
  ieee80211_tx_dequeue+0x6b8/0x3b4c net/mac80211/tx.c:3854
  wake_tx_push_queue net/mac80211/util.c:294 [inline]
  ieee80211_handle_wake_tx_queue+0x118/0x274 net/mac80211/util.c:315
  drv_wake_tx_queue net/mac80211/driver-ops.h:1350 [inline]
  schedule_and_wake_txq net/mac80211/driver-ops.h:1357 [inline]
  ieee80211_queue_skb+0x18e8/0x2244 net/mac80211/tx.c:1664
  ieee80211_tx+0x260/0x400 net/mac80211/tx.c:1966
  ieee80211_xmit+0x278/0x354 net/mac80211/tx.c:2062
  __ieee80211_subif_start_xmit+0xab8/0x122c net/mac80211/tx.c:4338
  ieee80211_subif_start_xmit+0xe0/0x438 net/mac80211/tx.c:4532
  __netdev_start_xmit include/linux/netdevice.h:4903 [inline]
  netdev_start_xmit include/linux/netdevice.h:4917 [inline]
  xmit_one net/core/dev.c:3531 [inline]
  dev_hard_start_xmit+0x27c/0x938 net/core/dev.c:3547
  __dev_queue_xmit+0x1678/0x33fc net/core/dev.c:4341
  dev_queue_xmit include/linux/netdevice.h:3091 [inline]
  neigh_resolve_output+0x558/0x658 net/core/neighbour.c:1563
  neigh_output include/net/neighbour.h:542 [inline]
  ip6_finish_output2+0x104c/0x1ee8 net/ipv6/ip6_output.c:137
  ip6_finish_output+0x428/0x7a0 net/ipv6/ip6_output.c:222
  NF_HOOK_COND include/linux/netfilter.h:303 [inline]
  ip6_output+0x270/0x594 net/ipv6/ip6_output.c:243
  dst_output include/net/dst.h:450 [inline]
  NF_HOOK+0x160/0x4f0 include/linux/netfilter.h:314
  mld_sendpack+0x7b4/0x10f4 net/ipv6/mcast.c:1818
  mld_send_cr net/ipv6/mcast.c:2119 [inline]
  mld_ifc_work+0x840/0xd0c net/ipv6/mcast.c:2650
  process_one_work+0x7b8/0x15d4 kernel/workqueue.c:3267
  process_scheduled_works kernel/workqueue.c:3348 [inline]
  worker_thread+0x938/0xef4 kernel/workqueue.c:3429
  kthread+0x288/0x310 kernel/kthread.c:388
  ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:860

Fixes: 52539ca89f36 ("cfg80211: Expose TXQ stats and parameters to userspace")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20240615160800.250667-1-edumazet@google.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/wireless/nl80211.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -468,6 +468,10 @@ static struct netlink_range_validation n
 	.max = 0xffff,
 };
 
+static struct netlink_range_validation q_range = {
+	.max = INT_MAX,
+};
+
 static const struct nla_policy nl80211_policy[NUM_NL80211_ATTR] = {
 	[0] = { .strict_start_type = NL80211_ATTR_HE_OBSS_PD },
 	[NL80211_ATTR_WIPHY] = { .type = NLA_U32 },
@@ -750,7 +754,7 @@ static const struct nla_policy nl80211_p
 
 	[NL80211_ATTR_TXQ_LIMIT] = { .type = NLA_U32 },
 	[NL80211_ATTR_TXQ_MEMORY_LIMIT] = { .type = NLA_U32 },
-	[NL80211_ATTR_TXQ_QUANTUM] = { .type = NLA_U32 },
+	[NL80211_ATTR_TXQ_QUANTUM] = NLA_POLICY_FULL_RANGE(NLA_U32, &q_range),
 	[NL80211_ATTR_HE_CAPABILITY] =
 		NLA_POLICY_VALIDATE_FN(NLA_BINARY, validate_he_capa,
 				       NL80211_HE_MAX_CAPABILITY_LEN),


