Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025263;
	b=dbtNqpOBDYAGdKPEqJuwcrXYs56fdmkt2xq029FdrwwaHhb1hjRZot7Ui3TKAPcLfdWS
	 e8j1ERgg49MGz/7hBbg9XrW38CArKlxjhUeT4JDQWxKVAhgKW40TQyutdzsXzPRsZ3y/4
	 Dz8D/CKo8DFCEXpD2bwp5pwTuBGqMbb8ExHvHfKopQffotAxOd74//wQ9zdCEEqm3aj4s
	 qwHoCsB2UIjOpcbc0DckQmaMxq+LSuTL+ADj/oY7rNCe4bmjVBAeIm1LB39mc903cLEnk
	 ivfW1uAO7/W0KYORUBHOzA+utmj9SKOg5CiyP9oI7U+aTyQFWYh6Gv3TOTEtRlFYYXg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025263;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UpIUf1GJc7tVP5dw6pgyEhBDdZx/L7K1+slPvb8FhU0=;
	b=PsLw+ntInlno2R3237oRPI3XLtiJ5900QRItny+OjzEFFihRbkw1m0ROEdrKE8S+fJRL
	 HFZrpWDumXXfM+o5V8souBOE6R8YyhfOfRPa7LD1V/BPTrI5JcdJK2OXPqFCmLVwtKcHu
	 ce6cR1EsDxf/vNpZGr0YxgYR6yadHNh/ltWuG16JEuwzObuAQCc5ne5DzIi05AmhPY71F
	 +FZ/5y1SIBM+Y//YsKT1xnzvDZWIalN6xko1ALB0Y5tylLZFqqaxtPEjohf9mbsTf74t+
	 Be7QNgRGa+7q4tUWMWnFlV6ufHmeIIde1X19f8H9Y02Q/hUrYlNZHnqekHU0v+JSy2g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="DQ6MxRI/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E110F606A33F;
	Wed, 18 Nov 2026 18:07:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DQ6MxRI/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E18F51F000C9;
	Wed, 18 Nov 2026 18:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025262;
	bh=UpIUf1GJc7tVP5dw6pgyEhBDdZx/L7K1+slPvb8FhU0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DQ6MxRI/5AwDsBEE3gW0roAa75o+9U4aMNsXsEv18No9rmkxNgNdrg40da0rEGCjm
	 hHrthVpDI2t9L0g9YvDbak/5rYu38qCsoWfjs323B0s920Izn6Ngebwre4askdIAcD
	 p0pThUGRJ4Vu/uU7bmsb65H2WA8jDKt3WxJOO8j8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Garry <john.g.garry@oracle.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1015/2151] scsi: scsi_debug: Abort SCSI commands via an internal command
Date: Wed, 18 Nov 2026 15:45:50 +0100
Message-ID: <20261118150159.387538758@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit 581ca490353ca5f4bee0d662595af27c06e603d4 ]

Add a .queue_reserved_command() implementation and call it from the code
path that aborts SCSI commands. This ensures that the code for
allocating a pseudo SCSI device and also the code for allocating and
processing reserved commands gets triggered while running blktests.

Most of the code in this patch is a modified version of code from John
Garry. See also
https://lore.kernel.org/linux-scsi/75018e17-4dea-4e1b-8c92-7a224a1e13b9@oracle.com/

Reviewed-by: John Garry <john.g.garry@oracle.com>
Suggested-by: John Garry <john.g.garry@oracle.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Link: https://patch.msgid.link/20251031204029.2883185-8-bvanassche@acm.org
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: 92feb036a2d3 ("scsi: scsi_debug: Avoid 32-bit overflow in WRITE SCATTERED offsets")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_debug.c | 116 ++++++++++++++++++++++++++++++++++----
 1 file changed, 105 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 60ed10fa1f7fd..47206da6f4161 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -6756,20 +6756,59 @@ static bool scsi_debug_stop_cmnd(struct scsi_cmnd *cmnd)
 	return false;
 }
 
