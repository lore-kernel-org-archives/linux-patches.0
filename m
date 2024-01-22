Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCDC313EFEC;
	Tue, 23 Jan 2024 01:06:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705972010; cv=none; b=jhtKNWWUgMFkMTagdvS00Kss1Zo92Swx5VuWoKPf9qaSBQqaF+wdddE+ilnGKdvidBAg8EGZTDR1Eh2SM81xBOgpz8APQt4SwDPx02IbZ+6muD9g6SoOn8hrQb+fqFRElPm0HS4eWmggcB+sosMQBIGH7vvEcpy6m3OsFEDbKqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705972010; c=relaxed/simple;
	bh=4d88BJxgFSChc1VQTeoC7H1osnjEJQjkNtX+LM5EHJo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZGkQq8rSDbOCEg8vP/KB08sKuRJWmJ3KY1xUy18i0cwBHyAbkzZ+a2GNyyDxuXwpnxinS0+DtF5DnT9ynts8aXlwO8t6h+nHkEOyeNtrAS5RLZ7S/ZgqVMyouHdaw6k2ttvuoUZn7N7eaBFeRYlGtogeFmxL0YavjdD6ymc/AEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v5gF2iVK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v5gF2iVK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99E74C433F1;
	Tue, 23 Jan 2024 01:06:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705972010;
	bh=4d88BJxgFSChc1VQTeoC7H1osnjEJQjkNtX+LM5EHJo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v5gF2iVKrVbevy0j9gOzhN+U/GBQ8uFi5caLDjjgUk8jqxTaWFLM1Ww2jymKC+KiP
	 SgeEpRiEoJuMtJ0ch7ltrCesDUoDyr0QCGu3YXNmBo3MTsfNEouvWHqjnwXyAVlyN+
	 sxIffHsoTC4qaY0P0COkbv/7O8IWnD358fOyyeek=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot <syzkaller@googlegroups.com>,
	Eric Dumazet <edumazet@google.com>,
	Florian Westphal <fw@strlen.de>,
	Peter Krystad <peter.krystad@linux.intel.com>,
	Matthieu Baerts <matttbe@kernel.org>,
	Mat Martineau <martineau@kernel.org>,
	Geliang Tang <geliang.tang@linux.dev>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 385/417] mptcp: use OPTION_MPTCP_MPJ_SYN in subflow_check_req()
Date: Mon, 22 Jan 2024 15:59:13 -0800
Message-ID: <20240122235805.108373489@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 66ff70df1a919a066942844bb095d6fcb748d78d ]

syzbot reported that subflow_check_req() was using uninitialized data in
subflow_check_req() [1]

This is because mp_opt.token is only set when OPTION_MPTCP_MPJ_SYN is also set.

While we are are it, fix mptcp_subflow_init_cookie_req()
to test for OPTION_MPTCP_MPJ_ACK.

[1]

