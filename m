Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B1E0111A8;
	Sat,  3 Feb 2024 04:18:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933935; cv=none; b=J5yzdKFIKXZeLA4A8CK23HNkwVa72BDnc8jLkpdIV/flBcuDvv9BLX/eTvU2+C6u3VHrQeQv/SQyzGv3ZMZq+sInBwE+7X63Wu7LhZ/mr57bs5DbWYJFG90DIK9Y1c5AMtW8tiMQYfHsGivjk053JyYJp7Qr28x1HG5bc+kTuUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933935; c=relaxed/simple;
	bh=/loUbwfaXTJr3tVSAJ39C88viBYO+gQFKvCbw8gu/tk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jfz3NsSdSEaRU/13R8NN84rnKVYpYioV0dKF8DkQp+aLFQ6LOm4QjOJnMZYXKqnok0o8tAKyhVzULrEzX3cVPxuvDWt9gYJ+16Qtq5fIV7uCg/M28Pnmvvgb8k65TNbB0NYAAsAk/XxKv2UEKRgdlZZa0aADzwcwDZ/11h5PHoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fRBnbCse; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fRBnbCse"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 004BAC433C7;
	Sat,  3 Feb 2024 04:18:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933935;
	bh=/loUbwfaXTJr3tVSAJ39C88viBYO+gQFKvCbw8gu/tk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fRBnbCseluZZkTutz84WFUhKdUiClzhH1j2sopa0msGUK43Jgk9qChSG+lASQIE/y
	 OayITiRKfXn4voOqrNizlGnV8UZhZVWcPslePyn+A7SdMclk4+LXuwR/QVSGHlxLQK
	 qsRwz231OD67tkPDoDciR1qY05opLuJmV5gt7Hpo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ewan Milne <emilne@redhat.com>,
	Ming Lei <ming.lei@redhat.com>,
	Sathya Prakash Veerichetty <safhya.prakash@broadcom.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 296/353] scsi: core: Move scsi_host_busy() out of host lock for waking up EH handler
Date: Fri,  2 Feb 2024 20:06:54 -0800
Message-ID: <20240203035413.190544237@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit 4373534a9850627a2695317944898eb1283a2db0 ]

Inside scsi_eh_wakeup(), scsi_host_busy() is called & checked with host
lock every time for deciding if error handler kthread needs to be waken up.

This can be too heavy in case of recovery, such as:

 - N hardware queues

 - queue depth is M for each hardware queue

 - each scsi_host_busy() iterates over (N * M) tag/requests

If recovery is triggered in case that all requests are in-flight, each
scsi_eh_wakeup() is strictly serialized, when scsi_eh_wakeup() is called
for the last in-flight request, scsi_host_busy() has been run for (N * M -
1) times, and request has been iterated for (N*M - 1) * (N * M) times.

If both N and M are big enough, hard lockup can be triggered on acquiring
host lock, and it is observed on mpi3mr(128 hw queues, queue depth 8169).

Fix the issue by calling scsi_host_busy() outside the host lock. We don't
need the host lock for getting busy count because host the lock never
covers that.

[mkp: Drop unnecessary 'busy' variables pointed out by Bart]

Cc: Ewan Milne <emilne@redhat.com>
Fixes: 6eb045e092ef ("scsi: core: avoid host-wide host_busy counter for scsi_mq")
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Link: https://lore.kernel.org/r/20240112070000.4161982-1-ming.lei@redhat.com
Reviewed-by: Ewan D. Milne <emilne@redhat.com>
Reviewed-by: Sathya Prakash Veerichetty <safhya.prakash@broadcom.com>
Tested-by: Sathya Prakash Veerichetty <safhya.prakash@broadcom.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_error.c | 8 ++++----
 drivers/scsi/scsi_lib.c   | 2 +-
 drivers/scsi/scsi_priv.h  | 2 +-
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index d983f4a0e9f1..3328b175a832 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -61,11 +61,11 @@ static int scsi_eh_try_stu(struct scsi_cmnd *scmd);
 static enum scsi_disposition scsi_try_to_abort_cmd(const struct scsi_host_template *,
 						   struct scsi_cmnd *);
 
-void scsi_eh_wakeup(struct Scsi_Host *shost)
+void scsi_eh_wakeup(struct Scsi_Host *shost, unsigned int busy)
 {
 	lockdep_assert_held(shost->host_lock);
 
-	if (scsi_host_busy(shost) == shost->host_failed) {
+	if (busy == shost->host_failed) {
 		trace_scsi_eh_wakeup(shost);
 		wake_up_process(shost->ehandler);
 		SCSI_LOG_ERROR_RECOVERY(5, shost_printk(KERN_INFO, shost,
@@ -88,7 +88,7 @@ void scsi_schedule_eh(struct Scsi_Host *shost)
 	if (scsi_host_set_state(shost, SHOST_RECOVERY) == 0 ||
 	    scsi_host_set_state(shost, SHOST_CANCEL_RECOVERY) == 0) {
 		shost->host_eh_scheduled++;
-		scsi_eh_wakeup(shost);
+		scsi_eh_wakeup(shost, scsi_host_busy(shost));
 	}
 
 	spin_unlock_irqrestore(shost->host_lock, flags);
@@ -286,7 +286,7 @@ static void scsi_eh_inc_host_failed(struct rcu_head *head)
 
 	spin_lock_irqsave(shost->host_lock, flags);
 	shost->host_failed++;
-	scsi_eh_wakeup(shost);
+	scsi_eh_wakeup(shost, scsi_host_busy(shost));
 	spin_unlock_irqrestore(shost->host_lock, flags);
 }
 
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index cf3864f72093..1fb80eae9a63 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -280,7 +280,7 @@ static void scsi_dec_host_busy(struct Scsi_Host *shost, struct scsi_cmnd *cmd)
 	if (unlikely(scsi_host_in_recovery(shost))) {
 		spin_lock_irqsave(shost->host_lock, flags);
 		if (shost->host_failed || shost->host_eh_scheduled)
-			scsi_eh_wakeup(shost);
+			scsi_eh_wakeup(shost, scsi_host_busy(shost));
 		spin_unlock_irqrestore(shost->host_lock, flags);
 	}
 	rcu_read_unlock();
diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index 3f0dfb97db6b..1fbfe1b52c9f 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -92,7 +92,7 @@ extern void scmd_eh_abort_handler(struct work_struct *work);
 extern enum blk_eh_timer_return scsi_timeout(struct request *req);
 extern int scsi_error_handler(void *host);
 extern enum scsi_disposition scsi_decide_disposition(struct scsi_cmnd *cmd);
-extern void scsi_eh_wakeup(struct Scsi_Host *shost);
+extern void scsi_eh_wakeup(struct Scsi_Host *shost, unsigned int busy);
 extern void scsi_eh_scmd_add(struct scsi_cmnd *);
 void scsi_eh_ready_devs(struct Scsi_Host *shost,
 			struct list_head *work_q,
-- 
2.43.0



