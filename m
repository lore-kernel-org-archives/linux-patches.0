Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 868308634A;
	Mon,  6 Jan 2025 15:22:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736176939; cv=none; b=qwcde3ePUR0duxzrxROaholMrqHce+R+/IutRxA/ZTXPy9b1ro6BvrHSQqkrkDFkaKeu4f+5y4pGx+nWDqTmwlrgo0Ve6Qt9pHcixoFG2rKX18md3UBNeDNT7CCpW4FaM0nOwh+J+nV2puz1juTtXgmL781y9afnBpF2J+PAt90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736176939; c=relaxed/simple;
	bh=VRzyi+4KNFW0E6xojgcXjswsfrVjWyuJlvXr97es+Ds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=alIyqA0KAq4xABwhEzjvuPeMPuqSfM5UnmYzkdSnQzmnZ2Efn81VgqGOSARCj87yRg42vTqWZ9z7jwgB9VnyU2YIjc85qGfmYgq4QWKshTBsIckDzBTa+/N1oPh36i7fvYy1n4ZWQvWbP/3sxXQGqyewYAaF17CTeQYG/mpfjlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oQL8+KN8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oQL8+KN8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 064EBC4CEDF;
	Mon,  6 Jan 2025 15:22:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736176939;
	bh=VRzyi+4KNFW0E6xojgcXjswsfrVjWyuJlvXr97es+Ds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oQL8+KN8OUEldMdUsKjoxkAbBLWQj+wWi2gAkt6fbk+byuXWfskvgtMJEL2uFWmzY
	 aSSdlu4ysSn6JhE1dgwuVdqk1fvEnEN8VUwKh6Z5/MEhpYI6KqjGYr/VbviV6lXTUo
	 YPQv68e9Dfb0sJOTOUQn6WjqvRhm2ia9dKrXEKcY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+38a095a81f30d82884c1@syzkaller.appspotmail.com,
	Paolo Abeni <pabeni@redhat.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 79/81] mptcp: fix TCP options overflow.
Date: Mon,  6 Jan 2025 16:16:51 +0100
Message-ID: <20250106151132.409280652@linuxfoundation.org>
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

From: Paolo Abeni <pabeni@redhat.com>

commit cbb26f7d8451fe56ccac802c6db48d16240feebd upstream.

Syzbot reported the following splat:

