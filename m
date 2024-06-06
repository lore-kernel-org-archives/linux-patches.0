Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 354081991B6;
	Thu,  6 Jun 2024 14:20:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683649; cv=none; b=IF/T9Y+SkA3+s2mKNhJPyqKNKRm53gmpEjbhFr+OFkwIj2av7PZ0430KTOp1jwwST0eBhp1kecnXXp0ihGaO3M38Phlp7B8TIVjDC4puh3rrmhgjJ9YL8V8h7But2IdYnEW9VNc9IFDZTeddzoGwHJMY9qG/NLKx/mOch0eK4W8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683649; c=relaxed/simple;
	bh=HoXXS6zWI8u5LAJFATsDsf0STPdEnRW82eOCVcXQRfI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c2Z7Nc/UvSRltJUmfGG5JdpakPSRYrfjgLNwQmYfzstEBaemQI9boWoSWitawAuRTzApKXUyQ8cO21w+U19ThdOZJvlT7/DLBQK7wWrxKE10tjCSIHQJaAY4yM45dcT/bEFUjOe9gORg58SDeWJADVhpSwA+g8UhC/f1Z3xay1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aPcj7VEW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aPcj7VEW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10BC3C2BD10;
	Thu,  6 Jun 2024 14:20:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683649;
	bh=HoXXS6zWI8u5LAJFATsDsf0STPdEnRW82eOCVcXQRfI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aPcj7VEWG2G+lQ8KSm4PymIZvXYEJhXE2TV+v1S3fqFUbaBds4HZGnnTdXU6lUC6k
	 vrOm5qv/FKh98G5Q4bMGSkDX+2p2r24oWu8pKfVzWcFtDkxxexvEaBR7EvWpfx7SXm
	 gyf+mkRpzHGkPD0izwQi6rHVioBtwROStHcenY/8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Yue Haibing <yuehaibing@huawei.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 468/473] ipvlan: Dont Use skb->sk in ipvlan_process_v{4,6}_outbound
Date: Thu,  6 Jun 2024 16:06:37 +0200
Message-ID: <20240606131715.156851602@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yue Haibing <yuehaibing@huawei.com>

[ Upstream commit b3dc6e8003b500861fa307e9a3400c52e78e4d3a ]

Raw packet from PF_PACKET socket ontop of an IPv6-backed ipvlan device will
hit WARN_ON_ONCE() in sk_mc_loop() through sch_direct_xmit() path.

WARNING: CPU: 2 PID: 0 at net/core/sock.c:775 sk_mc_loop+0x2d/0x70
Modules linked in: sch_netem ipvlan rfkill cirrus drm_shmem_helper sg drm_kms_helper
CPU: 2 PID: 0 Comm: swapper/2 Kdump: loaded Not tainted 6.9.0+ #279
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/2014
RIP: 0010:sk_mc_loop+0x2d/0x70
Code: fa 0f 1f 44 00 00 65 0f b7 15 f7 96 a3 4f 31 c0 66 85 d2 75 26 48 85 ff 74 1c
RSP: 0018:ffffa9584015cd78 EFLAGS: 00010212
RAX: 0000000000000011 RBX: ffff91e585793e00 RCX: 0000000002c6a001
RDX: 0000000000000000 RSI: 0000000000000040 RDI: ffff91e589c0f000
RBP: ffff91e5855bd100 R08: 0000000000000000 R09: 3d00545216f43d00
R10: ffff91e584fdcc50 R11: 00000060dd8616f4 R12: ffff91e58132d000
R13: ffff91e584fdcc68 R14: ffff91e5869ce800 R15: ffff91e589c0f000
FS:  0000000000000000(0000) GS:ffff91e898100000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f788f7c44c0 CR3: 0000000008e1a000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
<IRQ>
 ? __warn (kernel/panic.c:693)
 ? sk_mc_loop (net/core/sock.c:760)
 ? report_bug (lib/bug.c:201 lib/bug.c:219)
 ? handle_bug (arch/x86/kernel/traps.c:239)
 ? exc_invalid_op (arch/x86/kernel/traps.c:260 (discriminator 1))
 ? asm_exc_invalid_op (./arch/x86/include/asm/idtentry.h:621)
 ? sk_mc_loop (net/core/sock.c:760)
 ip6_finish_output2 (net/ipv6/ip6_output.c:83 (discriminator 1))
 ? nf_hook_slow (net/netfilter/core.c:626)
 ip6_finish_output (net/ipv6/ip6_output.c:222)
 ? __pfx_ip6_finish_output (net/ipv6/ip6_output.c:215)
 ipvlan_xmit_mode_l3 (drivers/net/ipvlan/ipvlan_core.c:602) ipvlan
 ipvlan_start_xmit (drivers/net/ipvlan/ipvlan_main.c:226) ipvlan
 dev_hard_start_xmit (net/core/dev.c:3594)
 sch_direct_xmit (net/sched/sch_generic.c:343)
 __qdisc_run (net/sched/sch_generic.c:416)
 net_tx_action (net/core/dev.c:5286)
 handle_softirqs (kernel/softirq.c:555)
 __irq_exit_rcu (kernel/softirq.c:589)
 sysvec_apic_timer_interrupt (arch/x86/kernel/apic/apic.c:1043)

The warning triggers as this:
packet_sendmsg
   packet_snd //skb->sk is packet sk
      __dev_queue_xmit
         __dev_xmit_skb //q->enqueue is not NULL
             __qdisc_run
               sch_direct_xmit
                 dev_hard_start_xmit
                   ipvlan_start_xmit
                      ipvlan_xmit_mode_l3 //l3 mode
                        ipvlan_process_outbound //vepa flag
                          ipvlan_process_v6_outbound
                            ip6_local_out
                                __ip6_finish_output
                                  ip6_finish_output2 //multicast packet
                                    sk_mc_loop //sk->sk_family is AF_PACKET

Call ip{6}_local_out() with NULL sk in ipvlan as other tunnels to fix this.

Fixes: 2ad7bf363841 ("ipvlan: Initial check-in of the IPVLAN driver.")
Suggested-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Yue Haibing <yuehaibing@huawei.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/20240529095633.613103-1-yuehaibing@huawei.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ipvlan/ipvlan_core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ipvlan/ipvlan_core.c b/drivers/net/ipvlan/ipvlan_core.c
index d447f3076e24a..1d49771d07f4c 100644
--- a/drivers/net/ipvlan/ipvlan_core.c
+++ b/drivers/net/ipvlan/ipvlan_core.c
@@ -439,7 +439,7 @@ static noinline_for_stack int ipvlan_process_v4_outbound(struct sk_buff *skb)
 
 	memset(IPCB(skb), 0, sizeof(*IPCB(skb)));
 
-	err = ip_local_out(net, skb->sk, skb);
+	err = ip_local_out(net, NULL, skb);
 	if (unlikely(net_xmit_eval(err)))
 		DEV_STATS_INC(dev, tx_errors);
 	else
@@ -494,7 +494,7 @@ static int ipvlan_process_v6_outbound(struct sk_buff *skb)
 
 	memset(IP6CB(skb), 0, sizeof(*IP6CB(skb)));
 
-	err = ip6_local_out(dev_net(dev), skb->sk, skb);
+	err = ip6_local_out(dev_net(dev), NULL, skb);
 	if (unlikely(net_xmit_eval(err)))
 		DEV_STATS_INC(dev, tx_errors);
 	else
-- 
2.43.0



