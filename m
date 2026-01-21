Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD95E346783;
	Wed, 21 Jan 2026 18:20:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769019654; cv=none; b=NzkoPX9j8QHQ7AX+CWXeeRBvtb58YyQKPQCaoLR1o7/kLZ5tRd3Ba3csrgMqOJwGU8yQCSWIblpsZ18bqJ/Rj+cMPWWotfJfjuQ/QCXcHJ1tnqIKGXY+O5/ll9wZKH3Gh1E87NyRh2F3F917dZ5Y0Fi/ku0ihOvRr1qzcMn460k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769019654; c=relaxed/simple;
	bh=2zwD9n/6d8sJLNrjI5lS4G4TSe4GBaAw7VXbL5zjG8Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DUr/GRz5ncAYgUJ0kTwEylYssnSZv6JLJN0R+UoEFNLA2zQPk7nPKmezFd+ivwalSlEeMtHPfE2oRDXnDW5546hk36lq1/K+dugEDMIL1TKs7qN8bslNxM5qiTgCa4YLRVdshlgHeWvUJk45Ajyvvp6lymnTp7hnLN39UUEofeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WQUTdpTc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WQUTdpTc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49009C4CEF1;
	Wed, 21 Jan 2026 18:20:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769019653;
	bh=2zwD9n/6d8sJLNrjI5lS4G4TSe4GBaAw7VXbL5zjG8Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WQUTdpTcAWCKYd97HLvoSxxUuKSfgCHopLkDWt9vYHTZEyhfl152WWZgrThJXEJxS
	 g6YfatMl/vqZNn7PhhQKEtYu9KSM1oSm+pHsLeGAv2GsCBQhhoNw59tlRQQJVg/J+0
	 8ZYuKJI0MeDPGp0vjOgsJEVisouo3dyNtkd929m8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot <syzbot+881d65229ca4f9ae8c84@syzkaller.appspotmail.com>,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.12 069/139] net: can: j1939: j1939_xtp_rx_rts_session_active(): deactivate session upon receiving the second rts
Date: Wed, 21 Jan 2026 19:15:17 +0100
Message-ID: <20260121181413.938710734@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181411.452263583@linuxfoundation.org>
References: <20260121181411.452263583@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

commit 1809c82aa073a11b7d335ae932d81ce51a588a4a upstream.

Since j1939_session_deactivate_activate_next() in j1939_tp_rxtimer() is
called only when the timer is enabled, we need to call
j1939_session_deactivate_activate_next() if we cancelled the timer.
Otherwise, refcount for j1939_session leaks, which will later appear as

| unregister_netdevice: waiting for vcan0 to become free. Usage count = 2.

problem.

Reported-by: syzbot <syzbot+881d65229ca4f9ae8c84@syzkaller.appspotmail.com>
Closes: https://syzkaller.appspot.com/bug?extid=881d65229ca4f9ae8c84
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Tested-by: Oleksij Rempel <o.rempel@pengutronix.de>
Acked-by: Oleksij Rempel <o.rempel@pengutronix.de>
Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")
Link: https://patch.msgid.link/b1212653-8fa1-44e1-be9d-12f950fb3a07@I-love.SAKURA.ne.jp
Cc: stable@vger.kernel.org
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/can/j1939/transport.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/net/can/j1939/transport.c
+++ b/net/can/j1939/transport.c
@@ -1699,8 +1699,16 @@ static int j1939_xtp_rx_rts_session_acti
 
 		j1939_session_timers_cancel(session);
 		j1939_session_cancel(session, J1939_XTP_ABORT_BUSY);
-		if (session->transmission)
+		if (session->transmission) {
 			j1939_session_deactivate_activate_next(session);
+		} else if (session->state == J1939_SESSION_WAITING_ABORT) {
+			/* Force deactivation for the receiver.
+			 * If we rely on the timer starting in j1939_session_cancel,
+			 * a second RTS call here will cancel that timer and fail
+			 * to restart it because the state is already WAITING_ABORT.
+			 */
+			j1939_session_deactivate_activate_next(session);
+		}
 
 		return -EBUSY;
 	}


