Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018661;
	b=oYL4YNxzb4qU5aPhbWM5OJk3DqKWOEuCG/e7lmH3vZLjdcpmEIndg1G0dZLGPXSQlcnB
	 +UCpidgcl3lU0H19zDef+puLMIZl/7URaTqa3/WeMLeQyBuJRLUODswQunrIv1FhXxWxE
	 FrGy+e28fZjb7Qzb6JnqvNTbHuCwDMHQA6Au+GM5ozOq2HmURXgVO9YxAozsQtnsLItjZ
	 jxGKtk7+wcX3BlBZn9xbP8ASTNwwsCE4uI5nMS+Wy4cLiyc/M8JU11BdA3NGZT/WAJgd4
	 6jZ3wlnFMytqhas2gMGP2lsT1scnXeNQ0zIIQH84LbOmvMTJcCG61N6rz8pHEocSwGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018661;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BEbtrqtASQ8ELPlAPdgGitOmIQZU9Ll1l8L+J3o/TDI=;
	b=b4Lx1Q6x4QGJtyahCsfoiP6o9cgXcq4V8JEY3v5Exi2qqTySORzlDxUaMXFjeggvv6RQ
	 TIN7Pl8mtBt0SfZ4RSi3xK/eX/YqWogxnuPCWSrQrsrhKEWWYCtgF5SfBfa9CLJmZfA/a
	 vBvOpHtEYc+j3YfY+JWcwnIEoU9GFqORgFTdta8S/P1Ns7w/TGvGt9b0A8wioyJWzXomq
	 86s0Ofr4r3ZvPHFmkcPgw/DH5VRbRjH2FsLIBrUjbDqtCcH804J/ILJEF8t9/mW6pjX6F
	 R4lqk/JfdruCTqkWNSP+bI6lKhuavsW3/S4WcWy5ct/3QM7GbbKDIGg6deaOru1314Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kNENgVZV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42C3C606A31C;
	Wed, 18 Nov 2026 16:17:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kNENgVZV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 986011F000C5;
	Wed, 18 Nov 2026 16:17:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018661;
	bh=BEbtrqtASQ8ELPlAPdgGitOmIQZU9Ll1l8L+J3o/TDI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kNENgVZVbZSQgQWLySQhnUfFBhKf3yyyktUNzZTVnkBrrEAIQQHJZOTiUAe5zBa0L
	 vu7OqrzHVPuS4RHnerox7AGUa3AvqO7IODbXH6fvgmrmZLI2nZM3hZqzCZmiqGKU8+
	 jsQsrNPu51WxWp3kiWS5tutK1MdjZbaEdEkkRRwA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <cel@kernel.org>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1320/2651] SUNRPC: treat every client-side TLS error alert as fatal
Date: Wed, 18 Nov 2026 15:42:40 +0100
Message-ID: <20261118150335.520646204@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
index 8274752969219..963e46a514217 100644
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



