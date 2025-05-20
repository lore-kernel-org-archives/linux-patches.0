Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B97FAEEDE;
	Tue, 20 May 2025 14:02:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747749742; cv=none; b=ohE/avFH+KUB3cEEw533Hkxdy1dWMl4uLgEh/XhKGLlNCqLSboNepSQqgJTiYj7o3qNz5mMzYyaia6Dtxgp4kbMbvKBcMZOPf/+OkqHEJ+xJcZdoD20IawuR/vjmz++vk25N1CXbAom8T6C2eRTYp1mjVG7o8Fs6Yn3N2x21BI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747749742; c=relaxed/simple;
	bh=w5SDU04gWgxqivugwUu2KpCu5vXf4njL3ACIOPpspQ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V2o9SjQiI7m4F6646RTqsaBMFpGfgOWxDTYvV24vSqh9VQWKI7tl6QQJnX9Fl5My1Nq+oKXBs+xJ/cPAlCKfPcVophOeXk0D1R3AcfbsoKVuBILFE7AnhpWxEoC0c6uM7IXAsigcgmUNfBIVFKsY8PCdVdiW7mIVfm6doopeLO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aFAYSsIk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aFAYSsIk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AF2EC4CEE9;
	Tue, 20 May 2025 14:02:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747749742;
	bh=w5SDU04gWgxqivugwUu2KpCu5vXf4njL3ACIOPpspQ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aFAYSsIkmrAeYUk1kGvibpyocH6mGhZurL79hRItgN5nsawcI3Wsx6sODEjoxlFuP
	 ZbBLnxH7belJn9qaXXOLWfsG6W45v76X7fRYPLP2olPUtbPT4Mu10RxXx+9z8M6YAk
	 n9plnsW7yhhzzAut13wvHGbdx/wuoMLlPWA/Q4uE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luke Parkin <luke.parkin@arm.com>,
	Cristian Marussi <cristian.marussi@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 018/117] firmware: arm_scmi: Track basic SCMI communication debug metrics
Date: Tue, 20 May 2025 15:49:43 +0200
Message-ID: <20250520125804.705376048@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125803.981048184@linuxfoundation.org>
References: <20250520125803.981048184@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Luke Parkin <luke.parkin@arm.com>

[ Upstream commit 0b3d48c4726e1b20dffd2ff81a9d94d5d930220b ]

Add the support for counting some of the SCMI communication debug metrics
like how many were sent successfully or with some errors, responses
received, notifications and delayed responses, transfer timeouts and
errors from the firmware/platform.

In many cases, the traces exists. But the traces are not always necessarily
enabled and getting such cumulative SCMI communication debug metrics helps
in understanding if there are any possible improvements that can be made
on either side of SCMI communication.

Signed-off-by: Luke Parkin <luke.parkin@arm.com>
Reviewed-by: Cristian Marussi <cristian.marussi@arm.com>
Tested-by: Cristian Marussi <cristian.marussi@arm.com>
Message-Id: <20240805131013.587016-4-sudeep.holla@arm.com>
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Stable-dep-of: c23c03bf1faa ("firmware: arm_scmi: Fix timeout checks on polling path")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scmi/common.h | 14 ++++++++++++++
 drivers/firmware/arm_scmi/driver.c | 25 ++++++++++++++++++++-----
 2 files changed, 34 insertions(+), 5 deletions(-)

