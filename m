Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829092;
	b=ZjbscvCpsxOxpquK35LQRVTK0/PWh6h4k4kOf7EhZ5nkmdPRrqsxJX/RZcvQRGF2dHPc
	 MrryvT2aILAQJ0bTk7G5BxAUVvKLI5kYXaFwdOZ8GA21CW/lIjsBfAJNJKDGSr8cKStwk
	 07usI7l8qxTEPxcyLE/ruShYs+fvqvfpzFfdm8x+QMUMV8zM2n/AWNcIgF9JoRSDDj3ln
	 nYnYvW1n8sEtUFUGvpJ8yTfpFf97u+5NiK+CydvEiictZLLLySdNc0eQ3g7ZRM5Ck18vb
	 3tcmMhcSW/S/JKDsApt9w6blRpsJPm2j2idVWxqw/FE3C+pV0iBoGT1YmP5tt9wL9Fg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829092;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=P5qQc8tfBewrRy0hGoALtkS46hdRDvYOQcqPSo2PoAE=;
	b=Rd0vNsh0WK5SRcCh1iVibS49RnlxoM1AOENO/Bf4TE5wJwcEQi8tdcqJAaot+WEkFD6d
	 0dfICoGcXmdlXHNMS6kdMOu9u6P9qyW5a7eKDpNRl4aFI4Q8dy/YCPhi8R/sQ3vt3+2Mt
	 mp/RBWn1fiaJ+kLIsM2Q0l38gN6Adyqc9YJuLhrkzthjWqmgGltSQ+7vrG0OG7EAt9HSs
	 LuYeuAv24kk13ZPag33vFZa9QEJConElI+ZQ4smu5cWKjHEsgVptb3J9iBOjT8B/OQPuD
	 0zYn3rA4i9obvpYbTnSvyJ6s+bsn0Rbr0C6yuVC0XjKf/FHIG8JX5o344g3FWBtwRyg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bN1M+0gC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 394DB6070318;
	Wed,  4 Nov 2026 21:51:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bN1M+0gC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8E541F000C1;
	Wed,  4 Nov 2026 21:51:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829092;
	bh=P5qQc8tfBewrRy0hGoALtkS46hdRDvYOQcqPSo2PoAE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bN1M+0gCuMRbMkCR/LtkcDXOI9+C774aCDgnIgHqXGc7lc8q19H3NMNJCm7k+sFPB
	 0Q/QgO6QlLrCYQew/RnKET6BxrAWxQ9ql41CUCeuhmyj0MN8m3eH/wUDPs0KT8u0/8
	 AN4AYspw+Y5p9Z0OFY94pRhO4R5Q8iuVT4OmZDaQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 7.3 441/547] SUNRPC: Reject a TLS alert record that is not two octets
Date: Wed,  4 Nov 2026 16:10:25 -0500
Message-ID: <20261104211050.880995814@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

commit d16bebe45272ced4f962d27b9efd8b32a3876bd9 upstream.

tls_alert_recv() reads two octets from the kvec it is handed and does
not check the length (net/handshake/alert.c). svc_tcp_sock_recv_cmsg()
calls it for any positive receive, and the alert[] buffer it supplies
carries no initializer. A one-octet alert body leaves the description
read from uninitialized stack and reported through
trace_tls_alert_recv().

The peer controls that length. Neither tls_rx_msg_size() nor
tls_rx_one_record() enforces the two-octet Alert payload. A TLS 1.3
record carrying only the inner content-type octet decrypts to a
zero-length payload. RFC 8446 Section 5.1 requires a record with an
Alert type to carry exactly one message, so any other length is
malformed.

Require exactly two octets before parsing and return -EBADMSG
otherwise. That closes the transport rather than acting on a partly
uninitialized alert. Gate the path on a control message rather than a
positive count so that a zero-length record reaches the check.

Fixes: bee47cb026e7 ("sunrpc: fix handling of server side tls alerts")
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260808-svcsock-cmsg-fixes-v3-2-62d9a631c880@kernel.org
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sunrpc/svcsock.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/net/sunrpc/svcsock.c
+++ b/net/sunrpc/svcsock.c
@@ -289,13 +289,23 @@ svc_tcp_sock_recv_cmsg(struct socket *so
 	iov_iter_kvec(&msg.msg_iter, ITER_DEST, &alert_kvec, 1,
 		      alert_kvec.iov_len);
 	ret = sock_recvmsg(sock, &msg, MSG_DONTWAIT);
-	if (ret > 0) {
+	/* put_cmsg() shrinks msg_controllen, so a short one means
+	 * kTLS filled in u.cmsg.
+	 */
+	if (ret >= 0 && msg.msg_controllen < sizeof(u)) {
 		/* Returning the count would credit the RPC stream with
 		 * octets that never reached the caller's buffer.
 		 */
 		if (tls_get_record_type(sock->sk, &u.cmsg) !=
 		    TLS_RECORD_TYPE_ALERT)
 			return -EAGAIN;
+		/* An Alert record carries exactly one two-octet message
+		 * (RFC 8446 Section 5.1). alert_kvec caps the receive at two,
+		 * so a longer record produces the same count. MSG_EOR appears
+		 * only once kTLS has drained the whole record.
+		 */
+		if (ret != sizeof(alert) || !(msg.msg_flags & MSG_EOR))
+			return -EBADMSG;
 		iov_iter_revert(&msg.msg_iter, ret);
 		ret = svc_tcp_sock_process_cmsg(sock, &msg, &u.cmsg, -EAGAIN);
 	}


