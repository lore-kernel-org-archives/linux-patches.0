Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 518B078B69;
	Mon,  4 Mar 2024 21:54:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709589241; cv=none; b=BSKBp2hAdbxyHsfS9/DSEsLMfj2yIvViSFajnlUld+FYdoM5LeviMa3GtirMuI3G963qp3HAtisr+8lMGhOVK/9KxPFhYLxdhEUr8qVWmJ+vpyps/PCsdyLHMO00ImVstHP0f1vPEG2dj9ia7AioAeHc+wmJA8HK8JOyXjmQhYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709589241; c=relaxed/simple;
	bh=fGv7rByy8GGDxnURe3sB6OXMZQBnpRBy/42AYPtx8hI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JydTA0rfxq0JGz/eNNzbpu7X5mXoMBvRHFCAKut8OIyMPh2zi36Ix78hAulGIXBdO9Kik1gtR25ougxC8/annlO8PDThrMGjGQKP0Bl0dKh8Bk2O24hzSVf88f9EQfffbMUrAjCUthCtbNeAUzBOucVv+Y71dfJAZkNlJahYf4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SNrMSP5E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SNrMSP5E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D94A2C433C7;
	Mon,  4 Mar 2024 21:54:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709589241;
	bh=fGv7rByy8GGDxnURe3sB6OXMZQBnpRBy/42AYPtx8hI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SNrMSP5EvfvSTCLDr4FYR9/X9I/CvCpCD9rrn02HY/Ow29SJJezUGWiSlsv8C5/aC
	 vUtJJmp2FB9Alif30KpuqxrodxOYTS+WSl5pK5c5gBM6bw3eaf+bouw1qdK6uM+fit
	 09QxrBDjD/hl1y5obihrIdmxKiBiN/i67hEe57Ts=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 34/84] tls: rx: wrap decryption arguments in a structure
Date: Mon,  4 Mar 2024 21:24:07 +0000
Message-ID: <20240304211543.474699398@linuxfoundation.org>
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

[ Upstream commit 4175eac37123a68ebee71f288826339fb89bfec7 ]

