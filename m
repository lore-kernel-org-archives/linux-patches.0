Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92BBE377016;
	Thu, 20 Aug 2026 15:08:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238523; cv=none; b=eJlD61uKTFfGSgZXO6RztjrMaXLnqeqHyEbTiud+yu6/E6q+WHVRDk5IajHZn52IpxTe1UMEVCpKVdynobANBx2Pr1qZ+mXeIMRSu6tps/N6f94CKDMnFzFoMlxj9KrV1lvSWv/8LzYSwIak2/xyg1QqSLsnA0eKu+bd8E1wigg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238523; c=relaxed/simple;
	bh=1mcVI4N0sbINbNVz72LlTIuqCQKqKcCUvGPhimvGmIA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JEfn5OLOafJSXyQWP6v9oVhodDnjzdECfCJV9gTiH+QCVqiblJvAd1ca34XTPiQEvyZJpoEpCo90uplDHcA9k6jWBJefT9qnkFv/EAEQ1NLIUggoh+SLgrFZm8WWXUSHkrUgXKLg77UPOe8WRRK/DrzlEVQJ+PRxSNdwBjqTyXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=14PIDrnI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="14PIDrnI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 984041F000E9;
	Thu, 20 Aug 2026 15:08:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238522;
	bh=zwgRJlOVdEjz4rCGQz9NJgcVmctc1w9K1DZM395WACY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=14PIDrnIDXhQ1O4QfrRNkL+j26WdFSrnrpnwCrmKpVBFrS++DWg/FeEDIrp4lDGkY
	 VKvrJl+7jS4mycOmripgFJQ2pOmfJ667+PFg5aHW4bksy2XHhOVI/i4ciRug1WdgQr
	 lkC2EVFSIRe76osnJLFEak56sBJPOlbkGJOd54/g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongjie Fang <hongjiefang@asrmicro.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Peter Wang <peter.wang@mediatek.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 176/228] scsi: core: pair EH runtime PM get and put
Date: Thu, 20 Aug 2026 16:55:18 +0200
Message-ID: <20260820145250.038111857@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145244.450574346@linuxfoundation.org>
References: <20260820145244.450574346@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hongjie Fang <hongjiefang@asrmicro.com>

[ Upstream commit 872f486259ae0bc6b73ca4735a15d013241f73e9 ]

shost->eh_noresume is currently consulted twice in one error handling
iteration: once before scsi_autopm_get_host() and once again before
scsi_autopm_put_host().

That is racy when a PM-triggered error path flips shost->eh_noresume
while the SCSI EH thread is still running.

The problem flow looks like this:
PM path
  ufshcd_set_dev_pwr_mode()
    shost->eh_noresume = 1
    ufshcd_execute_start_stop  <-- trigger EH
    ...
    shost->eh_noresume = 0

EH path
  scsi_error_handler()
    if (!shost->eh_noresume)
      scsi_autopm_get_host()  <-- skipped
    ...
    if (!shost->eh_noresume)
       scsi_autopm_put_host()  <-- executed later

In that case one EH iteration can skip autoresume on entry and still
drop a runtime PM reference on exit. That leaves an unmatched runtime PM
put and can trigger a runtime PM usage count underflow.

Fix this by making eh_noresume a regular bool so it can be accessed with
READ_ONCE() and WRITE_ONCE(). Snapshot it once per EH iteration and use
that snapshot for both runtime PM get and put decisions.

Fixes: ae0751ffc77e ("[SCSI] add flag to skip the runtime PM calls on the host")
Signed-off-by: Hongjie Fang <hongjiefang@asrmicro.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Link: https://patch.msgid.link/20260729111614.2407559-1-hongjiefang@asrmicro.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_error.c | 6 ++++--
 drivers/ufs/core/ufshcd.c | 4 ++--
 include/scsi/scsi_host.h  | 6 +++---
 3 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 453a2232452db..74b70801269bd 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -2362,6 +2362,7 @@ static void scsi_unjam_host(struct Scsi_Host *shost)
 int scsi_error_handler(void *data)
 {
 	struct Scsi_Host *shost = data;
+	bool eh_noresume;
 
 	/*
 	 * We use TASK_INTERRUPTIBLE so that the thread is not
@@ -2403,7 +2404,8 @@ int scsi_error_handler(void *data)
 		 * what we need to do to get it up and online again (if we can).
 		 * If we fail, we end up taking the thing offline.
 		 */
-		if (!shost->eh_noresume && scsi_autopm_get_host(shost) != 0) {
+		eh_noresume = READ_ONCE(shost->eh_noresume);
+		if (!eh_noresume && scsi_autopm_get_host(shost) != 0) {
 			SCSI_LOG_ERROR_RECOVERY(1,
 				shost_printk(KERN_ERR, shost,
 					     "scsi_eh_%d: unable to autoresume\n",
@@ -2427,7 +2429,7 @@ int scsi_error_handler(void *data)
 		 * which are still online.
 		 */
 		scsi_restart_operations(shost);
-		if (!shost->eh_noresume)
+		if (!eh_noresume)
 			scsi_autopm_put_host(shost);
 	}
 	__set_current_state(TASK_RUNNING);
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index d6444b3c2ef16..4abeb77c3a0fa 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -9985,7 +9985,7 @@ static int ufshcd_set_dev_pwr_mode(struct ufs_hba *hba,
 	 * we are functional while we are here, skip host resume in error
 	 * handling context.
 	 */
-	hba->host->eh_noresume = 1;
+	WRITE_ONCE(hba->host->eh_noresume, 1);
 
 	/*
 	 * Current function would be generally called from the power management
@@ -10007,7 +10007,7 @@ static int ufshcd_set_dev_pwr_mode(struct ufs_hba *hba,
 	}
 
 	scsi_device_put(sdp);
-	hba->host->eh_noresume = 0;
+	WRITE_ONCE(hba->host->eh_noresume, 0);
 	return ret;
 }
 
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index f6b286fa59f21..98b0ccf0813ea 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -664,6 +664,9 @@ struct Scsi_Host {
 	/* Asynchronous scan in progress */
 	bool async_scan __guarded_by(&scan_mutex);
 
+	/* Don't resume host in EH */
+	bool eh_noresume;
+
 	unsigned active_mode:2;
 
 	/*
@@ -682,9 +685,6 @@ struct Scsi_Host {
 	/* Task mgmt function in progress */
 	unsigned tmf_in_progress:1;
 
-	/* Don't resume host in EH */
-	unsigned eh_noresume:1;
-
 	/* The controller does not support WRITE SAME */
 	unsigned no_write_same:1;
 
-- 
2.53.0



