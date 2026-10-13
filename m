Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A37514DDB5A;
	Tue, 13 Oct 2026 11:48:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892136; cv=none; b=D3w0IzmuwNPEVyTxcLeMCjT6QGfQlc4v0aYxjMNAAXuyIN1tC//s7ciHSSSQ8rbAn1dp8sWNvocFdAZ7iY60FHbMEEwWV3bxPawvXLAlUU9gPUEp9LUe2xOzmZU5R4Drp0YV24lxO2tnK/CI6APqTk3AmIYB2EA9l+LCY+uaHr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892136; c=relaxed/simple;
	bh=vlWg1YXC8naLHo8VQwD1G9g+zHdwIED7VHiLYUKM0Bs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WrZ62TL/fiXF+HH0E8uxFqeZYZY/f/h/fhg7r93NG8WbgUPaNGbbURHSMYK0H+PajOa6bT5lFVTwzEQrC25UA/hw8JPqA/Vx9ICbIthQovnqMbuDVmNE6bZTYK+Q/dVB7AaSN/8s7mQ3BzPD+t1btXg5XSzHe8u9K9v7rYCxr30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m+TfHTy4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m+TfHTy4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E756C1F000FF;
	Tue, 13 Oct 2026 11:48:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892135;
	bh=BRnRI+gl6y945/OY46xyZTnc1r8RWOAb4aH7ZPt8bss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m+TfHTy4jPyxaqZjly5QF03HirOqKh7SqZ40ty9GabzuW34WFZCRha+wfzc4jutjW
	 A9w0bP4GuX7LdXi8bH08fW2W+Kfh8VTOKerAxobyhAOReQFA4P3xUVgBkYKMfdJ98j
	 Q/B8Vd+HGRt1knDXgNXMr7PR3zFXJiuJ/o1JULPo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 7.2 070/281] memstick: rtsx_usb_ms: complete requests after eject instead of dropping them
Date: Tue, 13 Oct 2026 13:36:26 +0200
Message-ID: <20261013112856.830146185@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>

commit c96ca94425b076dc398d929366e378d1e22ec794 upstream.

memstick_check() can pass its host->removing check just before
rtsx_usb_ms_drv_remove() sets eject/removing. Its next request is then
silently dropped: rtsx_usb_ms_request() skips schedule_work() once eject
is set, and drv_remove's cancel_work_sync() can also cancel a queued
handle_req before it picks the request up. Nobody completes
card->mrq_complete.

Once memstick core waits for requests without a timeout ("memstick: core:
wait for request completion before freeing card"), this hangs removal:
memstick_check() never returns and memstick_remove_host() blocks in
flush_workqueue():

  INFO: task kworker/u10:3:65 blocked for more than 20 seconds.
  Workqueue: kmemstick memstick_check
   __wait_for_common
   memstick_check

  INFO: task kworker/1:1:33 blocked for more than 20 seconds.
  Workqueue: usb_hub_wq hub_event
   __flush_workqueue
   memstick_remove_host
   rtsx_usb_ms_drv_remove

Never drop a request. rtsx_usb_ms_request() always schedules handle_req,
and handle_req fails requests with -ENOMEDIUM once eject is set, without
touching the device. drv_remove flushes handle_req instead of cancelling
it, and cancels it only after memstick_remove_host(), when no new
request can arrive, so it cannot run on a freed host.

The host_mutex drain in drv_remove is removed: handle_req always leaves
host->req NULL when it finishes, so the drain never had anything to do,
and it would now race with handle_req.

Fixes: 99451dceeb5f ("memstick: Add realtek USB memstick host driver")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/all/20260924204142.607-1-rajojha047@gmail.com/
Signed-off-by: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/memstick/host/rtsx_usb_ms.c |   31 +++++++++++--------------------
 1 file changed, 11 insertions(+), 20 deletions(-)

--- a/drivers/memstick/host/rtsx_usb_ms.c
+++ b/drivers/memstick/host/rtsx_usb_ms.c
@@ -27,7 +27,6 @@ struct rtsx_usb_ms {
 	struct memstick_host	*msh;
 	struct memstick_request	*req;
 
-	struct mutex		host_mutex;
 	struct work_struct	handle_req;
 	struct delayed_work	poll_card;
 
@@ -514,6 +513,13 @@ static void rtsx_usb_ms_handle_req(struc
 	struct memstick_host *msh = host->msh;
 	int rc;
 
+	/* Fail requests after eject so their waiters are released. */
+	if (host->eject) {
+		while (!memstick_next_req(msh, &host->req))
+			host->req->error = -ENOMEDIUM;
+		return;
+	}
+
 	if (!host->req) {
 		pm_runtime_get_sync(ms_dev(host));
 		do {
@@ -547,8 +553,7 @@ static void rtsx_usb_ms_request(struct m
 
 	dev_dbg(ms_dev(host), "--> %s\n", __func__);
 
-	if (!host->eject)
-		schedule_work(&host->handle_req);
+	schedule_work(&host->handle_req);
 }
 
 static int rtsx_usb_ms_set_param(struct memstick_host *msh,
@@ -781,7 +786,6 @@ static int rtsx_usb_ms_drv_probe(struct
 	host->power_mode = MEMSTICK_POWER_OFF;
 	platform_set_drvdata(pdev, host);
 
-	mutex_init(&host->host_mutex);
 	INIT_WORK(&host->handle_req, rtsx_usb_ms_handle_req);
 
 	INIT_DELAYED_WORK(&host->poll_card, rtsx_usb_ms_poll_card);
@@ -812,27 +816,12 @@ static void rtsx_usb_ms_drv_remove(struc
 {
 	struct rtsx_usb_ms *host = platform_get_drvdata(pdev);
 	struct memstick_host *msh = host->msh;
-	int err;
 
 	host->eject = true;
 	msh->removing = true;
-	cancel_work_sync(&host->handle_req);
+	flush_work(&host->handle_req);
 	cancel_delayed_work_sync(&host->poll_card);
 
-	mutex_lock(&host->host_mutex);
-	if (host->req) {
-		dev_dbg(ms_dev(host),
-			"%s: Controller removed during transfer\n",
-			dev_name(&msh->dev));
-		host->req->error = -ENOMEDIUM;
-		do {
-			err = memstick_next_req(msh, &host->req);
-			if (!err)
-				host->req->error = -ENOMEDIUM;
-		} while (!err);
-	}
-	mutex_unlock(&host->host_mutex);
-
 	/* Balance possible unbalanced usage count
 	 * e.g. unconditional module removal
 	 */
@@ -841,6 +830,8 @@ static void rtsx_usb_ms_drv_remove(struc
 
 	pm_runtime_disable(ms_dev(host));
 	memstick_remove_host(msh);
+	/* No card, no new requests; wait for the last failed one to finish. */
+	cancel_work_sync(&host->handle_req);
 	dev_dbg(ms_dev(host),
 		": Realtek USB Memstick controller has been removed\n");
 	memstick_free_host(msh);