We pass zc as a pointer to bool a few functions down as an in/out
argument. This is error prone since C will happily evalue a pointer
as a boolean (IOW forgetting *zc and writing zc leads to loss of
developer time..). Wrap the arguments into a structure.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: f7fa16d49837 ("tls: decrement decrypt_pending if no async completion will be called")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tls/tls_sw.c | 49 ++++++++++++++++++++++++++----------------------
 1 file changed, 27 insertions(+), 22 deletions(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index fc1fa98d21937..c491cde30504e 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -44,6 +44,11 @@
 #include <net/strparser.h>
 #include <net/tls.h>
 
+struct tls_decrypt_arg {
+	bool zc;
+	bool async;
+};
+
 noinline void tls_err_abort(struct sock *sk, int err)
 {
 	WARN_ON_ONCE(err >= 0);
@@ -1415,7 +1420,7 @@ static int tls_setup_from_iter(struct iov_iter *from,
 static int decrypt_internal(struct sock *sk, struct sk_buff *skb,
 			    struct iov_iter *out_iov,
 			    struct scatterlist *out_sg,
-			    bool *zc, bool async)
+			    struct tls_decrypt_arg *darg)
 {
 	struct tls_context *tls_ctx = tls_get_ctx(sk);
 	struct tls_sw_context_rx *ctx = tls_sw_ctx_rx(tls_ctx);
@@ -1432,7 +1437,7 @@ static int decrypt_internal(struct sock *sk, struct sk_buff *skb,
 			     prot->tail_size;
 	int iv_offset = 0;
 
-	if (*zc && (out_iov || out_sg)) {
+	if (darg->zc && (out_iov || out_sg)) {
 		if (out_iov)
 			n_sgout = iov_iter_npages(out_iov, INT_MAX) + 1;
 		else
@@ -1441,7 +1446,7 @@ static int decrypt_internal(struct sock *sk, struct sk_buff *skb,
 				 rxm->full_len - prot->prepend_size);
 	} else {
 		n_sgout = 0;
-		*zc = false;
+		darg->zc = false;
 		n_sgin = skb_cow_data(skb, 0, &unused);
 	}
 
@@ -1531,12 +1536,12 @@ static int decrypt_internal(struct sock *sk, struct sk_buff *skb,
 fallback_to_reg_recv:
 		sgout = sgin;
 		pages = 0;
-		*zc = false;
+		darg->zc = false;
 	}
 
 	/* Prepare and submit AEAD request */
 	err = tls_do_decryption(sk, skb, sgin, sgout, iv,
-				data_len, aead_req, async);
+				data_len, aead_req, darg->async);
 	if (err == -EINPROGRESS)
 		return err;
 
@@ -1549,7 +1554,8 @@ static int decrypt_internal(struct sock *sk, struct sk_buff *skb,
 }
 
 static int decrypt_skb_update(struct sock *sk, struct sk_buff *skb,
-			      struct iov_iter *dest, bool *zc, bool async)
+			      struct iov_iter *dest,
+			      struct tls_decrypt_arg *darg)
 {
 	struct tls_context *tls_ctx = tls_get_ctx(sk);
 	struct tls_prot_info *prot = &tls_ctx->prot_info;
@@ -1558,7 +1564,7 @@ static int decrypt_skb_update(struct sock *sk, struct sk_buff *skb,
 	int pad, err;
 
 	if (tlm->decrypted) {
-		*zc = false;
+		darg->zc = false;
 		return 0;
 	}
 
@@ -1568,12 +1574,12 @@ static int decrypt_skb_update(struct sock *sk, struct sk_buff *skb,
 			return err;
 		if (err > 0) {
 			tlm->decrypted = 1;
-			*zc = false;
+			darg->zc = false;
 			goto decrypt_done;
 		}
 	}
 
-	err = decrypt_internal(sk, skb, dest, NULL, zc, async);
+	err = decrypt_internal(sk, skb, dest, NULL, darg);
 	if (err < 0) {
 		if (err == -EINPROGRESS)
 			tls_advance_record_sn(sk, prot, &tls_ctx->rx);
@@ -1599,9 +1605,9 @@ static int decrypt_skb_update(struct sock *sk, struct sk_buff *skb,
 int decrypt_skb(struct sock *sk, struct sk_buff *skb,
 		struct scatterlist *sgout)
 {
-	bool zc = true;
+	struct tls_decrypt_arg darg = { .zc = true, };
 
-	return decrypt_internal(sk, skb, NULL, sgout, &zc, false);
+	return decrypt_internal(sk, skb, NULL, sgout, &darg);
 }
 
 static bool tls_sw_advance_skb(struct sock *sk, struct sk_buff *skb,
@@ -1790,11 +1796,10 @@ int tls_sw_recvmsg(struct sock *sk,
 	decrypted = 0;
 	num_async = 0;
 	while (len && (decrypted + copied < target || ctx->recv_pkt)) {
+		struct tls_decrypt_arg darg = {};
 		bool retain_skb = false;
 		int to_decrypt, chunk;
-		bool zc = false;
-		bool async_capable;
-		bool async = false;
+		bool async;
 
 		skb = tls_wait_data(sk, psock, flags & MSG_DONTWAIT, timeo, &err);
 		if (!skb) {
@@ -1820,16 +1825,15 @@ int tls_sw_recvmsg(struct sock *sk,
 		    tlm->control == TLS_RECORD_TYPE_DATA &&
 		    prot->version != TLS_1_3_VERSION &&
 		    !bpf_strp_enabled)
-			zc = true;
+			darg.zc = true;
 
 		/* Do not use async mode if record is non-data */
 		if (tlm->control == TLS_RECORD_TYPE_DATA && !bpf_strp_enabled)
-			async_capable = ctx->async_capable;
+			darg.async = ctx->async_capable;
 		else
-			async_capable = false;
+			darg.async = false;
 
-		err = decrypt_skb_update(sk, skb, &msg->msg_iter,
-					 &zc, async_capable);
+		err = decrypt_skb_update(sk, skb, &msg->msg_iter, &darg);
 		if (err < 0 && err != -EINPROGRESS) {
 			tls_err_abort(sk, -EBADMSG);
 			goto recv_end;
@@ -1875,7 +1879,7 @@ int tls_sw_recvmsg(struct sock *sk,
 		/* TLS 1.3 may have updated the length by more than overhead */
 		chunk = rxm->full_len;
 
-		if (!zc) {
+		if (!darg.zc) {
 			if (bpf_strp_enabled) {
 				err = sk_psock_tls_strp_read(psock, skb);
 				if (err != __SK_PASS) {
@@ -1991,7 +1995,6 @@ ssize_t tls_sw_splice_read(struct socket *sock,  loff_t *ppos,
 	int err = 0;
 	long timeo;
 	int chunk;
-	bool zc = false;
 
 	lock_sock(sk);
 
@@ -2001,12 +2004,14 @@ ssize_t tls_sw_splice_read(struct socket *sock,  loff_t *ppos,
 	if (from_queue) {
 		skb = __skb_dequeue(&ctx->rx_list);
 	} else {
+		struct tls_decrypt_arg darg = {};
+
 		skb = tls_wait_data(sk, NULL, flags & SPLICE_F_NONBLOCK, timeo,
 				    &err);
 		if (!skb)
 			goto splice_read_end;
 
-		err = decrypt_skb_update(sk, skb, NULL, &zc, false);
+		err = decrypt_skb_update(sk, skb, NULL, &darg);
 		if (err < 0) {
 			tls_err_abort(sk, -EBADMSG);
 			goto splice_read_end;
-- 
2.43.0



