Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021634;
	b=3aJSyvReikpU6itJD1Inh5q1G0yaiLwGxhXBTaWoFOF5VRWSe5RsjEoKyb3SMQfY8weE
	 KEAJsMI962Pn6EB5INOTAQySJS2yhmZTkHPmw1NzAP1HSZeJEDHyMvoYDTQtLrB31uZ90
	 vDLgDOZROKpfs7sweuHmneRBoStNvtrgZ4D1vgbgTvk9fFp6l5cgivVB7IOVsmx3ifdjS
	 a51sInQHcpZb6e2+MirRsZaCzVJd9JcT3nwyEWQlQkn8csfw2EyJ1NGFYK/BA8s7vorDo
	 9gnpdxthDwVsDMsA7wPlfM3yPZPFBdb2MPft2hV0gGoHq6+pFQ2u3+yteQyHXJ/rirw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021634;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EwB7ApRbqlih5z8U31rUxKKArG0V2/KBRWkSacwFdmA=;
	b=QnsezppO4wVt3bNXgfOgdwyztIFZ3OaerErHF0j8w7/vI7We28ztmuGqgn20SwUf4XtD
	 tuj+uYSK6UHuPHeVKy01Hpff2/WvyzS2n8ht1sroS8q1YKAOQ77WL82FQJoWr0tXacy3K
	 0tLcbCEpVvt1inoQqltfDao91Ry1Na1gFuPi1AH6Li0fyFEqtgU7v3RBAVeHtlSB+vKGz
	 MLvqWsfTiIMtmZmLozzQ5ytl/YeXDBmA9vfBrmLyKgSS8hk6t5QRc0qWJztF9Z6U78GDa
	 2xkz0Aat/3bPRcptie5Vmip1mfm16hIfte21STc/iADKUahJgsz7YXPYf9ZRLHBmmOQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sKqDKkXx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BE8E606A339;
	Wed, 18 Nov 2026 17:07:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sKqDKkXx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C049E1F000C4;
	Wed, 18 Nov 2026 17:07:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021634;
	bh=EwB7ApRbqlih5z8U31rUxKKArG0V2/KBRWkSacwFdmA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sKqDKkXxErOyGrjN1K+BRdd7ZypqBMZ4DutCSUPxDuSkLp2ulU/8Lgm+aocrA5skU
	 cu0SRTupblby6LxdFARCSesfWYabvRv7H+1C1IZ6E0ktWBA3xltmczFBoc1l9YFt6c
	 fLFffJggqsQdbQsRicBLpQokgFIHOZ1day6LN/hI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2378/2651] tls: fix the open record check in the max payload size setsockopt
Date: Wed, 18 Nov 2026 16:00:18 +0100
Message-ID: <20261118150411.079808345@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiayuan Chen <jiayuan.chen@linux.dev>

[ Upstream commit ed642349d87dd7067a44c30319f0cffd22780376 ]

do_tls_setsockopt_tx_payload_len() refuses to resize records while one is
open, but the check is broken in two ways.

It reaches for the open record through tls_sw_ctx_tx(), an unchecked cast
of ctx->priv_ctx_tx.  Under device offload that pointer is a
tls_offload_context_tx, so the check reads a field of the wrong struct: it
returns EBUSY on whatever happens to be there, and never sees the record
that really is open.  Dispatch on tx_conf.

The socket lock alone is also not enough to tell no sender is in flight.
The device tx path drops it in sk_stream_wait_memory() after
tls_push_record() cleared open_record, so setsockopt can slip in
mid-sendmsg and shrink the limit.  tls_push_data() latches the limit once
per call, and a record left open by MSG_MORE can then be bigger than the
new limit, making the u32 subtraction in the copy clamp wrap around and
build an oversized record.  Take tx_lock like the sendmsg paths do so
setsockopt waits for in-flight senders.  Re-reading the limit inside the
tls_push_data() loop could close the wrap too, but a parked sender would
still finish with the old limit, so serializing on tx_lock is simpler.

Take tx_lock interruptible, as tls_sw_sendmsg() does.  Both sendmsg paths
keep it across sk_stream_wait_memory(), which sleeps until the peer reads,
so a plain mutex_lock() could park setsockopt in D state for as long as
the sender waits.  The lock_sock() after it is fine uninterruptible: a
sender sleeping for memory has released the socket lock, so that wait only
covers short critical sections, like every other setsockopt.

Fixes: 82cb5be6ad64 ("net/tls: support setting the maximum payload size")
Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Link: https://patch.msgid.link/20261020121240.29082-1-jiayuan.chen@linux.dev
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tls/tls_main.c | 22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
index fbb274287aa5f..2d1cde3f61886 100644
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -833,15 +833,26 @@ static int do_tls_setsockopt_no_pad(struct sock *sk, sockptr_t optval,
 	return rc;
 }
 
+static bool tls_tx_record_is_open(struct tls_context *ctx)
+{
+	switch (ctx->tx_conf) {
+	case TLS_SW:
+		return !!tls_sw_ctx_tx(ctx)->open_rec;
+	case TLS_HW:
+		return !!tls_offload_ctx_tx(ctx)->open_record;
+	default:
+		return false;
+	}
+}
+
 static int do_tls_setsockopt_tx_payload_len(struct sock *sk, sockptr_t optval,
 					    unsigned int optlen)
 {
 	struct tls_context *ctx = tls_get_ctx(sk);
-	struct tls_sw_context_tx *sw_ctx = tls_sw_ctx_tx(ctx);
 	u16 value;
 	bool tls_13 = ctx->prot_info.version == TLS_1_3_VERSION;
 
-	if (sw_ctx && sw_ctx->open_rec)
+	if (tls_tx_record_is_open(ctx))
 		return -EBUSY;
 
 	if (sockptr_is_null(optval) || optlen != sizeof(value))
@@ -862,6 +873,7 @@ static int do_tls_setsockopt_tx_payload_len(struct sock *sk, sockptr_t optval,
 static int do_tls_setsockopt(struct sock *sk, int optname, sockptr_t optval,
 			     unsigned int optlen)
 {
+	struct tls_context *ctx;
 	int rc = 0;
 
 	switch (optname) {
@@ -881,9 +893,15 @@ static int do_tls_setsockopt(struct sock *sk, int optname, sockptr_t optval,
 		rc = do_tls_setsockopt_no_pad(sk, optval, optlen);
 		break;
 	case TLS_TX_MAX_PAYLOAD_LEN:
+		ctx = tls_get_ctx(sk);
+		/* Senders sleep with tx_lock held, so take it interruptible */
+		rc = mutex_lock_interruptible(&ctx->tx_lock);
+		if (rc)
+			break;
 		lock_sock(sk);
 		rc = do_tls_setsockopt_tx_payload_len(sk, optval, optlen);
 		release_sock(sk);
+		mutex_unlock(&ctx->tx_lock);
 		break;
 	default:
 		rc = -ENOPROTOOPT;
-- 
2.53.0



