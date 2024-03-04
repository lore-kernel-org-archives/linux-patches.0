Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC2E91C6AB;
	Mon,  4 Mar 2024 21:53:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709589238; cv=none; b=L/DgIj/UB1agRO7+mtgrLrW1jBbLMpdtDvTPsKutrnJWLk/UYSQvb+MD2OMrPHL7l1A++h+qMkbmpSk27JC47FyUInccDaHbpMcU3eqWkG0II1B55OtYfYdCBsffiPPRUXquQi2nhLCgmbnwdaHZLJ7CRDYlSuKNt7L0sv8trpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709589238; c=relaxed/simple;
	bh=oer9zX5cDQZ4uwV7AC693k80Jv+XN0DM4feOViYh01k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YDK30+jxej5c4U72CLfeC5uKlxeOilltwehOJ4ZAr/tHz/mszgkEzhPP6bDr/dmtmZcHI2v5zmDRgR7UyGCS1EhgUhD3dIjkAx4+y9y657ek+mEaWOlu9pdpP0rEUEz/tdEPqpf2EiRolNLzED2TPuESasoGiQXoG3rdShKeHyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uSPlT1G9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uSPlT1G9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6039CC433F1;
	Mon,  4 Mar 2024 21:53:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709589238;
	bh=oer9zX5cDQZ4uwV7AC693k80Jv+XN0DM4feOViYh01k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uSPlT1G9IJ9zGzoVQSJPYQBPs/WU3oNPOg8bUxf5/xZW851uxFO89xO50lK+HEFFa
	 Z/pbl5L1wwwSdhKA8tQBEbIfqg+9Fudl4c/KiMWEAGdcNB7Me4yL62+OAtBbiqpXL1
	 twJOs8OckLHy446/O/uwEUrlURZa8KUY6zloFe+8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 33/84] tls: rx: dont report text length from the bowels of decrypt
Date: Mon,  4 Mar 2024 21:24:06 +0000
Message-ID: <20240304211543.435893293@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211542.332206551@linuxfoundation.org>
References: <20240304211542.332206551@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 9bdf75ccffa690237cd0b472cd598cf6d22873dc ]

We plumb pointer to chunk all the way to the decryption method.
It's set to the length of the text when decrypt_skb_update()
returns.

I think the code is written this way because original TLS
implementation passed &chunk to zerocopy_from_iter() and this
was carried forward as the code gotten more complex, without
any refactoring.

The fix for peek() introduced a new variable - to_decrypt
which for all practical purposes is what chunk is going to
get set to. Spare ourselves the pointer passing, use to_decrypt.

Use this opportunity to clean things up a little further.

Note that chunk / to_decrypt was mostly needed for the async
path, since the sync path would access rxm->full_len (decryption
transforms full_len from record size to text size). Use the
right source of truth more explicitly.

