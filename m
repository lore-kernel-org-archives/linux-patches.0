Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E16F81B583A;
	Tue,  2 Jul 2024 17:24:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719941089; cv=none; b=U/EJbQCvfZ/AMGnban7YL3DuJtuGtzZ2v3bOHFS7eYDUbr+/wNXTNDvWXjbsNTV5os6A5qmJcGfD0MfU5ji5w31vK2O0Ist5cHRKgCGVmcrAjJsSKZzOIBWppwDISlFjtGwh7SuxQXcfQSKEnx9o7sw1rCCs7Pff16f9pnbSP1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719941089; c=relaxed/simple;
	bh=9tJqgm4TofYRzNmV/de+AcGQO8VVgoWd+/mJicq5u6U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W160f/JfC2S+s0pND8fjd542ftGal3I/Js402V/w9mtXIp3ewY8bkGx1YEN6BvFVRiqvB7fLllxFOfAqgMv4ravkVahNMeTvjnTzKlGc4flcPD62pmjO94t+yM6iBNpFeP5C/+Mvd1+Pe0MAl9JMNLFUu4x7A31oML3Zsu0QHc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dXspqi0g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dXspqi0g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52121C116B1;
	Tue,  2 Jul 2024 17:24:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719941088;
	bh=9tJqgm4TofYRzNmV/de+AcGQO8VVgoWd+/mJicq5u6U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dXspqi0gM/075YkIiHzz/w13YWR1ZuK7KNVUHa0psPxX6ziuK5P7e25WR+zXdpMBb
	 JC5ZWDsen4CLVlOo6+qC4Dy4h7Daeux0U9vr+ZHeIa7BUPwmJ9RpzFN7KRg2Q0pWsY
	 M7aw3CUWnMUONGetnlLlXE1NJRfRXG7SBVQv1LbY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+daa36413a5cedf799ae4@syzkaller.appspotmail.com,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.6 124/163] net: can: j1939: enhanced error handling for tightly received RTS messages in xtp_rx_rts_session_new
Date: Tue,  2 Jul 2024 19:03:58 +0200
Message-ID: <20240702170237.746481186@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170233.048122282@linuxfoundation.org>
References: <20240702170233.048122282@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleksij Rempel <o.rempel@pengutronix.de>

commit d3e2904f71ea0fe7eaff1d68a2b0363c888ea0fb upstream.

This patch enhances error handling in scenarios with RTS (Request to
Send) messages arriving closely. It replaces the less informative WARN_ON_ONCE
backtraces with a new error handling method. This provides clearer error
messages and allows for the early termination of problematic sessions.
Previously, sessions were only released at the end of j1939_xtp_rx_rts().

Potentially this could be reproduced with something like:
testj1939 -r vcan0:0x80 &
while true; do
	# send first RTS
	cansend vcan0 18EC8090#1014000303002301;
	# send second RTS
	cansend vcan0 18EC8090#1014000303002301;
	# send abort
	cansend vcan0 18EC8090#ff00000000002301;
done

Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")
Reported-by: syzbot+daa36413a5cedf799ae4@syzkaller.appspotmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Link: https://lore.kernel.org/all/20231117124959.961171-1-o.rempel@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/can/j1939/transport.c |   19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

--- a/net/can/j1939/transport.c
+++ b/net/can/j1939/transport.c
@@ -1593,8 +1593,8 @@ j1939_session *j1939_xtp_rx_rts_session_
 	struct j1939_sk_buff_cb skcb = *j1939_skb_to_cb(skb);
 	struct j1939_session *session;
 	const u8 *dat;
+	int len, ret;
 	pgn_t pgn;
-	int len;
 
 	netdev_dbg(priv->ndev, "%s\n", __func__);
 
@@ -1653,7 +1653,22 @@ j1939_session *j1939_xtp_rx_rts_session_
 	session->tskey = priv->rx_tskey++;
 	j1939_sk_errqueue(session, J1939_ERRQUEUE_RX_RTS);
 
-	WARN_ON_ONCE(j1939_session_activate(session));
+	ret = j1939_session_activate(session);
+	if (ret) {
+		/* Entering this scope indicates an issue with the J1939 bus.
+		 * Possible scenarios include:
+		 * - A time lapse occurred, and a new session was initiated
+		 *   due to another packet being sent correctly. This could
+		 *   have been caused by too long interrupt, debugger, or being
+		 *   out-scheduled by another task.
+		 * - The bus is receiving numerous erroneous packets, either
+		 *   from a malfunctioning device or during a test scenario.
+		 */
+		netdev_alert(priv->ndev, "%s: 0x%p: concurrent session with same addr (%02x %02x) is already active.\n",
+			     __func__, session, skcb.addr.sa, skcb.addr.da);
+		j1939_session_put(session);
+		return NULL;
+	}
 
 	return session;
 }


