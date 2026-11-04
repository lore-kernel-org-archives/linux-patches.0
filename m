Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829143;
	b=KKaxruc2E2PJAvS29YVHiAUWRHkfyr0gQcwle5i7i42RQBCUbJ1YBVyDsFo5ItZgHZSt
	 53dDDKFqLSRYnKZGxcbpfX4Z5OUFP376vTqPfU+qDcaasTbjwp6iy3XiSdLjO0HU9VamN
	 Jn7pbHo/Y8S1HYZNc58tkHgsY3XyYIdTbRQCcN8c+zQCDU8j2ETsfgsKdzJyXYdoeK7X3
	 i8PFL6kkUVAHzlnz1DbMZKFxLerKK14RXUCXxojaE7MsJq0whWmKKSFwlDVwbwYYjfOOx
	 9/YwZbG34FTHgcKj7uY8ycXOb5BxuvehziqnBu6msS+eZxoDhNGN2sWfMNbQt+KmhNA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829143;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=H385g6MjbN3tMZFk+jZ9AwPcHV8J8Vx6HxQ2/H4gfNc=;
	b=fvJh93V1O42T5Y060Ym8/EwUviBBQdca3eZ9dEbcy94r3ynGFyhY59a8haKikVW1gjVB
	 v5pT93kNDJtbu9kAJPLc0NsTX7p+9jjlJOyODifvnvEQnwpq5GuFraemGra3JjecKRt6V
	 k452hzSgdTJLat1EtrNElaGHB2WgsrYCPMhBcYz50SDLJE/xuJrsFCMZGfv3Meo0ZKp52
	 5VHO0h2PlFJQT98gpE12wT8ASWh7JdV5SXTrLtiEFJe11qeP8FOa3oW51w6YvpVk8oRxq
	 O9sBNtP861/hYlahrC9eiVYMDvfxvC81RD+tdaP/W/XtlcMFX+C7dQZNW/2tS4YyHMA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g3Idy0Ge;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF354607077E;
	Wed,  4 Nov 2026 21:52:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g3Idy0Ge
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FE3B1F000C1;
	Wed,  4 Nov 2026 21:52:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829142;
	bh=H385g6MjbN3tMZFk+jZ9AwPcHV8J8Vx6HxQ2/H4gfNc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g3Idy0Ge8SU09gp1NhzBqkmbTIOyaIHdmIkuaQDq0apRMqr2J4Z26IAGfnkUVlezn
	 ir/Qylys8yJrVMCQxGHj5H4GhIt5i/A/sa/J9qMI2eC64auSmscNj6wpsuNHhFYPqf
	 RgHYjQL3LDL3/jriS2VSrJjKrxcScYQhI7VgAq4Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 7.3 435/547] SUNRPC: Do not credit control-record octets to the RPC stream
Date: Wed,  4 Nov 2026 16:10:19 -0500
Message-ID: <20261104211050.706189657@linuxfoundation.org>
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

commit 129e7107b971009bc81643d23f3ab949f540d321 upstream.

svc_tcp_sock_recv_cmsg() receives up to two octets into a local
buffer, and returns that count for any record type other than
TLS_RECORD_TYPE_ALERT. Nothing reached the caller's buffer, but
svc_tcp_read_marker() adds the count to sk_tcplen and
svc_tcp_read_msg()'s caller adds it to sk_datalen. The RPC stream
advances over octets it never received. The fragment marker is
assembled from stale sk_marker octets. The message body comes from
pages nothing wrote.

A conforming client reaches this. RFC 8446 Section 4.6.3 lets either
peer send KeyUpdate once it has sent its Finished, and svcsock has no
rekey path. kTLS leaves the partially consumed record on ctx->rx_list,
so the body drains two octets per svc_tcp_recvfrom() call. Each pair
is credited the same way.

Return -EAGAIN for a record that is not an alert. That is what
svc_tcp_sock_process_cmsg()'s default arm returned before the receive
moved into a local buffer.

Fixes: bee47cb026e7 ("sunrpc: fix handling of server side tls alerts")
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260808-svcsock-cmsg-fixes-v3-1-62d9a631c880@kernel.org
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sunrpc/svcsock.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/net/sunrpc/svcsock.c
+++ b/net/sunrpc/svcsock.c
@@ -289,8 +289,13 @@ svc_tcp_sock_recv_cmsg(struct socket *so
 	iov_iter_kvec(&msg.msg_iter, ITER_DEST, &alert_kvec, 1,
 		      alert_kvec.iov_len);
 	ret = sock_recvmsg(sock, &msg, MSG_DONTWAIT);
-	if (ret > 0 &&
-	    tls_get_record_type(sock->sk, &u.cmsg) == TLS_RECORD_TYPE_ALERT) {
+	if (ret > 0) {
+		/* Returning the count would credit the RPC stream with
+		 * octets that never reached the caller's buffer.
+		 */
+		if (tls_get_record_type(sock->sk, &u.cmsg) !=
+		    TLS_RECORD_TYPE_ALERT)
+			return -EAGAIN;
 		iov_iter_revert(&msg.msg_iter, ret);
 		ret = svc_tcp_sock_process_cmsg(sock, &msg, &u.cmsg, -EAGAIN);
 	}


