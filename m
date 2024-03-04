Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48DF71C6AB;
	Mon,  4 Mar 2024 21:54:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709589257; cv=none; b=pykdyLd0WpG7XxvDfYyl+rCS9GBOphS6atH4tq7nH+n+za6FPHxYgpv/Ntdko7j8Q8dDxhjgPh1yXzWXe8BtbojbQaMyFHS0Q99v7psi7O2m3/4YchB9EI45fqnGA5XTklcU6Q/3A6vQ6ZH/zQ371qCSf62AwuzOjDNZmNCyjng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709589257; c=relaxed/simple;
	bh=65iXFR0/v9blfhohgSFjtcSWI8Nd4AkkacoY4JGKblY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HKdWRdag8N8KYwHtQ+QAGGlIP9XpaeR4CdK445QBMOhXErIoSMN7hsKyv6z+c64c2smPYBg3Qh+o4SLyqbtczBh4zi68yr1eU4QfscVUN0Ou3KOpZe7Z3uXZQEuAcKG1Zv3SJtEVt51rYX3mF+L1qmjNOzcUmnF5+Pw7U19Ql14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ftet5QUc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ftet5QUc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77804C433F1;
	Mon,  4 Mar 2024 21:54:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709589256;
	bh=65iXFR0/v9blfhohgSFjtcSWI8Nd4AkkacoY4JGKblY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ftet5QUcYRQWurs2sVDUTpg1xrpFjmpgDthA+UcAPiMUveHsfTsugBH3Cv7pDrgwQ
	 s54r7HthB34+7mUGwIO94Wm2npUlN7jDvRM50rI2J4wm0lFVMBP4NCnqZr3Nr09zBp
	 CHtkxHKXceRYppELOg2EmrVxzSRxKBuW2wAqcr6Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 39/84] tls: rx: use async as an in-out argument
Date: Mon,  4 Mar 2024 21:24:12 +0000
Message-ID: <20240304211543.644892938@linuxfoundation.org>
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

[ Upstream commit 3547a1f9d988d88ecff4fc365d2773037c849f49 ]

Propagating EINPROGRESS thru multiple layers of functions is
error prone. Use darg->async as an in/out argument, like we
use darg->zc today. On input it tells the code if async is
allowed, on output if it took place.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: f7fa16d49837 ("tls: decrement decrypt_pending if no async completion will be called")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tls/tls_sw.c | 31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 27ac27daec868..a1a99f9f093b1 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -236,7 +236,7 @@ static int tls_do_decryption(struct sock *sk,
 			     char *iv_recv,
 			     size_t data_len,
 			     struct aead_request *aead_req,
-			     bool async)
+			     struct tls_decrypt_arg *darg)
 {
 	struct tls_context *tls_ctx = tls_get_ctx(sk);
 	struct tls_prot_info *prot = &tls_ctx->prot_info;
@@ -249,7 +249,7 @@ static int tls_do_decryption(struct sock *sk,
 			       data_len + prot->tag_size,
 			       (u8 *)iv_recv);
 
-	if (async) {
+	if (darg->async) {
 		/* Using skb->sk to push sk through to crypto async callback
 		 * handler. This allows propagating errors up to the socket
 		 * if needed. It _must_ be cleared in the async handler
@@ -269,11 +269,13 @@ static int tls_do_decryption(struct sock *sk,
 
 	ret = crypto_aead_decrypt(aead_req);
 	if (ret == -EINPROGRESS) {
-		if (async)
-			return ret;
+		if (darg->async)
+			return 0;
 
 		ret = crypto_wait_req(ret, &ctx->async_wait);
 	}
+	darg->async = false;
+
 	if (ret == -EBADMSG)
 		TLS_INC_STATS(sock_net(sk), LINUX_MIB_TLSDECRYPTERROR);
 
@@ -1540,9 +1542,9 @@ static int decrypt_internal(struct sock *sk, struct sk_buff *skb,
 
 	/* Prepare and submit AEAD request */
 	err = tls_do_decryption(sk, skb, sgin, sgout, iv,
-				data_len, aead_req, darg->async);
-	if (err == -EINPROGRESS)
-		return err;
+				data_len, aead_req, darg);
+	if (darg->async)
+		return 0;
 
 	/* Release the pages in case iov was mapped to pages */
 	for (; pages > 0; pages--)
@@ -1579,11 +1581,10 @@ static int decrypt_skb_update(struct sock *sk, struct sk_buff *skb,
 	}
 
 	err = decrypt_internal(sk, skb, dest, NULL, darg);
-	if (err < 0) {
-		if (err == -EINPROGRESS)
-			tls_advance_record_sn(sk, prot, &tls_ctx->rx);
+	if (err < 0)
 		return err;
-	}
+	if (darg->async)
+		goto decrypt_next;
 
 decrypt_done:
 	pad = padding_length(prot, skb);
@@ -1593,8 +1594,9 @@ static int decrypt_skb_update(struct sock *sk, struct sk_buff *skb,
 	rxm->full_len -= pad;
 	rxm->offset += prot->prepend_size;
 	rxm->full_len -= prot->overhead_size;
-	tls_advance_record_sn(sk, prot, &tls_ctx->rx);
 	tlm->decrypted = 1;
+decrypt_next:
+	tls_advance_record_sn(sk, prot, &tls_ctx->rx);
 
 	return 0;
 }
@@ -1826,13 +1828,12 @@ int tls_sw_recvmsg(struct sock *sk,
 			darg.async = false;
 
 		err = decrypt_skb_update(sk, skb, &msg->msg_iter, &darg);
-		if (err < 0 && err != -EINPROGRESS) {
+		if (err < 0) {
 			tls_err_abort(sk, -EBADMSG);
 			goto recv_end;
 		}
 
-		if (err == -EINPROGRESS)
-			async = true;
+		async |= darg.async;
 
 		/* If the type of records being processed is not known yet,
 		 * set it to record type just dequeued. If it is already known,
-- 
2.43.0



