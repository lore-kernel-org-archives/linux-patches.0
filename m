Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E21A61675;
	Mon,  4 Mar 2024 21:54:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709589244; cv=none; b=IfozB/HbGjJLMB157/PxpNMXmia1zY8tw8aob86mBvs20rTgeqOF7KPjmB+d1UZOsFHJRPmr+cE+JVYvLA6W3kOxm+n7R8+8koj9aazkPl5WkAls0dp/hsHiqO0iDAozAhRT8Lt/Ij69T/DHkCVX5/nDfxLU47VSDNWqoqU7ON0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709589244; c=relaxed/simple;
	bh=mZ/Sw8uig77pK7X2NpI9BDB72KRHPAx+UMMWqyJn/K8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UmhLz3VQxvImRv6OYrraUCEa36mvl18SQ2AyKznYrkZA9eKtmjT7qnHtnhgItZCOPMpVm0fkekOHrUb1QN8u8Vqm19klrAIn56jO7XCFhWSkG+04cf72a/CskR4+1Dv8dbpac8cdrChUvc/SYNsrypjOkb2Ye3kIcU6lJdvkdUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=St9KrJXO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="St9KrJXO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72CEEC433F1;
	Mon,  4 Mar 2024 21:54:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709589243;
	bh=mZ/Sw8uig77pK7X2NpI9BDB72KRHPAx+UMMWqyJn/K8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=St9KrJXOse2PeoZaxUkxdbQYLYwFVp3qjdOzyPV8ha5aGm1g1IFsRVfO4fw/WDhJc
	 vA4IHmJJ0FEUpmdJGDSKcNABQ2oi/at4QH4J0I1y+ZxCXT2b84bYBaAeoejPgEW7ia
	 /+TVula4uox6utJPI6kfh9Sl+Pg8spY7zIcRzydI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 35/84] tls: rx: factor out writing ContentType to cmsg
Date: Mon,  4 Mar 2024 21:24:08 +0000
Message-ID: <20240304211543.511609155@linuxfoundation.org>
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

[ Upstream commit 06554f4ffc2595ae52ee80aec4a13bd77d22bed7 ]

cmsg can be filled in during rx_list processing or normal
receive. Consolidate the code.

