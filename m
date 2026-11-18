Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035555;
	b=ZQAeuLo1Ckqh0/TcN2EOBptFKl4zyJurfAXH3tuJTPnousQoQa+Y5BHuK9MkbC7iWOPQ
	 ZIWe9INNa/GxWOS6aa5G/VpPqnN850Xw6n9mB2P79B6nOgiF4JT6kSLRhs5iL1WeOwQ3d
	 SyRVfshxEln7POcAHKg7jYfG+WNjjZbTMEh6BRpPVQyJxXb/wGLMYYPR90PgCuHV2zD4X
	 vdloe8VCMA3pmMdb9eOzFL47k5iWhg2Sh+GrbxVwkMiaF+Vc17g2xUrVzs3wTVm/Woe4d
	 1+5Ok+asuFytFxkcCfkARKQLmtF1iK8KA++jn1frrvMz3g4ypfe26P6jw3iMZsYN9/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035555;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=z9X+o4w1rO0Hrn5FCx1qYPu9GVyoIF3Fy2W9QPw47XE=;
	b=ltsdoQth2WQje2cNKRSR1J1ENCMMk0H+X0mcDRPKjtgMyFXQpQSnPvctiTAaCTee7KDk
	 v2DVt4643PD8jomwFEI82iPtldNXKMf8ypmWtSHRd/bJq7x0/zuXxdYAIgcG1d+lJKqnG
	 pYyYay4yze0o1IoBeTKYBMWYq8m6Td/0zTpGvli84MqhGahS6Kg58p7Nh2gfYdTs1f3bq
	 xFWbOTTD6vLKEqswIHZzayl5s+ITxaphR9ZeZHlp8m3cFHWsdBczIsoc+i6dSlzS1U0sF
	 /2JD2eY2Rurb9vxCMBtq+Np5T9qqhOV8YeHwkfl80yCoRGopAlLcltqEmzoEXQ+cvHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pbE8SrlX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A779606A31C;
	Wed, 18 Nov 2026 20:59:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pbE8SrlX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C38CD1F000C4;
	Wed, 18 Nov 2026 20:59:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035555;
	bh=z9X+o4w1rO0Hrn5FCx1qYPu9GVyoIF3Fy2W9QPw47XE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pbE8SrlXG2p4eCfrDqUU4pcB9cdIRqZE6nz+PHF5faK3jmrmKT3Z5EgN0ddkXUnX7
	 7kvfBpwqw81ouT1/2zhR+xsluXx1ZNzMLykCzE4D6f4t5RCTl0J1MSMzvFLqq1nFU3
	 qZ/aIFvhA679vV1BF0lOhPaW+vnn4ambfNegWfZI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 6.6 0700/3318] SUNRPC: Do not credit control-record octets to the RPC stream
Date: Wed, 18 Nov 2026 15:22:02 +0100
Message-ID: <20261118150339.361796337@linuxfoundation.org>
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