We have three cases:
 - async - it's TLS 1.2 only, so chunk == to_decrypt, but we
           need the min() because to_decrypt is a whole record
	   and we don't want to underflow len. Note that we can't
	   handle partial record by falling back to sync as it
	   would introduce reordering against records in flight.
 - zc - again, TLS 1.2 only for now, so chunk == to_decrypt,
        we don't do zc if len < to_decrypt, no need to check again.
 - normal - it already handles chunk > len, we can factor out the
            assignment to rxm->full_len and share it with zc.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: f7fa16d49837 ("tls: decrement decrypt_pending if no async completion will be called")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tls/tls_sw.c | 33 ++++++++++++++-------------------
 1 file changed, 14 insertions(+), 19 deletions(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index cf09f147f5a09..fc1fa98d21937 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -1415,7 +1415,7 @@ static int tls_setup_from_iter(struct iov_iter *from,
 static int decrypt_internal(struct sock *sk, struct sk_buff *skb,
 			    struct iov_iter *out_iov,
 			    struct scatterlist *out_sg,
-			    int *chunk, bool *zc, bool async)
+			    bool *zc, bool async)
 {
 	struct tls_context *tls_ctx = tls_get_ctx(sk);
 	struct tls_sw_context_rx *ctx = tls_sw_ctx_rx(tls_ctx);
@@ -1522,7 +1522,6 @@ static int decrypt_internal(struct sock *sk, struct sk_buff *skb,
 						  (n_sgout - 1));
 			if (err < 0)
 				goto fallback_to_reg_recv;
-			*chunk = data_len;
 		} else if (out_sg) {
 			memcpy(sgout, out_sg, n_sgout * sizeof(*sgout));
 		} else {
@@ -1532,7 +1531,6 @@ static int decrypt_internal(struct sock *sk, struct sk_buff *skb,
 fallback_to_reg_recv:
 		sgout = sgin;
 		pages = 0;
-		*chunk = data_len;
 		*zc = false;
 	}
 
@@ -1551,8 +1549,7 @@ static int decrypt_internal(struct sock *sk, struct sk_buff *skb,
 }
 
 static int decrypt_skb_update(struct sock *sk, struct sk_buff *skb,
-			      struct iov_iter *dest, int *chunk, bool *zc,
-			      bool async)
+			      struct iov_iter *dest, bool *zc, bool async)
 {
 	struct tls_context *tls_ctx = tls_get_ctx(sk);
 	struct tls_prot_info *prot = &tls_ctx->prot_info;
@@ -1576,7 +1573,7 @@ static int decrypt_skb_update(struct sock *sk, struct sk_buff *skb,
 		}
 	}
 
-	err = decrypt_internal(sk, skb, dest, NULL, chunk, zc, async);
+	err = decrypt_internal(sk, skb, dest, NULL, zc, async);
 	if (err < 0) {
 		if (err == -EINPROGRESS)
 			tls_advance_record_sn(sk, prot, &tls_ctx->rx);
@@ -1603,9 +1600,8 @@ int decrypt_skb(struct sock *sk, struct sk_buff *skb,
 		struct scatterlist *sgout)
 {
 	bool zc = true;
-	int chunk;
 
-	return decrypt_internal(sk, skb, NULL, sgout, &chunk, &zc, false);
+	return decrypt_internal(sk, skb, NULL, sgout, &zc, false);
 }
 
 static bool tls_sw_advance_skb(struct sock *sk, struct sk_buff *skb,
@@ -1795,9 +1791,8 @@ int tls_sw_recvmsg(struct sock *sk,
 	num_async = 0;
 	while (len && (decrypted + copied < target || ctx->recv_pkt)) {
 		bool retain_skb = false;
+		int to_decrypt, chunk;
 		bool zc = false;
-		int to_decrypt;
-		int chunk = 0;
 		bool async_capable;
 		bool async = false;
 
@@ -1834,7 +1829,7 @@ int tls_sw_recvmsg(struct sock *sk,
 			async_capable = false;
 
 		err = decrypt_skb_update(sk, skb, &msg->msg_iter,
-					 &chunk, &zc, async_capable);
+					 &zc, async_capable);
 		if (err < 0 && err != -EINPROGRESS) {
 			tls_err_abort(sk, -EBADMSG);
 			goto recv_end;
@@ -1872,8 +1867,13 @@ int tls_sw_recvmsg(struct sock *sk,
 			}
 		}
 
-		if (async)
+		if (async) {
+			/* TLS 1.2-only, to_decrypt must be text length */
+			chunk = min_t(int, to_decrypt, len);
 			goto pick_next_record;
+		}
+		/* TLS 1.3 may have updated the length by more than overhead */
+		chunk = rxm->full_len;
 
 		if (!zc) {
 			if (bpf_strp_enabled) {
@@ -1889,11 +1889,9 @@ int tls_sw_recvmsg(struct sock *sk,
 				}
 			}
 
-			if (rxm->full_len > len) {
+			if (chunk > len) {
 				retain_skb = true;
 				chunk = len;
-			} else {
-				chunk = rxm->full_len;
 			}
 
 			err = skb_copy_datagram_msg(skb, rxm->offset,
@@ -1908,9 +1906,6 @@ int tls_sw_recvmsg(struct sock *sk,
 		}
 
 pick_next_record:
-		if (chunk > len)
-			chunk = len;
-
 		decrypted += chunk;
 		len -= chunk;
 
@@ -2011,7 +2006,7 @@ ssize_t tls_sw_splice_read(struct socket *sock,  loff_t *ppos,
 		if (!skb)
 			goto splice_read_end;
 
-		err = decrypt_skb_update(sk, skb, NULL, &chunk, &zc, false);
+		err = decrypt_skb_update(sk, skb, NULL, &zc, false);
 		if (err < 0) {
 			tls_err_abort(sk, -EBADMSG);
 			goto splice_read_end;
-- 
2.43.0



