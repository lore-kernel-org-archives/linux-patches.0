Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039576;
	b=1VL6wjIHPc38RJ6t5ObSJwig8bTJFbnb0HTtHGrCthp8FKwIJNR6m4jwI0zrGKcnOnB7
	 INEU0YLBXm8Yd0px+WyyKVdh0GV9r197ChcbZflG3ka8/lpRUsjltLEJy1Y/KnESRm/25
	 9oulc2diKVj6GpogYSEcR22iaUu665tyJADA27LV/RE/M5JQ5f82BU+7LihQRKEMox8FJ
	 6jXSHKkr7vW9Wm9wWw6Xka4ZBSO8qeXbdLxugGR/z111zFiFxaqY0ZfqdUOKWXF90Mk+T
	 hGgkKnZxEdgPOpu3YJ4KozK+RyFaHLAg8uw0K10iv3GkLsPReaZpYbXPlf2Aa3t8bhw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039576;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ccq76wCzPN904SAhbWpGSfNFyQn7VbRwJUp4XPiVeHQ=;
	b=EWcW514Jeb2vDjx/FwmsYpaxd8jOHXuvRh/x1v5b413QKKQXgLiWkHQueW+AIlhIYFKl
	 SxfvONuxH2D/BdANCZ82875jZPMmDc5dYwlV5BMToP6lFpBNmS3Sp0K1Z+K+d3bfw8JKH
	 cduD21fBIi5ZQDEBklHYnZ31FeCB0oqB9ymWiEQsh8tKGSEHt1wogDsGY1uzEPrRAhhdc
	 4dv/PVogM3fu2R2zwQQpK/OQbZidfV+BDelmPjlGW1DaKbl705R+pHj1bfkVRrc5vGShJ
	 58pkpOtTuM7m4joNavhp8gD9jvgq7IxRw7C6YGxiIbqM125liPB/Yo1sKetGCMjSG+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eSElXYEs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B41BB606A31C;
	Wed, 18 Nov 2026 22:06:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eSElXYEs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19DBF1F000C4;
	Wed, 18 Nov 2026 22:06:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039576;
	bh=ccq76wCzPN904SAhbWpGSfNFyQn7VbRwJUp4XPiVeHQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eSElXYEs9Q39sOppB9EACa8D7qEqeSwZ3zbStbQmZz6lICVU8uy7fY02WFCSeazce
	 H6zxBSCtEs1xn21FYc06FvnyJZ3mDj/AY4fODzk7kzYkFW+LDiY52T1xCfGxwTqCNr
	 VuIL4NxiQH/CE3im5UbrMwy2zrZ8MeV7GuD2lZzQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roland Dreier <rolanddreier@rivian.com>,
	Cristian Marussi <cristian.marussi@arm.com>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2151/3318] firmware: arm_scmi: Protect xfer->async_done with xfer->lock
Date: Wed, 18 Nov 2026 15:46:13 +0100
Message-ID: <20261118150426.564635747@linuxfoundation.org>
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

From: Roland Dreier <rolanddreier@rivian.com>

[ Upstream commit 49fc5bc04eec2b7687d49ccceb7adf6ace640a3b ]

Asynchronous SCMI commands are completed by a delayed response. The RX
path signals the response with complete(xfer->async_done). Unlike
xfer->done, xfer->async_done is a pointer to a completion owned by
whoever is waiting for the delayed response, and it stays valid only for
as long as that waiter is still waiting.  In do_xfer_with_response() it
is a DECLARE_COMPLETION_ONSTACK() in the caller's stack frame.

Nothing serialises the RX path against a waiter that gives up on a
timeout. scmi_msg_response_validate() does read xfer->async_done
under xfer->lock, and documents that as a requirement, but the lock is
dropped again before scmi_handle_response() dereferences the pointer,
and neither the arming nor the disarming side takes it at all. So a
delayed response arriving just as the wait times out can be signalled
on a completion that is already gone:

  waiter                                RX path (IRQ context)
  ------                                ---------------------
  do_xfer_with_response():
    xfer->async_done = &async_response
    do_xfer(xfer)
    wait_for_completion_timeout(xfer->async_done, tmo)
    /* returns 0, gives up */
                                        /* response receive interrupt */
                                        scmi_handle_response():
                                          scmi_xfer_command_acquire()
                                            lock xfer->lock
                                            validate: async_done != NULL
                                            unlock xfer->lock
    xfer->async_done = NULL
    return -ETIMEDOUT
    /* async_response goes out of scope */
                                          complete(xfer->async_done)

That last complete() has two possible bad outcomes: it either dereferences
the NULL just stored by the waiter or - if that store is not yet visible
on the RX CPU - it takes a lock and writes to a stack frame that the
waiter may already have returned from.

