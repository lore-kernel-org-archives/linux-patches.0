Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0335718AE4
	for <patches@lists.linux.dev>; Mon,  6 Nov 2023 11:19:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v8Z804LH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A2D9C433C7;
	Mon,  6 Nov 2023 11:19:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1699269588;
	bh=O21ivG+H7W+EifusiGMNaSFgWVh+Wui3aXrmKTADwYk=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=v8Z804LH1R6prrOoeyu8+FOT5b8j3EG/hxTXPZnwTPRE2qXU7TacM5S77CyhrCNUt
	 /xfdQHkChslwTA/ic9m6vLXRfi0pGlN6q3n1YXk6/8KKyDPxvV17CrHoSo7dWoIUZy
	 1fwhqQaVG2Kv8QeseE1hAEcc2xnxMPNv77tAlzXI=
Subject: Patch "can: isotp: isotp_sendmsg(): fix TX state detection and wait behavior" has been added to the 5.15-stable tree
To: 11328958-453f-447f-9af8-3b5824dfb041@munic.io,20230331125511.372783-1-michal.sojka@cvut.cz,gregkh@linuxfoundation.org,lukas.magel@posteo.net,maxime.jayat@mobile-devices.fr,michal.sojka@cvut.cz,mkl@pengutronix.de,patches@lists.linux.dev,sashal@kernel.org,socketcan@hartkopp.net
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Mon, 06 Nov 2023 12:19:33 +0100
In-Reply-To: <20231031093025.2699-8-socketcan@hartkopp.net>
Message-ID: <2023110632-aside-startling-201b@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore 


This is a note to let you know that I've just added the patch titled

    can: isotp: isotp_sendmsg(): fix TX state detection and wait behavior

to the 5.15-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     can-isotp-isotp_sendmsg-fix-tx-state-detection-and-wait-behavior.patch
and it can be found in the queue-5.15 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From stable-owner@vger.kernel.org Tue Oct 31 10:31:21 2023
From: Oliver Hartkopp <socketcan@hartkopp.net>
Date: Tue, 31 Oct 2023 10:30:25 +0100
Subject: can: isotp: isotp_sendmsg(): fix TX state detection and wait behavior
To: gregkh@linuxfoundation.org, stable@vger.kernel.org, sashal@kernel.org
Cc: linux-can@vger.kernel.org, lukas.magel@posteo.net, patches@lists.linux.dev, maxime.jayat@mobile-devices.fr, mkl@pengutronix.de, michal.sojka@cvut.cz, Oliver Hartkopp <socketcan@hartkopp.net>
Message-ID: <20231031093025.2699-8-socketcan@hartkopp.net>

From: Oliver Hartkopp <socketcan@hartkopp.net>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/can/isotp.c |   19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -925,21 +925,18 @@ static int isotp_sendmsg(struct socket *
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


Patches currently in stable-queue which might be from stable-owner@vger.kernel.org are

queue-5.15/ext4-avoid-overlapping-preallocations-due-to-overflow.patch
queue-5.15/can-isotp-isotp_bind-do-not-validate-unused-address-information.patch
queue-5.15/can-isotp-set-max-pdu-size-to-64-kbyte.patch
queue-5.15/can-isotp-isotp_bind-return-einval-on-incorrect-can-id-formatting.patch
queue-5.15/ext4-fix-bug-in-ext4_mb_new_inode_pa-due-to-overflow.patch
queue-5.15/rpmsg-fix-calling-device_lock-on-non-initialized-device.patch
queue-5.15/can-isotp-isotp_sendmsg-fix-tx-state-detection-and-wait-behavior.patch
queue-5.15/rpmsg-constify-local-variable-in-field-store-macro.patch
queue-5.15/rpmsg-glink-release-driver_override.patch
queue-5.15/driver-platform-add-helper-for-safer-setting-of-driver_override.patch
queue-5.15/can-isotp-check-can-address-family-in-isotp_bind.patch
queue-5.15/rpmsg-fix-kfree-of-static-memory-on-setting-driver_override.patch
queue-5.15/can-isotp-add-local-echo-tx-processing-and-tx-without-fc.patch
queue-5.15/can-isotp-handle-wait_event_interruptible-return-values.patch
queue-5.15/rpmsg-fix-possible-refcount-leak-in-rpmsg_register_device_override.patch
queue-5.15/ext4-add-two-helper-functions-extent_logical_end-and-pa_logical_end.patch