BUG: KMSAN: uninit-value in subflow_token_join_request net/mptcp/subflow.c:91 [inline]
 BUG: KMSAN: uninit-value in subflow_check_req+0x1028/0x15d0 net/mptcp/subflow.c:209
  subflow_token_join_request net/mptcp/subflow.c:91 [inline]
  subflow_check_req+0x1028/0x15d0 net/mptcp/subflow.c:209
  subflow_v6_route_req+0x269/0x410 net/mptcp/subflow.c:367
  tcp_conn_request+0x153a/0x4240 net/ipv4/tcp_input.c:7164
 subflow_v6_conn_request+0x3ee/0x510
  tcp_rcv_state_process+0x2e1/0x4ac0 net/ipv4/tcp_input.c:6659
  tcp_v6_do_rcv+0x11bf/0x1fe0 net/ipv6/tcp_ipv6.c:1669
  tcp_v6_rcv+0x480b/0x4fb0 net/ipv6/tcp_ipv6.c:1900
  ip6_protocol_deliver_rcu+0xda6/0x2a60 net/ipv6/ip6_input.c:438
  ip6_input_finish net/ipv6/ip6_input.c:483 [inline]
  NF_HOOK include/linux/netfilter.h:314 [inline]
  ip6_input+0x15d/0x430 net/ipv6/ip6_input.c:492
  dst_input include/net/dst.h:461 [inline]
  ip6_rcv_finish+0x5db/0x870 net/ipv6/ip6_input.c:79
  NF_HOOK include/linux/netfilter.h:314 [inline]
  ipv6_rcv+0xda/0x390 net/ipv6/ip6_input.c:310
  __netif_receive_skb_one_core net/core/dev.c:5532 [inline]
  __netif_receive_skb+0x1a6/0x5a0 net/core/dev.c:5646
  netif_receive_skb_internal net/core/dev.c:5732 [inline]
  netif_receive_skb+0x58/0x660 net/core/dev.c:5791
  tun_rx_batched+0x3ee/0x980 drivers/net/tun.c:1555
  tun_get_user+0x53af/0x66d0 drivers/net/tun.c:2002
  tun_chr_write_iter+0x3af/0x5d0 drivers/net/tun.c:2048
  call_write_iter include/linux/fs.h:2020 [inline]
  new_sync_write fs/read_write.c:491 [inline]
  vfs_write+0x8ef/0x1490 fs/read_write.c:584
  ksys_write+0x20f/0x4c0 fs/read_write.c:637
  __do_sys_write fs/read_write.c:649 [inline]
  __se_sys_write fs/read_write.c:646 [inline]
  __x64_sys_write+0x93/0xd0 fs/read_write.c:646
  do_syscall_x64 arch/x86/entry/common.c:52 [inline]
  do_syscall_64+0x44/0x110 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x63/0x6b

Local variable mp_opt created at:
  subflow_check_req+0x6d/0x15d0 net/mptcp/subflow.c:145
  subflow_v6_route_req+0x269/0x410 net/mptcp/subflow.c:367

CPU: 1 PID: 5924 Comm: syz-executor.3 Not tainted 6.7.0-rc8-syzkaller-00055-g5eff55d725a4 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 11/17/2023

Fixes: f296234c98a8 ("mptcp: Add handling of incoming MP_JOIN requests")
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Florian Westphal <fw@strlen.de>
Cc: Peter Krystad <peter.krystad@linux.intel.com>
Cc: Matthieu Baerts <matttbe@kernel.org>
Cc: Mat Martineau <martineau@kernel.org>
Cc: Geliang Tang <geliang.tang@linux.dev>
Reviewed-by: Simon Horman <horms@kernel.org>
Acked-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Mat Martineau <martineau@kernel.org>
Link: https://lore.kernel.org/r/20240111194917.4044654-5-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/subflow.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index caf7981fbee5..95cd4f6d83e6 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -157,7 +157,7 @@ static int subflow_check_req(struct request_sock *req,
 	mptcp_get_options(skb, &mp_opt);
 
 	opt_mp_capable = !!(mp_opt.suboptions & OPTIONS_MPTCP_MPC);
-	opt_mp_join = !!(mp_opt.suboptions & OPTIONS_MPTCP_MPJ);
+	opt_mp_join = !!(mp_opt.suboptions & OPTION_MPTCP_MPJ_SYN);
 	if (opt_mp_capable) {
 		SUBFLOW_REQ_INC_STATS(req, MPTCP_MIB_MPCAPABLEPASSIVE);
 
@@ -254,7 +254,7 @@ int mptcp_subflow_init_cookie_req(struct request_sock *req,
 	mptcp_get_options(skb, &mp_opt);
 
 	opt_mp_capable = !!(mp_opt.suboptions & OPTIONS_MPTCP_MPC);
-	opt_mp_join = !!(mp_opt.suboptions & OPTIONS_MPTCP_MPJ);
+	opt_mp_join = !!(mp_opt.suboptions & OPTION_MPTCP_MPJ_ACK);
 	if (opt_mp_capable && opt_mp_join)
 		return -EINVAL;
 
-- 
2.43.0



