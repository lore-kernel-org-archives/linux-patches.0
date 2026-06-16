Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DCBB36E47E;
	Tue, 16 Jun 2026 17:10:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781629830; cv=none; b=ASgR4reg5nhqIvQu/5J76KM7wn1/BnvibhO/4OJ7VDkvHsNE7u2CrvHrWGi2iP7Jo0hckd+c6Kgk7xzogvpgRYmyg2/IN88QR+Lrcel+kmO0VNh6QZrP6LKevDUn7Hfs8/9oIO3KqEt3cTuT+8a66vO3MOSXISIgmzRTNaPTLyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781629830; c=relaxed/simple;
	bh=RTX4U71STQmVwiFVRdxn9dk8DftV30HipESGs4DKWDs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SI/1b8MEdpY2mgd27vGO0NQK7NfD3VJ+kNXEMOGswjCoI56mlG/Wxr1xpkHTgmvuifoo0m53JwhiBXs8qqpoLRDRJfUcogFCTFl78wFqmHn7Q0EChktaxndWq4GXwR5fJ1vf7aenY1jvp3QFGClhilrwDL44IPchlP0176xLTps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2tQ5ngZC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2tQ5ngZC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B12E51F000E9;
	Tue, 16 Jun 2026 17:10:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781629829;
	bh=rUlaUZvQKKp9ZBmnkrmn4vm/p31GFZhg1TeFhj5iI/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2tQ5ngZCp77dGmYwY09bGD9v9eWQ922iUriXzWfui3CUQ3OSUJlV3TeAmS5pyJu0f
	 YWVwdZjCohHdMZ4EIxhJDfLd9UI2q27hXisrSXBUk3zBlm/hGAETSMi4Xo4LEoUyI1
	 pXjgblz+Wnc3a+5QmCOIF2SfHx3n8imrm8kwUnx8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>,
	Srinivas Kandagatla <srini@kernel.org>
Subject: [PATCH 6.6 360/452] slimbus: qcom-ngd-ctrl: Avoid ABBA on tx_lock/ctrl->lock
Date: Tue, 16 Jun 2026 20:29:47 +0530
Message-ID: <20260616145136.027966247@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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
@@ -1469,15 +1469,12 @@ static int qcom_slim_ngd_ssr_pdr_notify(
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


