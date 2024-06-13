Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B181A143C50;
	Thu, 13 Jun 2024 12:40:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282433; cv=none; b=kiQ11ha76h96MP9dOKrlc6s5TKJlmrdX9pGYvmGzB1+/jzfkbDZiYS/LHDeKIoV+LOsTKktW+dpgtonlySX3mclUV45yEzgOlF6C+6LWAhZom/ZKyOTgY208KG4rmxmAi73lDHi6iMKrmlwOVvHICo5GHPxDFWsRtdrfI/bX6XM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282433; c=relaxed/simple;
	bh=tbxnlCMIHlVpGruUxJ3zYc+IZVcYFBXD1pzEEPI2ANE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gf/JcCycb9NgM3evxSw0aVezH6OeojjavhLE5+5CD+TC4ofOR1lACmysgh+UDT2kqg6WV4e1XDoVGqSBbP61g8i2TN2Wknh97ZAGyVIYBH3oUZIlcb7TOWTlmgpP/xKQLua2tODt1a7KdZJ5yvVZOPNF5dtHCSu9m4wf9gtyW8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AhkaHY6P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AhkaHY6P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A044C2BBFC;
	Thu, 13 Jun 2024 12:40:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282433;
	bh=tbxnlCMIHlVpGruUxJ3zYc+IZVcYFBXD1pzEEPI2ANE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AhkaHY6P+0otVOCfsbJI3rAqcQptR9uJVXcrVRu7FwJH/DwnSa2/k0EQrw/l5OluF
	 fmn7mjACKLY9Kzp75g+J8WSNyYQQNJdnHXcY59tGK9PgyTkcvPG9dFPNy7oQXdD0mq
	 sHIyNgXrmufCUDJayCH7T+n6wodQqOOBOp2a2K6g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 275/402] media: cec: correctly pass on reply results
Date: Thu, 13 Jun 2024 13:33:52 +0200
Message-ID: <20240613113312.879661914@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

[ Upstream commit f9d0ecbf56f4b90745a6adc5b59281ad8f70ab54 ]

The results of non-blocking transmits were not correctly communicated
to userspace.

Specifically:

1) if a non-blocking transmit was canceled, then rx_status wasn't set to 0
   as it should.
2) if the non-blocking transmit succeeded, but the corresponding reply
   never arrived (aborted or timed out), then tx_status wasn't set to 0
   as it should, and rx_status was hardcoded to ABORTED instead of the
   actual reason, such as TIMEOUT. In addition, adap->ops->received() was
   never called, so drivers that want to do message processing themselves
   would not be informed of the failed reply.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Stable-dep-of: 47c82aac10a6 ("media: cec: core: avoid recursive cec_claim_log_addrs")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/cec/core/cec-adap.c | 48 +++++++++++++++++++------------
 1 file changed, 30 insertions(+), 18 deletions(-)

diff --git a/drivers/media/cec/core/cec-adap.c b/drivers/media/cec/core/cec-adap.c
index a0a19f37ef5ba..297842398cf30 100644
--- a/drivers/media/cec/core/cec-adap.c
+++ b/drivers/media/cec/core/cec-adap.c
@@ -366,38 +366,48 @@ static void cec_data_completed(struct cec_data *data)
 /*
  * A pending CEC transmit needs to be cancelled, either because the CEC
  * adapter is disabled or the transmit takes an impossibly long time to
- * finish.
+ * finish, or the reply timed out.
  *
  * This function is called with adap->lock held.
  */
