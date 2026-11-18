Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040819;
	b=l3e/W80IIYsVQP5UY1Uchj78Abwvapmc8NHphAhJ/3BSSsfNJFU+jeZXKBV3WAADIQsV
	 aYIwHZgaI4RDHXqO5zVLYFUiUf/RmwoykPjO8lO6XM5mSTyfBJdZLgmq47wTF9WgsJoJ6
	 rHOVupelQiSLtMWK70xr66lFTdSwb9Jj1134OfMyR1ByVrzgfU2GJeu4KoWOVUhmU07eT
	 RGYBoT86uQX9KIX9GhGAR//d4o6JwCkDKe5s2ADSKUGRluWKTJAJP8zM6tMlZBMYu+or3
	 Itzgl+V7fdR28VN8WK72yGQYJBPLc0Y9lHOzmU7h54Qbo7IzvdmE9tRXClILZ3MNCNA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040819;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=o7HX9hAaOnCpsqXMljTkPZbAs4Hno3ceCZ0DRGT9BVs=;
	b=RPy1rqtGrnx5ERXrKzEg4enMjwnHXTY93Qs99y82Jl0wuhR+XlcT7PmyiFk8Gx7eKCTM
	 h/YwCLkhsUfdXE+x7j9cICzZEZyk1k+w8A2VVa6yOnQ4vkOih4xdMAY6bwdABOrTJLcf6
	 C3RHzXy3LUFNg2yuFI0MRMgEWC78a+L+vqu8gQ7dO81vEcN6DqGGo2+zam3961xVrecby
	 yUZ5P+Y/LJI98oyKhKAcGJPeewUsVCaDeJzEJqHqonlpRL+G6ocUqz06GkgnaLzY4XXlA
	 c+qwN/wqggaTAbwoTdTDfK54dJspCOhEDc6i00Ie0UxhIlxRQHCM8gcKcbiDMTF1p3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qkeikY28;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C365F606A325;
	Wed, 18 Nov 2026 22:26:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qkeikY28
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2041D1F000C4;
	Wed, 18 Nov 2026 22:26:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040819;
	bh=o7HX9hAaOnCpsqXMljTkPZbAs4Hno3ceCZ0DRGT9BVs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qkeikY28/9r40SIlfxUuCbGf+YuiMpEVbRUv91PwZ7TpKwGG7fA8EHnxSHZ/NLUDQ
	 rhjKDhq3VxNsGWgLORmIHKX9wtEYzQ7gc46oKZRHOjXOXbA2XuFD4we8PPxB3BfOci
	 jcJngKMNmU75+MB8Cyq/lOKZ9t+ewlGQxqYnvOqs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <cel@kernel.org>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2594/3318] SUNRPC: treat every client-side TLS error alert as fatal
Date: Wed, 18 Nov 2026 15:53:36 +0100
Message-ID: <20261118150438.988095801@linuxfoundation.org>
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

[ Upstream commit 9b7b1f89b93a3ec1ed121e1ab28450acde815bff ]

xs_sock_process_cmsg() decides whether an alert ends the session by
reading the alert's level octet. RFC 8446 Section 6 retired that
field. The severity is implicit in the description, and a receiver
treats every alert listed in Section 6.2 as an error alert
"regardless of the AlertLevel in the message". A peer that aborts
with unexpected_message but leaves the legacy octet set to warning
makes the client return -EAGAIN. xs_stream_data_receive() wakes no
pending task for that error, so RPC Calls queued on a dead TLS
session wait for their timeouts to expire.

Decide from the alert description instead. close_notify and
user_canceled are the closure alerts (RFC 8446 Section 6.1). Every
other description ends the session, including one this kernel does
not recognize.

Fixes: 39067dda1d86 ("SUNRPC: Use new helpers to handle TLS Alerts")
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Anna Schumaker <anna.schumaker@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/xprtsock.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
index 9c64c81fb678a..0b0663ab466ee 100644
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -375,8 +375,18 @@ xs_sock_process_cmsg(struct socket *sock, struct msghdr *msg,
 		break;
 	case TLS_RECORD_TYPE_ALERT:
 		tls_alert_recv(sock->sk, msg, &level, &description);
-		ret = (level == TLS_ALERT_LEVEL_FATAL) ?
-			-EACCES : -EAGAIN;
+		/* RFC 8446 Section 6: every alert but a closure alert is
+		 * an error alert, whatever the legacy AlertLevel octet
+		 * says.
+		 */
+		switch (description) {
+		case TLS_ALERT_DESC_CLOSE_NOTIFY:
+		case TLS_ALERT_DESC_USER_CANCELED:
+			ret = -EAGAIN;
+			break;
+		default:
+			ret = -EACCES;
+		}
 		break;
 	default:
 		/* discard this record type */
-- 
2.53.0



