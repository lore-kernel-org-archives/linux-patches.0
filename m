Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705326;
	b=Fndau8sf+A6hyO46cB7Cig8Az9qUQQsg7pP71h4Ic85kOUkYMMVLtkh+ht5shFZU9BuP
	 A14xQatXL/L/4zJuUlyU+oyoGIav6Q1nupkhzpgwOdW8HC2ngmB04GnTppnMoK8lRBw1L
	 +qdzq5ojKS4D/8Xli2N9xpJ4+FaOlDjSfwvza1PdlVdW7Co43dg0y1YCzaCsrzlp0k0yx
	 0jwAB8b7bPIVsCyMP2WDItATuxOkRyYV7d+UKba9U0cBnNrMKoHKrA3fRIyntB+Xzem8Y
	 RjuJbiBmwdYrsLe8TvfOh/48Mq2AvuRlDeVwqUl33cFOMbqZr51Al9hmpKsYrqm+rvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705326;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=G+jPcelxXPIbnCyWsq3Eiab9Ayuuxubv6tTOBeGQDcM=;
	b=tCSrAFzG0QZ/6vt/zuxAaBMvYjZZ2+861Kbi5ClzR0BLSAd3dOyCBuB2yUpNBWWK9OPA
	 cVi+Rq9uPt5eiqF34mTTm+H8zBQJxOkO0qMEq71W/ppIYGTlXYWs/u8jb8dvAX3UIZ2qf
	 PqV0mpjSUHldoh8hQjQG/rsDYAFUemp4m6wr3EMgoKltJYH/+GurYMVTYXBuqZ7Xi2SNr
	 1I8X6absQA1K3G4jeLN4sbODu7DgjDHY5N6NZvHOsfbBSQdW6nqtu+a8a4IybX0F5P9Vt
	 Xve5ZpCMskJhJbgR7KaM16olnV/ofjSUzg/utBa/qC6rRvljap89GIKDQ1jpP/eXsbw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xr6zSB6c;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22E59606A31C;
	Thu, 26 Nov 2026 15:02:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xr6zSB6c
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BD521F000E1;
	Thu, 26 Nov 2026 15:02:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705325;
	bh=G+jPcelxXPIbnCyWsq3Eiab9Ayuuxubv6tTOBeGQDcM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xr6zSB6cbB8bSDSaxiFrsHyaCJrniYt838efh001GHOyWwEvffJAp8AzOq9iTnzfo
	 HZM9NC4svqe3GCYbgtCwutB+LHMU5iSbpLf21jaXEpmQcDpAgt+hxeAEV0DiebzUr2
	 cNWVoZ27Y4hloC2l/gRExY1vJ4x6bZMUm4A/w9mo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ofri Zangi <ofriz@xsightlabs.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 159/319] tls: fix async encryption race on weakly ordered architectures
Date: Thu, 26 Nov 2026 15:38:47 +0100
Message-ID: <20261126144010.333801849@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ofri Zangi <ofriz@xsightlabs.com>

[ Upstream commit a2fd526d644233d6a892c28173f07c61e21e4c93 ]

With async encryption, a record can be transmitted without its TLS
header on weakly ordered architectures such as arm64, because the
consumer may observe rec->tx_ready set while still seeing the old
scatterlist entry.

tls_encrypt_done() restores the TLS header in the scatterlist entry
(sge->offset -= prot->prepend_size, sge->length += prot->prepend_size)
and then publishes the record with smp_store_mb(rec->tx_ready, true).
On another CPU, tls_tx_records() checks rec->tx_ready with READ_ONCE()
and then reads the entry in tls_push_sg().

Nothing orders these accesses. The barrier in smp_store_mb() comes
after the tx_ready store, so it does not order the earlier scatterlist
update before it. On the reader side, READ_ONCE() does not order the
later loads of sge->offset and sge->length. The reader can therefore
see tx_ready set together with the old offset and length, and pushes
the record without its header.

Publish tx_ready with smp_store_release() in tls_encrypt_done() and read
it with smp_load_acquire() in tls_tx_records(), so that observing
tx_ready guarantees the restored scatterlist entry is visible. Keep the
full barrier that smp_store_mb() provided as an explicit smp_mb(), as
it is still needed to order the tx_ready store before the tx_list head
check.

The issue was discovered during development on an arm64 system.
A curl download test over kTLS failed with:

  curl: (56) OpenSSL SSL_read: error:0A00010B:SSL routines::wrong version number, errno 0

Fixes: a42055e8d2c3 ("net/tls: Add support for async encryption of records for performance")
Signed-off-by: Ofri Zangi <ofriz@xsightlabs.com>
Link: https://patch.msgid.link/20261108-tls-async-tx-ordering-v1-1-f9a1844ca88e@xsightlabs.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tls/tls_sw.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 37e92d1386e2f..4ce4005c4cc14 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -433,7 +433,8 @@ int tls_tx_records(struct sock *sk, int flags)
 
 	/* Tx all ready records */
 	list_for_each_entry_safe(rec, tmp, &ctx->tx_list, list) {
-		if (READ_ONCE(rec->tx_ready)) {
+		/* Pairs with smp_store_release() in tls_encrypt_done() */
+		if (smp_load_acquire(&rec->tx_ready)) {
 			if (flags == -1)
 				tx_flags = rec->tx_flags;
 			else
@@ -498,8 +499,14 @@ static void tls_encrypt_done(struct crypto_async_request *req, int err)
 	if (rec) {
 		struct tls_rec *first_rec;
 
-		/* Mark the record as ready for transmission */
-		smp_store_mb(rec->tx_ready, true);
+		/* Mark the record as ready for transmission. Pairs with
+		 * smp_load_acquire() in tls_tx_records(): the sge
+		 * offset/length update above must be visible before tx_ready.
+		 */
+		smp_store_release(&rec->tx_ready, true);
+
+		/* Order the tx_ready store before the tx_list head check */
+		smp_mb();
 
 		/* If received record is at head of tx_list, schedule tx */
 		first_rec = list_first_entry(&ctx->tx_list,
-- 
2.53.0



