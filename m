Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80C50383C6A
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:07:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302070; cv=none; b=lG/yln1Nn8pfhVm1Coe3m9NY2MzxPi/MSYrU+5uwoaykWx0qY4VlO0CIItqqSgRoPYklUy2N0PNfOM4i2AEdSFybGMd2jGZymarP65JmgVOPp33VXyNWRcRHz+cz5/OOK5JcF3lqQ2neSe742D9VJVVQSgHCg8bdK4Hbn7MWoo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302070; c=relaxed/simple;
	bh=sa0XMHo1czUEMhkreRnNQjC9r1fbvp2vFcpaqAyA7Dc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UjTEfM9AKFpkfRaVCuSVPadO5ck9VbvFaK3cdOjewTCuXVrcL4Ru7P0pLav5TOof6DuhZk4USlMSsoxaLR5X54fa/nbqtRea+/tHLdFUIXXzEjVh9T2XgnIjFMHf9B2FNwULIeL3JK7w+Si8n4e9eI6XfSB0P9LSg8fSX/iUxkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V2dXRHbe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V2dXRHbe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB4F0C2BC87;
	Sat, 28 Feb 2026 18:07:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302070;
	bh=sa0XMHo1czUEMhkreRnNQjC9r1fbvp2vFcpaqAyA7Dc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V2dXRHbeIk03lMQCPMm6pQvmbjGaKgNjr7h/Y0AAB0jljdv7sp9f5laCGrutwcK+3
	 Ap8ngEp00J3ETe1NYRwJJZm33tTTEzfgqUykchxt24RdFMgw4eaKW9vGZ5F5jc/Oul
	 ZH7gQBK3SCLNG43fnqy6iqvZ7tfbkciNLFYSRAwmbJnTr5YrGPrD0wR9oTNpqPrR6H
	 xWJLoKyQagrUoqj0YCcoqBWgseqscfzC2LfoLJdbedxRrLstrtLkuHyn1qmBRdbckE
	 dlEPoSRpyd4lKV0Xh269wcTTGHbAiOh2aMsvWc6Qf8HBucrc/TZU/KscmTdkJEI17j
	 9nAqeZsGQQjZg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Jiayuan Chen <jiayuan.chen@linux.dev>,
	Jakub Sitnicki <jakub@cloudflare.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 049/283] bpf, sockmap: Fix FIONREAD for sockmap
Date: Sat, 28 Feb 2026 13:03:11 -0500
Message-ID: <20260228180709.1583486-49-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Jiayuan Chen <jiayuan.chen@linux.dev>

[ Upstream commit 929e30f9312514902133c45e51c79088421ab084 ]

A socket using sockmap has its own independent receive queue: ingress_msg.
This queue may contain data from its own protocol stack or from other
sockets.

Therefore, for sockmap, relying solely on copied_seq and rcv_nxt to
calculate FIONREAD is not enough.

This patch adds a new msg_tot_len field in the psock structure to record
the data length in ingress_msg. Additionally, we implement new ioctl
interfaces for TCP and UDP to intercept FIONREAD operations.

Note that we intentionally do not include sk_receive_queue data in the
FIONREAD result. Data in sk_receive_queue has not yet been processed by
the BPF verdict program, and may be redirected to other sockets or
dropped. Including it would create semantic ambiguity since this data
may never be readable by the user.

Unix and VSOCK sockets have similar issues, but fixing them is outside
the scope of this patch as it would require more intrusive changes.

Previous work by John Fastabend made some efforts towards FIONREAD support:
commit e5c6de5fa025 ("bpf, sockmap: Incorrectly handling copied_seq")
Although the current patch is based on the previous work by John Fastabend,
it is acceptable for our Fixes tag to point to the same commit.

                                                      FD1:read()
                                                      --  FD1->copied_seq++
                                                          |  [read data]
                                                          |
                                   [enqueue data]         v
                  [sockmap]     -> ingress to self ->  ingress_msg queue
FD1 native stack  ------>                                 ^
-- FD1->rcv_nxt++               -> redirect to other      | [enqueue data]
                                       |                  |
                                       |             ingress to FD1
                                       v                  ^
                                      ...                 |  [sockmap]
                                                     FD2 native stack

Fixes: 04919bed948dc ("tcp: Introduce tcp_read_skb()")
Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>
Link: https://lore.kernel.org/r/20260124113314.113584-3-jiayuan.chen@linux.dev
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/skmsg.h | 68 +++++++++++++++++++++++++++++++++++++++++--
 net/core/skmsg.c      |  3 ++
 net/ipv4/tcp_bpf.c    | 20 +++++++++++++
 net/ipv4/udp_bpf.c    | 23 ++++++++++++---
 4 files changed, 108 insertions(+), 6 deletions(-)

diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
index 5c5a2d65184c3..e923f1c24ce4b 100644
--- a/include/linux/skmsg.h
+++ b/include/linux/skmsg.h
@@ -93,6 +93,8 @@ struct sk_psock {
 	struct sk_buff_head		ingress_skb;
 	struct list_head		ingress_msg;
 	spinlock_t			ingress_lock;
+	/** @msg_tot_len: Total bytes queued in ingress_msg list. */
+	u32				msg_tot_len;
 	unsigned long			state;
 	struct list_head		link;
 	spinlock_t			link_lock;
@@ -312,6 +314,27 @@ static inline void sock_drop(struct sock *sk, struct sk_buff *skb)
 	kfree_skb(skb);
 }
 
+static inline u32 sk_psock_get_msg_len_nolock(struct sk_psock *psock)
+{
+	/* Used by ioctl to read msg_tot_len only; lock-free for performance */
+	return READ_ONCE(psock->msg_tot_len);
+}
+
+static inline void sk_psock_msg_len_add_locked(struct sk_psock *psock, int diff)
+{
+	/* Use WRITE_ONCE to ensure correct read in sk_psock_get_msg_len_nolock().
+	 * ingress_lock should be held to prevent concurrent updates to msg_tot_len
+	 */
+	WRITE_ONCE(psock->msg_tot_len, psock->msg_tot_len + diff);
+}
+
+static inline void sk_psock_msg_len_add(struct sk_psock *psock, int diff)
+{
+	spin_lock_bh(&psock->ingress_lock);
+	sk_psock_msg_len_add_locked(psock, diff);
+	spin_unlock_bh(&psock->ingress_lock);
+}
+
 static inline bool sk_psock_queue_msg(struct sk_psock *psock,
 				      struct sk_msg *msg)
 {
@@ -320,6 +343,7 @@ static inline bool sk_psock_queue_msg(struct sk_psock *psock,
 	spin_lock_bh(&psock->ingress_lock);
 	if (sk_psock_test_state(psock, SK_PSOCK_TX_ENABLED)) {
 		list_add_tail(&msg->list, &psock->ingress_msg);
+		sk_psock_msg_len_add_locked(psock, msg->sg.size);
 		ret = true;
 	} else {
 		sk_msg_free(psock->sk, msg);
@@ -336,18 +360,25 @@ static inline struct sk_msg *sk_psock_dequeue_msg(struct sk_psock *psock)
 
 	spin_lock_bh(&psock->ingress_lock);
 	msg = list_first_entry_or_null(&psock->ingress_msg, struct sk_msg, list);
-	if (msg)
+	if (msg) {
 		list_del(&msg->list);
+		sk_psock_msg_len_add_locked(psock, -msg->sg.size);
+	}
 	spin_unlock_bh(&psock->ingress_lock);
 	return msg;
 }
 
+static inline struct sk_msg *sk_psock_peek_msg_locked(struct sk_psock *psock)
+{
+	return list_first_entry_or_null(&psock->ingress_msg, struct sk_msg, list);
+}
+
 static inline struct sk_msg *sk_psock_peek_msg(struct sk_psock *psock)
 {
 	struct sk_msg *msg;
 
 	spin_lock_bh(&psock->ingress_lock);
-	msg = list_first_entry_or_null(&psock->ingress_msg, struct sk_msg, list);
+	msg = sk_psock_peek_msg_locked(psock);
 	spin_unlock_bh(&psock->ingress_lock);
 	return msg;
 }
@@ -511,6 +542,39 @@ static inline bool sk_psock_strp_enabled(struct sk_psock *psock)
 	return !!psock->saved_data_ready;
 }
 
+/* for tcp only, sk is locked */
+static inline ssize_t sk_psock_msg_inq(struct sock *sk)
+{
+	struct sk_psock *psock;
+	ssize_t inq = 0;
+
+	psock = sk_psock_get(sk);
+	if (likely(psock)) {
+		inq = sk_psock_get_msg_len_nolock(psock);
+		sk_psock_put(sk, psock);
+	}
+	return inq;
+}
+
+/* for udp only, sk is not locked */
+static inline ssize_t sk_msg_first_len(struct sock *sk)
+{
+	struct sk_psock *psock;
+	struct sk_msg *msg;
+	ssize_t inq = 0;
+
+	psock = sk_psock_get(sk);
+	if (likely(psock)) {
+		spin_lock_bh(&psock->ingress_lock);
+		msg = sk_psock_peek_msg_locked(psock);
+		if (msg)
+			inq = msg->sg.size;
+		spin_unlock_bh(&psock->ingress_lock);
+		sk_psock_put(sk, psock);
+	}
+	return inq;
+}
+
 #if IS_ENABLED(CONFIG_NET_SOCK_MSG)
 
 #define BPF_F_STRPARSER	(1UL << 1)
diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index 9f522835bfafe..5d557ba9c0cb4 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -457,6 +457,7 @@ int __sk_msg_recvmsg(struct sock *sk, struct sk_psock *psock, struct msghdr *msg
 					atomic_sub(copy, &sk->sk_rmem_alloc);
 				}
 				msg_rx->sg.size -= copy;
+				sk_psock_msg_len_add(psock, -copy);
 
 				if (!sge->length) {
 					sk_msg_iter_var_next(i);
@@ -820,9 +821,11 @@ static void __sk_psock_purge_ingress_msg(struct sk_psock *psock)
 		list_del(&msg->list);
 		if (!msg->skb)
 			atomic_sub(msg->sg.size, &psock->sk->sk_rmem_alloc);
+		sk_psock_msg_len_add(psock, -msg->sg.size);
 		sk_msg_free(psock->sk, msg);
 		kfree(msg);
 	}
+	WARN_ON_ONCE(psock->msg_tot_len);
 }
 
 static void __sk_psock_zap_ingress(struct sk_psock *psock)
diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
index 5ff5faa2adde0..06a185bb1e35c 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -10,6 +10,7 @@
 
 #include <net/inet_common.h>
 #include <net/tls.h>
+#include <asm/ioctls.h>
 
 void tcp_eat_skb(struct sock *sk, struct sk_buff *skb)
 {
@@ -332,6 +333,24 @@ static int tcp_bpf_recvmsg_parser(struct sock *sk,
 	return copied;
 }
 
+static int tcp_bpf_ioctl(struct sock *sk, int cmd, int *karg)
+{
+	bool slow;
+
+	if (cmd != SIOCINQ)
+		return tcp_ioctl(sk, cmd, karg);
+
+	/* works similar as tcp_ioctl */
+	if (sk->sk_state == TCP_LISTEN)
+		return -EINVAL;
+
+	slow = lock_sock_fast(sk);
+	*karg = sk_psock_msg_inq(sk);
+	unlock_sock_fast(sk, slow);
+
+	return 0;
+}
+
 static int tcp_bpf_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 			   int flags, int *addr_len)
 {
@@ -610,6 +629,7 @@ static void tcp_bpf_rebuild_protos(struct proto prot[TCP_BPF_NUM_CFGS],
 	prot[TCP_BPF_BASE].close		= sock_map_close;
 	prot[TCP_BPF_BASE].recvmsg		= tcp_bpf_recvmsg;
 	prot[TCP_BPF_BASE].sock_is_readable	= sk_msg_is_readable;
+	prot[TCP_BPF_BASE].ioctl		= tcp_bpf_ioctl;
 
 	prot[TCP_BPF_TX]			= prot[TCP_BPF_BASE];
 	prot[TCP_BPF_TX].sendmsg		= tcp_bpf_sendmsg;
diff --git a/net/ipv4/udp_bpf.c b/net/ipv4/udp_bpf.c
index 0735d820e413f..91233e37cd97a 100644
--- a/net/ipv4/udp_bpf.c
+++ b/net/ipv4/udp_bpf.c
@@ -5,6 +5,7 @@
 #include <net/sock.h>
 #include <net/udp.h>
 #include <net/inet_common.h>
+#include <asm/ioctls.h>
 
 #include "udp_impl.h"
 
@@ -111,12 +112,26 @@ enum {
 static DEFINE_SPINLOCK(udpv6_prot_lock);
 static struct proto udp_bpf_prots[UDP_BPF_NUM_PROTS];
 
+static int udp_bpf_ioctl(struct sock *sk, int cmd, int *karg)
+{
+	if (cmd != SIOCINQ)
+		return udp_ioctl(sk, cmd, karg);
+
+	/* Since we don't hold a lock, sk_receive_queue may contain data.
+	 * BPF might only be processing this data at the moment. We only
+	 * care about the data in the ingress_msg here.
+	 */
+	*karg = sk_msg_first_len(sk);
+	return 0;
+}
+
 static void udp_bpf_rebuild_protos(struct proto *prot, const struct proto *base)
 {
-	*prot        = *base;
-	prot->close  = sock_map_close;
-	prot->recvmsg = udp_bpf_recvmsg;
-	prot->sock_is_readable = sk_msg_is_readable;
+	*prot			= *base;
+	prot->close		= sock_map_close;
+	prot->recvmsg		= udp_bpf_recvmsg;
+	prot->sock_is_readable	= sk_msg_is_readable;
+	prot->ioctl		= udp_bpf_ioctl;
 }
 
 static void udp_bpf_check_v6_needs_rebuild(struct proto *ops)
-- 
2.51.0

