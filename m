Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCCE14315A;
	Sun,  7 Sep 2025 20:41:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277704; cv=none; b=Bzi500h752jQS2XOc3ZaoRcVntpctAmmhWpDDLrb13AKIl7f8UIHC9vz5tTuu2xC/97GW1Lw9hM0lFS6AGF5YjHJvA7428BgQ63hXYiGPBkVdVjZkqf9zZbncc2tUTdryyob/oFzopy+czxGZoDaRb4Rhjt1dWrV7CpAm/CWOlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277704; c=relaxed/simple;
	bh=HD+HbMS3IrWZeQIO9KmJ9uRcikiM1Y0h2rtstT0uH5k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BXj8gfZvF5Ls73KgF2yNGU3CZjgXrulT82asJxtRtmSB8bN5OB+dnMYPAOzujH3Uw8b0EHsuyVMPnmD0uiWgCM3jtwmT2N/PBIDmid/QdakA3vCgZeHKcOlYOncTiDlLE0UGvKJXNCw1Lu44NTzhXnYXCEn6cj4dlKV4iMiOVBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aWq3JY8/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aWq3JY8/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65FDDC4CEF0;
	Sun,  7 Sep 2025 20:41:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277703;
	bh=HD+HbMS3IrWZeQIO9KmJ9uRcikiM1Y0h2rtstT0uH5k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aWq3JY8/gHhnXSK7t0k1Pd3llsACmv8+2Ql/twOh4Vn4TGhidsrn1nnmnt1yXnZG2
	 us1/HIKY49U0asOvGTeF8PCinzavPgq6KpijYIYuSPpiIHMkT1AjxYg8e1rv8oLYgf
	 tXayNWKT0lLHYqBKyw+Q1a5pJgii/c3ZakOlm8/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karol Wachowski <karol.wachowski@intel.com>,
	Lizhi Hou <lizhi.hou@amd.com>,
	Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
Subject: [PATCH 6.16 097/183] accel/ivpu: Prevent recovery work from being queued during device removal
Date: Sun,  7 Sep 2025 21:58:44 +0200
Message-ID: <20250907195618.090313408@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195615.802693401@linuxfoundation.org>
References: <20250907195615.802693401@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karol Wachowski <karol.wachowski@intel.com>

commit 69a79ada8eb034ce016b5b78fb7d08d8687223de upstream.

Use disable_work_sync() instead of cancel_work_sync() in ivpu_dev_fini()
to ensure that no new recovery work items can be queued after device
removal has started. Previously, recovery work could be scheduled even
after canceling existing work, potentially leading to use-after-free
bugs if recovery accessed freed resources.

Rename ivpu_pm_cancel_recovery() to ivpu_pm_disable_recovery() to better
reflect its new behavior.

Fixes: 58cde80f45a2 ("accel/ivpu: Use dedicated work for job timeout detection")
Cc: stable@vger.kernel.org # v6.8+
Signed-off-by: Karol Wachowski <karol.wachowski@intel.com>
Reviewed-by: Lizhi Hou <lizhi.hou@amd.com>
Signed-off-by: Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
Link: https://lore.kernel.org/r/20250808110939.328366-1-jacek.lawrynowicz@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/accel/ivpu/ivpu_drv.c |    2 +-
 drivers/accel/ivpu/ivpu_pm.c  |    4 ++--
 drivers/accel/ivpu/ivpu_pm.h  |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/accel/ivpu/ivpu_drv.c
+++ b/drivers/accel/ivpu/ivpu_drv.c
@@ -677,7 +677,7 @@ static void ivpu_bo_unbind_all_user_cont
 static void ivpu_dev_fini(struct ivpu_device *vdev)
 {
 	ivpu_jobs_abort_all(vdev);
-	ivpu_pm_cancel_recovery(vdev);
+	ivpu_pm_disable_recovery(vdev);
 	ivpu_pm_disable(vdev);
 	ivpu_prepare_for_reset(vdev);
 	ivpu_shutdown(vdev);
--- a/drivers/accel/ivpu/ivpu_pm.c
+++ b/drivers/accel/ivpu/ivpu_pm.c
@@ -408,10 +408,10 @@ void ivpu_pm_init(struct ivpu_device *vd
 	ivpu_dbg(vdev, PM, "Autosuspend delay = %d\n", delay);
 }
 
-void ivpu_pm_cancel_recovery(struct ivpu_device *vdev)
+void ivpu_pm_disable_recovery(struct ivpu_device *vdev)
 {
 	drm_WARN_ON(&vdev->drm, delayed_work_pending(&vdev->pm->job_timeout_work));
-	cancel_work_sync(&vdev->pm->recovery_work);
+	disable_work_sync(&vdev->pm->recovery_work);
 }
 
 void ivpu_pm_enable(struct ivpu_device *vdev)
--- a/drivers/accel/ivpu/ivpu_pm.h
+++ b/drivers/accel/ivpu/ivpu_pm.h
@@ -25,7 +25,7 @@ struct ivpu_pm_info {
 void ivpu_pm_init(struct ivpu_device *vdev);
 void ivpu_pm_enable(struct ivpu_device *vdev);
 void ivpu_pm_disable(struct ivpu_device *vdev);
-void ivpu_pm_cancel_recovery(struct ivpu_device *vdev);
+void ivpu_pm_disable_recovery(struct ivpu_device *vdev);
 
 int ivpu_pm_suspend_cb(struct device *dev);
 int ivpu_pm_resume_cb(struct device *dev);


