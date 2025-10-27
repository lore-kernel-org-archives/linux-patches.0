Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15B6731E107;
	Mon, 27 Oct 2025 19:30:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761593402; cv=none; b=gwcj8cXKQ3iUmnU5EZNbaFv28iGbmpVEsI3nUxFmkHLQzZOsBxEh1o1hsNe1BQF7AHMO1cjo9llFgqbHSk+64aPVFXc0IahiY1qyHAwh40llP//dH+pXy8u/5ji6rlzsy7ta0rG/mnPti3uL0xq5yXAocuMrUjNjj/y/PVWNrdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761593402; c=relaxed/simple;
	bh=9JJfOQBczYs9W096w7Z9xDMP/27wED5ENRDnUbeo2o4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bdLINDm+dpdWkeT4vKcZ/mpsYx/j+LKHQ6xcC8RSyQvt7Pw2vG/9u9AZvoqC1IkuimmbpwwFMopLmptQLlI8Xcmal3vVhy2++hU1nfnMMm6lCg3dipYpB2sAmN5iLD2VZM1Qsp0xvgnldH7tN4a5MBrN05NdiFb9aAjOMv23xVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r19yNRlM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r19yNRlM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93542C4CEF1;
	Mon, 27 Oct 2025 19:30:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761593402;
	bh=9JJfOQBczYs9W096w7Z9xDMP/27wED5ENRDnUbeo2o4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r19yNRlM+hsWB/XBkxz7I7sIHEFJJkxSjX5tyCkofBCXig+bUGmWNCBIThZ8MXaAU
	 1rCQ+/9nUje62J06OXs54epmvcnnRII8S24lW6FcznOBVFnttdR4g5OXKVlenEq8IJ
	 R6dX2lmJ8ZHdaQps8AwhoOOevIV61iYwcjN0O4yA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Marussi <cristian.marussi@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 123/184] firmware: arm_scmi: Account for failed debug initialization
Date: Mon, 27 Oct 2025 19:36:45 +0100
Message-ID: <20251027183518.257005283@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183514.934710872@linuxfoundation.org>
References: <20251027183514.934710872@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cristian Marussi <cristian.marussi@arm.com>

[ Upstream commit 2290ab43b9d8eafb8046387f10a8dfa2b030ba46 ]

When the SCMI debug subsystem fails to initialize, the related debug root
will be missing, and the underlying descriptor will be NULL.

Handle this fault condition in the SCMI debug helpers that maintain
metrics counters.

Fixes: 0b3d48c4726e ("firmware: arm_scmi: Track basic SCMI communication debug metrics")
Signed-off-by: Cristian Marussi <cristian.marussi@arm.com>
Message-Id: <20251014115346.2391418-1-cristian.marussi@arm.com>
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scmi/common.h | 24 ++++++++++++++--
 drivers/firmware/arm_scmi/driver.c | 44 ++++++++++--------------------
 2 files changed, 35 insertions(+), 33 deletions(-)

diff --git a/drivers/firmware/arm_scmi/common.h b/drivers/firmware/arm_scmi/common.h
index 07b9e629276d2..21c0b95027c64 100644
--- a/drivers/firmware/arm_scmi/common.h
+++ b/drivers/firmware/arm_scmi/common.h
@@ -309,10 +309,28 @@ enum debug_counters {
 	SCMI_DEBUG_COUNTERS_LAST
 };
 
-static inline void scmi_inc_count(atomic_t *arr, int stat)
+/**
+ * struct scmi_debug_info  - Debug common info
+ * @top_dentry: A reference to the top debugfs dentry
+ * @name: Name of this SCMI instance
+ * @type: Type of this SCMI instance
+ * @is_atomic: Flag to state if the transport of this instance is atomic
+ * @counters: An array of atomic_c's used for tracking statistics (if enabled)
+ */
+struct scmi_debug_info {
+	struct dentry *top_dentry;
+	const char *name;
+	const char *type;
+	bool is_atomic;
+	atomic_t counters[SCMI_DEBUG_COUNTERS_LAST];
+};
+
+static inline void scmi_inc_count(struct scmi_debug_info *dbg, int stat)
 {
-	if (IS_ENABLED(CONFIG_ARM_SCMI_DEBUG_COUNTERS))
-		atomic_inc(&arr[stat]);
+	if (IS_ENABLED(CONFIG_ARM_SCMI_DEBUG_COUNTERS)) {
+		if (dbg)
+			atomic_inc(&dbg->counters[stat]);
+	}
 }
 
 static inline void scmi_dec_count(atomic_t *arr, int stat)
