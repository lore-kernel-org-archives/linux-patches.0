Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2671A6FAA
	for <patches@lists.linux.dev>; Mon,  3 Apr 2023 14:33:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3A68C433EF;
	Mon,  3 Apr 2023 14:33:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680532414;
	bh=lqCj2IrxJRiHvfJNpW0pIk9HAiPYPcQsC53d06/2DPU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DVbXvNPkwDsjWosOjoeMmrBRXUUiapDGSJEsRbMVY2MKXt4CWFPwLuK/UcW9bnB8p
	 A75wOMJv3/Z5j1hb5LEWHui4F+HS4WrSns1nvP8jUtFi+g1K+ArD7NyC76QAt9CUsa
	 lNpvEB19+73bs4PlsvmwHJsblx4Y8cdEuRil4Hgk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+ee1cd780f69483a8616b@syzkaller.appspotmail.com,
	Hillf Danton <hdanton@sina.com>,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.15 73/99] can: j1939: prevent deadlock by moving j1939_sk_errqueue()
Date: Mon,  3 Apr 2023 16:09:36 +0200
Message-Id: <20230403140406.228764166@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140356.079638751@linuxfoundation.org>
References: <20230403140356.079638751@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Oleksij Rempel <o.rempel@pengutronix.de>

commit d1366b283d94ac4537a4b3a1e8668da4df7ce7e9 upstream.

This commit addresses a deadlock situation that can occur in certain
scenarios, such as when running data TP/ETP transfer and subscribing to
the error queue while receiving a net down event. The deadlock involves
locks in the following order:

3
  j1939_session_list_lock ->  active_session_list_lock
  j1939_session_activate
  ...
  j1939_sk_queue_activate_next -> sk_session_queue_lock
  ...
  j1939_xtp_rx_eoma_one

2
  j1939_sk_queue_drop_all  ->  sk_session_queue_lock
  ...
  j1939_sk_netdev_event_netdown -> j1939_socks_lock
  j1939_netdev_notify

1
  j1939_sk_errqueue -> j1939_socks_lock
  __j1939_session_cancel -> active_session_list_lock
  j1939_tp_rxtimer

       CPU0                    CPU1
       ----                    ----
  lock(&priv->active_session_list_lock);
                               lock(&jsk->sk_session_queue_lock);
                               lock(&priv->active_session_list_lock);
  lock(&priv->j1939_socks_lock);

The solution implemented in this commit is to move the
j1939_sk_errqueue() call out of the active_session_list_lock context,
thus preventing the deadlock situation.

Reported-by: syzbot+ee1cd780f69483a8616b@syzkaller.appspotmail.com
Fixes: 5b9272e93f2e ("can: j1939: extend UAPI to notify about RX status")
Co-developed-by: Hillf Danton <hdanton@sina.com>
Signed-off-by: Hillf Danton <hdanton@sina.com>
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Link: https://lore.kernel.org/all/20230324130141.2132787-1-o.rempel@pengutronix.de
Cc: stable@vger.kernel.org
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/can/j1939/transport.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/net/can/j1939/transport.c
+++ b/net/can/j1939/transport.c
@@ -1124,8 +1124,6 @@ static void __j1939_session_cancel(struc
 
 	if (session->sk)
 		j1939_sk_send_loop_abort(session->sk, session->err);
-	else
-		j1939_sk_errqueue(session, J1939_ERRQUEUE_RX_ABORT);
 }
 
 static void j1939_session_cancel(struct j1939_session *session,
@@ -1140,6 +1138,9 @@ static void j1939_session_cancel(struct
 	}
 
 	j1939_session_list_unlock(session->priv);
+
+	if (!session->sk)
+		j1939_sk_errqueue(session, J1939_ERRQUEUE_RX_ABORT);
 }
 
 static enum hrtimer_restart j1939_tp_txtimer(struct hrtimer *hrtimer)
@@ -1253,6 +1254,9 @@ static enum hrtimer_restart j1939_tp_rxt
 			__j1939_session_cancel(session, J1939_XTP_ABORT_TIMEOUT);
 		}
 		j1939_session_list_unlock(session->priv);
+
+		if (!session->sk)
+			j1939_sk_errqueue(session, J1939_ERRQUEUE_RX_ABORT);
 	}
 
 	j1939_session_put(session);


