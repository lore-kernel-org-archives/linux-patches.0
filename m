Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704463;
	b=M6sfnfKxW8sUklQ5z7sh1Orv8yAPltC3OTInx3IHOrclXMjAtV/HHniC+lpSYPWlWRp9
	 pDNFgoJP+P+ojC38orATxlB2N/iD8fCBaCvB8SYA7eLNK/OaPRj76C8OIHY5ew24MiboM
	 Lkv4jLFEzyLAASF3xMZTOcSNDIGSPvcRfuuVulg3mSDDJuOrnxQ0dJpWmMocQ3sq7o1UJ
	 CR9UCcF8AGj8ETKbrNUbq/0Qp5YVfQjShhXHs+PJCjNK8wEiMStGVUj10u+k6C0yRGB7P
	 XSTIfhV+jC7WLhFBWvgBCG49+JKquYqprbZran5TpQH6FN34FBZy0XP3nWnZVOHz+UA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704463;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mqKH/PH6ZqptXwLeXfrHTYVFqXWRCi07f3TAzMwCxlk=;
	b=Bnjd72UVQVn3uuOtP3/G3wJ34S7RGO1qHr+qHDyCfMJdrigpWFK+2EHyzKhHPV6B2N3l
	 KY7RMPM4lr9XdxMdabcMe2tA3XZ2bLTQJLltxBfi71RmtKJz69Dn/Ak24XjklG3b7hIzC
	 o+3nLTiq9rqo+c9i/QxYGalTuAgPxLDAnXRCuGMc/FsNBnkWHXbljETsLoH83B9XpfCIV
	 DAAmKdHL+tzSbsKFUoD/PBV1Qf7EiH+KsjEimGGls4R2aswYvFqcYi4xgz1oeNxluLl1T
	 3+C9gUuuDJbaX2WmxOLpb80JZIRT6fnVvtltYd3SZNgSd2cJSP3lMqvERDWXQnCF9oQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NxN1Po3C;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5279606A329;
	Thu, 26 Nov 2026 14:47:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NxN1Po3C
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0C6B1F000CA;
	Thu, 26 Nov 2026 14:47:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704463;
	bh=mqKH/PH6ZqptXwLeXfrHTYVFqXWRCi07f3TAzMwCxlk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NxN1Po3CT92iUYMpAb/h6l8NccPxXvyGakqSSQsATj5EmA81DyHF1aZOkD8nuyZXv
	 JFjnQm4bvwxdivb9h4Dj8M9q7RPrIN2cMkpe3TX5IVm8JLSWYuQ5p/k7TYe1ybNwut
	 kMGgk6KLvpdiNGP53dJhTlaPZQtGBj+78C8L6XgQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ofri Zangi <ofriz@xsightlabs.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 132/265] tls: fix async encryption race on weakly ordered architectures
Date: Thu, 26 Nov 2026 15:37:42 +0100
Message-ID: <20261126143614.249160431@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index c2344a46dddda..7e71fe2c2f305 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -408,7 +408,8 @@ int tls_tx_records(struct sock *sk, int flags)
 
 	/* Tx all ready records */
 	list_for_each_entry_safe(rec, tmp, &ctx->tx_list, list) {
-		if (READ_ONCE(rec->tx_ready)) {
+		/* Pairs with smp_store_release() in tls_encrypt_done() */
+		if (smp_load_acquire(&rec->tx_ready)) {
 			if (flags == -1)
 				tx_flags = rec->tx_flags;
 			else
@@ -472,8 +473,14 @@ static void tls_encrypt_done(struct crypto_async_request *req, int err)
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



