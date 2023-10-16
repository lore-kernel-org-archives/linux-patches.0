Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4959B1A29F
	for <patches@lists.linux.dev>; Mon, 16 Oct 2023 08:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cayQry/4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EC7FC433C7;
	Mon, 16 Oct 2023 08:59:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1697446775;
	bh=3zNAflOWgZzKRVADdqB/55YvWlB1To9FsOkDONpJCP8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cayQry/4fZG3cpCD5UqMPBAMmJQdKL788AnWai5Qm4Xwhn2BW4eiv19exT8jq+9Vz
	 RTPKpqKqkJWXLPnp+XLVmENKWE2P1f5ud0nZvMAhKPkTKlJkePlBkxYckge7jIkiy6
	 MDA9IIJ8RG5rS/OOJuSpRXHPp8m17PcUXvkpFtYo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Jayat <maxime.jayat@mobile-devices.fr>,
	Lukas Magel <lukas.magel@posteo.net>,
	Oliver Hartkopp <socketcan@hartkopp.net>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 043/131] can: isotp: isotp_sendmsg(): fix TX state detection and wait behavior
Date: Mon, 16 Oct 2023 10:40:26 +0200
Message-ID: <20231016084001.142952122@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231016084000.050926073@linuxfoundation.org>
References: <20231016084000.050926073@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lukas Magel <lukas.magel@posteo.net>

[ Upstream commit d9c2ba65e651467de739324d978b04ed8729f483 ]

With patch [1], isotp_poll was updated to also queue the poller in the
so->wait queue, which is used for send state changes. Since the queue
now also contains polling tasks that are not interested in sending, the
queue fill state can no longer be used as an indication of send
readiness. As a consequence, nonblocking writes can lead to a race and
lock-up of the socket if there is a second task polling the socket in
parallel.

With this patch, isotp_sendmsg does not consult wq_has_sleepers but
instead tries to atomically set so->tx.state and waits on so->wait if it
is unable to do so. This behavior is in alignment with isotp_poll, which
also checks so->tx.state to determine send readiness.

V2:
- Revert direct exit to goto err_event_drop

[1] https://lore.kernel.org/all/20230331125511.372783-1-michal.sojka@cvut.cz

Reported-by: Maxime Jayat <maxime.jayat@mobile-devices.fr>
Closes: https://lore.kernel.org/linux-can/11328958-453f-447f-9af8-3b5824dfb041@munic.io/
Signed-off-by: Lukas Magel <lukas.magel@posteo.net>
Reviewed-by: Oliver Hartkopp <socketcan@hartkopp.net>
Fixes: 79e19fa79cb5 ("can: isotp: isotp_ops: fix poll() to not report false EPOLLOUT events")
Link: https://github.com/pylessard/python-udsoncan/issues/178#issuecomment-1743786590
Link: https://lore.kernel.org/all/20230827092205.7908-1-lukas.magel@posteo.net
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/can/isotp.c | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/net/can/isotp.c b/net/can/isotp.c
index 8c97f4061ffd7..545889935d39c 100644
--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -925,21 +925,18 @@ static int isotp_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 	if (!so->bound || so->tx.state == ISOTP_SHUTDOWN)
 		return -EADDRNOTAVAIL;
 
-wait_free_buffer:
-	/* we do not support multiple buffers - for now */
-	if (wq_has_sleeper(&so->wait) && (msg->msg_flags & MSG_DONTWAIT))
-		return -EAGAIN;
+	while (cmpxchg(&so->tx.state, ISOTP_IDLE, ISOTP_SENDING) != ISOTP_IDLE) {
+		/* we do not support multiple buffers - for now */
+		if (msg->msg_flags & MSG_DONTWAIT)
+			return -EAGAIN;
 
-	/* wait for complete transmission of current pdu */
-	err = wait_event_interruptible(so->wait, so->tx.state == ISOTP_IDLE);
-	if (err)
-		goto err_event_drop;
-
-	if (cmpxchg(&so->tx.state, ISOTP_IDLE, ISOTP_SENDING) != ISOTP_IDLE) {
 		if (so->tx.state == ISOTP_SHUTDOWN)
 			return -EADDRNOTAVAIL;
 
-		goto wait_free_buffer;
+		/* wait for complete transmission of current pdu */
+		err = wait_event_interruptible(so->wait, so->tx.state == ISOTP_IDLE);
+		if (err)
+			goto err_event_drop;
 	}
 
 	if (!size || size > MAX_MSG_LENGTH) {
-- 
2.40.1



