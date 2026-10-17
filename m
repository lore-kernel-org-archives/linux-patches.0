Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23AA838424C;
	Sat, 17 Oct 2026 17:50:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259430; cv=none; b=c1wjAO/N7ovyEr9k9khc0Dv8fyE7G8Bb8MOmr3vccnpoyiDyiAhItNZop8foOHjkI5HF+19HCXo/I2Z/329FwCWhVqqmghYWkwzznpJihr5kEW12bnVoRu69n6+e4zlPx6Jp0D4hQr+tjwf6V7X0EEwYAzsD7iu6MDD3fBr7z2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259430; c=relaxed/simple;
	bh=Q4FQzsb5oL8NsuqZryce18aTX3Wn4nTPMuPABVDzxGY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i/GXkm8FgoAnFIi6Fvq4Mi9WcWz/599t8iTx6Yo9dgCWOcP2wa558fgwQ6N0UX79faau5hKG+NkgQ2Wtk89B/7ZnvZVTaFcGFxwimREY7e4/phy2xoWg6jzIs4zEL3mD/1IUfOaqi0Epg/OZMs+J8VefSTO2diYYnvxCwybgoNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yS+q7zy+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yS+q7zy+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C5911F000C6;
	Sat, 17 Oct 2026 17:50:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259428;
	bh=3tj65XUOy9jA+JNLWJeC/Jl0efXtCJMlUux44N2bk0A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yS+q7zy+1AtYZ4vEFTbTTYnv6sADbIeJe2kmn619oCSDKQL2KzJbDhKAboVQJIqEN
	 IFd1cvV4aXa5STKHvpMag3JWAC4t3pCZcxB0jJnE9JLkrCIxmzeJWMJHie6o9Hq6ll
	 kAS228vX6GtWfBjWmMdmhWCzNuTGlvqBzNnM/ZKo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongjie Fang <hongjiefang@asrmicro.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Peter Wang <peter.wang@mediatek.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1211/1674] scsi: core: pair EH runtime PM get and put
Date: Sat, 17 Oct 2026 17:58:03 +0200
Message-ID: <20261017160502.221840825@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 include/scsi/scsi_host.h  | 7 ++++---
 3 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 912adc325e255..e7c9764152e9b 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -2337,6 +2337,7 @@ static void scsi_unjam_host(struct Scsi_Host *shost)
 int scsi_error_handler(void *data)
 {
 	struct Scsi_Host *shost = data;
+	bool eh_noresume;
 
 	/*
 	 * We use TASK_INTERRUPTIBLE so that the thread is not
@@ -2378,7 +2379,8 @@ int scsi_error_handler(void *data)
 		 * what we need to do to get it up and online again (if we can).
 		 * If we fail, we end up taking the thing offline.
 		 */
-		if (!shost->eh_noresume && scsi_autopm_get_host(shost) != 0) {
+		eh_noresume = READ_ONCE(shost->eh_noresume);
+		if (!eh_noresume && scsi_autopm_get_host(shost) != 0) {
 			SCSI_LOG_ERROR_RECOVERY(1,
 				shost_printk(KERN_ERR, shost,
 					     "scsi_eh_%d: unable to autoresume\n",
@@ -2402,7 +2404,7 @@ int scsi_error_handler(void *data)
 		 * which are still online.
 		 */
 		scsi_restart_operations(shost);
-		if (!shost->eh_noresume)
+		if (!eh_noresume)
 			scsi_autopm_put_host(shost);
 	}
 	__set_current_state(TASK_RUNNING);
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 5e42772095ce1..60fdec1eab193 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -9614,7 +9614,7 @@ static int ufshcd_set_dev_pwr_mode(struct ufs_hba *hba,
 	 * we are functional while we are here, skip host resume in error
 	 * handling context.
 	 */
-	hba->host->eh_noresume = 1;
+	WRITE_ONCE(hba->host->eh_noresume, 1);
 
 	/*
 	 * Current function would be generally called from the power management
@@ -9644,7 +9644,7 @@ static int ufshcd_set_dev_pwr_mode(struct ufs_hba *hba,
 	}
 
 	scsi_device_put(sdp);
-	hba->host->eh_noresume = 0;
+	WRITE_ONCE(hba->host->eh_noresume, 0);
 	return ret;
 }
 
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 21ef487f0eede..8a3ea67a6af16 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -626,6 +626,10 @@ struct Scsi_Host {
 	 */
 	unsigned nr_hw_queues;
 	unsigned nr_maps;
+
+	/* Don't resume host in EH */
+	bool eh_noresume;
+
 	unsigned active_mode:2;
 
 	/*
@@ -647,9 +651,6 @@ struct Scsi_Host {
 	/* Asynchronous scan in progress */
 	unsigned async_scan:1;
 
-	/* Don't resume host in EH */
-	unsigned eh_noresume:1;
-
 	/* The controller does not support WRITE SAME */
 	unsigned no_write_same:1;
 
-- 
2.53.0



