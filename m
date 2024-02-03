Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B324810A1C;
	Sat,  3 Feb 2024 04:10:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933455; cv=none; b=j/emzJvyjCfH3bp+X5sS9R8O9YokkCitX7DlSa5nx1eAq35e7G20kB0S08Hcp0CXfq6Nw/L7qVD2ecYcUfcstllbEYx59/zPbYnIcJSjQx0v7hxNJJ8qPq1W7Q1mThGXiN5GVu26eokmpF7tjljyh+S8MzXM1Ra0K7gBSFkPkzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933455; c=relaxed/simple;
	bh=j7X+lTq8jhsBLLOil2HSJVg0uh8RUMe95VxHvBL4rEk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EXpHyqFBy/ZVEhWVsCoVhntbICc+De2oqLgRQRe2MtndT7zb4eUe4vlp8U2nqzQI+qPHMw80YE2OmAN+CvzLDlsd7iSENxKcinfBJ+jLkeCLfu3xwyKHyhANMD9rx+0CNmUJaePacKDOloWmHQEwtKuhKYqzXeouzqH84SKGAFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lNsWvxQU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lNsWvxQU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D5EEC43399;
	Sat,  3 Feb 2024 04:10:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933455;
	bh=j7X+lTq8jhsBLLOil2HSJVg0uh8RUMe95VxHvBL4rEk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lNsWvxQU859UnanKdwblcIRUrdt6FUM81oD4mj9MNM7upeKfOKIC94VL4tXSkgmF5
	 ximxdcTd592i6LiR8U5IMSVLL7BYvrEGQAqgvrFfK/cV7mLRnWQg7e70H5FbwRSUeZ
	 ClhsUpjfP7a0bavS4BgiPfYSHNDzJK6DPsXLtJzU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Dichtel <nicolas.dichtel@6wind.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 192/219] ipmr: fix kernel panic when forwarding mcast packets
Date: Fri,  2 Feb 2024 20:06:05 -0800
Message-ID: <20240203035343.908008728@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035317.354186483@linuxfoundation.org>
References: <20240203035317.354186483@linuxfoundation.org>
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

From: Nicolas Dichtel <nicolas.dichtel@6wind.com>

[ Upstream commit e622502c310f1069fd9f41cd38210553115f610a ]

