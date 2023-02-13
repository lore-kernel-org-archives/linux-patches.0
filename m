Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47A6F8F57
	for <patches@lists.linux.dev>; Mon, 13 Feb 2023 15:01:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4318C4339B;
	Mon, 13 Feb 2023 15:01:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676300477;
	bh=xsed+Pw3QOdieEWBApozWLW52qilzTOEGbX19aVoxcU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gSnDISB7cVicEoi1jGD91LUgBi4iBeDZfHYBDUmqZHDkF6hMsEfnB/xuOkF6RZjWd
	 PzJEhFPSMblwheiMhRCPV9aS1tc5zsjO0w4xwHKyqM/GT+wRDI3HIqOgppzuKbpIpQ
	 h7CMRBbyWofh4lRBxyKGQKQ24UnegfoiHCrk7Gr8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+9981a614060dcee6eeca@syzkaller.appspotmail.com,
	Ziyang Xuan <william.xuanziyang@huawei.com>,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 028/139] can: j1939: fix errant WARN_ON_ONCE in j1939_session_deactivate
Date: Mon, 13 Feb 2023 15:49:33 +0100
Message-Id: <20230213144747.129014314@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144745.696901179@linuxfoundation.org>
References: <20230213144745.696901179@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ziyang Xuan <william.xuanziyang@huawei.com>

[ Upstream commit d0553680f94c49bbe0e39eb50d033ba563b4212d ]

The conclusion "j1939_session_deactivate() should be called with a
session ref-count of at least 2" is incorrect. In some concurrent
scenarios, j1939_session_deactivate can be called with the session
ref-count less than 2. But there is not any problem because it
will check the session active state before session putting in
j1939_session_deactivate_locked().

Here is the concurrent scenario of the problem reported by syzbot
and my reproduction log.

        cpu0                            cpu1
                                j1939_xtp_rx_eoma
j1939_xtp_rx_abort_one
                                j1939_session_get_by_addr [kref == 2]
j1939_session_get_by_addr [kref == 3]
j1939_session_deactivate [kref == 2]
j1939_session_put [kref == 1]
				j1939_session_completed
				j1939_session_deactivate
				WARN_ON_ONCE(kref < 2)

=====================================================
WARNING: CPU: 1 PID: 21 at net/can/j1939/transport.c:1088 j1939_session_deactivate+0x5f/0x70
CPU: 1 PID: 21 Comm: ksoftirqd/1 Not tainted 5.14.0-rc7+ #32
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-1ubuntu1 04/01/2014
RIP: 0010:j1939_session_deactivate+0x5f/0x70
Call Trace:
 j1939_session_deactivate_activate_next+0x11/0x28
 j1939_xtp_rx_eoma+0x12a/0x180
 j1939_tp_recv+0x4a2/0x510
 j1939_can_recv+0x226/0x380
 can_rcv_filter+0xf8/0x220
 can_receive+0x102/0x220
 ? process_backlog+0xf0/0x2c0
 can_rcv+0x53/0xf0
 __netif_receive_skb_one_core+0x67/0x90
 ? process_backlog+0x97/0x2c0
 __netif_receive_skb+0x22/0x80

Fixes: 0c71437dd50d ("can: j1939: j1939_session_deactivate(): clarify lifetime of session object")
Reported-by: syzbot+9981a614060dcee6eeca@syzkaller.appspotmail.com
Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
Acked-by: Oleksij Rempel <o.rempel@pengutronix.de>
Link: https://lore.kernel.org/all/20210906094200.95868-1-william.xuanziyang@huawei.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/can/j1939/transport.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/net/can/j1939/transport.c b/net/can/j1939/transport.c
index 78f6a9110699..57d6aac7f435 100644
--- a/net/can/j1939/transport.c
+++ b/net/can/j1939/transport.c
@@ -1087,10 +1087,6 @@ static bool j1939_session_deactivate(struct j1939_session *session)
 	bool active;
 
 	j1939_session_list_lock(priv);
-	/* This function should be called with a session ref-count of at
-	 * least 2.
-	 */
-	WARN_ON_ONCE(kref_read(&session->kref) < 2);
 	active = j1939_session_deactivate_locked(session);
 	j1939_session_list_unlock(priv);
 
-- 
2.39.0