-static void cec_data_cancel(struct cec_data *data, u8 tx_status)
+static void cec_data_cancel(struct cec_data *data, u8 tx_status, u8 rx_status)
 {
+	struct cec_adapter *adap = data->adap;
+
 	/*
 	 * It's either the current transmit, or it is a pending
 	 * transmit. Take the appropriate action to clear it.
 	 */
-	if (data->adap->transmitting == data) {
-		data->adap->transmitting = NULL;
+	if (adap->transmitting == data) {
+		adap->transmitting = NULL;
 	} else {
 		list_del_init(&data->list);
 		if (!(data->msg.tx_status & CEC_TX_STATUS_OK))
-			if (!WARN_ON(!data->adap->transmit_queue_sz))
-				data->adap->transmit_queue_sz--;
+			if (!WARN_ON(!adap->transmit_queue_sz))
+				adap->transmit_queue_sz--;
 	}
 
 	if (data->msg.tx_status & CEC_TX_STATUS_OK) {
 		data->msg.rx_ts = ktime_get_ns();
-		data->msg.rx_status = CEC_RX_STATUS_ABORTED;
+		data->msg.rx_status = rx_status;
+		if (!data->blocking)
+			data->msg.tx_status = 0;
 	} else {
 		data->msg.tx_ts = ktime_get_ns();
 		data->msg.tx_status |= tx_status |
 				       CEC_TX_STATUS_MAX_RETRIES;
 		data->msg.tx_error_cnt++;
 		data->attempts = 0;
+		if (!data->blocking)
+			data->msg.rx_status = 0;
 	}
 
 	/* Queue transmitted message for monitoring purposes */
-	cec_queue_msg_monitor(data->adap, &data->msg, 1);
+	cec_queue_msg_monitor(adap, &data->msg, 1);
+
+	if (!data->blocking && data->msg.sequence && adap->ops->received)
+		/* Allow drivers to process the message first */
+		adap->ops->received(adap, &data->msg);
 
 	cec_data_completed(data);
 }
@@ -418,7 +428,7 @@ static void cec_flush(struct cec_adapter *adap)
 	while (!list_empty(&adap->transmit_queue)) {
 		data = list_first_entry(&adap->transmit_queue,
 					struct cec_data, list);
-		cec_data_cancel(data, CEC_TX_STATUS_ABORTED);
+		cec_data_cancel(data, CEC_TX_STATUS_ABORTED, 0);
 	}
 	if (adap->transmitting)
 		adap->transmit_in_progress_aborted = true;
@@ -426,7 +436,7 @@ static void cec_flush(struct cec_adapter *adap)
 	/* Cancel the pending timeout work. */
 	list_for_each_entry_safe(data, n, &adap->wait_queue, list) {
 		if (cancel_delayed_work(&data->work))
-			cec_data_cancel(data, CEC_TX_STATUS_OK);
+			cec_data_cancel(data, CEC_TX_STATUS_OK, CEC_RX_STATUS_ABORTED);
 		/*
 		 * If cancel_delayed_work returned false, then
 		 * the cec_wait_timeout function is running,
@@ -516,7 +526,7 @@ int cec_thread_func(void *_adap)
 					adap->transmitting->msg.msg);
 				/* Just give up on this. */
 				cec_data_cancel(adap->transmitting,
-						CEC_TX_STATUS_TIMEOUT);
+						CEC_TX_STATUS_TIMEOUT, 0);
 			} else {
 				pr_warn("cec-%s: transmit timed out\n", adap->name);
 			}
@@ -576,7 +586,7 @@ int cec_thread_func(void *_adap)
 		/* Tell the adapter to transmit, cancel on error */
 		if (adap->ops->adap_transmit(adap, data->attempts,
 					     signal_free_time, &data->msg))
-			cec_data_cancel(data, CEC_TX_STATUS_ABORTED);
+			cec_data_cancel(data, CEC_TX_STATUS_ABORTED, 0);
 		else
 			adap->transmit_in_progress = true;
 
@@ -738,9 +748,7 @@ static void cec_wait_timeout(struct work_struct *work)
 
 	/* Mark the message as timed out */
 	list_del_init(&data->list);
-	data->msg.rx_ts = ktime_get_ns();
-	data->msg.rx_status = CEC_RX_STATUS_TIMEOUT;
-	cec_data_completed(data);
+	cec_data_cancel(data, CEC_TX_STATUS_OK, CEC_RX_STATUS_TIMEOUT);
 unlock:
 	mutex_unlock(&adap->lock);
 }
@@ -923,8 +931,12 @@ int cec_transmit_msg_fh(struct cec_adapter *adap, struct cec_msg *msg,
 	mutex_lock(&adap->lock);
 
 	/* Cancel the transmit if it was interrupted */
-	if (!data->completed)
-		cec_data_cancel(data, CEC_TX_STATUS_ABORTED);
+	if (!data->completed) {
+		if (data->msg.tx_status & CEC_TX_STATUS_OK)
+			cec_data_cancel(data, CEC_TX_STATUS_OK, CEC_RX_STATUS_ABORTED);
+		else
+			cec_data_cancel(data, CEC_TX_STATUS_ABORTED, 0);
+	}
 
 	/* The transmit completed (possibly with an error) */
 	*msg = data->msg;
@@ -1583,7 +1595,7 @@ static void cec_activate_cnt_dec(struct cec_adapter *adap)
 	adap->transmit_in_progress = false;
 	adap->transmit_in_progress_aborted = false;
 	if (adap->transmitting)
-		cec_data_cancel(adap->transmitting, CEC_TX_STATUS_ABORTED);
+		cec_data_cancel(adap->transmitting, CEC_TX_STATUS_ABORTED, 0);
 	mutex_unlock(&adap->devnode.lock);
 }
 
-- 
2.43.0