diff --git a/drivers/firmware/arm_scmi/common.h b/drivers/firmware/arm_scmi/common.h
index e3a9217f29d39..6c22348712154 100644
--- a/drivers/firmware/arm_scmi/common.h
+++ b/drivers/firmware/arm_scmi/common.h
@@ -304,6 +304,20 @@ extern const struct scmi_desc scmi_optee_desc;
 void scmi_rx_callback(struct scmi_chan_info *cinfo, u32 msg_hdr, void *priv);
 
 enum debug_counters {
+	SENT_OK,
+	SENT_FAIL,
+	SENT_FAIL_POLLING_UNSUPPORTED,
+	SENT_FAIL_CHANNEL_NOT_FOUND,
+	RESPONSE_OK,
+	NOTIFICATION_OK,
+	DELAYED_RESPONSE_OK,
+	XFERS_RESPONSE_TIMEOUT,
+	XFERS_RESPONSE_POLLED_TIMEOUT,
+	RESPONSE_POLLED_OK,
+	ERR_MSG_UNEXPECTED,
+	ERR_MSG_INVALID,
+	ERR_MSG_NOMEM,
+	ERR_PROTOCOL,
 	SCMI_DEBUG_COUNTERS_LAST
 };
 
diff --git a/drivers/firmware/arm_scmi/driver.c b/drivers/firmware/arm_scmi/driver.c
index 3bc41a9920294..09aaad6dce043 100644
--- a/drivers/firmware/arm_scmi/driver.c
+++ b/drivers/firmware/arm_scmi/driver.c
@@ -856,6 +856,7 @@ scmi_xfer_command_acquire(struct scmi_chan_info *cinfo, u32 msg_hdr)
 		spin_unlock_irqrestore(&minfo->xfer_lock, flags);
 
 		scmi_bad_message_trace(cinfo, msg_hdr, MSG_UNEXPECTED);
+		scmi_inc_count(info->dbg->counters, ERR_MSG_UNEXPECTED);
 
 		return xfer;
 	}
@@ -883,6 +884,8 @@ scmi_xfer_command_acquire(struct scmi_chan_info *cinfo, u32 msg_hdr)
 			msg_type, xfer_id, msg_hdr, xfer->state);
 
 		scmi_bad_message_trace(cinfo, msg_hdr, MSG_INVALID);
+		scmi_inc_count(info->dbg->counters, ERR_MSG_INVALID);
+
 
 		/* On error the refcount incremented above has to be dropped */
 		__scmi_xfer_put(minfo, xfer);
@@ -927,6 +930,7 @@ static void scmi_handle_notification(struct scmi_chan_info *cinfo,
 			PTR_ERR(xfer));
 
 		scmi_bad_message_trace(cinfo, msg_hdr, MSG_NOMEM);
+		scmi_inc_count(info->dbg->counters, ERR_MSG_NOMEM);
 
 		scmi_clear_channel(info, cinfo);
 		return;