The stacktrace was:
[   86.305548] BUG: kernel NULL pointer dereference, address: 0000000000000092
[   86.306815] #PF: supervisor read access in kernel mode
[   86.307717] #PF: error_code(0x0000) - not-present page
[   86.308624] PGD 0 P4D 0
[   86.309091] Oops: 0000 [#1] PREEMPT SMP NOPTI
[   86.309883] CPU: 2 PID: 3139 Comm: pimd Tainted: G     U             6.8.0-6wind-knet #1
[   86.311027] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.11.1-0-g0551a4be2c-prebuilt.qemu-project.org 04/01/2014
[   86.312728] RIP: 0010:ip_mr_forward (/build/work/knet/net/ipv4/ipmr.c:1985)
[ 86.313399] Code: f9 1f 0f 87 85 03 00 00 48 8d 04 5b 48 8d 04 83 49 8d 44 c5 00 48 8b 40 70 48 39 c2 0f 84 d9 00 00 00 49 8b 46 58 48 83 e0 fe <80> b8 92 00 00 00 00 0f 84 55 ff ff ff 49 83 47 38 01 45 85 e4 0f
[   86.316565] RSP: 0018:ffffad21c0583ae0 EFLAGS: 00010246
[   86.317497] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
[   86.318596] RDX: ffff9559cb46c000 RSI: 0000000000000000 RDI: 0000000000000000
[   86.319627] RBP: ffffad21c0583b30 R08: 0000000000000000 R09: 0000000000000000
[   86.320650] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000001
[   86.321672] R13: ffff9559c093a000 R14: ffff9559cc00b800 R15: ffff9559c09c1d80
[   86.322873] FS:  00007f85db661980(0000) GS:ffff955a79d00000(0000) knlGS:0000000000000000
[   86.324291] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   86.325314] CR2: 0000000000000092 CR3: 000000002f13a000 CR4: 0000000000350ef0
[   86.326589] Call Trace:
[   86.327036]  <TASK>
[   86.327434] ? show_regs (/build/work/knet/arch/x86/kernel/dumpstack.c:479)
[   86.328049] ? __die (/build/work/knet/arch/x86/kernel/dumpstack.c:421 /build/work/knet/arch/x86/kernel/dumpstack.c:434)
[   86.328508] ? page_fault_oops (/build/work/knet/arch/x86/mm/fault.c:707)
[   86.329107] ? do_user_addr_fault (/build/work/knet/arch/x86/mm/fault.c:1264)
[   86.329756] ? srso_return_thunk (/build/work/knet/arch/x86/lib/retpoline.S:223)
[   86.330350] ? __irq_work_queue_local (/build/work/knet/kernel/irq_work.c:111 (discriminator 1))
[   86.331013] ? exc_page_fault (/build/work/knet/./arch/x86/include/asm/paravirt.h:693 /build/work/knet/arch/x86/mm/fault.c:1515 /build/work/knet/arch/x86/mm/fault.c:1563)
[   86.331702] ? asm_exc_page_fault (/build/work/knet/./arch/x86/include/asm/idtentry.h:570)
[   86.332468] ? ip_mr_forward (/build/work/knet/net/ipv4/ipmr.c:1985)
[   86.333183] ? srso_return_thunk (/build/work/knet/arch/x86/lib/retpoline.S:223)
[   86.333920] ipmr_mfc_add (/build/work/knet/./include/linux/rcupdate.h:782 /build/work/knet/net/ipv4/ipmr.c:1009 /build/work/knet/net/ipv4/ipmr.c:1273)
[   86.334583] ? __pfx_ipmr_hash_cmp (/build/work/knet/net/ipv4/ipmr.c:363)
[   86.335357] ip_mroute_setsockopt (/build/work/knet/net/ipv4/ipmr.c:1470)
[   86.336135] ? srso_return_thunk (/build/work/knet/arch/x86/lib/retpoline.S:223)
[   86.336854] ? ip_mroute_setsockopt (/build/work/knet/net/ipv4/ipmr.c:1470)
[   86.337679] do_ip_setsockopt (/build/work/knet/net/ipv4/ip_sockglue.c:944)
[   86.338408] ? __pfx_unix_stream_read_actor (/build/work/knet/net/unix/af_unix.c:2862)
[   86.339232] ? srso_return_thunk (/build/work/knet/arch/x86/lib/retpoline.S:223)
[   86.339809] ? aa_sk_perm (/build/work/knet/security/apparmor/include/cred.h:153 /build/work/knet/security/apparmor/net.c:181)
[   86.340342] ip_setsockopt (/build/work/knet/net/ipv4/ip_sockglue.c:1415)
[   86.340859] raw_setsockopt (/build/work/knet/net/ipv4/raw.c:836)
[   86.341408] ? security_socket_setsockopt (/build/work/knet/security/security.c:4561 (discriminator 13))
[   86.342116] sock_common_setsockopt (/build/work/knet/net/core/sock.c:3716)
[   86.342747] do_sock_setsockopt (/build/work/knet/net/socket.c:2313)
[   86.343363] __sys_setsockopt (/build/work/knet/./include/linux/file.h:32 /build/work/knet/net/socket.c:2336)
[   86.344020] __x64_sys_setsockopt (/build/work/knet/net/socket.c:2340)
[   86.344766] do_syscall_64 (/build/work/knet/arch/x86/entry/common.c:52 /build/work/knet/arch/x86/entry/common.c:83)
[   86.345433] ? srso_return_thunk (/build/work/knet/arch/x86/lib/retpoline.S:223)
[   86.346161] ? syscall_exit_work (/build/work/knet/./include/linux/audit.h:357 /build/work/knet/kernel/entry/common.c:160)
[   86.346938] ? srso_return_thunk (/build/work/knet/arch/x86/lib/retpoline.S:223)
[   86.347657] ? syscall_exit_to_user_mode (/build/work/knet/kernel/entry/common.c:215)
[   86.348538] ? srso_return_thunk (/build/work/knet/arch/x86/lib/retpoline.S:223)
[   86.349262] ? do_syscall_64 (/build/work/knet/./arch/x86/include/asm/cpufeature.h:171 /build/work/knet/arch/x86/entry/common.c:98)
[   86.349971] entry_SYSCALL_64_after_hwframe (/build/work/knet/arch/x86/entry/entry_64.S:129)

The original packet in ipmr_cache_report() may be queued and then forwarded
with ip_mr_forward(). This last function has the assumption that the skb
dst is set.

After the below commit, the skb dst is dropped by ipv4_pktinfo_prepare(),
which causes the oops.

