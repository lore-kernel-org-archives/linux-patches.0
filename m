Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60F5415CAE
	for <patches@lists.linux.dev>; Tue,  8 Nov 2022 14:16:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A93D4C4347C;
	Tue,  8 Nov 2022 14:16:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667916968;
	bh=BG9hX42uaxvDmxwv+TA9hQ0O7yzHlnkM65obWE0fAUw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E706R7osADLybyE9xOZt6doRqCcwULAo0mBq62I1y1H00m0+/ll7vK1Cm+BKl7rIV
	 dMvzSnK2qTB7BOJA2p3svLcNpi2A3L7IfbKuaLaT0U5oZG6OZOc3sJ9JUZ5OSSr6kW
	 2rfUUNOOOeLSQx2T+I0hrz8piApOqxUV6PFGxZnA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 6.0 159/197] net: remove SOCK_SUPPORT_ZC from sockmap
Date: Tue,  8 Nov 2022 14:39:57 +0100
Message-Id: <20221108133402.164912730@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133354.787209461@linuxfoundation.org>
References: <20221108133354.787209461@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Pavel Begunkov <asml.silence@gmail.com>

commit fee9ac06647e59a69fb7aec58f25267c134264b4 upstream.

sockmap replaces ->sk_prot with its own callbacks, we should remove
SOCK_SUPPORT_ZC as the new proto doesn't support msghdr::ubuf_info.

Cc: <stable@vger.kernel.org> # 6.0
Reported-by: Jakub Kicinski <kuba@kernel.org>
Fixes: e993ffe3da4bc ("net: flag sockets supporting msghdr originated zerocopy")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/sock.h  |    7 +++++++
 net/ipv4/tcp_bpf.c  |    4 ++--
 net/ipv4/udp_bpf.c  |    4 ++--
 net/unix/unix_bpf.c |    8 ++++----
 4 files changed, 15 insertions(+), 8 deletions(-)

--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1871,6 +1871,13 @@ void sock_kfree_s(struct sock *sk, void
 void sock_kzfree_s(struct sock *sk, void *mem, int size);
 void sk_send_sigurg(struct sock *sk);
 
+static inline void sock_replace_proto(struct sock *sk, struct proto *proto)
+{
+	if (sk->sk_socket)
+		clear_bit(SOCK_SUPPORT_ZC, &sk->sk_socket->flags);
+	WRITE_ONCE(sk->sk_prot, proto);
+}
+
 struct sockcm_cookie {
 	u64 transmit_time;
 	u32 mark;
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -607,7 +607,7 @@ int tcp_bpf_update_proto(struct sock *sk
 		} else {
 			sk->sk_write_space = psock->saved_write_space;
 			/* Pairs with lockless read in sk_clone_lock() */
-			WRITE_ONCE(sk->sk_prot, psock->sk_proto);
+			sock_replace_proto(sk, psock->sk_proto);
 		}
 		return 0;
 	}
@@ -620,7 +620,7 @@ int tcp_bpf_update_proto(struct sock *sk
 	}
 
 	/* Pairs with lockless read in sk_clone_lock() */
-	WRITE_ONCE(sk->sk_prot, &tcp_bpf_prots[family][config]);
+	sock_replace_proto(sk, &tcp_bpf_prots[family][config]);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(tcp_bpf_update_proto);
--- a/net/ipv4/udp_bpf.c
+++ b/net/ipv4/udp_bpf.c
@@ -141,14 +141,14 @@ int udp_bpf_update_proto(struct sock *sk
 
 	if (restore) {
 		sk->sk_write_space = psock->saved_write_space;
-		WRITE_ONCE(sk->sk_prot, psock->sk_proto);
+		sock_replace_proto(sk, psock->sk_proto);
 		return 0;
 	}
 
 	if (sk->sk_family == AF_INET6)
 		udp_bpf_check_v6_needs_rebuild(psock->sk_proto);
 
-	WRITE_ONCE(sk->sk_prot, &udp_bpf_prots[family]);
+	sock_replace_proto(sk, &udp_bpf_prots[family]);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(udp_bpf_update_proto);
--- a/net/unix/unix_bpf.c
+++ b/net/unix/unix_bpf.c
@@ -145,12 +145,12 @@ int unix_dgram_bpf_update_proto(struct s
 
 	if (restore) {
 		sk->sk_write_space = psock->saved_write_space;
-		WRITE_ONCE(sk->sk_prot, psock->sk_proto);
+		sock_replace_proto(sk, psock->sk_proto);
 		return 0;
 	}
 
 	unix_dgram_bpf_check_needs_rebuild(psock->sk_proto);
-	WRITE_ONCE(sk->sk_prot, &unix_dgram_bpf_prot);
+	sock_replace_proto(sk, &unix_dgram_bpf_prot);
 	return 0;
 }
 
@@ -158,12 +158,12 @@ int unix_stream_bpf_update_proto(struct
 {
 	if (restore) {
 		sk->sk_write_space = psock->saved_write_space;
-		WRITE_ONCE(sk->sk_prot, psock->sk_proto);
+		sock_replace_proto(sk, psock->sk_proto);
 		return 0;
 	}
 
 	unix_stream_bpf_check_needs_rebuild(psock->sk_proto);
-	WRITE_ONCE(sk->sk_prot, &unix_stream_bpf_prot);
+	sock_replace_proto(sk, &unix_stream_bpf_prot);
 	return 0;
 }
 