+struct sdebug_abort_cmd {
+	u32 unique_tag;
+};
+
+enum sdebug_internal_cmd_type {
+	SCSI_DEBUG_ABORT_CMD,
+};
+
+struct sdebug_internal_cmd {
+	enum sdebug_internal_cmd_type type;
+
+	union {
+		struct sdebug_abort_cmd abort_cmd;
+	};
+};
+
+union sdebug_priv {
+	struct sdebug_scsi_cmd cmd;
+	struct sdebug_internal_cmd internal_cmd;
+};
+
 /*
- * Called from scsi_debug_abort() only, which is for timed-out cmd.
+ * Abort SCSI command @cmnd. Only called from scsi_debug_abort(). Although
+ * it would be possible to call scsi_debug_stop_cmnd() directly, an internal
+ * command is allocated and submitted to trigger the reserved command
+ * infrastructure.
  */
 static bool scsi_debug_abort_cmnd(struct scsi_cmnd *cmnd)
 {
-	struct sdebug_scsi_cmd *sdsc = scsi_cmd_priv(cmnd);
-	unsigned long flags;
-	bool res;
-
-	spin_lock_irqsave(&sdsc->lock, flags);
-	res = scsi_debug_stop_cmnd(cmnd);
-	spin_unlock_irqrestore(&sdsc->lock, flags);
-
-	return res;
+	struct Scsi_Host *shost = cmnd->device->host;
+	struct request *rq = scsi_cmd_to_rq(cmnd);
+	u32 unique_tag = blk_mq_unique_tag(rq);
+	struct sdebug_internal_cmd *internal_cmd;
+	struct scsi_cmnd *abort_cmd;
+	struct request *abort_rq;
+	blk_status_t res;
+
+	abort_cmd = scsi_get_internal_cmd(shost->pseudo_sdev, DMA_NONE,
+					  BLK_MQ_REQ_RESERVED);
+	if (!abort_cmd)
+		return false;
+	internal_cmd = scsi_cmd_priv(abort_cmd);
+	*internal_cmd = (struct sdebug_internal_cmd) {
+		.type = SCSI_DEBUG_ABORT_CMD,
+		.abort_cmd = {
+			.unique_tag = unique_tag,
+		},
+	};
+	abort_rq = scsi_cmd_to_rq(abort_cmd);
+	abort_rq->timeout = secs_to_jiffies(3);
+	res = blk_execute_rq(abort_rq, true);
+	scsi_put_internal_cmd(abort_cmd);
+	return res == BLK_STS_OK;
 }
 
 /*
@@ -9224,6 +9263,56 @@ static int sdebug_fail_cmd(struct scsi_cmnd *cmnd, int *retval,
 	return ret;
 }
 
+/* Process @scp, a request to abort a SCSI command by tag. */
+static void scsi_debug_abort_cmd(struct Scsi_Host *shost, struct scsi_cmnd *scp)
+{
+	struct sdebug_internal_cmd *internal_cmd = scsi_cmd_priv(scp);
+	struct sdebug_abort_cmd *abort_cmd = &internal_cmd->abort_cmd;
+	const u32 unique_tag = abort_cmd->unique_tag;
+	struct scsi_cmnd *to_be_aborted_scmd =
+		scsi_host_find_tag(shost, unique_tag);
+	struct sdebug_scsi_cmd *to_be_aborted_sdsc =
+		scsi_cmd_priv(to_be_aborted_scmd);
+	bool res = false;
+
+	if (!to_be_aborted_scmd) {
+		pr_err("%s: command with tag %#x not found\n", __func__,
+		       unique_tag);
+		return;
+	}
+
+	scoped_guard(spinlock_irqsave, &to_be_aborted_sdsc->lock)
+		res = scsi_debug_stop_cmnd(to_be_aborted_scmd);
+
+	if (res)
+		pr_info("%s: aborted command with tag %#x\n",
+			__func__, unique_tag);
+	else
+		pr_err("%s: failed to abort command with tag %#x\n",
+		       __func__, unique_tag);
+
+	set_host_byte(scp, res ? DID_OK : DID_ERROR);
+}
+
+static int scsi_debug_process_reserved_command(struct Scsi_Host *shost,
+					       struct scsi_cmnd *scp)
+{
+	struct sdebug_internal_cmd *internal_cmd = scsi_cmd_priv(scp);
+
+	switch (internal_cmd->type) {
+	case SCSI_DEBUG_ABORT_CMD:
+		scsi_debug_abort_cmd(shost, scp);
+		break;
+	default:
+		WARN_ON_ONCE(true);
+		set_host_byte(scp, DID_ERROR);
+		break;
+	}
+
+	scsi_done(scp);
+	return 0;
+}
+
 static int scsi_debug_queuecommand(struct Scsi_Host *shost,
 				   struct scsi_cmnd *scp)
 {
@@ -9424,6 +9513,9 @@ static int sdebug_init_cmd_priv(struct Scsi_Host *shost, struct scsi_cmnd *cmd)
 	struct sdebug_scsi_cmd *sdsc = scsi_cmd_priv(cmd);
 	struct sdebug_defer *sd_dp = &sdsc->sd_dp;
 
+	if (blk_mq_is_reserved_rq(scsi_cmd_to_rq(cmd)))
+		return 0;
+
 	spin_lock_init(&sdsc->lock);
 	hrtimer_setup(&sd_dp->hrt, sdebug_q_cmd_hrt_complete, CLOCK_MONOTONIC,
 		      HRTIMER_MODE_REL_PINNED);
@@ -9443,6 +9535,7 @@ static const struct scsi_host_template sdebug_driver_template = {
 	.sdev_destroy =		scsi_debug_sdev_destroy,
 	.ioctl =		scsi_debug_ioctl,
 	.queuecommand =		scsi_debug_queuecommand,
+	.queue_reserved_command = scsi_debug_process_reserved_command,
 	.change_queue_depth =	sdebug_change_qdepth,
 	.map_queues =		sdebug_map_queues,
 	.mq_poll =		sdebug_blk_mq_poll,
@@ -9452,6 +9545,7 @@ static const struct scsi_host_template sdebug_driver_template = {
 	.eh_bus_reset_handler = scsi_debug_bus_reset,
 	.eh_host_reset_handler = scsi_debug_host_reset,
 	.can_queue =		SDEBUG_CANQUEUE,
+	.nr_reserved_cmds =	1,
 	.this_id =		7,
 	.sg_tablesize =		SG_MAX_SEGMENTS,
 	.cmd_per_lun =		DEF_CMD_PER_LUN,
@@ -9460,7 +9554,7 @@ static const struct scsi_host_template sdebug_driver_template = {
 	.module =		THIS_MODULE,
 	.skip_settle_delay =	1,
 	.track_queue_depth =	1,
-	.cmd_size = sizeof(struct sdebug_scsi_cmd),
+	.cmd_size = sizeof(union sdebug_priv),
 	.init_cmd_priv = sdebug_init_cmd_priv,
 	.target_alloc =		sdebug_target_alloc,
 	.target_destroy =	sdebug_target_destroy,
-- 
2.53.0



