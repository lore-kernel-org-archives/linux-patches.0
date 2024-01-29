Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6471C15AACD;
	Mon, 29 Jan 2024 17:07:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548076; cv=none; b=Lv2vWA0wkii4qvz1p22FOAKre66WKRf7BlfYbi0QhKS6JM7IEX7lnFsyS+8nXec9Gq9Fg6VVOomLqkC+AzFyoU8j80ZiHQH+NSBhxCFe2Alzrd9TLKpzeLzOf3L2ZlANQol4q2PW0iLZEJ+5lkSClNmLxI7LKwoAsnpnISZJ53A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548076; c=relaxed/simple;
	bh=R+JNocAtCOz2yX7F83lEbI67+dlwZ1s/fpuZSD9Hjbk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vo8B+l6wwvklKmQWw6JqGF37RycdmKk4EsDDPqjcxVfcM69m1YTnmW69P8+qvScJB7OqyXpCU49wMzyDOQF3cN92+Xx6BvGAqMSGY9uCLRsebEt47F73GFKBDCEsnmgZ/XygxMFqdWpE1ChGDKfnWaatnIVd5br26ro1aqKLWQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rTgCmU5j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rTgCmU5j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CB59C43390;
	Mon, 29 Jan 2024 17:07:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548076;
	bh=R+JNocAtCOz2yX7F83lEbI67+dlwZ1s/fpuZSD9Hjbk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rTgCmU5jPyThANuUTOzCXyZC7NivOKJBVWlv3qkJ+F1rNkVRtM/V4Ycb4R+Macy8t
	 O2axH+PFUY3EX1WQ5eeuPRLpGReWY2jQOXV9N+31w/0YxTffxyInorIIg/fZQ7CkHC
	 LItAHsXOQrtWTxb7ahLU87sLwJcWVtobALE7Zgb0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kevin Locke <kevin@kevinlocke.name>,
	Niklas Cassel <cassel@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 060/346] scsi: core: Kick the requeue list after inserting when flushing
Date: Mon, 29 Jan 2024 09:01:31 -0800
Message-ID: <20240129170018.161681059@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niklas Cassel <cassel@kernel.org>

[ Upstream commit 6df0e077d76bd144c533b61d6182676aae6b0a85 ]

When libata calls ata_link_abort() to abort all ata queued commands, it
calls blk_abort_request() on the SCSI command representing each QC.

This causes scsi_timeout() to be called, which calls scsi_eh_scmd_add() for
each SCSI command.

scsi_eh_scmd_add() sets the SCSI host to state recovery, and then adds the
command to shost->eh_cmd_q.

This will wake up the SCSI EH, and eventually the libata EH strategy
handler will be called, which calls scsi_eh_flush_done_q() to either flush
retry or flush finish each failed command.

The commands that are flush retried by scsi_eh_flush_done_q() are done so
using scsi_queue_insert().

Before commit 8b566edbdbfb ("scsi: core: Only kick the requeue list if
necessary"), __scsi_queue_insert() called blk_mq_requeue_request() with the
second argument set to true, indicating that it should always kick/run the
requeue list after inserting.

After commit 8b566edbdbfb ("scsi: core: Only kick the requeue list if
necessary"), __scsi_queue_insert() does not kick/run the requeue list after
inserting, if the current SCSI host state is recovery (which is the case in
the libata example above).

This optimization is probably fine in most cases, as I can only assume that
most often someone will eventually kick/run the queues.

However, that is not the case for scsi_eh_flush_done_q(), where we can see
that the request gets inserted to the requeue list, but the queue is never
started after the request has been inserted, leading to the block layer
waiting for the completion of command that never gets to run.

Since scsi_eh_flush_done_q() is called by SCSI EH context, the SCSI host
state is most likely always in recovery when this function is called.

Thus, let scsi_eh_flush_done_q() explicitly kick the requeue list after
inserting a flush retry command, so that scsi_eh_flush_done_q() keeps the
same behavior as before commit 8b566edbdbfb ("scsi: core: Only kick the
requeue list if necessary").

Simple reproducer for the libata example above:
$ hdparm -Y /dev/sda
$ echo 1 > /sys/class/scsi_device/0\:0\:0\:0/device/delete

Fixes: 8b566edbdbfb ("scsi: core: Only kick the requeue list if necessary")
Reported-by: Kevin Locke <kevin@kevinlocke.name>
Closes: https://lore.kernel.org/linux-scsi/ZZw3Th70wUUvCiCY@kevinlocke.name/
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Link: https://lore.kernel.org/r/20240111120533.3612509-1-cassel@kernel.org
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_error.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 1223d34c04da..d983f4a0e9f1 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -2196,15 +2196,18 @@ void scsi_eh_flush_done_q(struct list_head *done_q)
 	struct scsi_cmnd *scmd, *next;
 
 	list_for_each_entry_safe(scmd, next, done_q, eh_entry) {
+		struct scsi_device *sdev = scmd->device;
+
 		list_del_init(&scmd->eh_entry);
-		if (scsi_device_online(scmd->device) &&
-		    !scsi_noretry_cmd(scmd) && scsi_cmd_retry_allowed(scmd) &&
-			scsi_eh_should_retry_cmd(scmd)) {
+		if (scsi_device_online(sdev) && !scsi_noretry_cmd(scmd) &&
+		    scsi_cmd_retry_allowed(scmd) &&
+		    scsi_eh_should_retry_cmd(scmd)) {
 			SCSI_LOG_ERROR_RECOVERY(3,
 				scmd_printk(KERN_INFO, scmd,
 					     "%s: flush retry cmd\n",
 					     current->comm));
 				scsi_queue_insert(scmd, SCSI_MLQUEUE_EH_RETRY);
+				blk_mq_kick_requeue_list(sdev->request_queue);
 		} else {
 			/*
 			 * If just we got sense for the device (called
-- 
2.43.0



