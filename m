Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5764344C518;
	Thu, 30 Jul 2026 15:31:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425487; cv=none; b=aUs9fXxOWXZQkJ0n6b2jATItqJXKDhWZ/BG6hBMyZk7pSeUrcKC3mZNNYrJ0YCqgP1UZAd/6bL13ZvUg7dBB/hbqvfsws/CtNWDyuGWfFMsX8hvAiqAnhyoVqVHp3DVG6LgWyaLel3e01jWlcowGl4KdGevIeR1DmCJEARip/nQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425487; c=relaxed/simple;
	bh=M9oG/q5oR0koDWlWvMfB2YHkNYjNxHOfE62/PQCXpJs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o4AlUpchh0fdX2+cU/he/EU2He2JoqDm4YqcpmHJthyAkDXHV9MRsE6n+Ia2vQcwYM3b9yDLQOpXAlE1PzKCoPsAXNYEXBRCvRxyGjj3Kd4ZBmheKNSgSP4Dbe4h36cf/ngglvBqRf7cDzoFCBjfTQ5s280onrY1z2Saj3U1IAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PjBmbZba; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PjBmbZba"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1EFA1F00A3D;
	Thu, 30 Jul 2026 15:31:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425486;
	bh=KA6asVmInoroGS/0ret1n2ibyq1GRt0nazcy/wsDF3c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PjBmbZbajf+eFZKKBoIs9A1hn8WISBLihUb90/rYPtZDOeJKR0Xi9sXf2N1X4zbWa
	 RPK5f2VvhQoNOGyA3ijxmdyTOk7c3oMIVL3nFtsKN7DhQlVOCVUwZ/PAeyb6d6rHj3
	 qR8abUjw7OyxKMCA36SxVjYYYGJI4bbPIyHsRTHA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Jeffery <djeffery@redhat.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 084/602] scsi: core: wake eh reliably when using scsi_schedule_eh
Date: Thu, 30 Jul 2026 16:07:56 +0200
Message-ID: <20260730141437.761819524@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 5cf13d019a15e9..e617b98ce84cf2 100644
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
index 9a89a94784cd0c..03fadefa1cee8e 100644
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
index 9fc397a9ce7a4f..7238d53883be76 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -93,6 +93,7 @@ extern enum blk_eh_timer_return scsi_timeout(struct request *req);
 extern int scsi_error_handler(void *host);
 extern enum scsi_disposition scsi_decide_disposition(struct scsi_cmnd *cmd);
 extern void scsi_eh_wakeup(struct Scsi_Host *shost, unsigned int busy);
+extern void scsi_rcu_eh_wakeup(struct work_struct *work);
 extern void scsi_eh_scmd_add(struct scsi_cmnd *);
 void scsi_eh_ready_devs(struct Scsi_Host *shost,
 			struct list_head *work_q,
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 2b4ab0369ffbe9..990747f803feff 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -718,6 +718,9 @@ struct Scsi_Host {
 	 */
 	struct device *dma_dev;
 
+	/* Used for an rcu-synchronizing eh wakeup */
+	struct work_struct eh_work;
+
 	/* Delay for runtime autosuspend */
 	int rpm_autosuspend_delay;
 
-- 
2.53.0