We don't need to keep the boolean to track if the cmsg was
created. 0 is an invalid content type.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: f7fa16d49837 ("tls: decrement decrypt_pending if no async completion will be called")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tls/tls_sw.c | 91 +++++++++++++++++++-----------------------------
 1 file changed, 36 insertions(+), 55 deletions(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index c491cde30504e..ca71a9f559b37 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -1634,6 +1634,29 @@ static bool tls_sw_advance_skb(struct sock *sk, struct sk_buff *skb,
 	return true;
 }
 
+static int tls_record_content_type(struct msghdr *msg, struct tls_msg *tlm,
+				   u8 *control)
+{
+	int err;
+
+	if (!*control) {
+		*control = tlm->control;
+		if (!*control)
+			return -EBADMSG;
+
+		err = put_cmsg(msg, SOL_TLS, TLS_GET_RECORD_TYPE,
+			       sizeof(*control), control);
+		if (*control != TLS_RECORD_TYPE_DATA) {
+			if (err || msg->msg_flags & MSG_CTRUNC)
+				return -EIO;
+		}
+	} else if (*control != tlm->control) {
+		return 0;
+	}
+
+	return 1;
+}
+
 /* This function traverses the rx_list in tls receive context to copies the
  * decrypted records into the buffer provided by caller zero copy is not
  * true. Further, the records are removed from the rx_list if it is not a peek
@@ -1642,31 +1665,23 @@ static bool tls_sw_advance_skb(struct sock *sk, struct sk_buff *skb,
 static int process_rx_list(struct tls_sw_context_rx *ctx,
 			   struct msghdr *msg,
 			   u8 *control,
-			   bool *cmsg,
 			   size_t skip,
 			   size_t len,
 			   bool zc,
 			   bool is_peek)
 {
 	struct sk_buff *skb = skb_peek(&ctx->rx_list);
-	u8 ctrl = *control;
-	u8 msgc = *cmsg;
 	struct tls_msg *tlm;
 	ssize_t copied = 0;
-
-	/* Set the record type in 'control' if caller didn't pass it */
-	if (!ctrl && skb) {
-		tlm = tls_msg(skb);
-		ctrl = tlm->control;
-	}
+	int err;
 
 	while (skip && skb) {
 		struct strp_msg *rxm = strp_msg(skb);
 		tlm = tls_msg(skb);
 
-		/* Cannot process a record of different type */
-		if (ctrl != tlm->control)
-			return 0;
+		err = tls_record_content_type(msg, tlm, control);
+		if (err <= 0)
+			return err;
 
 		if (skip < rxm->full_len)
 			break;
@@ -1682,27 +1697,12 @@ static int process_rx_list(struct tls_sw_context_rx *ctx,
 
 		tlm = tls_msg(skb);
 
-		/* Cannot process a record of different type */
-		if (ctrl != tlm->control)
-			return 0;
-
-		/* Set record type if not already done. For a non-data record,
-		 * do not proceed if record type could not be copied.
-		 */
-		if (!msgc) {
-			int cerr = put_cmsg(msg, SOL_TLS, TLS_GET_RECORD_TYPE,
-					    sizeof(ctrl), &ctrl);
-			msgc = true;
-			if (ctrl != TLS_RECORD_TYPE_DATA) {
-				if (cerr || msg->msg_flags & MSG_CTRUNC)
-					return -EIO;
-
-				*cmsg = msgc;
-			}
-		}
+		err = tls_record_content_type(msg, tlm, control);
+		if (err <= 0)
+			return err;
 
 		if (!zc || (rxm->full_len - skip) > len) {
-			int err = skb_copy_datagram_msg(skb, rxm->offset + skip,
+			err = skb_copy_datagram_msg(skb, rxm->offset + skip,
 						    msg, chunk);
 			if (err < 0)
 				return err;
@@ -1739,7 +1739,6 @@ static int process_rx_list(struct tls_sw_context_rx *ctx,
 		skb = next_skb;
 	}
 
-	*control = ctrl;
 	return copied;
 }
 
@@ -1761,7 +1760,6 @@ int tls_sw_recvmsg(struct sock *sk,
 	struct tls_msg *tlm;
 	struct sk_buff *skb;
 	ssize_t copied = 0;
-	bool cmsg = false;
 	int target, err = 0;
 	long timeo;
 	bool is_kvec = iov_iter_is_kvec(&msg->msg_iter);
@@ -1778,8 +1776,7 @@ int tls_sw_recvmsg(struct sock *sk,
 	bpf_strp_enabled = sk_psock_strp_enabled(psock);
 
 	/* Process pending decrypted records. It must be non-zero-copy */
-	err = process_rx_list(ctx, msg, &control, &cmsg, 0, len, false,
-			      is_peek);
+	err = process_rx_list(ctx, msg, &control, 0, len, false, is_peek);
 	if (err < 0) {
 		tls_err_abort(sk, err);
 		goto end;
@@ -1851,26 +1848,10 @@ int tls_sw_recvmsg(struct sock *sk,
 		 * is known just after record is dequeued from stream parser.
 		 * For tls1.3, we disable async.
 		 */
-
-		if (!control)
-			control = tlm->control;
-		else if (control != tlm->control)
+		err = tls_record_content_type(msg, tlm, &control);
+		if (err <= 0)
 			goto recv_end;
 
-		if (!cmsg) {
-			int cerr;
-
-			cerr = put_cmsg(msg, SOL_TLS, TLS_GET_RECORD_TYPE,
-					sizeof(control), &control);
-			cmsg = true;
-			if (control != TLS_RECORD_TYPE_DATA) {
-				if (cerr || msg->msg_flags & MSG_CTRUNC) {
-					err = -EIO;
-					goto recv_end;
-				}
-			}
-		}
-
 		if (async) {
 			/* TLS 1.2-only, to_decrypt must be text length */
 			chunk = min_t(int, to_decrypt, len);
@@ -1959,10 +1940,10 @@ int tls_sw_recvmsg(struct sock *sk,
 
 		/* Drain records from the rx_list & copy if required */
 		if (is_peek || is_kvec)
-			err = process_rx_list(ctx, msg, &control, &cmsg, copied,
+			err = process_rx_list(ctx, msg, &control, copied,
 					      decrypted, false, is_peek);
 		else
-			err = process_rx_list(ctx, msg, &control, &cmsg, 0,
+			err = process_rx_list(ctx, msg, &control, 0,
 					      decrypted, true, is_peek);
 		if (err < 0) {
 			tls_err_abort(sk, err);
-- 
2.43.0



