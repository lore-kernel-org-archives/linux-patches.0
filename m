Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A87D78B47;
	Mon,  4 Mar 2024 21:53:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709589223; cv=none; b=L8FnAYAq3vao33ZTXLLJ8UHFia0mh6zR5TyyEhepue4Hay2VgwMNYIvWdoDswUGmr7cEFa8CRh71fNdZuufqWX03t8l3CpQeRfpCMmCKjWnSAopMHTUwtYKeyxgqqkzPXlX7lp21yj85eFzgThwJ1sIybL329DT9k2yYI4CB5yk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709589223; c=relaxed/simple;
	bh=2X4ui7l1VwZclMlCUt4Xlxu72giX+WdlWDxSKgbEglU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y+S/cL7FDgkkMS7z6gM2MJEUy3TlXEvtFUAhFG90HP1uP6dz9trlQY04a8yCF/A2OqDlbnRXRr4QH4PkwCygEcd1AsLXj7sS1HiupLDv3Qb1aUUHHDiU9ex6mq29Tc0w7DG4JE8GN7/NW4IWo7Tr3RyeUS4atxAMOdZOhDJ9zek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vQq/rekf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vQq/rekf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1728C433F1;
	Mon,  4 Mar 2024 21:53:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709589223;
	bh=2X4ui7l1VwZclMlCUt4Xlxu72giX+WdlWDxSKgbEglU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vQq/rekfv33jRQ1w5GYYQJYa06lsRj2typ84QOy3RsD55r9RWq4Qyjzoky0lqYxWi
	 Ucx/HvI3Ovz0DrljzdMduCkmQik99xpq5SubWHXfevJo4+bIkuVMiIa9Ti6HPiVrjw
	 ZdW+98uvo1/YBdzmmapAoK+lAWqCmJTxJSBzV/l8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 27/84] tls: rx: dont store the record type in socket context
Date: Mon,  4 Mar 2024 21:24:00 +0000
Message-ID: <20240304211543.237236688@linuxfoundation.org>
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

[ Upstream commit c3f6bb74137c68b515b7e2ff123a80611e801013 ]

Original TLS implementation was handling one record at a time.
It stashed the type of the record inside tls context (per socket
structure) for convenience. When async crypto support was added
[1] the author had to use skb->cb to store the type per-message.

The use of skb->cb overlaps with strparser, however, so a hybrid
approach was taken where type is stored in context while parsing
(since we parse a message at a time) but once parsed its copied
to skb->cb.

Recently a workaround for sockmaps [2] exposed the previously
private struct _strp_msg and started a trend of adding user
fields directly in strparser's header. This is cleaner than
storing information about an skb in the context.

This change is not strictly necessary, but IMHO the ownership
of the context field is confusing. Information naturally
belongs to the skb.

[1] commit 94524d8fc965 ("net/tls: Add support for async decryption of tls records")
[2] commit b2c4618162ec ("bpf, sockmap: sk_skb data_end access incorrect when src_reg = dst_reg")

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: f7fa16d49837 ("tls: decrement decrypt_pending if no async completion will be called")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/strparser.h |  3 +++
 include/net/tls.h       | 10 +++-------
 net/tls/tls_sw.c        | 38 +++++++++++++++++---------------------
 3 files changed, 23 insertions(+), 28 deletions(-)

diff --git a/include/net/strparser.h b/include/net/strparser.h
index 732b7097d78e4..c271543076cf8 100644
--- a/include/net/strparser.h
+++ b/include/net/strparser.h
@@ -70,6 +70,9 @@ struct sk_skb_cb {
 	 * when dst_reg == src_reg.
 	 */
 	u64 temp_reg;
+	struct tls_msg {
+		u8 control;
+	} tls;
 };
 
 static inline struct strp_msg *strp_msg(struct sk_buff *skb)
