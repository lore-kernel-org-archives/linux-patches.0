Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3324C335BA3;
	Mon, 18 Aug 2025 13:47:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524857; cv=none; b=ePR7qW/u7QzkXNFVfrx82VAwu3JclAmKCHb7oLD4AeBIlxn5U7680uV+ErgMaB8UsRJfGb7rRO1jYI8pm1Wmy5vpYtPO6h1NpVK/DTfAG3GaqJ+6fg2ymY5iSgVq9ohJLWETA0V84o6ZHrDC+73TgP7L4B5EgooCg9DuAd/joTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524857; c=relaxed/simple;
	bh=gXp3QyHoPxrt7YfWZekhZ8bl8oitC63ZHE6ivkXgyw8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VlAjYfwJGOyQ/Ml7cRjazCmt+Rj+lFQDSafEcbTgGw5yjgpMlKuzmy/beAPYwF31IbxOoBhAVK6PPFtBVau6BrbBdJIcQGxb1i2aYAyOh8PvSnDrHOoSVUYo796wzZvErcPMarto4vo87GeTTLSAlla3UtFRFki2xLiru3fxeLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ftf9F0mm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ftf9F0mm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B9DAC4CEEB;
	Mon, 18 Aug 2025 13:47:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524857;
	bh=gXp3QyHoPxrt7YfWZekhZ8bl8oitC63ZHE6ivkXgyw8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ftf9F0mmUTI1T1rlD6wfQjhbN37Leg+ql6XdlVbg2M+qlOrDLdUMNQBCC8xOcBqF4
	 nyeABk4KUVZCONtq70sTSVdV8dToC6rLZEvrjcSOZ5g6X57IXL4teyk+96TDyVb1d6
	 9dkKeJNKekA4SnBq21VRqm9dehy1T2xBf5jjcU6Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	William Liu <will@willsroot.io>,
	Savino Dicanosa <savy@syst3mfailure.io>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 084/570] tls: handle data disappearing from under the TLS ULP
Date: Mon, 18 Aug 2025 14:41:11 +0200
Message-ID: <20250818124509.055271477@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index 774859b63f0d..4e077068e6d9 100644
--- a/net/tls/tls.h
+++ b/net/tls/tls.h
@@ -196,7 +196,7 @@ void tls_strp_msg_done(struct tls_strparser *strp);
 int tls_rx_msg_size(struct tls_strparser *strp, struct sk_buff *skb);
 void tls_rx_msg_ready(struct tls_strparser *strp);
 
-void tls_strp_msg_load(struct tls_strparser *strp, bool force_refresh);
+bool tls_strp_msg_load(struct tls_strparser *strp, bool force_refresh);
 int tls_strp_msg_cow(struct tls_sw_context_rx *ctx);
 struct sk_buff *tls_strp_msg_detach(struct tls_sw_context_rx *ctx);
 int tls_strp_msg_hold(struct tls_strparser *strp, struct sk_buff_head *dst);
diff --git a/net/tls/tls_strp.c b/net/tls/tls_strp.c
index 095cf31bae0b..d71643b494a1 100644
--- a/net/tls/tls_strp.c
+++ b/net/tls/tls_strp.c
@@ -475,7 +475,7 @@ static void tls_strp_load_anchor_with_queue(struct tls_strparser *strp, int len)
 	strp->stm.offset = offset;
 }
 
-void tls_strp_msg_load(struct tls_strparser *strp, bool force_refresh)
+bool tls_strp_msg_load(struct tls_strparser *strp, bool force_refresh)
 {
 	struct strp_msg *rxm;
 	struct tls_msg *tlm;
@@ -484,8 +484,11 @@ void tls_strp_msg_load(struct tls_strparser *strp, bool force_refresh)
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
@@ -495,6 +498,8 @@ void tls_strp_msg_load(struct tls_strparser *strp, bool force_refresh)
 	rxm->offset	= strp->stm.offset;
 	tlm = tls_msg(strp->anchor);
 	tlm->control	= strp->mark;
+
+	return true;
 }
 
 /* Called with lock held on lower socket */
diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 549d1ea01a72..51c98a007dda 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -1384,7 +1384,8 @@ tls_rx_rec_wait(struct sock *sk, struct sk_psock *psock, bool nonblock,
 			return sock_intr_errno(timeo);
 	}
 
-	tls_strp_msg_load(&ctx->strp, released);
+	if (unlikely(!tls_strp_msg_load(&ctx->strp, released)))
+		return tls_rx_rec_wait(sk, psock, nonblock, false);
 
 	return 1;
 }
-- 
2.50.1



