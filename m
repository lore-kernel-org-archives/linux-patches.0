Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035437;
	b=k9gfwJ2ZP8tZDjGZXouOnyMhRkWrK3/W96FJdYHqB7BR/xkOn1vU1DvUYnu5ELYJgq2m
	 07eD6JVv7suQ9Dn5E6gndw0TmoU9w3xxlREGz0HZdi6nrzUqM4Lx6nCF+VLZ7mYseNa++
	 XoswU6bNNQ5iEEaFEFqV86IC8Foa3i0GI+zJuIcQyq/a/cIeHBf2UhwAQr7F7kzp3KYui
	 95smpUt60JgIXZx/3jormSTUdDdImk4QOyQLT2YoiDTpV93vNegTdAeTN9GIZDrXhoWWB
	 55qca8kLmHqZflHykrVE4yJ0dpMbx77YEh2cgc60n8hEdlpQyN8Ct/AKOmhQqcpWFZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035437;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RuSc/AhaIhOKIRY4onAf/hkMUkm+nGMAsdwPcdfvLys=;
	b=IV1QmZ+bp6uA4j4ZkgGfYDYpQZ5xw1mnnghjFBEGrrau0uIjIuun8ydhDTGW6vJg4oN8
	 gR6rsoWRslQ3jN89YQAJiHaP1wfFl85TphiTIg7QcNWjOXV/dhBjMmnsZX4JfPgSEx1bs
	 SW7llOOHTmi+wJLms4qO/qL+wYAG/JaYAQLcFOadpE3gXarv5V18hXugF+Q/tph4sC1kW
	 1n5hebYNVh2umakEo5ga/ykdxluyw4rA6wQmb6hFxmW8c/F3wa5vFL6onTUN24pMN5fpU
	 JN/cUuhBPGygMvBrwbpjJ5ydHdNPaW8oo+EefirhqodEqMoDFMlRx0hyZx1WG9FyS6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Llcn7c84;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4979606A325;
	Wed, 18 Nov 2026 20:57:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Llcn7c84
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23CB71F000C5;
	Wed, 18 Nov 2026 20:57:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035437;
	bh=RuSc/AhaIhOKIRY4onAf/hkMUkm+nGMAsdwPcdfvLys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Llcn7c843/86lI2uRk0vYhzSHcIVaMNGmZu0+r8vu2IGaq5w9onZV/ibQCTXR3ISp
	 RJIloeqUHTEwddEJ7d1KqQGitHBPLQsZyDxbJzoPUeAP7sFmUDbU774qmoiyFDxSRE
	 T022lGC2DAzWHtgYG/O8MbuyyYTbQmr6wfD5CfqQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 6.6 0705/3318] SUNRPC: Reject a TLS alert record that is not two octets
Date: Wed, 18 Nov 2026 15:22:07 +0100
Message-ID: <20261118150339.536000967@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 net/sunrpc/svcsock.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/net/sunrpc/svcsock.c b/net/sunrpc/svcsock.c
index 8e1009302e3b..2e5107a1fb89 100644
--- a/net/sunrpc/svcsock.c
+++ b/net/sunrpc/svcsock.c
@@ -289,13 +289,23 @@ svc_tcp_sock_recv_cmsg(struct socket *sock, unsigned int *msg_flags)
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
-- 
2.56.0