Oops: general protection fault, probably for non-canonical address 0xdffffc0000000001: 0000 [#1] PREEMPT SMP KASAN PTI
KASAN: null-ptr-deref in range [0x0000000000000008-0x000000000000000f]
CPU: 1 UID: 0 PID: 5836 Comm: sshd Not tainted 6.13.0-rc3-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 11/25/2024
RIP: 0010:_compound_head include/linux/page-flags.h:242 [inline]
RIP: 0010:put_page+0x23/0x260 include/linux/mm.h:1552
Code: 90 90 90 90 90 90 90 55 41 57 41 56 53 49 89 fe 48 bd 00 00 00 00 00 fc ff df e8 f8 5e 12 f8 49 8d 5e 08 48 89 d8 48 c1 e8 03 <80> 3c 28 00 74 08 48 89 df e8 8f c7 78 f8 48 8b 1b 48 89 de 48 83
RSP: 0000:ffffc90003916c90 EFLAGS: 00010202
RAX: 0000000000000001 RBX: 0000000000000008 RCX: ffff888030458000
RDX: 0000000000000100 RSI: 0000000000000000 RDI: 0000000000000000
RBP: dffffc0000000000 R08: ffffffff898ca81d R09: 1ffff110054414ac
R10: dffffc0000000000 R11: ffffed10054414ad R12: 0000000000000007
R13: ffff88802a20a542 R14: 0000000000000000 R15: 0000000000000000
FS:  00007f34f496e800(0000) GS:ffff8880b8700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f9d6ec9ec28 CR3: 000000004d260000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 skb_page_unref include/linux/skbuff_ref.h:43 [inline]
 __skb_frag_unref include/linux/skbuff_ref.h:56 [inline]
 skb_release_data+0x483/0x8a0 net/core/skbuff.c:1119
 skb_release_all net/core/skbuff.c:1190 [inline]
 __kfree_skb+0x55/0x70 net/core/skbuff.c:1204
 tcp_clean_rtx_queue net/ipv4/tcp_input.c:3436 [inline]
 tcp_ack+0x2442/0x6bc0 net/ipv4/tcp_input.c:4032
 tcp_rcv_state_process+0x8eb/0x44e0 net/ipv4/tcp_input.c:6805
 tcp_v4_do_rcv+0x77d/0xc70 net/ipv4/tcp_ipv4.c:1939
 tcp_v4_rcv+0x2dc0/0x37f0 net/ipv4/tcp_ipv4.c:2351
 ip_protocol_deliver_rcu+0x22e/0x440 net/ipv4/ip_input.c:205
 ip_local_deliver_finish+0x341/0x5f0 net/ipv4/ip_input.c:233
 NF_HOOK+0x3a4/0x450 include/linux/netfilter.h:314
 NF_HOOK+0x3a4/0x450 include/linux/netfilter.h:314
 __netif_receive_skb_one_core net/core/dev.c:5672 [inline]
 __netif_receive_skb+0x2bf/0x650 net/core/dev.c:5785
 process_backlog+0x662/0x15b0 net/core/dev.c:6117
 __napi_poll+0xcb/0x490 net/core/dev.c:6883
 napi_poll net/core/dev.c:6952 [inline]
 net_rx_action+0x89b/0x1240 net/core/dev.c:7074
 handle_softirqs+0x2d4/0x9b0 kernel/softirq.c:561
 __do_softirq kernel/softirq.c:595 [inline]
 invoke_softirq kernel/softirq.c:435 [inline]
 __irq_exit_rcu+0xf7/0x220 kernel/softirq.c:662
 irq_exit_rcu+0x9/0x30 kernel/softirq.c:678
 instr_sysvec_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1049 [inline]
 sysvec_apic_timer_interrupt+0x57/0xc0 arch/x86/kernel/apic/apic.c:1049
 asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:702
RIP: 0033:0x7f34f4519ad5
Code: 85 d2 74 0d 0f 10 02 48 8d 54 24 20 0f 11 44 24 20 64 8b 04 25 18 00 00 00 85 c0 75 27 41 b8 08 00 00 00 b8 0f 01 00 00 0f 05 <48> 3d 00 f0 ff ff 76 75 48 8b 15 24 73 0d 00 f7 d8 64 89 02 48 83
RSP: 002b:00007ffec5b32ce0 EFLAGS: 00000246
RAX: 0000000000000001 RBX: 00000000000668a0 RCX: 00007f34f4519ad5
RDX: 00007ffec5b32d00 RSI: 0000000000000004 RDI: 0000564f4bc6cae0
RBP: 0000564f4bc6b5a0 R08: 0000000000000008 R09: 0000000000000000
R10: 00007ffec5b32de8 R11: 0000000000000246 R12: 0000564f48ea8aa4
R13: 0000000000000001 R14: 0000564f48ea93e8 R15: 00007ffec5b32d68
 </TASK>

Eric noted a probable shinfo->nr_frags corruption, which indeed
occurs.

The root cause is a buggy MPTCP option len computation in some
circumstances: the ADD_ADDR option should be mutually exclusive
with DSS since the blamed commit.

Still, mptcp_established_options_add_addr() tries to set the
relevant info in mptcp_out_options, if the remaining space is
large enough even when DSS is present.

Since the ADD_ADDR infos and the DSS share the same union
fields, adding first corrupts the latter. In the worst-case
scenario, such corruption increases the DSS binary layout,
exceeding the computed length and possibly overwriting the
skb shared info.

Address the issue by enforcing mutual exclusion in
mptcp_established_options_add_addr(), too.

Cc: stable@vger.kernel.org
Reported-by: syzbot+38a095a81f30d82884c1@syzkaller.appspotmail.com
Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/538
Fixes: 1bff1e43a30e ("mptcp: optimize out option generation")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/025d9df8cde3c9a557befc47e9bc08fbbe3476e5.1734771049.git.pabeni@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/options.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -665,8 +665,15 @@ static bool mptcp_established_options_ad
 		    &echo, &drop_other_suboptions))
 		return false;
 
+	/*
+	 * Later on, mptcp_write_options() will enforce mutually exclusion with
+	 * DSS, bail out if such option is set and we can't drop it.
+	 */
 	if (drop_other_suboptions)
 		remaining += opt_size;
+	else if (opts->suboptions & OPTION_MPTCP_DSS)
+		return false;
+
 	len = mptcp_add_addr_len(opts->addr.family, echo, !!opts->addr.port);
 	if (remaining < len)
 		return false;


