Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D471B322C80;
	Tue, 26 Aug 2025 13:12:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213935; cv=none; b=K3zb1PpZfPU7rZmGa4EkwGvND2a6A2/kdQs/lRA6zBKLBwHbjRv7vZKcpYoobumdUufqbNLfIcOcfZQudJ37naZX3svngr2Y3uYOzF+O9Ja3oCG5fEvcto+FIyXZa078XKvPqAqlRvl3eJcCGrbTZXNhP2MG7zWmZxqSt69tTpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213935; c=relaxed/simple;
	bh=eqd2sPTdsQk733PWjDf6BiC5D+mGYvpbOW9W6yK89/c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gJPLS5SnY83hZ23f1JWTiegO/gzayD+JW5OqRGyk/Q5dTyLk5uQ/+79PENIwDTfHIY43MdkJZBONYSsxnTrBdarMv/oL2ulWwEnUC95FPXAiJ/IkSmqvbHxM+V2zqss1MLwZKKdLQi+Tp0KJP8iq4BTsP37T/F3cEi7O9P9qbVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2TW/LkRI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2TW/LkRI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31975C4CEF1;
	Tue, 26 Aug 2025 13:12:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213935;
	bh=eqd2sPTdsQk733PWjDf6BiC5D+mGYvpbOW9W6yK89/c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2TW/LkRIfkOq7meyw7+mscxjiBvqnT28rmA3yAtJHYKeI6EMO7taZw3yxYVOHS0Q8
	 f9VIxa/KzhJz49RqO0AbjNKdU2VcZoWiQVfZGUhPQVRN3od9uiQL3ljupmANMhtcKc
	 9FVImOWy/svLsPDVteRDq88FlWpmuavPd7j8brw8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Alifa Ramdhan <ramdhan@starlabs.sg>,
	Billy Jheng Bing-Jhong <billy@starlabs.sg>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 535/587] tls: fix handling of zero-length records on the rx_list
Date: Tue, 26 Aug 2025 13:11:24 +0200
Message-ID: <20250826111006.618576591@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

commit 62708b9452f8eb77513115b17c4f8d1a22ebf843 upstream.

Each recvmsg() call must process either
 - only contiguous DATA records (any number of them)
 - one non-DATA record

If the next record has different type than what has already been
processed we break out of the main processing loop. If the record
has already been decrypted (which may be the case for TLS 1.3 where
we don't know type until decryption) we queue the pending record
to the rx_list. Next recvmsg() will pick it up from there.

Queuing the skb to rx_list after zero-copy decrypt is not possible,
since in that case we decrypted directly to the user space buffer,
and we don't have an skb to queue (darg.skb points to the ciphertext
skb for access to metadata like length).

Only data records are allowed zero-copy, and we break the processing
loop after each non-data record. So we should never zero-copy and
then find out that the record type has changed. The corner case
we missed is when the initial record comes from rx_list, and it's
zero length.

Reported-by: Muhammad Alifa Ramdhan <ramdhan@starlabs.sg>
Reported-by: Billy Jheng Bing-Jhong <billy@starlabs.sg>
Fixes: 84c61fe1a75b ("tls: rx: do not use the standard strparser")
Reviewed-by: Sabrina Dubroca <sd@queasysnail.net>
Link: https://patch.msgid.link/20250820021952.143068-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/tls/tls_sw.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -1774,6 +1774,9 @@ int decrypt_skb(struct sock *sk, struct
 	return tls_decrypt_sg(sk, NULL, sgout, &darg);
 }
 
+/* All records returned from a recvmsg() call must have the same type.
+ * 0 is not a valid content type. Use it as "no type reported, yet".
+ */
 static int tls_record_content_type(struct msghdr *msg, struct tls_msg *tlm,
 				   u8 *control)
 {
@@ -2017,8 +2020,10 @@ int tls_sw_recvmsg(struct sock *sk,
 	if (err < 0)
 		goto end;
 
+	/* process_rx_list() will set @control if it processed any records */
 	copied = err;
-	if (len <= copied || (copied && control != TLS_RECORD_TYPE_DATA) || rx_more)
+	if (len <= copied || rx_more ||
+	    (control && control != TLS_RECORD_TYPE_DATA))
 		goto end;
 
 	target = sock_rcvlowat(sk, flags & MSG_WAITALL, len);


