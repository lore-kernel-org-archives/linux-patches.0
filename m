Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 276FC41B34E;
	Wed,  4 Feb 2026 14:54:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770216876; cv=none; b=h7lxYWlZB2XESWM9KyhsTkP/g0khG+7G9wK06+z7BL9uIJN5bpSs3GZrtRL7EfyDNBIuXzpATM+qCaC2RpV0xXNv/AaghmI62TwveQh/EsmZQO5q68JpIE/hwkdR7rYWG9v3s+H6iV78DyhWFqyqSaycBBngU0htJ3UW8s4ZH64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770216876; c=relaxed/simple;
	bh=oOuSaxByOUwjFNjmjW6/ogCuduDjOG/fLb1EdOB+7mY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LEvvrBtY/h4/WhjO368uin3dLdrv/C5spAhWtTfxMmdc/tbOWDlLC2ebH/rpb1AS9dVuLKjlqkL5/UG0j4E6xag7JusCkZdUNWyOecfCHxaU6GBwzkPEJCes6wHD4r0SDWKPtMZWIVOTIJfcCw45l25EEdu9mAgKDCJ/ORPioT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gHV5Pdnz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gHV5Pdnz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1C61C4CEF7;
	Wed,  4 Feb 2026 14:54:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770216876;
	bh=oOuSaxByOUwjFNjmjW6/ogCuduDjOG/fLb1EdOB+7mY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gHV5PdnzpYNx7NuEHxQ/2Bpxs53Vk3/zvEQfX1+H4gHtdZKXZareAc4pATeUA32OR
	 L5hlenrLzbBI3Lh+8FBFgsf5QmhrlgDIS3w3PCgdBp7xijSyawLa6gXm3UjE34EFto
	 HuoTJ9KavIF0lttKVi/ufMHN7O8iEdtOghN7/FGc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot <syzbot+881d65229ca4f9ae8c84@syzkaller.appspotmail.com>,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.15 024/206] net: can: j1939: j1939_xtp_rx_rts_session_active(): deactivate session upon receiving the second rts
Date: Wed,  4 Feb 2026 15:37:35 +0100
Message-ID: <20260204143859.075070199@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143858.193781818@linuxfoundation.org>
References: <20260204143858.193781818@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