diff --git a/drivers/firmware/arm_scmi/driver.c b/drivers/firmware/arm_scmi/driver.c
index bd56a877fdfc8..56419285c0bfd 100644
--- a/drivers/firmware/arm_scmi/driver.c
+++ b/drivers/firmware/arm_scmi/driver.c
@@ -115,22 +115,6 @@ struct scmi_protocol_instance {
 
 #define ph_to_pi(h)	container_of(h, struct scmi_protocol_instance, ph)
 
-/**
- * struct scmi_debug_info  - Debug common info
- * @top_dentry: A reference to the top debugfs dentry
- * @name: Name of this SCMI instance
- * @type: Type of this SCMI instance
- * @is_atomic: Flag to state if the transport of this instance is atomic
- * @counters: An array of atomic_c's used for tracking statistics (if enabled)
- */
-struct scmi_debug_info {
-	struct dentry *top_dentry;
-	const char *name;
-	const char *type;
-	bool is_atomic;
-	atomic_t counters[SCMI_DEBUG_COUNTERS_LAST];
-};
-
 /**
  * struct scmi_info - Structure representing a SCMI instance
  *
@@ -1034,7 +1018,7 @@ scmi_xfer_command_acquire(struct scmi_chan_info *cinfo, u32 msg_hdr)
 		spin_unlock_irqrestore(&minfo->xfer_lock, flags);
 
 		scmi_bad_message_trace(cinfo, msg_hdr, MSG_UNEXPECTED);
-		scmi_inc_count(info->dbg->counters, ERR_MSG_UNEXPECTED);
+		scmi_inc_count(info->dbg, ERR_MSG_UNEXPECTED);
 
 		return xfer;
 	}
@@ -1062,7 +1046,7 @@ scmi_xfer_command_acquire(struct scmi_chan_info *cinfo, u32 msg_hdr)
 			msg_type, xfer_id, msg_hdr, xfer->state);
 
 		scmi_bad_message_trace(cinfo, msg_hdr, MSG_INVALID);
-		scmi_inc_count(info->dbg->counters, ERR_MSG_INVALID);
+		scmi_inc_count(info->dbg, ERR_MSG_INVALID);
 
 		/* On error the refcount incremented above has to be dropped */
 		__scmi_xfer_put(minfo, xfer);
@@ -1107,7 +1091,7 @@ static void scmi_handle_notification(struct scmi_chan_info *cinfo,
 			PTR_ERR(xfer));
 
 		scmi_bad_message_trace(cinfo, msg_hdr, MSG_NOMEM);
-		scmi_inc_count(info->dbg->counters, ERR_MSG_NOMEM);
+		scmi_inc_count(info->dbg, ERR_MSG_NOMEM);
 
 		scmi_clear_channel(info, cinfo);
 		return;
@@ -1123,7 +1107,7 @@ static void scmi_handle_notification(struct scmi_chan_info *cinfo,
 	trace_scmi_msg_dump(info->id, cinfo->id, xfer->hdr.protocol_id,
 			    xfer->hdr.id, "NOTI", xfer->hdr.seq,
 			    xfer->hdr.status, xfer->rx.buf, xfer->rx.len);
-	scmi_inc_count(info->dbg->counters, NOTIFICATION_OK);
+	scmi_inc_count(info->dbg, NOTIFICATION_OK);
 
 	scmi_notify(cinfo->handle, xfer->hdr.protocol_id,
 		    xfer->hdr.id, xfer->rx.buf, xfer->rx.len, ts);
@@ -1183,10 +1167,10 @@ static void scmi_handle_response(struct scmi_chan_info *cinfo,
 	if (xfer->hdr.type == MSG_TYPE_DELAYED_RESP) {
 		scmi_clear_channel(info, cinfo);
 		complete(xfer->async_done);
-		scmi_inc_count(info->dbg->counters, DELAYED_RESPONSE_OK);
+		scmi_inc_count(info->dbg, DELAYED_RESPONSE_OK);
 	} else {
 		complete(&xfer->done);
-		scmi_inc_count(info->dbg->counters, RESPONSE_OK);
+		scmi_inc_count(info->dbg, RESPONSE_OK);
 	}
 
 	if (IS_ENABLED(CONFIG_ARM_SCMI_RAW_MODE_SUPPORT)) {
@@ -1296,7 +1280,7 @@ static int scmi_wait_for_reply(struct device *dev, const struct scmi_desc *desc,
 					"timed out in resp(caller: %pS) - polling\n",
 					(void *)_RET_IP_);
 				ret = -ETIMEDOUT;
-				scmi_inc_count(info->dbg->counters, XFERS_RESPONSE_POLLED_TIMEOUT);
+				scmi_inc_count(info->dbg, XFERS_RESPONSE_POLLED_TIMEOUT);
 			}
 		}
 
@@ -1321,7 +1305,7 @@ static int scmi_wait_for_reply(struct device *dev, const struct scmi_desc *desc,
 					    "RESP" : "resp",
 					    xfer->hdr.seq, xfer->hdr.status,
 					    xfer->rx.buf, xfer->rx.len);
-			scmi_inc_count(info->dbg->counters, RESPONSE_POLLED_OK);
+			scmi_inc_count(info->dbg, RESPONSE_POLLED_OK);
 
 			if (IS_ENABLED(CONFIG_ARM_SCMI_RAW_MODE_SUPPORT)) {
 				scmi_raw_message_report(info->raw, xfer,
@@ -1336,7 +1320,7 @@ static int scmi_wait_for_reply(struct device *dev, const struct scmi_desc *desc,
 			dev_err(dev, "timed out in resp(caller: %pS)\n",
 				(void *)_RET_IP_);
 			ret = -ETIMEDOUT;
-			scmi_inc_count(info->dbg->counters, XFERS_RESPONSE_TIMEOUT);
+			scmi_inc_count(info->dbg, XFERS_RESPONSE_TIMEOUT);
 		}
 	}
 
@@ -1420,13 +1404,13 @@ static int do_xfer(const struct scmi_protocol_handle *ph,
 	    !is_transport_polling_capable(info->desc)) {
 		dev_warn_once(dev,
 			      "Polling mode is not supported by transport.\n");
-		scmi_inc_count(info->dbg->counters, SENT_FAIL_POLLING_UNSUPPORTED);
+		scmi_inc_count(info->dbg, SENT_FAIL_POLLING_UNSUPPORTED);
 		return -EINVAL;
 	}
 
 	cinfo = idr_find(&info->tx_idr, pi->proto->id);
 	if (unlikely(!cinfo)) {
-		scmi_inc_count(info->dbg->counters, SENT_FAIL_CHANNEL_NOT_FOUND);
+		scmi_inc_count(info->dbg, SENT_FAIL_CHANNEL_NOT_FOUND);
 		return -EINVAL;
 	}
 	/* True ONLY if also supported by transport. */
@@ -1461,19 +1445,19 @@ static int do_xfer(const struct scmi_protocol_handle *ph,
 	ret = info->desc->ops->send_message(cinfo, xfer);
 	if (ret < 0) {
 		dev_dbg(dev, "Failed to send message %d\n", ret);
-		scmi_inc_count(info->dbg->counters, SENT_FAIL);
+		scmi_inc_count(info->dbg, SENT_FAIL);
 		return ret;
 	}
 
 	trace_scmi_msg_dump(info->id, cinfo->id, xfer->hdr.protocol_id,
 			    xfer->hdr.id, "CMND", xfer->hdr.seq,
 			    xfer->hdr.status, xfer->tx.buf, xfer->tx.len);
-	scmi_inc_count(info->dbg->counters, SENT_OK);
+	scmi_inc_count(info->dbg, SENT_OK);
 
 	ret = scmi_wait_for_message_response(cinfo, xfer);
 	if (!ret && xfer->hdr.status) {
 		ret = scmi_to_linux_errno(xfer->hdr.status);
-		scmi_inc_count(info->dbg->counters, ERR_PROTOCOL);
+		scmi_inc_count(info->dbg, ERR_PROTOCOL);
 	}
 
 	if (info->desc->ops->mark_txdone)
-- 
2.51.0