Fixes: bb7403655b3c ("ipmr: support IP_PKTINFO on cache report IGMP msg")
Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/20240125141847.1931933-1-nicolas.dichtel@6wind.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/ip.h       | 2 +-
 net/ipv4/ip_sockglue.c | 6 ++++--
 net/ipv4/ipmr.c        | 2 +-
 net/ipv4/raw.c         | 2 +-
 net/ipv4/udp.c         | 2 +-
 5 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/include/net/ip.h b/include/net/ip.h
index c83c09c65623..4f11f7df7dd6 100644
--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -752,7 +752,7 @@ int ip_options_rcv_srr(struct sk_buff *skb, struct net_device *dev);
  *	Functions provided by ip_sockglue.c
  */
 
-void ipv4_pktinfo_prepare(const struct sock *sk, struct sk_buff *skb);
+void ipv4_pktinfo_prepare(const struct sock *sk, struct sk_buff *skb, bool drop_dst);
 void ip_cmsg_recv_offset(struct msghdr *msg, struct sock *sk,
 			 struct sk_buff *skb, int tlen, int offset);
 int ip_cmsg_send(struct sock *sk, struct msghdr *msg,
diff --git a/net/ipv4/ip_sockglue.c b/net/ipv4/ip_sockglue.c
index c1fb7580ea58..a00ba2d51e1b 100644
--- a/net/ipv4/ip_sockglue.c
+++ b/net/ipv4/ip_sockglue.c
@@ -1406,12 +1406,13 @@ int do_ip_setsockopt(struct sock *sk, int level, int optname,
  * ipv4_pktinfo_prepare - transfer some info from rtable to skb
  * @sk: socket
  * @skb: buffer
+ * @drop_dst: if true, drops skb dst
  *
  * To support IP_CMSG_PKTINFO option, we store rt_iif and specific
  * destination in skb->cb[] before dst drop.
  * This way, receiver doesn't make cache line misses to read rtable.
  */
-void ipv4_pktinfo_prepare(const struct sock *sk, struct sk_buff *skb)
+void ipv4_pktinfo_prepare(const struct sock *sk, struct sk_buff *skb, bool drop_dst)
 {
 	struct in_pktinfo *pktinfo = PKTINFO_SKB_CB(skb);
 	bool prepare = (inet_sk(sk)->cmsg_flags & IP_CMSG_PKTINFO) ||
@@ -1440,7 +1441,8 @@ void ipv4_pktinfo_prepare(const struct sock *sk, struct sk_buff *skb)
 		pktinfo->ipi_ifindex = 0;
 		pktinfo->ipi_spec_dst.s_addr = 0;
 	}
-	skb_dst_drop(skb);
+	if (drop_dst)
+		skb_dst_drop(skb);
 }
 
 int ip_setsockopt(struct sock *sk, int level, int optname, sockptr_t optval,
diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
index b807197475a5..d5421c38c2aa 100644
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -1073,7 +1073,7 @@ static int ipmr_cache_report(const struct mr_table *mrt,
 		msg = (struct igmpmsg *)skb_network_header(skb);
 		msg->im_vif = vifi;
 		msg->im_vif_hi = vifi >> 8;
-		ipv4_pktinfo_prepare(mroute_sk, pkt);
+		ipv4_pktinfo_prepare(mroute_sk, pkt, false);
 		memcpy(skb->cb, pkt->cb, sizeof(skb->cb));
 		/* Add our header */
 		igmp = skb_put(skb, sizeof(struct igmphdr));
diff --git a/net/ipv4/raw.c b/net/ipv4/raw.c
index 19936dc329d8..7c63b91edbf7 100644
--- a/net/ipv4/raw.c
+++ b/net/ipv4/raw.c
@@ -290,7 +290,7 @@ static int raw_rcv_skb(struct sock *sk, struct sk_buff *skb)
 
 	/* Charge it to the socket. */
 
-	ipv4_pktinfo_prepare(sk, skb);
+	ipv4_pktinfo_prepare(sk, skb, true);
 	if (sock_queue_rcv_skb_reason(sk, skb, &reason) < 0) {
 		kfree_skb_reason(skb, reason);
 		return NET_RX_DROP;
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 11c0e1c66642..87d759bab001 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -2196,7 +2196,7 @@ static int udp_queue_rcv_one_skb(struct sock *sk, struct sk_buff *skb)
 
 	udp_csum_pull_header(skb);
 
-	ipv4_pktinfo_prepare(sk, skb);
+	ipv4_pktinfo_prepare(sk, skb, true);
 	return __udp_queue_rcv_skb(sk, skb);
 
 csum_error:
-- 
2.43.0



