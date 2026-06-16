Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 554892F12AE;
	Tue, 16 Jun 2026 17:46:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781631968; cv=none; b=r/8Vr8MlyCnQtabIcLgtkZapR91H6ZN6acKMNtVY5iUX8AkukjbRke8qtESr11ywsfFqA60gglocGFQqhUbF4QnnwK2DKf39w3EkucLqrHu+QwcsgYJYTBpQ5YUZpxZwkaJHOa8M1k3yFu+L7N/WoJh82pqTc/WsXOUA/Yt7M6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781631968; c=relaxed/simple;
	bh=YTLisOWibQMV/+f1pqVzxugSUzrRKHW7W0rL9VLbAp8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VzMNMDhwlUuXPJBuOIGjM9P2RytLx8j3f2qPQ5NW8SF7GpOlQJX2L85/LlmsqZIdmp7cojjVvKYbn4LBG8ZzC9Z506y0pdRAhBNtzsSphx0tIsPONJ429GFYLgyoNzFWtKJDaQ8jK8YbzzPCkT6x+TAthXyq1KAxM+2UyQXilx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g4S3dnNh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g4S3dnNh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AF3D1F000E9;
	Tue, 16 Jun 2026 17:46:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781631967;
	bh=WMNKfNX4ExS6bDdSw5R2yFdNVfEr7GqQEViC5KO8kqU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g4S3dnNh8gFmVc7CtTpY0R0jOSwHHZfBnndECxXQ3BQ2DTrSNs6PTnrLHQMRaIiu7
	 KThFsH12nbJBxM0l86/A7YGUeVnUU6iuE+SF0uKijmnzfYdqWYjXF7BNXUiB6zu7no
	 UItcxTknt+iBopS4haXL7egjDiY2mP9cwLXLfSfE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>,
	Srinivas Kandagatla <srini@kernel.org>
Subject: [PATCH 6.1 321/522] slimbus: qcom-ngd-ctrl: Avoid ABBA on tx_lock/ctrl->lock
Date: Tue, 16 Jun 2026 20:27:48 +0530
Message-ID: <20260616145140.869979826@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>

commit 55f2ea9ff83cc27a85526b14bc9b32f96a08d6ec upstream.

During the SSR/PDR down notification the tx_lock is taken with the
intent to provide synchronization with active DMA transfers.

But during this period qcom_slim_ngd_down() is invoked, which ends up in
slim_report_absent(), which takes the slim_controller lock. In multiple
other codepaths these two locks are taken in the opposite order (i.e.
slim_controller then tx_lock).

The result is a lockdep splat, and a possible deadlock:

  rprocctl/449 is trying to acquire lock:
  ffff00009793e620 (&ctrl->lock){+.+.}-{4:4}, at: slim_report_absent (drivers/slimbus/core.c:322) slimbus

  but task is already holding lock:
  ffff00009793fb50 (&ctrl->tx_lock){+.+.}-{4:4}, at: qcom_slim_ngd_ssr_pdr_notify (drivers/slimbus/qcom-ngd-ctrl.c:1475) slim_qcom_ngd_ctrl

  which lock already depends on the new lock.

  Possible unsafe locking scenario:

        CPU0                    CPU1
        ----                    ----
   lock(&ctrl->tx_lock);
                                lock(&ctrl->lock);
                                lock(&ctrl->tx_lock);
   lock(&ctrl->lock);

The assumption is that the comment refers to the desire to not call
qcom_slim_ngd_exit_dma() while we have an ongoing DMA TX transaction.
But any such transaction is initiated and completed within a single
qcom_slim_ngd_xfer_msg().

Prior to calling qcom_slim_ngd_exit_dma() the slim_controller is torn
down, all child devices are notified that the slimbus is gone and the
child devices are removed.

Stop taking the tx_lock in qcom_slim_ngd_ssr_pdr_notify() to avoid the
deadlock.

Fixes: a899d324863a ("slimbus: qcom-ngd-ctrl: add Sub System Restart support")
Cc: stable@vger.kernel.org
Signed-off-by: Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>
Signed-off-by: Srinivas Kandagatla <srini@kernel.org>
Link: https://patch.msgid.link/20260530204421.116824-9-srini@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/slimbus/qcom-ngd-ctrl.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/drivers/slimbus/qcom-ngd-ctrl.c
+++ b/drivers/slimbus/qcom-ngd-ctrl.c
@@ -1394,15 +1394,12 @@ static int qcom_slim_ngd_ssr_pdr_notify(
 	switch (action) {
 	case QCOM_SSR_BEFORE_SHUTDOWN:
 	case SERVREG_SERVICE_STATE_DOWN:
-		/* Make sure the last dma xfer is finished */
-		mutex_lock(&ctrl->tx_lock);
 		if (ctrl->state != QCOM_SLIM_NGD_CTRL_DOWN) {
 			pm_runtime_get_noresume(ctrl->ctrl.dev);
 			ctrl->state = QCOM_SLIM_NGD_CTRL_DOWN;
 			qcom_slim_ngd_down(ctrl);
 			qcom_slim_ngd_exit_dma(ctrl);
 		}
-		mutex_unlock(&ctrl->tx_lock);
 		break;
 	case QCOM_SSR_AFTER_POWERUP:
 	case SERVREG_SERVICE_STATE_UP:


