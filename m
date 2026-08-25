Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEC6825393E;
	Tue, 25 Aug 2026 13:52:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787665978; cv=none; b=SZVQzVqdx7x/KmVX/5XzbmnOggA9EXgmlXDaNOdX/KcsoGepe/ymXsFkKmByxPz5sk9XtaXurWkwbaPRDq3fxZFjtYjlj7lKTkpkIIjaZbE+oocrLruYkeFnLgZfW6hwxtMwBAUeFOhq0gicCmV+aGuZUAcL2BOzzWEBfaIIwI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787665978; c=relaxed/simple;
	bh=02pAOK4Qe2+/IGqNmcD8QoEHVakxQmxl1KflF/Y9wOw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jaNc6813NZ9Y9wUNrXd0f35pnhJ+TG7npON+dhKBFrNlCysw2A0FnbOVFvLQzlF7DaunRsmCDA7xUtZjYP8S7/XVC54bwE7pD2pthxnE90sOMGtjCzS1Gb2eUptN02rwqYQP7QLR84e78MEh5Fm2Oi7zqEpGwYn1BxdihHogNhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OUrFeY0B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OUrFeY0B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A1D31F000E9;
	Tue, 25 Aug 2026 13:52:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787665976;
	bh=3xYTixytdEDLuGUFvIjPrDIxtP1sIt1iXQIlNb3j6zo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OUrFeY0B31p1/Ijma0q03zwH2q2NCsUfK9H6lD/hCDzFf+mQYAM+ltxS81xQW3prw
	 n0dQUE1Pmjvv8KgiSfAGVqOctZhF5XKv5joER8WH7KAPIL2JbJsIrd7s4imf00GEfO
	 VoWS5HjRwSg4yBECNqOXLb/D7KwpEHP6x0Lx2XJw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	William Liu <will@willsroot.io>,
	Savino Dicanosa <savy@syst3mfailure.io>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Artem Dinaburg <artem@trailofbits.com>
Subject: [PATCH 6.1 40/79] tls: handle data disappearing from under the TLS ULP
Date: Tue, 25 Aug 2026 15:26:20 +0200
Message-ID: <20260825132543.270419319@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.677185791@linuxfoundation.org>
References: <20260825132541.677185791@linuxfoundation.org>
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

From: Jakub Kicinski <kuba@kernel.org>

commit 6db015fc4b5d5f63a64a193f65d98da3a7fc811d upstream.

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
Assisted-by: Codex:GPT-5
Signed-off-by: Artem Dinaburg <artem@trailofbits.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/tls/tls.h      |    2 +-
 net/tls/tls_strp.c |   11 ++++++++---
 net/tls/tls_sw.c   |    3 ++-
 3 files changed, 11 insertions(+), 5 deletions(-)

--- a/net/tls/tls.h
+++ b/net/tls/tls.h
@@ -147,7 +147,7 @@ void tls_strp_msg_done(struct tls_strpar
 int tls_rx_msg_size(struct tls_strparser *strp, struct sk_buff *skb);
 void tls_rx_msg_ready(struct tls_strparser *strp);
 
-void tls_strp_msg_load(struct tls_strparser *strp, bool force_refresh);
+bool tls_strp_msg_load(struct tls_strparser *strp, bool force_refresh);
 int tls_strp_msg_cow(struct tls_sw_context_rx *ctx);
 struct sk_buff *tls_strp_msg_detach(struct tls_sw_context_rx *ctx);
 int tls_strp_msg_hold(struct tls_strparser *strp, struct sk_buff_head *dst);
--- a/net/tls/tls_strp.c
+++ b/net/tls/tls_strp.c
@@ -481,7 +481,7 @@ static void tls_strp_load_anchor_with_qu
 	strp->stm.offset = offset;
 }
 
-void tls_strp_msg_load(struct tls_strparser *strp, bool force_refresh)
+bool tls_strp_msg_load(struct tls_strparser *strp, bool force_refresh)
 {
 	struct strp_msg *rxm;
 	struct tls_msg *tlm;
@@ -490,8 +490,11 @@ void tls_strp_msg_load(struct tls_strpar
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
@@ -501,6 +504,8 @@ void tls_strp_msg_load(struct tls_strpar
 	rxm->offset	= strp->stm.offset;
 	tlm = tls_msg(strp->anchor);
 	tlm->control	= strp->mark;
+
+	return true;
 }
 
 /* Called with lock held on lower socket */
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -1510,7 +1510,8 @@ tls_rx_rec_wait(struct sock *sk, struct
 			return sock_intr_errno(timeo);
 	}
 
-	tls_strp_msg_load(&ctx->strp, released);
+	if (unlikely(!tls_strp_msg_load(&ctx->strp, released)))
+		return tls_rx_rec_wait(sk, psock, nonblock, false);
 
 	return 1;
 }


