Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061799;
	b=Q/3bB3b4Jx//8WM2rbiyr1fwImgWNr/RFLAOuo+dNfvhioADVA5UywG3S/TtQJuMXJ5F
	 iU5ZfCx/UgMiYSxZBDK4Q1iILxcfsdtloW2RvmrxOCcT66UHZ58yUN2jPBgVqr1XBCcZv
	 MCEOsoLaxp11pcvdomsVpV+R0werFlKTbbdn6Qsj3B1pW7e51WuiEiNCOSUGx6JzllIz7
	 zbUJ3dPs5CFP6c/8mP3KI31chqxkFO7qOdS6Ql6RMwaxFlmxT7f8ov5sEytKxcFU3yvgZ
	 96JX8Lqzb/INMhMxxIuFyickyaQhZHGPUvkf2yUMBsopDDehAl3pfstMsuhXmHC6cmA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061799;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ULXyRkvU6lEmDBMur2ZJC9W0g2udWhVsnu+1Uosphuw=;
	b=NiUGio9RrulPhvsmShBAWqRr5zGvKgvSK72nSXfsE/EW7WGdU3D2M71Q/q11X4oO436H
	 X4kscVkhCb7jpbLoNZoI/lZzwCwiNt2zBbXH3iKaQP43PRe/q2IR1MJL6eKxl7rfR5p6g
	 6mfdx+plyDmHkB9zhbWC2c29v89AlmX1iT1v+ejFGF88hCS1HGP5hc8rjdCQIAQDC30iy
	 QZQn5VqDU6Sl8F4XE0N3nLmXANIYZz15fgL7jkeF4JFD2Z1F42CkU9GPtrniRQP0KyH3A
	 UMy3ucBQZd/NfIaWtb+vdZXj7nvLqU0YcUEJK3qzkVICtXCTIGJH2n+5tozcam/FwBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RL37ifbX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D236C606A339;
	Sat,  7 Nov 2026 14:29:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RL37ifbX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 751621F008A3;
	Sat,  7 Nov 2026 14:29:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061798;
	bh=ULXyRkvU6lEmDBMur2ZJC9W0g2udWhVsnu+1Uosphuw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RL37ifbXh7mCr/uQoNKeO9cnFoEvUmfdOZlUTSMx9VvJWOGaPDVmoGmVQh+4YEDil
	 LcveLxepT3yjpK41pSELNwJ4HlnAUryo/rZAJax/BiKpB/UHRyvKVJfdjFAqmjjXVj
	 cAG/BHhBUie8XHUQ31dgv8C4ek3zaPUjBDGdK8V8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 6.12 0789/1536] SUNRPC: Treat every TLS error alert as fatal
Date: Sat,  7 Nov 2026 08:46:45 -0500
Message-ID: <20261107135019.700555454@linuxfoundation.org>
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


