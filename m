Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829094;
	b=fEMaK3tVAoIrT1edhKyLshhHyIA2JsoGQ4RmUpM+opABT8cWcEbHccy+iqWRFPkY0+H7
	 Z2KULo8ZmfT0jYWfsONB7cvczHheUs6DCFtz6pyaezRYirE804bbjqRrMBsBx6yCBZHbX
	 VbimGEEEKieaqAh1bbJoGvw6vmZmD+v0xpAbhAXHcINIbM8TTllplAuUlfa99GxN+k9DJ
	 2jyAJfcz5Vg5YyaQq4z99X+hkTTlGyZMR6isMDNahovU1b9pexOfT8NCZwCOfDxFJIvdt
	 M0dlN2n484oGoyVt89XHAEVzzfdNEZqryWagXbG9bQAHRWYlZ+nOed0fqW03ItIHQoQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829094;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gWbA5ezF3opWuWX7aIpjAmkZCMFNlq+ycpA8es+9ebc=;
	b=Q5wODZe7/q0nv8Pe2Thr4QrscbwmeTk6EYDSr7/HmxYSZMffQi4luKPbETGu+eIqvCJI
	 w8n3FZtoUpaGlNFBBV7oWZPeqdcA2PoFJpJ6kV77N/IXzoss57R00diqUFq7EOgQnAMIv
	 x4c8rSDg4HCjXgmRiHYbTrdIl7vPUgI8W8J3vfQjZAfj41w/ozxs6S12xbxKZjvepOcW2
	 OvysTVVMjDGTfql3Zgx3xRcFrMrvSqmIxRmmGJYOuZ0MZA+oUcp45NO81cgZidVHRf4RE
	 57yNUChi4c8gZYTHgmcqSVgOQjIdbNCCSJZ79ACvMqrtxuFNw7eZERtdrBhNV3ZOOXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J6CYsQ4i;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7AB96072FB7;
	Wed,  4 Nov 2026 21:51:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J6CYsQ4i
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 452CF1F00A16;
	Wed,  4 Nov 2026 21:51:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829093;
	bh=gWbA5ezF3opWuWX7aIpjAmkZCMFNlq+ycpA8es+9ebc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J6CYsQ4iS23bl8oTAUseyZSDaSoLjJeOtOvTMojXCwxMOA2f2KpDfLxJ0UW4Jytr3
	 /RH2D7/VQV5pwrXn4Kkt/2rR7+awnET9brEP0C20er6SB3TqopIw9aahoZJxti5Uua
	 aJLWYfkJV6T3WIGFv/5Nk/NSWRHzm7lC6hVJSNo0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 7.3 442/547] SUNRPC: Resume receiving after a TLS control record
Date: Wed,  4 Nov 2026 16:10:26 -0500
Message-ID: <20261104211050.908189851@linuxfoundation.org>
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

commit 8079c660b247f282340fbe7f55cf8a354009db9e upstream.

A TLS control record delivers no payload to the RPC layer.
svc_tcp_recvfrom() clears XPT_DATA before the receive, and
svc_tcp_sock_recv_cmsg() returns -EAGAIN for the record it consumed.
Nothing marks the transport ready again. kTLS raises data_ready for
arriving TCP segments, not for records it has already decrypted. An
RPC Call queued behind an alert or a KeyUpdate waits until the client
sends more. The client blocks until its RPC timeout expires.

The receive takes only the first two octets of the record. kTLS holds
the remainder on its receive list, where each later receive takes two
octets more.

Drain a record that is not an alert, then mark the transport ready
once a control record has been consumed.

Fixes: 5e052dda121e ("SUNRPC: Recognize control messages in server-side TCP socket code")
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260808-svcsock-cmsg-fixes-v3-4-62d9a631c880@kernel.org
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sunrpc/svcsock.c |   55 ++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 52 insertions(+), 3 deletions(-)

--- a/net/sunrpc/svcsock.c
+++ b/net/sunrpc/svcsock.c
@@ -238,6 +238,39 @@ static int svc_one_sock_name(struct svc_
 	return len;
 }
 
+/*
+ * kTLS delivers a record only up to the caller's buffer and keeps
+ * the remainder on its receive list, where no further data_ready
+ * announces it. Consume the whole record.
+ */
+static void
+svc_tcp_sock_drain_record(struct socket *sock)
+{
+	union {
+		struct cmsghdr	cmsg;
+		u8		buf[CMSG_SPACE(sizeof(u8))];
+	} u;
+	u8 discard[64];
+	struct kvec discard_kvec = {
+		.iov_base = discard,
+		.iov_len = sizeof(discard),
+	};
+
+	for (;;) {
+		struct msghdr msg = {
+			.msg_control = &u,
+			.msg_controllen = sizeof(u),
+		};
+
+		iov_iter_kvec(&msg.msg_iter, ITER_DEST, &discard_kvec, 1,
+			      discard_kvec.iov_len);
+		if (sock_recvmsg(sock, &msg, MSG_DONTWAIT) <= 0)
+			break;
+		if (msg.msg_flags & MSG_EOR)
+			break;
+	}
+}
+
 static int
 svc_tcp_sock_process_cmsg(struct socket *sock, struct msghdr *msg,
 			  struct cmsghdr *cmsg, int ret)
@@ -293,12 +326,20 @@ svc_tcp_sock_recv_cmsg(struct socket *so
 	 * kTLS filled in u.cmsg.
 	 */
 	if (ret >= 0 && msg.msg_controllen < sizeof(u)) {
+		u8 content_type = tls_get_record_type(sock->sk, &u.cmsg);
+
 		/* Returning the count would credit the RPC stream with
 		 * octets that never reached the caller's buffer.
 		 */
-		if (tls_get_record_type(sock->sk, &u.cmsg) !=
-		    TLS_RECORD_TYPE_ALERT)
+		if (content_type != TLS_RECORD_TYPE_ALERT) {
+			/* An application data record carries RPC payload.
+			 * Draining one breaks RPC fragment framing.
+			 */
+			if (content_type != TLS_RECORD_TYPE_DATA &&
+			    !(msg.msg_flags & MSG_EOR))
+				svc_tcp_sock_drain_record(sock);
 			return -EAGAIN;
+		}
 		/* An Alert record carries exactly one two-octet message
 		 * (RFC 8446 Section 5.1). alert_kvec caps the receive at two,
 		 * so a longer record produces the same count. MSG_EOR appears
@@ -321,8 +362,16 @@ svc_tcp_sock_recvmsg(struct svc_sock *sv
 	ret = sock_recvmsg(sock, msg, MSG_DONTWAIT);
 	if (msg->msg_flags & MSG_CTRUNC) {
 		msg->msg_flags &= ~(MSG_CTRUNC | MSG_EOR);
-		if (ret == 0 || ret == -EIO)
+		if (ret == 0 || ret == -EIO) {
 			ret = svc_tcp_sock_recv_cmsg(sock, &msg->msg_flags);
+			/* A control record delivers nothing to the caller,
+			 * and kTLS announces no data_ready for records it
+			 * already holds. Mark the transport ready so that
+			 * the records behind this one can be received.
+			 */
+			if (ret == -EAGAIN)
+				set_bit(XPT_DATA, &svsk->sk_xprt.xpt_flags);
+		}
 	}
 	return ret;
 }


