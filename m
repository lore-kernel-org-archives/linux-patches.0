Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9279434165A;
	Tue, 26 Aug 2025 11:30:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207820; cv=none; b=aKDXbfpumjcWq9jmFgq03Ytghr14uLWzhaYwnDnwvYDbDw3Sr+GE+YqSllx0iAkHCZZzlwz92V2RYK25Obpx7mePY5yEUHGw0QzWRE6SI5kpCOi/BywUi69Ie34zGE/5Gxz1nmquOTJH0WuyS7ktFf0jaLp3YvHVMxVvkMNeLTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207820; c=relaxed/simple;
	bh=h2kMCeDcT9D410Cm1MDTZuKVB2Tg5u9L4+omnCIqy8A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y2OPpZkN39Ih+psEgMYJ08vfpw92Sqv7CfOQdZwJwx7LYtskAg6RzjdK+koDHcj2IAw2rgboe2fojmluq784sp9GUL45Dyvg08Ts2jvKNw/aQB4q6ghq8TEUzrKaV985Gw/uVSkdTjXGhYYMxbDcoS28Do23rJlKM7NvZu6J8mQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p1BtHzSB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p1BtHzSB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23B23C4CEF1;
	Tue, 26 Aug 2025 11:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207820;
	bh=h2kMCeDcT9D410Cm1MDTZuKVB2Tg5u9L4+omnCIqy8A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p1BtHzSBVCTDnEPDCfRLZFjcvbvK+ZW/P+6QH3e4N7CAoKOEcescdp12xTm+nTdf8
	 wdgK+9Ob8vDpw3pNwDznZ4h8EaysNc+6p57r06HXRc/ms2Vg9ub0zwQS084//UwL3h
	 asmbqwUkoOq7/A1pNPYfnnAt1TehuWrkjrYXcaHo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Alifa Ramdhan <ramdhan@starlabs.sg>,
	Billy Jheng Bing-Jhong <billy@starlabs.sg>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.16 330/457] tls: fix handling of zero-length records on the rx_list
Date: Tue, 26 Aug 2025 13:10:14 +0200
Message-ID: <20250826110945.498306143@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1808,6 +1808,9 @@ int decrypt_skb(struct sock *sk, struct
 	return tls_decrypt_sg(sk, NULL, sgout, &darg);
 }
 
+/* All records returned from a recvmsg() call must have the same type.
+ * 0 is not a valid content type. Use it as "no type reported, yet".
+ */
 static int tls_record_content_type(struct msghdr *msg, struct tls_msg *tlm,
 				   u8 *control)
 {
@@ -2051,8 +2054,10 @@ int tls_sw_recvmsg(struct sock *sk,
 	if (err < 0)
 		goto end;
 
+	/* process_rx_list() will set @control if it processed any records */
 	copied = err;
-	if (len <= copied || (copied && control != TLS_RECORD_TYPE_DATA) || rx_more)
+	if (len <= copied || rx_more ||
+	    (control && control != TLS_RECORD_TYPE_DATA))
 		goto end;
 
 	target = sock_rcvlowat(sk, flags & MSG_WAITALL, len);


