Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E489B4E2F2A;
	Tue, 13 Oct 2026 12:18:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893940; cv=none; b=WFu5+PVf7eEcWXMdV4J0fFnLZbcLRgpFy6gbdyWzniI77RzpDUmr7xapQ31OnFDyfNbh46VPPHyzshyBLZeZ4PFRk+5yEimkRrIYt7McAMv46bHRW7oHA1ZcMCvJsoQyEFGswhs7b/OKDypvBCCcMrBPU74M3h/FfVTJ4ujInIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893940; c=relaxed/simple;
	bh=IzMkBKtgvuxhAP7xTM4wnCBfcBZfdatQmyH3qwRv7OI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U8GJSKxYcAFNVG/2BPiLgXs+I4X7MU0LZvu01MGFwshLP/xaENNaxMofImiie8auHEonIkku7XN7weKqIFbNdzv3ANcxrpJZCnPMgM9UXEQIlxMVGjpRPI0qLcs11Tc8nA7RXHxMwvjyfYe5Y60bbrqQiRUZOGg+iTXxyeykBaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MdStXNQN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MdStXNQN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C1C31F000FF;
	Tue, 13 Oct 2026 12:18:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893938;
	bh=We8C4fYQz7WQ6qqp6aFjhoLWiPs66/CefhrOj11h5XA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MdStXNQNPuuM5jtYlh+4dJ4WPwN9zq75XDbkf3oWkF/aTZMuWhf1a7sDYYyf2vT7m
	 hzlvcPsZ1bWxPcfDbR7RydnjWKXu/qyv4qIn0ICb9UvYvMiKv2QbmFbAWHnAP8i8Xq
	 11fvHQBmHX99YLsCKwW0wmE7NtNO5a1aSoNFyww4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongjie Fang <hongjiefang@asrmicro.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Peter Wang <peter.wang@mediatek.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 350/621] scsi: core: pair EH runtime PM get and put
Date: Tue, 13 Oct 2026 13:35:45 +0200
Message-ID: <20261013112929.157634948@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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
index 857c2acc99645..39870ae748905 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -2358,6 +2358,7 @@ static void scsi_unjam_host(struct Scsi_Host *shost)
 int scsi_error_handler(void *data)
 {
 	struct Scsi_Host *shost = data;
+	bool eh_noresume;
 
 	/*
 	 * We use TASK_INTERRUPTIBLE so that the thread is not
@@ -2399,7 +2400,8 @@ int scsi_error_handler(void *data)
 		 * what we need to do to get it up and online again (if we can).
 		 * If we fail, we end up taking the thing offline.
 		 */
-		if (!shost->eh_noresume && scsi_autopm_get_host(shost) != 0) {
+		eh_noresume = READ_ONCE(shost->eh_noresume);
+		if (!eh_noresume && scsi_autopm_get_host(shost) != 0) {
 			SCSI_LOG_ERROR_RECOVERY(1,
 				shost_printk(KERN_ERR, shost,
 					     "scsi_eh_%d: unable to autoresume\n",
@@ -2423,7 +2425,7 @@ int scsi_error_handler(void *data)
 		 * which are still online.
 		 */
 		scsi_restart_operations(shost);
-		if (!shost->eh_noresume)
+		if (!eh_noresume)
 			scsi_autopm_put_host(shost);
 	}
 	__set_current_state(TASK_RUNNING);
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 87578e8824d2d..f0c7a8d7477c4 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -9637,7 +9637,7 @@ static int ufshcd_set_dev_pwr_mode(struct ufs_hba *hba,
 	 * we are functional while we are here, skip host resume in error
 	 * handling context.
 	 */
-	hba->host->eh_noresume = 1;
+	WRITE_ONCE(hba->host->eh_noresume, 1);
 
 	/*
 	 * Current function would be generally called from the power management
@@ -9659,7 +9659,7 @@ static int ufshcd_set_dev_pwr_mode(struct ufs_hba *hba,
 	}
 
 	scsi_device_put(sdp);
-	hba->host->eh_noresume = 0;
+	WRITE_ONCE(hba->host->eh_noresume, 0);
 	return ret;
 }
 
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 936403c15e53d..c02e2d42297c4 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -631,6 +631,10 @@ struct Scsi_Host {
 	 */
 	unsigned nr_hw_queues;
 	unsigned nr_maps;
+
+	/* Don't resume host in EH */
+	bool eh_noresume;
+
 	unsigned active_mode:2;
 
 	/*
@@ -652,9 +656,6 @@ struct Scsi_Host {
 	/* Asynchronous scan in progress */
 	unsigned async_scan:1;
 
-	/* Don't resume host in EH */
-	unsigned eh_noresume:1;
-
 	/* The controller does not support WRITE SAME */
 	unsigned no_write_same:1;
 
-- 
2.53.0



