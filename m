Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619382;
	b=n3vfaxhTJkaQ6yWsDJzXa7Jgpnp8ZBWoX2mHsSbKG7Jd3+lOngk9CtyeZODqf2w59IVt
	 ljTmt/qFxPLHk+Ka+dkNB9rM3u1rz+Xf7OojMyie1ywkOJEAdYpKKzbcLW6FR5pa1yC4h
	 sq0XWh6Ks/mUU+EZ/649rkWM93claCLTPSlQ1lWgdj7X97QlTC5yvPHooLoAfEQoPqNcJ
	 DIiJa3RctJqxuU1/B9521phad4RMKeS8YroQeowVivjK9FnaN7AdrEQ91iP/XLlD4P545
	 OvDBVgk6UD/J2twN1DlTwIv1a8Q5+qXCR3yu/JfET+eQXHLaJsWTLNQNJZmBYxZjlJg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619382;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ADVnujTVb5/3uHI0hRsGuBCSyKB/SzyR5T4nKuhTnM4=;
	b=4zxyHDJTVCQXGhKwCilCmjD3gHSq0S/5RsVetyA1zN0JD52EqMzOZNbkmdbxRUAQtic/
	 dOB8xLYv0FrtytcM6mLahgnaxUjRhPAVTwYofriQcTTvdiRB80xNe8+L7kaGP4I7ELbez
	 dHAMCzN/rueFpbOBpv501I0R4L5jQB/WYHhhZKpzHy2x1AV/NXGi0LR7AX1gnaJW5ipaQ
	 h2lMwBJfWsibmAGSJItWkTY3Wg2nn+u6O66m+N+2WtwHQQ6w8mZ5LgVIw+qUtuun7Saor
	 /1f33dWqh+vRtsuf1RrDEl97f7TWyNUMctXyI6M9yAxWeQl78o+R2PjqYwtkxlZbF3A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IroD2ZFF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E2B9606A321;
	Wed, 25 Nov 2026 15:09:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IroD2ZFF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 882B81F000C6;
	Wed, 25 Nov 2026 15:09:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619382;
	bh=ADVnujTVb5/3uHI0hRsGuBCSyKB/SzyR5T4nKuhTnM4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IroD2ZFFVw7lxulP2hE2B+4MAMtRXzcO3y+1JhJJ5H+47Ral1qRzKKrAu4uejPV3B
	 xBmDDqflJ53sGosZNp9H5hpRnX2MIHUyXg3HsuCXVOjuBI0wz/Y8DAue99fcqUZpi2
	 3wBDQgq9yJAlOSdI/TQd9T8Hz6e6CSARJl1fPAyc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sabrina Dubroca <sd@queasysnail.net>,
	Chuck Lever <cel@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0551/1005] tls: Consume empty data records in tls_sw_splice_read()
Date: Wed, 25 Nov 2026 15:31:29 +0100
Message-ID: <20261125143834.652823352@linuxfoundation.org>
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

From: Chuck Lever <cel@kernel.org>

[ Upstream commit db6a6c6863bd22b2543e313cb8e4807fdd33778b ]

A zero-length application_data record decrypts to full_len == 0,
so tls_sw_splice_read() splices zero bytes and returns zero. A zero
return from a splice read means EOF, and the caller tears down a
connection that is still live.

Consume the record and fetch the next one, as tls_sw_read_sock()
does. The cap on consecutive empty records bounds the loop.

When an empty record precedes a close_notify, splice(2) now returns
-EINVAL from the control-record test instead of a false EOF. A
splice that reaches an alert record already reports -EINVAL.

Fixes: c46234ebb4d1 ("tls: RX path for ktls")
Reported-by: Sabrina Dubroca <sd@queasysnail.net>
Closes: https://lore.kernel.org/netdev/akaoXcfamBp8_mYe@krikkit/
Signed-off-by: Chuck Lever <cel@kernel.org>
Link: https://patch.msgid.link/20261111185522.2859004-3-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tls/tls_sw.c | 48 ++++++++++++++++++++++++++++--------------------
 1 file changed, 28 insertions(+), 20 deletions(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 3dc0d9db3e882..ecd26d1f3019f 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -2051,32 +2051,40 @@ ssize_t tls_sw_splice_read(struct socket *sock,  loff_t *ppos,
 	if (err)
 		goto splice_read_end;
 
-	if (!skb_queue_empty(&ctx->rx_list)) {
-		skb = __skb_dequeue(&ctx->rx_list);
-	} else {
-		struct tls_decrypt_arg darg;
+	for (;;) {
+		if (!skb_queue_empty(&ctx->rx_list)) {
+			skb = __skb_dequeue(&ctx->rx_list);
+		} else {
+			struct tls_decrypt_arg darg;
 
-		err = tls_rx_rec_wait(sk, nonblock, true, false);
-		if (err <= 0)
-			goto splice_read_end;
+			err = tls_rx_rec_wait(sk, nonblock, true, false);
+			if (err <= 0)
+				goto splice_read_end;
 
-		memset(&darg.inargs, 0, sizeof(darg.inargs));
+			memset(&darg.inargs, 0, sizeof(darg.inargs));
 
-		err = tls_rx_one_record(sk, NULL, &darg);
-		if (err < 0)
-			goto splice_read_end;
+			err = tls_rx_one_record(sk, NULL, &darg);
+			if (err < 0)
+				goto splice_read_end;
 
-		tls_rx_rec_done(ctx);
-		skb = darg.skb;
-	}
+			tls_rx_rec_done(ctx);
+			skb = darg.skb;
+		}
 
-	rxm = strp_msg(skb);
-	tlm = tls_msg(skb);
+		rxm = strp_msg(skb);
+		tlm = tls_msg(skb);
 
-	/* splice does not support reading control messages */
-	if (tlm->control != TLS_RECORD_TYPE_DATA) {
-		err = -EINVAL;
-		goto splice_requeue;
+		/* splice does not support reading control messages */
+		if (tlm->control != TLS_RECORD_TYPE_DATA) {
+			err = -EINVAL;
+			goto splice_requeue;
+		}
+
+		/* Splicing zero bytes would read as EOF */
+		if (rxm->full_len)
+			break;
+
+		consume_skb(skb);
 	}
 
 	chunk = min_t(unsigned int, rxm->full_len, len);
-- 
2.53.0



