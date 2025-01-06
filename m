Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68126158A1F;
	Mon,  6 Jan 2025 15:20:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736176851; cv=none; b=GMmC0Ycu5Y5prKSpufYT0lQVwivsN95U6AFJWmyarX43FLh4IpF/zb6Qm2tBWf2EhlQJ3is8Hezkh0sXsUBb7a4hdm6dYrH2wWl5lR0a4H1DT7OLUtpg/BwIM4qGyCmUd+YoU/M+/GQ2e02iq8IIqu6ctp2sGGDY0NNjEIsc/3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736176851; c=relaxed/simple;
	bh=TYPX4u3n+AAljMZdODi/oEviage7fRRX2R8UwLB/aJU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=opjjxokhAkLqf7DqfFYWNGywZ7gdxovKjFSPpGRLabsBalKZ2tcakWcaxJ0cRHMhJE72a7iz+IJAoE3upjkf2K8nMt/pmUYCpsQnU9lCJjaFPPFxTSVH4PdbXeUh/ssRArCnbKiUl0Xc+Jl2ANWwIorunf7CrFi+my5UpmpR1dw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GbosXyre; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GbosXyre"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 989D3C4CEE1;
	Mon,  6 Jan 2025 15:20:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736176851;
	bh=TYPX4u3n+AAljMZdODi/oEviage7fRRX2R8UwLB/aJU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GbosXyreqe2t+AQReDOyPUG79yOYdCYZ/e6cADCEgVk1GpRGJ/ESCAqkDb5SPvpSq
	 Q0Qic0ErxRkdAqEN+P8zI3PMjzAo+NmRJzDQg7PD+3HmVSr4kx4/SQvYGtfBUl/i2j
	 EuEYYPGrBz7tNwq0SnpQULU5BfQTNfzeDBWjYqmk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+47e761d22ecf745f72b9@syzkaller.appspotmail.com,
	Eric Dumazet <edumazet@google.com>,
	Florian Westphal <fw@strlen.de>,
	Tom Herbert <tom@herbertland.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 50/81] ila: serialize calls to nf_register_net_hooks()
Date: Mon,  6 Jan 2025 16:16:22 +0100
Message-ID: <20250106151131.322070163@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151129.433047073@linuxfoundation.org>
References: <20250106151129.433047073@linuxfoundation.org>
User-Agent: quilt/0.68
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

[ Upstream commit 260466b576bca0081a7d4acecc8e93687aa22d0e ]

syzbot found a race in ila_add_mapping() [1]

commit 031ae72825ce ("ila: call nf_unregister_net_hooks() sooner")
attempted to fix a similar issue.

Looking at the syzbot repro, we have concurrent ILA_CMD_ADD commands.

Add a mutex to make sure at most one thread is calling nf_register_net_hooks().

[1]
 BUG: KASAN: slab-use-after-free in rht_key_hashfn include/linux/rhashtable.h:159 [inline]
 BUG: KASAN: slab-use-after-free in __rhashtable_lookup.constprop.0+0x426/0x550 include/linux/rhashtable.h:604
Read of size 4 at addr ffff888028f40008 by task dhcpcd/5501

