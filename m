Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061740;
	b=Ty6DrVG4YLwAkn7IrelXt3mPKmwSHcllelngAF1J7wc2KqBeJENKlOV37yW+Zm/iw8D2
	 F+VpHV5DN/RjlfuHKfxm7ItI3QJ91kj1zg2xK/yeeNbKiVjFmcg5ux0s24nK0tPlVQe8g
	 Gftq1LgiTGNeD1qP7WjwjCIqTQT1bJKjDyCQiniEO8C9mDwhNA/ik+9q2BA3BqYHEQgI4
	 Npkwcd1lBdgCaN4z8aN0YDApob4F3CRP5elqYPCoshpsyt7wqdCDR+OYseSHJ8gWT3zrW
	 57bxCsv4DjL/ZgdgCMjYiy3tSokbJ58/EG70GjoBUqUtRWAX3oazRsGxccAyPQXMQcQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061740;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tzlE7+1ZVrBm7sZ3GGjmhPEvLX3PT4maZGNyred1fo0=;
	b=AJlvZeODxUo1V0uoqHlwEQgFLQUaNWW9XI2hIJeHpDI7UHcGsVXGmBk9xqypIn0cR0d3
	 ETO+TpLptXpniSCKjiRNxVcyZTB0G4AHVQbkq0XrdCDojurJNsqKxBlwsPCvyYMWIfJn+
	 LhY2fp4yg9oeTKsbhfaiQE+wJhxPJd5YgJUyPF5IDc9o1mm3sUM0/TKXxX7inYhyNL2F8
	 q6e3iUko6VZbuTzYHLj9IKqRdYyPp6M80X6Vax4etawAVS85bLOVVArgaBr7pqwxOx5vl
	 F2rz8BUd1zH0aJ2IiMVuuumGTJ5IZP4Nny6DeOvMHXUuE4MCllFg0G7vrUW4CkVPUoQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gfStAjv7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EE6D606A326;
	Sat,  7 Nov 2026 14:29:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gfStAjv7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F097F1F0089F;
	Sat,  7 Nov 2026 14:28:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061740;
	bh=tzlE7+1ZVrBm7sZ3GGjmhPEvLX3PT4maZGNyred1fo0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gfStAjv7G/bERGfqhVI5DAgNyZfx8QFw8zVBK1v8QzzZa+i5Vqo4ikCk71YbVsz5L
	 bLW6xuckIZxzmgY21xngnhQ37BmFlgZ+Oi+/knbHBeegj0AcrMV55H3NmO3iy40VJ4
	 g+YA8YTGunVJwBuSqvRzk/6HNOIISpseOQNQtisE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 6.12 0780/1536] SUNRPC: Do not credit control-record octets to the RPC stream
Date: Sat,  7 Nov 2026 08:46:36 -0500
Message-ID: <20261107135019.446622723@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


