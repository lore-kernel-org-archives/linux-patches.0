Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B1D643C7A6;
	Thu, 30 Jul 2026 14:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423599; cv=none; b=YZ+QJ5QOt148PJ/8WBFcVAgkiPQJkqPQ7e5Och701lXZCCzFGqTWrxf/LFjJY24Qc9L/Nm3MW+9vIMF3MKKjzn2+1Ny1EmxR0y8TSe0IALZjUpKSEhM8+H5F4m1b/5KhqN2QVxLh8SbW1S+CJqE+xN/nmXRQ2Ct2Br0ILAEz/3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423599; c=relaxed/simple;
	bh=KsvDE8TMTpWaDfj5mRvnQsowuRgS+ZchRWP5UMx4LWY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mw93xTAl/PCX1dKgYBDPzGtty5q4ZnPd0baEh9WZpWOi0JuBWD78VLIPUbAq7VOSCp9j9MH6nq1Zx6aILbNQewib/SjugGPHYnpWSchFgXEA65QP36I5q94o+ckkWgWvAwX0CF9Jn7dUgS1ahsY1hOC4muLL65viijfGb8mDcAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u+59QUVq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u+59QUVq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48A4F1F000E9;
	Thu, 30 Jul 2026 14:59:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423597;
	bh=5GGtET28e3FswgCkfEecT7dGDawfWv6aC0hIqpNrZA8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u+59QUVqr586I+XpMmpiutBbSf6TMlC221+GtML2/ESLbmDLT8it67dipuVsuOgoF
	 ApOLkyS2ApH7MSRcStdowY7q+r7dqqwB1EgxfwR/FbWiZTDFbkPWd9KNQT0y0l9VIw
	 0g+u0RrSXb4K7pQPL7G1Q6HoTuN2yNDP1ukNH3bk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Jeffery <djeffery@redhat.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 100/675] scsi: core: wake eh reliably when using scsi_schedule_eh
Date: Thu, 30 Jul 2026 16:07:10 +0200
Message-ID: <20260730141447.259166342@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Jeffery <djeffery@redhat.com>

[ Upstream commit dccf3b1798b70f94e958b3d00b83010399e6fb05 ]

Drivers which use the scsi_schedule_eh function to run the error handler
currently risk the error handler thread never waking once all commands are
timed out or inactive. There is no enforced memory order between setting
the host into error recovery state and counting busy commands. This can
result in a race with scsi_dec_host_busy where neither CPU sees both
conditions of all commands inactive and the host error state to request
waking the error handler.

To fix this, run the scsi_schedule_eh's scsi_eh_wakeup from a new work item
which will use rcu to ensure scsi_schedule_eh's call to scsi_host_busy will
occur after the error state is globally visible and will be seen by any
current scsi_dec_host_busy callers.

Fixes: 6eb045e092ef ("scsi: core: avoid host-wide host_busy counter for scsi_mq")
Signed-off-by: David Jeffery <djeffery@redhat.com>
Link: https://patch.msgid.link/20260615174630.11492-1-djeffery@redhat.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/hosts.c      |  2 ++
 drivers/scsi/scsi_error.c | 22 +++++++++++++++++++++-
 drivers/scsi/scsi_priv.h  |  1 +
 include/scsi/scsi_host.h  |  3 +++
 4 files changed, 27 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 17173239301e61..a1055fe4922f64 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -343,6 +343,7 @@ static void scsi_host_dev_release(struct device *dev)
 	/* Wait for functions invoked through call_rcu(&scmd->rcu, ...) */
 	rcu_barrier();
 
+	cancel_work_sync(&shost->eh_work);
 	if (shost->tmf_work_q)
 		destroy_workqueue(shost->tmf_work_q);
 	if (shost->ehandler)
@@ -408,6 +409,7 @@ struct Scsi_Host *scsi_host_alloc(const struct scsi_host_template *sht, int priv
 	INIT_LIST_HEAD(&shost->starved_list);
 	init_waitqueue_head(&shost->host_wait);
 	mutex_init(&shost->scan_mutex);
+	INIT_WORK(&shost->eh_work, scsi_rcu_eh_wakeup);
 
 	index = ida_alloc(&host_index_ida, GFP_KERNEL);
 	if (index < 0) {
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 2fd4ca96b3089d..13d46b6e0359e2 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -73,6 +73,26 @@ void scsi_eh_wakeup(struct Scsi_Host *shost, unsigned int busy)
 	}
 }
 
+void scsi_rcu_eh_wakeup(struct work_struct *work)
+{
+	struct Scsi_Host *shost = container_of(work, struct Scsi_Host, eh_work);
+	unsigned long flags;
+	unsigned int busy;
+
+	/*
+	 * Ensure any running scsi_dec_host_busy has completed its rcu section
+	 * so changes to host state and host_eh_scheduled are visible to all
+	 * future calls of scsi_dec_host_busy
+	 */
+	synchronize_rcu();
+
+	busy = scsi_host_busy(shost);
+
+	spin_lock_irqsave(shost->host_lock, flags);
+	scsi_eh_wakeup(shost, busy);
+	spin_unlock_irqrestore(shost->host_lock, flags);
+}
+
 /**
  * scsi_schedule_eh - schedule EH for SCSI host
  * @shost:	SCSI host to invoke error handling on.
@@ -88,7 +108,7 @@ void scsi_schedule_eh(struct Scsi_Host *shost)
 	if (scsi_host_set_state(shost, SHOST_RECOVERY) == 0 ||
 	    scsi_host_set_state(shost, SHOST_CANCEL_RECOVERY) == 0) {
 		shost->host_eh_scheduled++;
-		scsi_eh_wakeup(shost, scsi_host_busy(shost));
+		queue_work(shost->tmf_work_q, &shost->eh_work);
 	}
 
 	spin_unlock_irqrestore(shost->host_lock, flags);
diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index 5b2b19f5e8ec8a..68866b18a60058 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -91,6 +91,7 @@ extern enum blk_eh_timer_return scsi_timeout(struct request *req);
 extern int scsi_error_handler(void *host);
 extern enum scsi_disposition scsi_decide_disposition(struct scsi_cmnd *cmd);
 extern void scsi_eh_wakeup(struct Scsi_Host *shost, unsigned int busy);
+extern void scsi_rcu_eh_wakeup(struct work_struct *work);
 extern void scsi_eh_scmd_add(struct scsi_cmnd *);
 void scsi_eh_ready_devs(struct Scsi_Host *shost,
 			struct list_head *work_q,
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index f5a24326123605..936403c15e53d3 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -714,6 +714,9 @@ struct Scsi_Host {
 	 */
 	struct device *dma_dev;
 
+	/* Used for an rcu-synchronizing eh wakeup */
+	struct work_struct eh_work;
+
 	/* Delay for runtime autosuspend */
 	int rpm_autosuspend_delay;
 
-- 
2.53.0