Fix this by making xfer->lock cover xfer->async_done end-to-end. Add
helpers to arm and disarm it under the lock, use them on both the regular
and the raw paths, and have the RX path read and signal the completion
under that same lock. A waiter that is timing out then either completes
its disarm before the RX path looks, in which case the delayed response is
dropped, or blocks in the disarm until the RX path is done with the
completion, in which case the completion is still alive.

Log the dropped case, so every path where a delayed response that was
matched to a pending xfer and then discarded produces an error. (This is
the same treatment scmi_msg_response_validate() already gives a
delayed response that arrives after the waiter has disarmed the xfer)

Fixes: 58ecdf03dbb9 ("firmware: arm_scmi: Add support for asynchronous commands and delayed response")
Signed-off-by: Roland Dreier <rolanddreier@rivian.com>
Reviewed-by: Cristian Marussi <cristian.marussi@arm.com>
Tested-by: Cristian Marussi <cristian.marussi@arm.com>
Link: https://patch.msgid.link/20260909-scmi-async-done-race-v2-1-cc5dec25c6be@rivian.com
Signed-off-by: Sudeep Holla <sudeep.holla@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scmi/common.h    | 22 ++++++++++++++++
 drivers/firmware/arm_scmi/driver.c    | 37 +++++++++++++++++++++++----
 drivers/firmware/arm_scmi/protocols.h |  9 ++++---
 drivers/firmware/arm_scmi/raw_mode.c  |  4 +--
 4 files changed, 62 insertions(+), 10 deletions(-)

diff --git a/drivers/firmware/arm_scmi/common.h b/drivers/firmware/arm_scmi/common.h
index dc95652fff400..65f3abe7294f7 100644
--- a/drivers/firmware/arm_scmi/common.h
+++ b/drivers/firmware/arm_scmi/common.h
@@ -276,6 +276,28 @@ static inline bool is_polling_enabled(struct scmi_chan_info *cinfo,
 		is_transport_polling_capable(desc);
 }
 
+/**
+ * scmi_xfer_async_response_arm  - Arm the delayed response completion
+ *
+ * @xfer: A reference to the xfer to arm
+ * @async_done: The completion to signal upon reception of a delayed response,
+ *		or NULL to disarm @xfer.
+ */
+static inline void scmi_xfer_async_response_arm(struct scmi_xfer *xfer,
+						struct completion *async_done)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&xfer->lock, flags);
+	xfer->async_done = async_done;
+	spin_unlock_irqrestore(&xfer->lock, flags);
+}
+
+static inline void scmi_xfer_async_response_disarm(struct scmi_xfer *xfer)
+{
+	scmi_xfer_async_response_arm(xfer, NULL);
+}
+
 void scmi_xfer_raw_put(const struct scmi_handle *handle,
 		       struct scmi_xfer *xfer);
 struct scmi_xfer *scmi_xfer_raw_get(const struct scmi_handle *handle);
diff --git a/drivers/firmware/arm_scmi/driver.c b/drivers/firmware/arm_scmi/driver.c
index 0c2a0dc350ebd..4e84f6ee2a98b 100644
--- a/drivers/firmware/arm_scmi/driver.c
+++ b/drivers/firmware/arm_scmi/driver.c
@@ -886,6 +886,29 @@ static inline void scmi_xfer_command_release(struct scmi_info *info,
 	__scmi_xfer_put(&info->tx_minfo, xfer);
 }
 
