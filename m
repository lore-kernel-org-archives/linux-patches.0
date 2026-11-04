Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829098;
	b=B9C5tn+CzMClUBr+EbA30fXM0K3axIwG8o3iypTfTpWG/rP+Bt5J3FBuVVdjwCRRyF81
	 J087ZmhdTwiIh1DacdfTageefsEk7RGrLCLYd6fLJsTCIxIhL68NXMnQLL3f/Md7nnpw7
	 I6lDckV4Z8Hc8hJ2GKDkpGUPby1E8+sR1JjGb40uHb1vLc7FxqsQ9Q3jy2405l7Piya5+
	 LBLnuD223FwdrasJors+vzQ9p8g8Fbp8rnhd343Cbtjg1SGMx+d9j+Lc27AGQpq+i3EYu
	 uvGJ+UzdczLttDG0EFBPz80Q8o7vQHaFPH1EktZkrbhJnKkBVWSokoLxL7A7ogU+zEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829098;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=R7a+wBg99UN83L4RSSU8KTDKp7sr3Bkms5mKzuwqLIk=;
	b=Ax0iwyASiiEBZBNECGf1KnhAvuQkG1KaqRliW9b78FKnkhEzQ/UY6UI0upUBTsDDOt0J
	 hfyPpj1stPM4/+BID7VzyRw6RLH/P6dFCfgMziEQqRH13Gp54W9bGtnIB87eLVhKUFWRF
	 KvaEjj4UBuTZ/eMWUlGqWXBmIWp5moJqIPs6teBpgEB8FlI/ouHYNxlNp8Y9BrCH9R7h0
	 VUVqg8WqcadHToRcmZkB0JTEZqldcvTIpJt5rPnhk65WO0cK0MZeDKQSPAzUUnqFGKgk6
	 whmoxkwtjkJiESuS3U3YAh9C3s/THUBB9VEteJJY1YeiqN7WTtxaPwpuwELLIJqJVXQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WUFhX5u4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FB276072FB3;
	Wed,  4 Nov 2026 21:51:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WUFhX5u4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8F4B1F00A02;
	Wed,  4 Nov 2026 21:51:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829098;
	bh=R7a+wBg99UN83L4RSSU8KTDKp7sr3Bkms5mKzuwqLIk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WUFhX5u4mHf6abaCQfLMeoxtGV0BOQB+7AmjA4qn6djwmiZ8GwsloSY1B2Wt8D5DP
	 FL9f7pXfxf5S24HiFzhIQIFpio+ldVa0RoK5OmKeQP2zp36e04Bogb5EPzeR9hI1ag
	 FP+bAKIeLLXBlJ7Bt/tklMPh7OXemOVIGGGskjoo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 7.3 445/547] SUNRPC: Treat every TLS error alert as fatal
Date: Wed,  4 Nov 2026 16:10:29 -0500
Message-ID: <20261104211050.993394509@linuxfoundation.org>
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


