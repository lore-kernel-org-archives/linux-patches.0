Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B24C8359F8E;
	Fri,  9 Jan 2026 12:51:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767963076; cv=none; b=lqYAeDOcM/apz3uS4ED/dMnAevEGZizehKLh7jjB3ByoL7ABiSzI/iOVHNm5M0JfHA1CGe5d2jMwhkMdXCSfG+ndFwMiH5ALcM/9MbczwvW2XpQ38PYlLANuI5iTF1sNMNdDxc1P8/heuRTVaE3GL9Xj8QXEa3/V+1m3OhemufQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767963076; c=relaxed/simple;
	bh=QjMbyFE5GGAuRPr33x43QXmuTe9+tS8nlx8hXqDQe2g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P8sd5NdYA8lML5eLHqt5nZ/8zil9Dn7RdUtQq4GovlzHo5V9+PuaY3dkUVSbsyv1aVZyhgNic/0q6Mp8jR/iTGkWjuePMx5d2SIH5MIodATYZ4psSL1A5gtJ2l2D6yzuQF1ALtw9Hui19EpHmu+mocdg1HOlmb2Lr+UYMaDGq7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D6xj3+eM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D6xj3+eM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03295C4CEF1;
	Fri,  9 Jan 2026 12:51:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767963076;
	bh=QjMbyFE5GGAuRPr33x43QXmuTe9+tS8nlx8hXqDQe2g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D6xj3+eMINAKiA6gqfpuXTEX5JzTXiSAzz6K+0Z3zEnQSFZ8OsGG+wNgTvVyIoOCo
	 abv5p9avoqcQQNAVOzIxZSVHjXSIGI/e4j9/nNNGJkAboa0m7zdTBB3XE8wZu48yEL
	 FRFkwbqLxbYTA/rGNrGM2rMOv8W0E011tEsVN15I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+0ff6b771b4f7a5bce83b@syzkaller.appspotmail.com,
	Paolo Abeni <pabeni@redhat.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 587/634] mptcp: fallback earlier on simult connection
Date: Fri,  9 Jan 2026 12:44:25 +0100
Message-ID: <20260109112139.706259016@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit 71154bbe49423128c1c8577b6576de1ed6836830 ]

Syzkaller reports a simult-connect race leading to inconsistent fallback
status:

  WARNING: CPU: 3 PID: 33 at net/mptcp/subflow.c:1515 subflow_data_ready+0x40b/0x7c0 net/mptcp/subflow.c:1515
  Modules linked in:
  CPU: 3 UID: 0 PID: 33 Comm: ksoftirqd/3 Not tainted syzkaller #0 PREEMPT(full)
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
  RIP: 0010:subflow_data_ready+0x40b/0x7c0 net/mptcp/subflow.c:1515
  Code: 89 ee e8 78 61 3c f6 40 84 ed 75 21 e8 8e 66 3c f6 44 89 fe bf 07 00 00 00 e8 c1 61 3c f6 41 83 ff 07 74 09 e8 76 66 3c f6 90 <0f> 0b 90 e8 6d 66 3c f6 48 89 df e8 e5 ad ff ff 31 ff 89 c5 89 c6
  RSP: 0018:ffffc900006cf338 EFLAGS: 00010246
  RAX: 0000000000000000 RBX: ffff888031acd100 RCX: ffffffff8b7f2abf
  RDX: ffff88801e6ea440 RSI: ffffffff8b7f2aca RDI: 0000000000000005
  RBP: 0000000000000000 R08: 0000000000000005 R09: 0000000000000007
  R10: 0000000000000004 R11: 0000000000002c10 R12: ffff88802ba69900
  R13: 1ffff920000d9e67 R14: ffff888046f81800 R15: 0000000000000004
  FS:  0000000000000000(0000) GS:ffff8880d69bc000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 0000560fc0ca1670 CR3: 0000000032c3a000 CR4: 0000000000352ef0
  Call Trace:
   <TASK>
   tcp_data_queue+0x13b0/0x4f90 net/ipv4/tcp_input.c:5197
   tcp_rcv_state_process+0xfdf/0x4ec0 net/ipv4/tcp_input.c:6922
   tcp_v6_do_rcv+0x492/0x1740 net/ipv6/tcp_ipv6.c:1672
   tcp_v6_rcv+0x2976/0x41e0 net/ipv6/tcp_ipv6.c:1918
   ip6_protocol_deliver_rcu+0x188/0x1520 net/ipv6/ip6_input.c:438
   ip6_input_finish+0x1e4/0x4b0 net/ipv6/ip6_input.c:489
   NF_HOOK include/linux/netfilter.h:318 [inline]
   NF_HOOK include/linux/netfilter.h:312 [inline]
   ip6_input+0x105/0x2f0 net/ipv6/ip6_input.c:500
   dst_input include/net/dst.h:471 [inline]
   ip6_rcv_finish net/ipv6/ip6_input.c:79 [inline]
   NF_HOOK include/linux/netfilter.h:318 [inline]
   NF_HOOK include/linux/netfilter.h:312 [inline]
   ipv6_rcv+0x264/0x650 net/ipv6/ip6_input.c:311
   __netif_receive_skb_one_core+0x12d/0x1e0 net/core/dev.c:5979
   __netif_receive_skb+0x1d/0x160 net/core/dev.c:6092
   process_backlog+0x442/0x15e0 net/core/dev.c:6444
   __napi_poll.constprop.0+0xba/0x550 net/core/dev.c:7494
   napi_poll net/core/dev.c:7557 [inline]
   net_rx_action+0xa9f/0xfe0 net/core/dev.c:7684
   handle_softirqs+0x216/0x8e0 kernel/softirq.c:579
   run_ksoftirqd kernel/softirq.c:968 [inline]
   run_ksoftirqd+0x3a/0x60 kernel/softirq.c:960
   smpboot_thread_fn+0x3f7/0xae0 kernel/smpboot.c:160
   kthread+0x3c2/0x780 kernel/kthread.c:463
   ret_from_fork+0x5d7/0x6f0 arch/x86/kernel/process.c:148
   ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
   </TASK>