+/**
+ * scmi_xfer_async_response_complete  - Signal a received delayed response
+ *
+ * @xfer: A reference to the xfer whose delayed response was received
+ *
+ * Return: True if a completion was still armed on @xfer and has been
+ *	   signalled, false if a waiter has already disarmed it due to
+ *	   timeout or other error.
+ */
+static bool scmi_xfer_async_response_complete(struct scmi_xfer *xfer)
+{
+	unsigned long flags;
+	struct completion *async_done;
+
+	spin_lock_irqsave(&xfer->lock, flags);
+	async_done = xfer->async_done;
+	if (async_done)
+		complete(async_done);
+	spin_unlock_irqrestore(&xfer->lock, flags);
+
+	return !!async_done;
+}
+
 static inline void scmi_clear_channel(struct scmi_info *info,
 				      struct scmi_chan_info *cinfo)
 {
@@ -989,8 +1012,12 @@ static void scmi_handle_response(struct scmi_chan_info *cinfo,
 
 	if (xfer->hdr.type == MSG_TYPE_DELAYED_RESP) {
 		scmi_clear_channel(info, cinfo);
-		complete(xfer->async_done);
-		scmi_inc_count(info->dbg, DELAYED_RESPONSE_OK);
+		if (scmi_xfer_async_response_complete(xfer))
+			scmi_inc_count(info->dbg, DELAYED_RESPONSE_OK);
+		else
+			dev_err(cinfo->dev,
+				"Delayed Response for %d (protocol 0x%X msg 0x%X) received after waiter was disarmed, dropping\n",
+				xfer->hdr.seq, xfer->hdr.protocol_id, xfer->hdr.id);
 	} else {
 		complete(&xfer->done);
 		scmi_inc_count(info->dbg, RESPONSE_OK);
@@ -1331,7 +1358,7 @@ static int do_xfer_with_response(const struct scmi_protocol_handle *ph,
 	int ret, timeout = msecs_to_jiffies(SCMI_MAX_RESPONSE_TIMEOUT);
 	DECLARE_COMPLETION_ONSTACK(async_response);
 
-	xfer->async_done = &async_response;
+	scmi_xfer_async_response_arm(xfer, &async_response);
 
 	/*
 	 * Delayed responses should not be polled, so an async command should
@@ -1343,7 +1370,7 @@ static int do_xfer_with_response(const struct scmi_protocol_handle *ph,
 
 	ret = do_xfer(ph, xfer);
 	if (!ret) {
-		if (!wait_for_completion_timeout(xfer->async_done, timeout)) {
+		if (!wait_for_completion_timeout(&async_response, timeout)) {
 			dev_err(ph->dev,
 				"timed out in delayed resp(caller: %pS)\n",
 				(void *)_RET_IP_);
@@ -1353,7 +1380,7 @@ static int do_xfer_with_response(const struct scmi_protocol_handle *ph,
 		}
 	}
 
-	xfer->async_done = NULL;
+	scmi_xfer_async_response_disarm(xfer);
 	return ret;
 }
 
diff --git a/drivers/firmware/arm_scmi/protocols.h b/drivers/firmware/arm_scmi/protocols.h
index 095b14a2d0a3f..4ed4266a729fb 100644
--- a/drivers/firmware/arm_scmi/protocols.h
+++ b/drivers/firmware/arm_scmi/protocols.h
@@ -97,7 +97,10 @@ struct scmi_msg_hdr {
  *	message. If request-ACK protocol is used, we can reuse the same
  *	buffer for the rx path as we use for the tx path.
  * @done: command message transmit completion event
- * @async_done: pointer to delayed response message received event completion
+ * @async_done: pointer to delayed response message received event completion,
+ *		or NULL when no delayed response is expected. Protected by
+ *		@lock, since the completion is owned by the waiter and can
+ *		vanish once the wait times out.
  * @pending: True for xfers added to @pending_xfers hashtable
  * @node: An hlist_node reference used to store this xfer, alternatively, on
  *	  the free list @free_xfers or in the @pending_xfers hashtable
@@ -118,7 +121,7 @@ struct scmi_msg_hdr {
  *	    - SCMI_XFER_SENT_OK -> SCMI_XFER_DRESP_OK
  *	      (Missing synchronous response is assumed OK and ignored)
  * @flags: Optional flags associated to this xfer.
- * @lock: A spinlock to protect state and busy fields.
+ * @lock: A spinlock to protect state, busy and async_done fields.
  * @priv: A pointer for transport private usage.
  */
 struct scmi_xfer {
@@ -144,7 +147,7 @@ struct scmi_xfer {
 #define SCMI_XFER_IS_CHAN_SET(x)	\
 	((x)->flags & SCMI_XFER_FLAG_CHAN_SET)
 	int flags;
-	/* A lock to protect state and busy fields */
+	/* A lock to protect state, busy and async_done fields */
 	spinlock_t lock;
 	void *priv;
 };
diff --git a/drivers/firmware/arm_scmi/raw_mode.c b/drivers/firmware/arm_scmi/raw_mode.c
index 130d13e9cd6be..297ddfe3cf0b7 100644
--- a/drivers/firmware/arm_scmi/raw_mode.c
+++ b/drivers/firmware/arm_scmi/raw_mode.c
@@ -346,7 +346,7 @@ scmi_xfer_raw_waiter_get(struct scmi_raw_mode_info *raw, struct scmi_xfer *xfer,
 
 		if (async) {
 			reinit_completion(&rw->async_response);
-			xfer->async_done = &rw->async_response;
+			scmi_xfer_async_response_arm(xfer, &rw->async_response);
 		}
 
 		rw->cinfo = cinfo;
@@ -361,7 +361,7 @@ static void scmi_xfer_raw_waiter_put(struct scmi_raw_mode_info *raw,
 				     struct scmi_xfer_raw_waiter *rw)
 {
 	if (rw->xfer) {
-		rw->xfer->async_done = NULL;
+		scmi_xfer_async_response_disarm(rw->xfer);
 		rw->xfer = NULL;
 	}
 
-- 
2.53.0



