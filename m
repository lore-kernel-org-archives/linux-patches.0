Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 874631DE4C2;
	Tue, 26 Aug 2025 12:52:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756212759; cv=none; b=a0IqhVdO7PFEbXDshJkIKzaCfBkZ0Jnezw6GPHP6lJdKGrLwPTHAFbk1xeGt2HZ16NEaXCtTF3La24MY9xn0lMIC4cDu8vM3DEfSQ42GIPgUqSAFWmN1gfd1uBF1fCja/4uZFGWKdWQ2HjRiojZljD+uC9bKEKkS9Ga5UbLi+Fc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756212759; c=relaxed/simple;
	bh=epI4Ow7afYyc0fKrO73bm7Fbz5ZC7SvKSqx4OQK5hJQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iqu/h3fQ3YzuEomzqtVVTEe/93xzbeVbpekzEdjk5gRlcBQ1cc8WDWfvqQCE95QFiRq88M0PshQZj/0VBW3rWy453YeOzAnVyvxFOoeodFmc0urJ8oYE3KJh+Xo0rAAb52f0887ET++tnAAVLTImbHJHvbOUQVbk1VAqc6gDHmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pQ+JWrJN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pQ+JWrJN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 155FDC4CEF1;
	Tue, 26 Aug 2025 12:52:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756212759;
	bh=epI4Ow7afYyc0fKrO73bm7Fbz5ZC7SvKSqx4OQK5hJQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pQ+JWrJNFfoRkZstUFFVMbUN3sVrMa8Ow9oFYgCfKwfQfzGvUoFCZhSGKNOtrXc5p
	 VrWQzxDi1JL1zP/TZGkycruccNvHEJMZu+0Mmvh6jNo9NV8VpKO4aXpWnsw/X+tBtN
	 keX8m1kSOdzumS4uW4pBSkTx7ipdVhMxwFGOBph4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	William Liu <will@willsroot.io>,
	Savino Dicanosa <savy@syst3mfailure.io>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 061/587] tls: handle data disappearing from under the TLS ULP
Date: Tue, 26 Aug 2025 13:03:30 +0200
Message-ID: <20250826110954.488275645@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 6db015fc4b5d5f63a64a193f65d98da3a7fc811d ]

TLS expects that it owns the receive queue of the TCP socket.
This cannot be guaranteed in case the reader of the TCP socket
entered before the TLS ULP was installed, or uses some non-standard
read API (eg. zerocopy ones). Replace the WARN_ON() and a buggy
early exit (which leaves anchor pointing to a freed skb) with real
error handling. Wipe the parsing state and tell the reader to retry.

We already reload the anchor every time we (re)acquire the socket lock,
so the only condition we need to avoid is an out of bounds read
(not having enough bytes in the socket for previously parsed record len).

If some data was read from under TLS but there's enough in the queue
we'll reload and decrypt what is most likely not a valid TLS record.
Leading to some undefined behavior from TLS perspective (corrupting
a stream? missing an alert? missing an attack?) but no kernel crash
should take place.

Reported-by: William Liu <will@willsroot.io>
Reported-by: Savino Dicanosa <savy@syst3mfailure.io>
Link: https://lore.kernel.org/tFjq_kf7sWIG3A7CrCg_egb8CVsT_gsmHAK0_wxDPJXfIzxFAMxqmLwp3MlU5EHiet0AwwJldaaFdgyHpeIUCS-3m3llsmRzp9xIOBR4lAI=@syst3mfailure.io
Fixes: 84c61fe1a75b ("tls: rx: do not use the standard strparser")
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20250807232907.600366-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tls/tls.h      |  2 +-
 net/tls/tls_strp.c | 11 ++++++++---
 net/tls/tls_sw.c   |  3 ++-
 3 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/net/tls/tls.h b/net/tls/tls.h
index 02038d0381b7..5dc61c85c076 100644
--- a/net/tls/tls.h
+++ b/net/tls/tls.h
@@ -192,7 +192,7 @@ void tls_strp_msg_done(struct tls_strparser *strp);
 int tls_rx_msg_size(struct tls_strparser *strp, struct sk_buff *skb);
 void tls_rx_msg_ready(struct tls_strparser *strp);
 
-void tls_strp_msg_load(struct tls_strparser *strp, bool force_refresh);
+bool tls_strp_msg_load(struct tls_strparser *strp, bool force_refresh);
 int tls_strp_msg_cow(struct tls_sw_context_rx *ctx);
 struct sk_buff *tls_strp_msg_detach(struct tls_sw_context_rx *ctx);
 int tls_strp_msg_hold(struct tls_strparser *strp, struct sk_buff_head *dst);
diff --git a/net/tls/tls_strp.c b/net/tls/tls_strp.c
index bea60b0160d1..6ce64a6e4495 100644
--- a/net/tls/tls_strp.c
+++ b/net/tls/tls_strp.c
@@ -474,7 +474,7 @@ static void tls_strp_load_anchor_with_queue(struct tls_strparser *strp, int len)
 	strp->stm.offset = offset;
 }
 
-void tls_strp_msg_load(struct tls_strparser *strp, bool force_refresh)
+bool tls_strp_msg_load(struct tls_strparser *strp, bool force_refresh)
 {
 	struct strp_msg *rxm;
 	struct tls_msg *tlm;
@@ -483,8 +483,11 @@ void tls_strp_msg_load(struct tls_strparser *strp, bool force_refresh)
 	DEBUG_NET_WARN_ON_ONCE(!strp->stm.full_len);
 
 	if (!strp->copy_mode && force_refresh) {
-		if (WARN_ON(tcp_inq(strp->sk) < strp->stm.full_len))
-			return;
+		if (unlikely(tcp_inq(strp->sk) < strp->stm.full_len)) {
+			WRITE_ONCE(strp->msg_ready, 0);
+			memset(&strp->stm, 0, sizeof(strp->stm));
+			return false;
+		}
 
 		tls_strp_load_anchor_with_queue(strp, strp->stm.full_len);
 	}
@@ -494,6 +497,8 @@ void tls_strp_msg_load(struct tls_strparser *strp, bool force_refresh)
 	rxm->offset	= strp->stm.offset;
 	tlm = tls_msg(strp->anchor);
 	tlm->control	= strp->mark;
+
+	return true;
 }
 
 /* Called with lock held on lower socket */
diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 4905a81c4ac1..c9b53472e955 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -1380,7 +1380,8 @@ tls_rx_rec_wait(struct sock *sk, struct sk_psock *psock, bool nonblock,
 			return sock_intr_errno(timeo);
 	}
 
-	tls_strp_msg_load(&ctx->strp, released);
+	if (unlikely(!tls_strp_msg_load(&ctx->strp, released)))
+		return tls_rx_rec_wait(sk, psock, nonblock, false);
 
 	return 1;
 }
-- 
2.50.1



