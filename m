Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035449;
	b=wTheh/knSELvMrnhCbsasUPS1RWf5iJp45FseLoyqqD2uJJDVQMYCosqRobcIZpLS8SZ
	 PbgGOOfTkJ3tk5HCPPE7XbkNwjxvt5//qNelyqo61i9OuoXVKbcrXylNJqvAM/dy6QD/g
	 MtKqVpRkQHWw2R240gI3NP6JYUOpweiGFSwmEOoKyXyQ9gbcryZ4vod/Pi2k2/Bo0k+Dv
	 qM7Sn2cXZ1/avdqQhX53UswA3WZV9L7NnBJgeEEJ9b96pMzkiYYLUbC3ghM3hOGdH6mTL
	 wg8oVwCwsBFBxOY1UJmxhQxI1bjq0WUn6hx6XPiqMrU0KnaL8voKg+6al6U/5BMdfJw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035449;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4eG1vylNVlmkb5XDrrowPsG38Vp4ZfImoW3IV8FNBg8=;
	b=eZzmwjaivZyMJ9kaqq/FnvyAYRvsBr5JNRT+17WhCrb5NhklaHIgMZSxP4QLSZC9QNIC
	 EZBfOQgKrSlFqAahzQXTOc1gS937SG9tQKzRbAbUOs+szGDsUrA/94zK/SFUg1z9vnwol
	 G40bxtusXrbqOHXha42wSc81j2sOSSvvBZPIf1Wx6eLn4O+x8ScCp7XUyVamTmR+80d2M
	 DyonQEcS8Lh+KUDFjk5V3z/SfqWi7Q3rFCfH4w7ZICCIuKU00t+k0Xpxv81LnM5vut2is
	 KWayb68p26+DoG31nXw69vRCRBKLJRWp/ObFDxmq5A/F+YUpfIvIrgUATt5WH57Tkkg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ic9JKC7h;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2AB9606A320;
	Wed, 18 Nov 2026 20:57:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ic9JKC7h
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 463161F000C4;
	Wed, 18 Nov 2026 20:57:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035448;
	bh=4eG1vylNVlmkb5XDrrowPsG38Vp4ZfImoW3IV8FNBg8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ic9JKC7hEPp3JmuN9IMk2wIE5iOnAwaUlssOLPQV/Ectgy1fdL1TasTici9WdeDbS
	 tfVd411UnqkC0l+SnssEwUiDg8QbDfWAEEcqi/1695lzA74ktuIc0V0+1VUPYdyBku
	 8aqRcM9k7hjRk4R7yb4ONGrL6/VJFh/TIg3BR2/s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 6.6 0709/3318] SUNRPC: Treat every TLS error alert as fatal
Date: Wed, 18 Nov 2026 15:22:11 +0100
Message-ID: <20261118150339.691697171@linuxfoundation.org>
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