diff --git a/include/net/tls.h b/include/net/tls.h
index eda0015c5c592..24c1b718ceacc 100644
--- a/include/net/tls.h
+++ b/include/net/tls.h
@@ -116,11 +116,6 @@ struct tls_rec {
 	u8 aead_req_ctx[];
 };
 
-struct tls_msg {
-	struct strp_msg rxm;
-	u8 control;
-};
-
 struct tx_work {
 	struct delayed_work work;
 	struct sock *sk;
@@ -151,7 +146,6 @@ struct tls_sw_context_rx {
 	void (*saved_data_ready)(struct sock *sk);
 
 	struct sk_buff *recv_pkt;
-	u8 control;
 	u8 async_capable:1;
 	u8 decrypted:1;
 	atomic_t decrypt_pending;
@@ -410,7 +404,9 @@ void tls_free_partial_record(struct sock *sk, struct tls_context *ctx);
 
 static inline struct tls_msg *tls_msg(struct sk_buff *skb)
 {
-	return (struct tls_msg *)strp_msg(skb);
+	struct sk_skb_cb *scb = (struct sk_skb_cb *)skb->cb;
+
+	return &scb->tls;
 }
 
 static inline bool tls_is_partially_sent_record(struct tls_context *ctx)
diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index e6f700f67c010..82d7c9b036bc7 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -128,10 +128,10 @@ static int skb_nsg(struct sk_buff *skb, int offset, int len)
         return __skb_nsg(skb, offset, len, 0);
 }
 
-static int padding_length(struct tls_sw_context_rx *ctx,
-			  struct tls_prot_info *prot, struct sk_buff *skb)
+static int padding_length(struct tls_prot_info *prot, struct sk_buff *skb)
 {
 	struct strp_msg *rxm = strp_msg(skb);
+	struct tls_msg *tlm = tls_msg(skb);
 	int sub = 0;
 
 	/* Determine zero-padding length */
@@ -153,7 +153,7 @@ static int padding_length(struct tls_sw_context_rx *ctx,
 			sub++;
 			back++;
 		}
-		ctx->control = content_type;
+		tlm->control = content_type;
 	}
 	return sub;
 }
@@ -187,7 +187,7 @@ static void tls_decrypt_done(struct crypto_async_request *req, int err)
 		struct strp_msg *rxm = strp_msg(skb);
 		int pad;
 
-		pad = padding_length(ctx, prot, skb);
+		pad = padding_length(prot, skb);
 		if (pad < 0) {
 			ctx->async_wait.err = pad;
 			tls_err_abort(skb->sk, pad);
@@ -1423,6 +1423,7 @@ static int decrypt_internal(struct sock *sk, struct sk_buff *skb,
 	struct tls_sw_context_rx *ctx = tls_sw_ctx_rx(tls_ctx);
 	struct tls_prot_info *prot = &tls_ctx->prot_info;
 	struct strp_msg *rxm = strp_msg(skb);
+	struct tls_msg *tlm = tls_msg(skb);
 	int n_sgin, n_sgout, nsg, mem_size, aead_size, err, pages = 0;
 	struct aead_request *aead_req;
 	struct sk_buff *unused;
@@ -1500,7 +1501,7 @@ static int decrypt_internal(struct sock *sk, struct sk_buff *skb,
 	/* Prepare AAD */
 	tls_make_aad(aad, rxm->full_len - prot->overhead_size +
 		     prot->tail_size,
-		     tls_ctx->rx.rec_seq, ctx->control, prot);
+		     tls_ctx->rx.rec_seq, tlm->control, prot);
 
 	/* Prepare sgin */
 	sg_init_table(sgin, n_sgin);
@@ -1585,7 +1586,7 @@ static int decrypt_skb_update(struct sock *sk, struct sk_buff *skb,
 			*zc = false;
 		}
 
-		pad = padding_length(ctx, prot, skb);
+		pad = padding_length(prot, skb);
 		if (pad < 0)
 			return pad;
 
@@ -1817,26 +1818,21 @@ int tls_sw_recvmsg(struct sock *sk,
 				}
 			}
 			goto recv_end;
-		} else {
-			tlm = tls_msg(skb);
-			if (prot->version == TLS_1_3_VERSION)
-				tlm->control = 0;
-			else
-				tlm->control = ctx->control;
 		}
 
 		rxm = strp_msg(skb);