@@ -942,6 +946,7 @@ static void scmi_handle_notification(struct scmi_chan_info *cinfo,
 	trace_scmi_msg_dump(info->id, cinfo->id, xfer->hdr.protocol_id,
 			    xfer->hdr.id, "NOTI", xfer->hdr.seq,
 			    xfer->hdr.status, xfer->rx.buf, xfer->rx.len);
+	scmi_inc_count(info->dbg->counters, NOTIFICATION_OK);
 
 	scmi_notify(cinfo->handle, xfer->hdr.protocol_id,
 		    xfer->hdr.id, xfer->rx.buf, xfer->rx.len, ts);
@@ -1001,8 +1006,10 @@ static void scmi_handle_response(struct scmi_chan_info *cinfo,
 	if (xfer->hdr.type == MSG_TYPE_DELAYED_RESP) {
 		scmi_clear_channel(info, cinfo);
 		complete(xfer->async_done);
+		scmi_inc_count(info->dbg->counters, DELAYED_RESPONSE_OK);
 	} else {
 		complete(&xfer->done);
+		scmi_inc_count(info->dbg->counters, RESPONSE_OK);
 	}
 
 	if (IS_ENABLED(CONFIG_ARM_SCMI_RAW_MODE_SUPPORT)) {
@@ -1086,6 +1093,7 @@ static int scmi_wait_for_reply(struct device *dev, const struct scmi_desc *desc,
 			       struct scmi_xfer *xfer, unsigned int timeout_ms)
 {
 	int ret = 0;
+	struct scmi_info *info = handle_to_scmi_info(cinfo->handle);
 
 	if (xfer->hdr.poll_completion) {
 		/*
@@ -1106,13 +1114,12 @@ static int scmi_wait_for_reply(struct device *dev, const struct scmi_desc *desc,
 					"timed out in resp(caller: %pS) - polling\n",
 					(void *)_RET_IP_);
 				ret = -ETIMEDOUT;
+				scmi_inc_count(info->dbg->counters, XFERS_RESPONSE_POLLED_TIMEOUT);
 			}
 		}
 
 		if (!ret) {
 			unsigned long flags;
-			struct scmi_info *info =
-				handle_to_scmi_info(cinfo->handle);
 
 			/*
 			 * Do not fetch_response if an out-of-order delayed
@@ -1132,6 +1139,7 @@ static int scmi_wait_for_reply(struct device *dev, const struct scmi_desc *desc,
 					    "RESP" : "resp",
 					    xfer->hdr.seq, xfer->hdr.status,
 					    xfer->rx.buf, xfer->rx.len);
+			scmi_inc_count(info->dbg->counters, RESPONSE_POLLED_OK);
 
 			if (IS_ENABLED(CONFIG_ARM_SCMI_RAW_MODE_SUPPORT)) {
 				struct scmi_info *info =
@@ -1149,6 +1157,7 @@ static int scmi_wait_for_reply(struct device *dev, const struct scmi_desc *desc,
 			dev_err(dev, "timed out in resp(caller: %pS)\n",
 				(void *)_RET_IP_);
 			ret = -ETIMEDOUT;
+			scmi_inc_count(info->dbg->counters, XFERS_RESPONSE_TIMEOUT);
 		}
 	}
 
@@ -1232,13 +1241,15 @@ static int do_xfer(const struct scmi_protocol_handle *ph,
 	    !is_transport_polling_capable(info->desc)) {
 		dev_warn_once(dev,
 			      "Polling mode is not supported by transport.\n");
+		scmi_inc_count(info->dbg->counters, SENT_FAIL_POLLING_UNSUPPORTED);
 		return -EINVAL;
 	}
 
 	cinfo = idr_find(&info->tx_idr, pi->proto->id);
-	if (unlikely(!cinfo))
+	if (unlikely(!cinfo)) {
+		scmi_inc_count(info->dbg->counters, SENT_FAIL_CHANNEL_NOT_FOUND);
 		return -EINVAL;
-
+	}
 	/* True ONLY if also supported by transport. */
 	if (is_polling_enabled(cinfo, info->desc))
 		xfer->hdr.poll_completion = true;
@@ -1270,16 +1281,20 @@ static int do_xfer(const struct scmi_protocol_handle *ph,
 	ret = info->desc->ops->send_message(cinfo, xfer);
 	if (ret < 0) {
 		dev_dbg(dev, "Failed to send message %d\n", ret);
+		scmi_inc_count(info->dbg->counters, SENT_FAIL);
 		return ret;
 	}
 
 	trace_scmi_msg_dump(info->id, cinfo->id, xfer->hdr.protocol_id,
 			    xfer->hdr.id, "CMND", xfer->hdr.seq,
 			    xfer->hdr.status, xfer->tx.buf, xfer->tx.len);
+	scmi_inc_count(info->dbg->counters, SENT_OK);
 
 	ret = scmi_wait_for_message_response(cinfo, xfer);
-	if (!ret && xfer->hdr.status)
+	if (!ret && xfer->hdr.status) {
 		ret = scmi_to_linux_errno(xfer->hdr.status);
+		scmi_inc_count(info->dbg->counters, ERR_PROTOCOL);
+	}
 
 	if (info->desc->ops->mark_txdone)
 		info->desc->ops->mark_txdone(cinfo, ret, xfer);
-- 
2.39.5



