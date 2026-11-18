Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025511;
	b=G1s05Ws0CJ0H1KGUQRXO44jPwVWOjfKgT/2GR8Ovjdcu/lcQCVNdgyNpJ8HNozLSgkAV
	 JxuQLeKAuwmQqgfagIjvgJyZFAU0g4eoW1XDdOlQcNWczTV62s2jrhp2PZKZJBUpMqhET
	 Mxzkth4SpqN+nHuzPf7Y3jq+N4iL+crhvRjprIDBZQlu4X5PyrkHygHrJLaqqdMS/uIe/
	 NkWzn1X+SuSB4LTHCBx+68DaK2nQlO/NyFDuDJxh4nWt9Z137H8SQtL8/EHvovP5zJJ4x
	 4M5wzGwd5lHg2jp8PCjUH8m4DO+/R8b4/+Ki1/XNH5qEzP0IziDbGNbx+PO4S+ZuDRQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025511;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=X2x2FGkaL1tQSZe08qWOgvzjLaXvA45yiES8BfyMb30=;
	b=4a4flWmBp+0Edw9vmohKIOYFHLLyi3DgR67HETfs4oBSP6ZLBJ/Xo4X4QHhWV0Wf0YK9
	 D/qQV16As3zciVKK97ZFxIxPEqObZIULaHRqeFAe0r9TunSdNNKLKxTARXU2EOlE5U3M2
	 9oOPFdIKCNXIt4DS1F8BOSuwn1wQLYfFfeEPpuS6nv8j7ucyxmB4kbfhe+He6jv0vM6KZ
	 RQspz74ZPv+BOnCD5s67u4FtQoI0XLkTwlHkFDtP6Gg/ELXHfNN9JgU36mz4s7sL4etug
	 HZ/xuEiYzNXt+/1W/RlesfcmR2STDhZg3vSxdFphp/tNitFKkj0Ral22g0VP1HaYzRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ocLDG2QD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81414606A32C;
	Wed, 18 Nov 2026 18:11:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ocLDG2QD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D98EF1F000C4;
	Wed, 18 Nov 2026 18:11:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025511;
	bh=X2x2FGkaL1tQSZe08qWOgvzjLaXvA45yiES8BfyMb30=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ocLDG2QDv36eka5j017vDp3xVh6kMAig55zCfQFkyOhg2C9OYtjRBqaKSmrPLugg9
	 tleCI8Yot2QnVrYVggE1qf9ywBbcfK1oBWLzbVMdtU8EGRfYhJTWWuB8IojmZMoxam
	 G7EP4xUoOJ1dVmRbqn6dbY/lZ401Jla1LE20XyEA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <cel@kernel.org>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1103/2151] SUNRPC: treat every client-side TLS error alert as fatal
Date: Wed, 18 Nov 2026 15:47:18 +0100
Message-ID: <20261118150202.429784806@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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
index 04e0052c565b8..e2318100d8110 100644
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