The TCP subflow can process the simult-connect syn-ack packet after
transitioning to TCP_FIN1 state, bypassing the MPTCP fallback check,
as the sk_state_change() callback is not invoked for * -> FIN_WAIT1
transitions.

That will move the msk socket to an inconsistent status and the next
incoming data will hit the reported splat.

Close the race moving the simult-fallback check at the earliest possible
stage - that is at syn-ack generation time.

About the fixes tags: [2] was supposed to also fix this issue introduced
by [3]. [1] is required as a dependence: it was not explicitly marked as
a fix, but it is one and it has already been backported before [3]. In
other words, this commit should be backported up to [3], including [2]
and [1] if that's not already there.

Fixes: 23e89e8ee7be ("tcp: Don't drop SYN+ACK for simultaneous connect().") [1]
Fixes: 4fd19a307016 ("mptcp: fix inconsistent state on fastopen race") [2]
Fixes: 1e777f39b4d7 ("mptcp: add MSG_FASTOPEN sendmsg flag support") [3]
Cc: stable@vger.kernel.org
Reported-by: syzbot+0ff6b771b4f7a5bce83b@syzkaller.appspotmail.com
Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/586
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20251212-net-mptcp-subflow_data_ready-warn-v1-1-d1f9fd1c36c8@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
[ adapted mptcp_try_fallback() call from two arguments to one argument ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/options.c  |   10 ++++++++++
 net/mptcp/protocol.h |    5 ++---
 net/mptcp/subflow.c  |    9 ---------
 3 files changed, 12 insertions(+), 12 deletions(-)

--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -403,6 +403,16 @@ bool mptcp_syn_options(struct sock *sk,
 	 */
 	subflow->snd_isn = TCP_SKB_CB(skb)->end_seq;
 	if (subflow->request_mptcp) {
+		if (unlikely(subflow_simultaneous_connect(sk))) {
+			WARN_ON_ONCE(!mptcp_try_fallback(sk));
+
+			/* Ensure mptcp_finish_connect() will not process the
+			 * MPC handshake.
+			 */
+			subflow->request_mptcp = 0;
+			return false;
+		}
+
 		opts->suboptions = OPTION_MPTCP_MPC_SYN;
 		opts->csum_reqd = mptcp_is_checksum_enabled(sock_net(sk));
 		opts->allow_join_id0 = mptcp_allow_join_id0(sock_net(sk));
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -1053,9 +1053,8 @@ static inline bool subflow_simultaneous_
 {
 	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(sk);
 
-	return sk->sk_state == TCP_ESTABLISHED &&
-	       is_active_ssk(subflow) &&
-	       !subflow->conn_finished;
+	/* Note that the sk state implies !subflow->conn_finished. */
+	return sk->sk_state == TCP_SYN_RECV && is_active_ssk(subflow);
 }
 
 #ifdef CONFIG_SYN_COOKIES
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -1700,15 +1700,6 @@ static void subflow_state_change(struct
 	__subflow_state_change(sk);
 
 	msk = mptcp_sk(parent);
-	if (subflow_simultaneous_connect(sk)) {
-		mptcp_propagate_sndbuf(parent, sk);
-		WARN_ON_ONCE(!mptcp_try_fallback(sk));
-		mptcp_rcv_space_init(msk, sk);
-		pr_fallback(msk);
-		subflow->conn_finished = 1;
-		mptcp_set_connected(parent);
-	}
-
 	/* as recvmsg() does not acquire the subflow socket for ssk selection
 	 * a fin packet carrying a DSS can be unnoticed if we don't trigger
 	 * the data available machinery here.


