Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6780E15E8B;
	Mon, 30 Dec 2024 15:49:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735573782; cv=none; b=TcFVDYpjljxmvHdCb2+GVG9D+VYaF92IPmjYioiCBQ6U+untpc2p8YCeBsJITW+YihHuufTXvXO65HSB1y0RETD3h6UhE2mLFiiX2JOSwhHtoZbYkxMSgE+5xLw0PDdd3xIOnqcZLJAqe0wDjLcQHdb/92mF7wJGwWL7bbZLOwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735573782; c=relaxed/simple;
	bh=4f8p9r5H3WFkqFGnGtRZyR7M5d2NL4vJ1khCX8a22kc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=anZUgNHKlwXFLh30hkK1HDOs3CHlFhyxmeS6G6v4mI8HIPiN1ssvGMx81mM2puKNwkDmgftwrEQLbhZNEnKHFrQGhkSE4XXSSb3v7PvK3EleFRweg2hpUTxaMc5Ugv7wfHkfPzO0flDmCIAb6p8r0n5izoF5In8Gwk5yuqwOFaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RAVjOGRl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RAVjOGRl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E62F6C4CED0;
	Mon, 30 Dec 2024 15:49:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735573782;
	bh=4f8p9r5H3WFkqFGnGtRZyR7M5d2NL4vJ1khCX8a22kc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RAVjOGRlKyQqasSn/SPz52Klf2EvH2K+yS6PZcsrwOelMHV+k4LnVT3TI0/fVmSy4
	 Hlatze/Cq3f7Pz/sqcqxczRoRGPBGXUfFDChzfn3zrzK2+cKC3sHjMo0LcPh1/uea7
	 6OG4S/2DeYgIGHvQnHuOZjie4aGTFJNdUqdcTDuk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijian Zhang <zijianzhang@bytedance.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	John Fastabend <john.fastabend@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 07/86] tcp_bpf: Add sk_rmem_alloc related logic for tcp_bpf ingress redirection
Date: Mon, 30 Dec 2024 16:42:15 +0100
Message-ID: <20241230154211.995525816@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154211.711515682@linuxfoundation.org>
References: <20241230154211.711515682@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zijian Zhang <zijianzhang@bytedance.com>

[ Upstream commit d888b7af7c149c115dd6ac772cc11c375da3e17c ]

When we do sk_psock_verdict_apply->sk_psock_skb_ingress, an sk_msg will
be created out of the skb, and the rmem accounting of the sk_msg will be
handled by the skb.

For skmsgs in __SK_REDIRECT case of tcp_bpf_send_verdict, when redirecting
to the ingress of a socket, although we sk_rmem_schedule and add sk_msg to
the ingress_msg of sk_redir, we do not update sk_rmem_alloc. As a result,
except for the global memory limit, the rmem of sk_redir is nearly
unlimited. Thus, add sk_rmem_alloc related logic to limit the recv buffer.

Since the function sk_msg_recvmsg and __sk_psock_purge_ingress_msg are
used in these two paths. We use "msg->skb" to test whether the sk_msg is
skb backed up. If it's not, we shall do the memory accounting explicitly.

Fixes: 604326b41a6f ("bpf, sockmap: convert to generic sk_msg interface")
Signed-off-by: Zijian Zhang <zijianzhang@bytedance.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: John Fastabend <john.fastabend@gmail.com>
Link: https://lore.kernel.org/bpf/20241210012039.1669389-3-zijianzhang@bytedance.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/skmsg.h | 11 ++++++++---
 net/core/skmsg.c      |  6 +++++-
 net/ipv4/tcp_bpf.c    |  4 +++-
 3 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
index 062fe440f5d0..6ccfd9236387 100644
--- a/include/linux/skmsg.h
+++ b/include/linux/skmsg.h
@@ -308,17 +308,22 @@ static inline void sock_drop(struct sock *sk, struct sk_buff *skb)
 	kfree_skb(skb);
 }
 
-static inline void sk_psock_queue_msg(struct sk_psock *psock,
+static inline bool sk_psock_queue_msg(struct sk_psock *psock,
 				      struct sk_msg *msg)
 {
+	bool ret;
+
 	spin_lock_bh(&psock->ingress_lock);
-	if (sk_psock_test_state(psock, SK_PSOCK_TX_ENABLED))
+	if (sk_psock_test_state(psock, SK_PSOCK_TX_ENABLED)) {
 		list_add_tail(&msg->list, &psock->ingress_msg);
-	else {
+		ret = true;
+	} else {
 		sk_msg_free(psock->sk, msg);
 		kfree(msg);
+		ret = false;
 	}
 	spin_unlock_bh(&psock->ingress_lock);
+	return ret;
 }
 
 static inline struct sk_msg *sk_psock_dequeue_msg(struct sk_psock *psock)
diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index 846fd672f0e5..902098e221b3 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -445,8 +445,10 @@ int sk_msg_recvmsg(struct sock *sk, struct sk_psock *psock, struct msghdr *msg,
 			if (likely(!peek)) {
 				sge->offset += copy;
 				sge->length -= copy;
-				if (!msg_rx->skb)
+				if (!msg_rx->skb) {
 					sk_mem_uncharge(sk, copy);
+					atomic_sub(copy, &sk->sk_rmem_alloc);
+				}
 				msg_rx->sg.size -= copy;
 
 				if (!sge->length) {
@@ -772,6 +774,8 @@ static void __sk_psock_purge_ingress_msg(struct sk_psock *psock)
 
 	list_for_each_entry_safe(msg, tmp, &psock->ingress_msg, list) {
 		list_del(&msg->list);
+		if (!msg->skb)
+			atomic_sub(msg->sg.size, &psock->sk->sk_rmem_alloc);
 		sk_msg_free(psock->sk, msg);
 		kfree(msg);
 	}
diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
index a7b5b160d107..f882054fae5e 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -56,6 +56,7 @@ static int bpf_tcp_ingress(struct sock *sk, struct sk_psock *psock,
 		}
 
 		sk_mem_charge(sk, size);
+		atomic_add(size, &sk->sk_rmem_alloc);
 		sk_msg_xfer(tmp, msg, i, size);
 		copied += size;
 		if (sge->length)
@@ -74,7 +75,8 @@ static int bpf_tcp_ingress(struct sock *sk, struct sk_psock *psock,
 
 	if (!ret) {
 		msg->sg.start = i;
-		sk_psock_queue_msg(psock, tmp);
+		if (!sk_psock_queue_msg(psock, tmp))
+			atomic_sub(copied, &sk->sk_rmem_alloc);
 		sk_psock_data_ready(sk, psock);
 	} else {
 		sk_msg_free(sk, tmp);
-- 
2.39.5