CPU: 1 UID: 0 PID: 5501 Comm: dhcpcd Not tainted 6.13.0-rc4-syzkaller-00054-gd6ef8b40d075 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
Call Trace:
 <IRQ>
  __dump_stack lib/dump_stack.c:94 [inline]
  dump_stack_lvl+0x116/0x1f0 lib/dump_stack.c:120
  print_address_description mm/kasan/report.c:378 [inline]
  print_report+0xc3/0x620 mm/kasan/report.c:489
  kasan_report+0xd9/0x110 mm/kasan/report.c:602
  rht_key_hashfn include/linux/rhashtable.h:159 [inline]
  __rhashtable_lookup.constprop.0+0x426/0x550 include/linux/rhashtable.h:604
  rhashtable_lookup include/linux/rhashtable.h:646 [inline]
  rhashtable_lookup_fast include/linux/rhashtable.h:672 [inline]
  ila_lookup_wildcards net/ipv6/ila/ila_xlat.c:127 [inline]
  ila_xlat_addr net/ipv6/ila/ila_xlat.c:652 [inline]
  ila_nf_input+0x1ee/0x620 net/ipv6/ila/ila_xlat.c:185
  nf_hook_entry_hookfn include/linux/netfilter.h:154 [inline]
  nf_hook_slow+0xbb/0x200 net/netfilter/core.c:626
  nf_hook.constprop.0+0x42e/0x750 include/linux/netfilter.h:269
  NF_HOOK include/linux/netfilter.h:312 [inline]
  ipv6_rcv+0xa4/0x680 net/ipv6/ip6_input.c:309
  __netif_receive_skb_one_core+0x12e/0x1e0 net/core/dev.c:5672
  __netif_receive_skb+0x1d/0x160 net/core/dev.c:5785
  process_backlog+0x443/0x15f0 net/core/dev.c:6117
  __napi_poll.constprop.0+0xb7/0x550 net/core/dev.c:6883
  napi_poll net/core/dev.c:6952 [inline]
  net_rx_action+0xa94/0x1010 net/core/dev.c:7074
  handle_softirqs+0x213/0x8f0 kernel/softirq.c:561
  __do_softirq kernel/softirq.c:595 [inline]
  invoke_softirq kernel/softirq.c:435 [inline]
  __irq_exit_rcu+0x109/0x170 kernel/softirq.c:662
  irq_exit_rcu+0x9/0x30 kernel/softirq.c:678
  instr_sysvec_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1049 [inline]
  sysvec_apic_timer_interrupt+0xa4/0xc0 arch/x86/kernel/apic/apic.c:1049

Fixes: 7f00feaf1076 ("ila: Add generic ILA translation facility")
Reported-by: syzbot+47e761d22ecf745f72b9@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/netdev/6772c9ae.050a0220.2f3838.04c7.GAE@google.com/T/#u
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Florian Westphal <fw@strlen.de>
Cc: Tom Herbert <tom@herbertland.com>
Link: https://patch.msgid.link/20241230162849.2795486-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/ila/ila_xlat.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/net/ipv6/ila/ila_xlat.c b/net/ipv6/ila/ila_xlat.c
index 2e7a36a1ea0a..8483116dfa23 100644
--- a/net/ipv6/ila/ila_xlat.c
+++ b/net/ipv6/ila/ila_xlat.c
@@ -201,6 +201,8 @@ static const struct nf_hook_ops ila_nf_hook_ops[] = {
 	},
 };
 
+static DEFINE_MUTEX(ila_mutex);
+
 static int ila_add_mapping(struct net *net, struct ila_xlat_params *xp)
 {
 	struct ila_net *ilan = net_generic(net, ila_net_id);
@@ -208,16 +210,20 @@ static int ila_add_mapping(struct net *net, struct ila_xlat_params *xp)
 	spinlock_t *lock = ila_get_lock(ilan, xp->ip.locator_match);
 	int err = 0, order;
 
-	if (!ilan->xlat.hooks_registered) {
+	if (!READ_ONCE(ilan->xlat.hooks_registered)) {
 		/* We defer registering net hooks in the namespace until the
 		 * first mapping is added.
 		 */
-		err = nf_register_net_hooks(net, ila_nf_hook_ops,
-					    ARRAY_SIZE(ila_nf_hook_ops));
+		mutex_lock(&ila_mutex);
+		if (!ilan->xlat.hooks_registered) {
+			err = nf_register_net_hooks(net, ila_nf_hook_ops,
+						ARRAY_SIZE(ila_nf_hook_ops));
+			if (!err)
+				WRITE_ONCE(ilan->xlat.hooks_registered, true);
+		}
+		mutex_unlock(&ila_mutex);
 		if (err)
 			return err;
-
-		ilan->xlat.hooks_registered = true;
 	}
 
 	ila = kzalloc(sizeof(*ila), GFP_KERNEL);
-- 
2.39.5