+		tlm = tls_msg(skb);
 
 		to_decrypt = rxm->full_len - prot->overhead_size;
 
 		if (to_decrypt <= len && !is_kvec && !is_peek &&
-		    ctx->control == TLS_RECORD_TYPE_DATA &&
+		    tlm->control == TLS_RECORD_TYPE_DATA &&
 		    prot->version != TLS_1_3_VERSION &&
 		    !bpf_strp_enabled)
 			zc = true;
 
 		/* Do not use async mode if record is non-data */
-		if (ctx->control == TLS_RECORD_TYPE_DATA && !bpf_strp_enabled)
+		if (tlm->control == TLS_RECORD_TYPE_DATA && !bpf_strp_enabled)
 			async_capable = ctx->async_capable;
 		else
 			async_capable = false;
@@ -1851,8 +1847,6 @@ int tls_sw_recvmsg(struct sock *sk,
 		if (err == -EINPROGRESS) {
 			async = true;
 			num_async++;
-		} else if (prot->version == TLS_1_3_VERSION) {
-			tlm->control = ctx->control;
 		}
 
 		/* If the type of records being processed is not known yet,
@@ -1999,6 +1993,7 @@ ssize_t tls_sw_splice_read(struct socket *sock,  loff_t *ppos,
 	struct tls_sw_context_rx *ctx = tls_sw_ctx_rx(tls_ctx);
 	struct strp_msg *rxm = NULL;
 	struct sock *sk = sock->sk;
+	struct tls_msg *tlm;
 	struct sk_buff *skb;
 	ssize_t copied = 0;
 	bool from_queue;
@@ -2027,14 +2022,15 @@ ssize_t tls_sw_splice_read(struct socket *sock,  loff_t *ppos,
 		}
 	}
 
+	rxm = strp_msg(skb);
+	tlm = tls_msg(skb);
+
 	/* splice does not support reading control messages */
-	if (ctx->control != TLS_RECORD_TYPE_DATA) {
+	if (tlm->control != TLS_RECORD_TYPE_DATA) {
 		err = -EINVAL;
 		goto splice_read_end;
 	}
 
-	rxm = strp_msg(skb);
-
 	chunk = min_t(unsigned int, rxm->full_len, len);
 	copied = skb_splice_bits(skb, sk, rxm->offset, pipe, chunk, flags);
 	if (copied < 0)
@@ -2077,10 +2073,10 @@ bool tls_sw_sock_is_readable(struct sock *sk)
 static int tls_read_size(struct strparser *strp, struct sk_buff *skb)
 {
 	struct tls_context *tls_ctx = tls_get_ctx(strp->sk);
-	struct tls_sw_context_rx *ctx = tls_sw_ctx_rx(tls_ctx);
 	struct tls_prot_info *prot = &tls_ctx->prot_info;
 	char header[TLS_HEADER_SIZE + MAX_IV_SIZE];
 	struct strp_msg *rxm = strp_msg(skb);
+	struct tls_msg *tlm = tls_msg(skb);
 	size_t cipher_overhead;
 	size_t data_len = 0;
 	int ret;
@@ -2101,7 +2097,7 @@ static int tls_read_size(struct strparser *strp, struct sk_buff *skb)
 	if (ret < 0)
 		goto read_failure;
 
-	ctx->control = header[0];
+	tlm->control = header[0];
 
 	data_len = ((header[4] & 0xFF) | (header[3] << 8));
 
-- 
2.43.0



