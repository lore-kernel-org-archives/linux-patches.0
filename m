Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73B83275B1A;
	Tue, 21 Oct 2025 20:04:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761077066; cv=none; b=sxE+mHVk7U4aGhdOxkyaGGsJsNaZiBBLV4kdkIQBwGRKM6XTaW5gj1IP01yrRAGEtymeJmkPyroh051JQNDtfv8RsoBZ7ExdFDjok9p8lBiXSJsSuhK4K60s0X/GaLfg5+JKEYea+RKEWth+Atrkd0M0T6+U+TuppXGZjKU/zm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761077066; c=relaxed/simple;
	bh=VzPoxuqNop0MvQRhOnoqpOXoAV8Zpim4pqOOcdlQqjM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h0eaonKG1WRYbkS3/Uop46nSg0ht/K8TdGpWd+hM5S4x0Dx+ECwLS+0Xju37izL44sxiu1K3VfH5WC/uqAQD9itG2C/EtnaQtUYz/pXVK4T/3Y2HKfTyPL3CxX9qLJ6y7boI02B5jum8J5Ic2TrTUWOT+9F9iA1Pb69kwX88qWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wjyZSgD7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wjyZSgD7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFF8FC4CEF1;
	Tue, 21 Oct 2025 20:04:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761077066;
	bh=VzPoxuqNop0MvQRhOnoqpOXoAV8Zpim4pqOOcdlQqjM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wjyZSgD7rXOCNvvdCXoKCdEBR4n6hJPrGLajeKRMb9zLhsyll3DfnxTrchqvpfbtH
	 JVIqFU2am4b/RMyLWGIQ4itmNbuAWB/grhiBWTuBcgh3seOj1W019aV9wHK6xWsvST
	 /uAtWeBcS+hx4VGh9SCUk63b8ivmyhdn1oFuWvkQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jason Xing <kerneljasonxing@gmail.com>,
	Neal Cardwell <ncardwell@google.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 124/136] tcp: cache RTAX_QUICKACK metric in a hot cache line
Date: Tue, 21 Oct 2025 21:51:52 +0200
Message-ID: <20251021195038.964318914@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195035.953989698@linuxfoundation.org>
References: <20251021195035.953989698@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 15492700ac41459b54a6683490adcee350ab11e3 ]

tcp_in_quickack_mode() is called from input path for small packets.

It calls __sk_dst_get() which reads sk->sk_dst_cache which has been
put in sock_read_tx group (for good reasons).

Then dst_metric(dst, RTAX_QUICKACK) also needs extra cache line misses.

Cache RTAX_QUICKACK in icsk->icsk_ack.dst_quick_ack to no longer pull
these cache lines for the cases a delayed ACK is scheduled.

After this patch TCP receive path does not longer access sock_read_tx
group.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Jason Xing <kerneljasonxing@gmail.com>
Reviewed-by: Neal Cardwell <ncardwell@google.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Link: https://patch.msgid.link/20250312083907.1931644-1-edumazet@google.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: 833d4313bc1e ("mptcp: reset blackhole on success with non-loopback ifaces")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/inet_connection_sock.h |    3 ++-
 net/core/sock.c                    |    6 +++++-
 net/ipv4/tcp_input.c               |    3 +--
 3 files changed, 8 insertions(+), 4 deletions(-)

--- a/include/net/inet_connection_sock.h
+++ b/include/net/inet_connection_sock.h
@@ -116,7 +116,8 @@ struct inet_connection_sock {
 		#define ATO_BITS 8
 		__u32		  ato:ATO_BITS,	 /* Predicted tick of soft clock	   */
 				  lrcv_flowlabel:20, /* last received ipv6 flowlabel	   */
-				  unused:4;
+				  dst_quick_ack:1, /* cache dst RTAX_QUICKACK		   */
+				  unused:3;
 		unsigned long	  timeout;	 /* Currently scheduled timeout		   */
 		__u32		  lrcvtime;	 /* timestamp of last received data packet */
 		__u16		  last_seg_size; /* Size of last incoming segment	   */
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2547,8 +2547,12 @@ void sk_setup_caps(struct sock *sk, stru
 	u32 max_segs = 1;
 
 	sk->sk_route_caps = dst->dev->features;
-	if (sk_is_tcp(sk))
+	if (sk_is_tcp(sk)) {
+		struct inet_connection_sock *icsk = inet_csk(sk);
+
 		sk->sk_route_caps |= NETIF_F_GSO;
+		icsk->icsk_ack.dst_quick_ack = dst_metric(dst, RTAX_QUICKACK);
+	}
 	if (sk->sk_route_caps & NETIF_F_GSO)
 		sk->sk_route_caps |= NETIF_F_GSO_SOFTWARE;
 	if (unlikely(sk->sk_gso_disabled))
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -331,9 +331,8 @@ static void tcp_enter_quickack_mode(stru
 static bool tcp_in_quickack_mode(struct sock *sk)
 {
 	const struct inet_connection_sock *icsk = inet_csk(sk);
-	const struct dst_entry *dst = __sk_dst_get(sk);
 
-	return (dst && dst_metric(dst, RTAX_QUICKACK)) ||
+	return icsk->icsk_ack.dst_quick_ack ||
 		(icsk->icsk_ack.quick && !inet_csk_in_pingpong_mode(sk));
 }
 


