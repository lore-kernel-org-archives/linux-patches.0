Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619211;
	b=du9lpubeN1shwulnlCppQhkttoWD+oCNGaCzo1H42liupaJ7yNH0bFz6kcH7PIno8zGY
	 dcGLqK/jWktjLxuLypRsmLDF3lFj7irEHhVVdsQ27xpdm0mmbRhnHSWqgcGxFqQsDHHm4
	 YpbN7jHKdEgP4VMl9H1HC0G1swIlC2av7lob4DUP+SUVIB84PjcRCRbrVdqNINyM1rPzT
	 lDQhHK+aBxxDL0bDE+ywEZmKF8OzkQHlVWjMe3O3jTZtfI3ietFtH0A2NE/uswdT2Px4P
	 q6XNh03vA/o2/ExbbLgkZjID+jbBUNHOLiq8kRodo93AdVaAcAQHrD0uJcBkdVaHV4A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619211;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zEOUKMIbZyBVgyALIOLcpTSl7R886NvH373Eqdlk/vc=;
	b=ZZhWkRlD7z7MnwVcBbgA3R+1AK574haydUeIk/zzS/zTKDUtFjtzgsxlVyeMwa+lLbix
	 Sj70qA/aHP6cUh5gdVU1yipnZbYKvG9isJVkxYyflNq9r+m0monDUOeyNJmhmWJZkWbnc
	 SVDoHhzxbgWSsu/YsaKq2gV/hpWZ6B8jb55p7yR7hrsTgp6VCmaZWS2Jwq1ZTprIADeH3
	 nORMYDeykV9d7WsRe0zzmC5oCDjF9VMnx4Ghpc8PCHjMYaqe+xqdlkcjQdefDyZ+9P07w
	 dWrxPuWkXFb2uVjI5FaYaofhUdtUW4kMpDZNGNoc/FBA5cwl72iZCaeUQ8iVUkPhoIg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="AwYQ/qMf";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 678B4606A323;
	Wed, 25 Nov 2026 15:06:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AwYQ/qMf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9688A1F000EB;
	Wed, 25 Nov 2026 15:06:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619211;
	bh=zEOUKMIbZyBVgyALIOLcpTSl7R886NvH373Eqdlk/vc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AwYQ/qMfKbMoNeO6VoPZMMrBFNa5mSH6I7fZq3oqTjSpsCOyi3N+17+GQBRQzHc9D
	 48dI55ljej8dpqvbIsX3YF2U4kxNiqhia4o4HxEaxhVI2KMYAfMYFjDgA9Wx55lEDA
	 KzQ1WCzZ2VAVSZNg3X1mdbG8qff5BCBta2JWY/IY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ofri Zangi <ofriz@xsightlabs.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0525/1005] tls: fix async encryption race on weakly ordered architectures
Date: Wed, 25 Nov 2026 15:31:03 +0100
Message-ID: <20261125143834.046127224@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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
index 79639ed79821c..47e46547108e9 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -436,7 +436,8 @@ int tls_tx_records(struct sock *sk, int flags)
 
 	/* Tx all ready records */
 	list_for_each_entry_safe(rec, tmp, &ctx->tx_list, list) {
-		if (READ_ONCE(rec->tx_ready)) {
+		/* Pairs with smp_store_release() in tls_encrypt_done() */
+		if (smp_load_acquire(&rec->tx_ready)) {
 			if (flags == -1)
 				tx_flags = rec->tx_flags;
 			else
@@ -504,8 +505,14 @@ static void tls_encrypt_done(void *data, int err)
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



