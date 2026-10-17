Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A67338654F;
	Sat, 17 Oct 2026 16:22:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254145; cv=none; b=gHt+j85rzWLC46IXrUIg8bQdZr1VYJl4fA6Ze4lt/UnFafiXK0RKHC1dlaPCv25uc8BWBMgmfbU3hT8VqXokqAdjckmbYhiHgGvZM+fBBAnuTbsPINE5xT1wYFoHwF6AgNWy/Eh0WRb2JqNTXKrxhDCE5cKKP0sIPZrWYJUiNVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254145; c=relaxed/simple;
	bh=D4axGK53X/OHIdCALnlprPgw6q0gPkhfH2YgWiLgOKw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ghtSPJl0XXRHdaHOpkh6L2aK+oKYt9y23X+OWNGTA1J3OWiHtbosFTFgzl243wyxOmncQlpw80/djNH+2kJa5ljvO1CntD2sHNYQrjy4ZmW7+ThYvY96qR1KfKYO6jWJ0zzrnntUsExRjvDGWVcpaMJ4EWNPrxWE+S3b7zj7au8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GKjBsk/q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GKjBsk/q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5A0B1F000C4;
	Sat, 17 Oct 2026 16:22:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254144;
	bh=ZOKhwD2X9t/ogaw1Y6sbqHX2BYrBMPD34PS0g9fQ/uc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GKjBsk/qIISw0URrRJhuRtidCwTApFRiPKDjhL1rnszHHVjS9BDdkCp9YdL/I260Y
	 z6VUbfuZK7fT535VOzb8IR8DikQ5WpphrV/PCMyXRhrc65pDyfXaHZmAHLrf93LcQH
	 +Gvw9F1lvF5GDAKikrt9HJE2txEVAuJVnQ7KNpSY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jason Xing <kerneljasonxing@gmail.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 351/869] tcp: Remove sk->sk_prot->orphan_count.
Date: Sat, 17 Oct 2026 17:53:12 +0200
Message-ID: <20261017160046.099953980@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

From: Kuniyuki Iwashima <kuniyu@google.com>

[ Upstream commit 7051b54fb5aa2d0b77657aef7c272471b36c0327 ]

TCP tracks the number of orphaned (SOCK_DEAD but not yet destructed)
sockets in tcp_orphan_count.

In some code that was shared with DCCP, tcp_orphan_count is referenced
via sk->sk_prot->orphan_count.

Let's reference tcp_orphan_count directly.

inet_csk_prepare_for_destroy_sock() is moved to inet_connection_sock.c
due to header dependency.

Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Jason Xing <kerneljasonxing@gmail.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20250829215641.711664-1-kuniyu@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Only the TCP-only users are converted: the code paths shared with DCCP
keep using sk->sk_prot->orphan_count, so DCCP orphan accounting is not
affected, and the struct proto member stays.

Stable-dep-of: 1bbf0ced1d9d ("tcp: fix stale per-CPU tcp_tw_isn leak enabling ISN prediction")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/chelsio/inline_crypto/chtls/chtls_cm.c    |  4 ++--
 .../ethernet/chelsio/inline_crypto/chtls/chtls_cm.h    |  1 -
 include/net/tcp.h                                      | 10 ++++++++++
 net/ipv4/tcp.c                                         |  2 +-
 4 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c
index 6d69c19ea7c30..5f9eb030aec9a 100644
--- a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c
+++ b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c
@@ -505,7 +505,7 @@ static void reset_listen_child(struct sock *child)
 
 	chtls_send_reset(child, CPL_ABORT_SEND_RST, skb);
 	sock_orphan(child);
-	INC_ORPHAN_COUNT(child);
+	tcp_orphan_count_inc();
 	if (child->sk_state == TCP_CLOSE)
 		inet_csk_destroy_sock(child);
 }
@@ -870,7 +870,7 @@ static void do_abort_syn_rcv(struct sock *child, struct sock *parent)
 		 * created only after 3 way handshake is done.
 		 */
 		sock_orphan(child);
-		INC_ORPHAN_COUNT(child);
+		tcp_orphan_count_inc();
 		chtls_release_resources(child);
 		chtls_conn_done(child);
 	} else {
diff --git a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.h b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.h
index f61ca657601ca..e949e4e580661 100644
--- a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.h
+++ b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.h
@@ -95,7 +95,6 @@ struct deferred_skb_cb {
 #define WSCALE_OK(tp) ((tp)->rx_opt.wscale_ok)
 #define TSTAMP_OK(tp) ((tp)->rx_opt.tstamp_ok)
 #define SACK_OK(tp) ((tp)->rx_opt.sack_ok)
-#define INC_ORPHAN_COUNT(sk) this_cpu_inc(*(sk)->sk_prot->orphan_count)
 
 /* TLS SKB */
 #define skb_ulp_tls_inline(skb)      (ULP_SKB_CB(skb)->ulp.tls.ofld)
diff --git a/include/net/tcp.h b/include/net/tcp.h
index ad9af706085ab..115f878540768 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -54,6 +54,16 @@ extern struct inet_hashinfo tcp_hashinfo;
 DECLARE_PER_CPU(unsigned int, tcp_orphan_count);
 int tcp_orphan_count_sum(void);
 
+static inline void tcp_orphan_count_inc(void)
+{
+	this_cpu_inc(tcp_orphan_count);
+}
+
+static inline void tcp_orphan_count_dec(void)
+{
+	this_cpu_dec(tcp_orphan_count);
+}
+
 DECLARE_PER_CPU(u32, tcp_tw_isn);
 
 void tcp_time_wait(struct sock *sk, int state, int timeo);
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 21c64ca9bb9b4..2ab07164eba19 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -3163,7 +3163,7 @@ void __tcp_close(struct sock *sk, long timeout)
 	/* remove backlog if any, without releasing ownership. */
 	__release_sock(sk);
 
-	this_cpu_inc(tcp_orphan_count);
+	tcp_orphan_count_inc();
 
 	/* Have we already been destroyed by a softirq or backlog? */
 	if (state != TCP_CLOSE && sk->sk_state == TCP_CLOSE)
-- 
2.53.0



