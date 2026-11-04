Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831797;
	b=qfDWgYkTFVlvR/WkpC/Z9I69O27NJJrMOiyudnSaskyIPVnbQ5mY/wsXbgxrqF+cSNtl
	 E01++E+aelYAxg2A58BGlxouGWyBILF1IwGKDQS+SWRsePaQZ7hUYiS4HJ8iuikoKOQ+V
	 V0gLveEx28loC/VZ7qzxYn5s09rwwDetmNJ0bRQlQNeIAmllr53X86PCvSij02/LLItCf
	 tWMYUNZU8OjKpDGu1PBV059O080iPx8FS75EoCEDswwCgxhu2L1DGbc03MIC+ugcVmQ5b
	 lXMlnHkALjLxXs2wD7Kc883onC54se25y6lB7XCcgD8B0MVqmYG2CjYWFURlCQiJXhQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831797;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KvEpP2g7jLtKxNRa1q/paY7beSrtBifvUYlL/J95oek=;
	b=PJnUQ0Z4beYdJ+TzD8X24+Y15JzaAqw1lgZUUK0t2tgOTsC7na/DA4pD/RjApk8EFMkQ
	 jeaZnubakYEOk4yozrz7q9DWpVv90TOxQebk9+HVwAJmzGclcJeB7qndfiQXF2BqrG1o1
	 5o3XNB2FUH7af+Iuh8tnSmnHNOiXoHJS9SHBfpsN/M8XmcyU/HHathXdw+nw8Dm5DAGZP
	 kd27iMrrhSiq22MffPGf4O+UoYnZb+odBj8PA47LxY9D0N57Ow7oKqZX8o+cWrhUz1ZZs
	 wnMwH6G1h4c8ICxuKqSQr94ukSYd3FIA1zFj2ISu7JrRTR3CgT+TdXV7J3erozVXHog==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nj8YDChb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9EEA606A33A;
	Wed,  4 Nov 2026 22:36:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nj8YDChb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52FF71F000C1;
	Wed,  4 Nov 2026 22:36:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831796;
	bh=KvEpP2g7jLtKxNRa1q/paY7beSrtBifvUYlL/J95oek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nj8YDChbLgXL4WSwuoUEbuE7BKaZb0gdvpEAfce/8fEklJ+iYV048RyCNwHIEfRgx
	 mYLVHmnFYkV/gZyvZG6B+wQj+UZZ0frxp4Bme56B4yuqB346k6+uWgEMPHZWafBme5
	 u0AGdWjlZb+k7+nt7Z3qWtFgfmaxblavBH4Gs3uk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 6.18 0917/1005] SUNRPC: Treat every TLS error alert as fatal
Date: Wed,  4 Nov 2026 16:10:50 -0500
Message-ID: <20261104211108.841229853@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <cel@kernel.org>

commit 2c0dfe9d6d81e4bc9201b11dab3876cbfd01884e upstream.

svc_tcp_sock_process_cmsg() decides whether an alert ends the session
by reading the alert's level octet. RFC 8446 Section 6 retired that
field. The severity is implicit in the description, and a receiver
treats every alert listed in Section 6.2 as an error alert
"regardless of the AlertLevel in the message". A peer that aborts
with unexpected_message but leaves the legacy octet set to warning
makes the server return -EAGAIN. svc_tcp_recvfrom() then leaves a
dead TLS session attached to an open transport. NFSD keeps polling
it.

Decide from the alert description instead. close_notify and
user_canceled are the closure alerts (RFC 8446 Section 6.1). Every
other description ends the session, including one this kernel does
not recognize.

Fixes: 39067dda1d86 ("SUNRPC: Use new helpers to handle TLS Alerts")
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260808-svcsock-cmsg-fixes-v3-3-62d9a631c880@kernel.org
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sunrpc/svcsock.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/net/sunrpc/svcsock.c
+++ b/net/sunrpc/svcsock.c
@@ -290,8 +290,17 @@ svc_tcp_sock_process_cmsg(struct socket
 		break;
 	case TLS_RECORD_TYPE_ALERT:
 		tls_alert_recv(sock->sk, msg, &level, &description);
-		ret = (level == TLS_ALERT_LEVEL_FATAL) ?
-			-ENOTCONN : -EAGAIN;
+		/* RFC 8446 Section 6: every alert but a closure alert is
+		 * an error alert.
+		 */
+		switch (description) {
+		case TLS_ALERT_DESC_CLOSE_NOTIFY:
+		case TLS_ALERT_DESC_USER_CANCELED:
+			ret = -EAGAIN;
+			break;
+		default:
+			ret = -ENOTCONN;
+		}
 		break;
 	default:
 		/* discard this record type */


