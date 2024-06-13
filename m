Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E98FC56458;
	Thu, 13 Jun 2024 12:22:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281334; cv=none; b=SYwzPLIvUSpWrsJ+sknGaZG3O8b8mj1tL7gcIVeOBx5dNXFrvgOGypDN2oVG3wFg+/RFEE5kYcYyr2mFuDRm2ap6p0ZrJqQ/JiajVoHv0aGrMutzHwMnPejdcnGKKi6h8B0l0g5XkXhkd5P4TbIUVUPuol/2KGTxFThFq807QaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281334; c=relaxed/simple;
	bh=e/8+XtmQzx7AN9Fu7SYFZBdlHVoL18WBOMQvDsSYVhI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bIuyodmPhxe53o3yijuEZIC1MVUsAID2NmT0FLhM+ky9Wp2YecOMwPMZgy0ClyzjC94LqKxegeftbtmwXqct1Elk3XMAWHaWdqOAFt2pK0iR3VDA9cTyySkgy+oDAAeDmJzc7I/qJHZ0GFt4SumXbNbXXQ4UR5YR/6xq6h1Mgek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v33dnMhR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v33dnMhR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73018C32786;
	Thu, 13 Jun 2024 12:22:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281333;
	bh=e/8+XtmQzx7AN9Fu7SYFZBdlHVoL18WBOMQvDsSYVhI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v33dnMhRtdHDTMZTLjB4fzeWBQ7+KBwt60MOjX9WXUI1NYPF9PIwr0agbi0Cltovf
	 Q79pErwKeTCkvr/s0/B/V8QQC/xcSOsJT/zDUo70QoC7DdELJUG9MRJ4banuphOlx0
	 4qvF5x2Od/xCBjjklcqK1zbm/Hy0zq+7AiNE4txU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 219/317] media: cec: abort if the current transmit was canceled
Date: Thu, 13 Jun 2024 13:33:57 +0200
Message-ID: <20240613113256.026584297@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

[ Upstream commit 590a8e564c6eff7e77a84e728612f1269e3c0685 ]

If a transmit-in-progress was canceled, then, once the transmit
is done, mark it as aborted and refrain from retrying the transmit.

To signal this situation the new transmit_in_progress_aborted field is
set to true.

The old implementation would just set adap->transmitting to NULL and
set adap->transmit_in_progress to false, but on the hardware level
the transmit was still ongoing. However, the framework would think
the transmit was aborted, and if a new transmit was issued, then
it could overwrite the HW buffer containing the old transmit with the
new transmit, leading to garbled data on the CEC bus.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Stable-dep-of: 47c82aac10a6 ("media: cec: core: avoid recursive cec_claim_log_addrs")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/cec/core/cec-adap.c | 14 +++++++++++---
 include/media/cec.h               |  6 ++++++
 2 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/drivers/media/cec/core/cec-adap.c b/drivers/media/cec/core/cec-adap.c
index 6415a80c9040e..fd4af157f4ce7 100644
--- a/drivers/media/cec/core/cec-adap.c
+++ b/drivers/media/cec/core/cec-adap.c
@@ -421,7 +421,7 @@ static void cec_flush(struct cec_adapter *adap)
 		cec_data_cancel(data, CEC_TX_STATUS_ABORTED);
 	}
 	if (adap->transmitting)
-		cec_data_cancel(adap->transmitting, CEC_TX_STATUS_ABORTED);
+		adap->transmit_in_progress_aborted = true;
 
 	/* Cancel the pending timeout work. */
 	list_for_each_entry_safe(data, n, &adap->wait_queue, list) {
@@ -572,6 +572,7 @@ int cec_thread_func(void *_adap)
 		if (data->attempts == 0)
 			data->attempts = attempts;
 
+		adap->transmit_in_progress_aborted = false;
 		/* Tell the adapter to transmit, cancel on error */
 		if (adap->ops->adap_transmit(adap, data->attempts,
 					     signal_free_time, &data->msg))
@@ -599,6 +600,8 @@ void cec_transmit_done_ts(struct cec_adapter *adap, u8 status,
 	struct cec_msg *msg;
 	unsigned int attempts_made = arb_lost_cnt + nack_cnt +
 				     low_drive_cnt + error_cnt;
+	bool done = status & (CEC_TX_STATUS_MAX_RETRIES | CEC_TX_STATUS_OK);
+	bool aborted = adap->transmit_in_progress_aborted;
 
 	dprintk(2, "%s: status 0x%02x\n", __func__, status);
 	if (attempts_made < 1)
@@ -619,6 +622,7 @@ void cec_transmit_done_ts(struct cec_adapter *adap, u8 status,
 		goto wake_thread;
 	}
 	adap->transmit_in_progress = false;
+	adap->transmit_in_progress_aborted = false;
 
 	msg = &data->msg;
 
@@ -639,8 +643,7 @@ void cec_transmit_done_ts(struct cec_adapter *adap, u8 status,
 	 * the hardware didn't signal that it retried itself (by setting
 	 * CEC_TX_STATUS_MAX_RETRIES), then we will retry ourselves.
 	 */
-	if (data->attempts > attempts_made &&
-	    !(status & (CEC_TX_STATUS_MAX_RETRIES | CEC_TX_STATUS_OK))) {
+	if (!aborted && data->attempts > attempts_made && !done) {
 		/* Retry this message */
 		data->attempts -= attempts_made;
 		if (msg->timeout)
@@ -655,6 +658,8 @@ void cec_transmit_done_ts(struct cec_adapter *adap, u8 status,
 		goto wake_thread;
 	}
 
+	if (aborted && !done)
+		status |= CEC_TX_STATUS_ABORTED;
 	data->attempts = 0;
 
 	/* Always set CEC_TX_STATUS_MAX_RETRIES on error */
@@ -1576,6 +1581,9 @@ static void cec_activate_cnt_dec(struct cec_adapter *adap)
 	WARN_ON(adap->ops->adap_enable(adap, false));
 	adap->last_initiator = 0xff;
 	adap->transmit_in_progress = false;
+	adap->transmit_in_progress_aborted = false;
+	if (adap->transmitting)
+		cec_data_cancel(adap->transmitting, CEC_TX_STATUS_ABORTED);
 	mutex_unlock(&adap->devnode.lock);
 }
 
diff --git a/include/media/cec.h b/include/media/cec.h
index 97c5f5bfcbd00..31d704f367074 100644
--- a/include/media/cec.h
+++ b/include/media/cec.h
@@ -163,6 +163,11 @@ struct cec_adap_ops {
  * @wait_queue:		queue of transmits waiting for a reply
  * @transmitting:	CEC messages currently being transmitted
  * @transmit_in_progress: true if a transmit is in progress
+ * @transmit_in_progress_aborted: true if a transmit is in progress is to be
+ *			aborted. This happens if the logical address is
+ *			invalidated while the transmit is ongoing. In that
+ *			case the transmit will finish, but will not retransmit
+ *			and be marked as ABORTED.
  * @kthread_config:	kthread used to configure a CEC adapter
  * @config_completion:	used to signal completion of the config kthread
  * @kthread:		main CEC processing thread
@@ -218,6 +223,7 @@ struct cec_adapter {
 	struct list_head wait_queue;
 	struct cec_data *transmitting;
 	bool transmit_in_progress;
+	bool transmit_in_progress_aborted;
 
 	struct task_struct *kthread_config;
 	struct completion config_completion;
-- 
2.43.0



