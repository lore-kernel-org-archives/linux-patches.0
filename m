Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAFD926B0AD;
	Thu, 13 Feb 2025 15:14:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459685; cv=none; b=CxAESpnwrrYbPSZNdl03/oLhLVDq9RwjkA+JEMtMbEfK2f2yQkOcOVVShck7BRAFZI+WMuf6Dw59O4IxLLUdaVhOoDcUCorNf5kUHearis4p5EyQTyTVTkpvOjovbOloSDk0/oZslN3MyjKZZyAt4gBdtHaPkBcJNXVWCf05T7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459685; c=relaxed/simple;
	bh=JIQLqqe532Z8U7l2eQnzmDNhxVoAY30D/c6VhgvZ+Mc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tDmCGeZDUFEof/OXdV5NUGMrFTS5UUorslHBq8r7fgwc6R2s8vSOaapP3GxWLQHzwfVrYqUAnjiFnWtWExqZQS4vxOg72YYBPXrnu+iubUzx+pcxuH7dAAX9PhLoUTGOnEhNJfEP+1OwpkPiPKi3EOgj9LDWGnMLZFR/WK9LXJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rl9GdYf+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rl9GdYf+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 373CDC4CEE4;
	Thu, 13 Feb 2025 15:14:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459685;
	bh=JIQLqqe532Z8U7l2eQnzmDNhxVoAY30D/c6VhgvZ+Mc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rl9GdYf+N50aRhleujrWCRNrZpIpJX+7wNhpyUJR1LQ85G7wyCOXfwjip9JOROrJo
	 M+19gvTo1LIT1QC8GgtJHtwS3/ztpxSYVZPDMG5kgMuDYQ+6AS3WKncaSKF7IjbbBu
	 hPt+T7IFDl2fWTmKjXTrnNYRRD8MC6fvSXQAx4sI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maciej Falkowski <maciej.falkowski@linux.intel.com>,
	Jeffrey Hugo <quic_jhugo@quicinc.com>,
	Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
Subject: [PATCH 6.13 334/443] accel/ivpu: Fix error handling in recovery/reset
Date: Thu, 13 Feb 2025 15:28:19 +0100
Message-ID: <20250213142453.513558138@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>

commit 41a2d8286c905614f29007f1bc8e652d54654b82 upstream.

Disable runtime PM for the duration of reset/recovery so it is possible
to set the correct runtime PM state depending on the outcome of the
`ivpu_resume()`. Don’t suspend or reset the HW if the NPU is suspended
when the reset/recovery is requested. Also, move common reset/recovery
code to separate functions for better code readability.

Fixes: 27d19268cf39 ("accel/ivpu: Improve recovery and reset support")
Cc: stable@vger.kernel.org # v6.8+
Reviewed-by: Maciej Falkowski <maciej.falkowski@linux.intel.com>
Reviewed-by: Jeffrey Hugo <quic_jhugo@quicinc.com>
Signed-off-by: Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250129124009.1039982-4-jacek.lawrynowicz@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/accel/ivpu/ivpu_pm.c |   79 +++++++++++++++++++++++--------------------
 1 file changed, 43 insertions(+), 36 deletions(-)

--- a/drivers/accel/ivpu/ivpu_pm.c
+++ b/drivers/accel/ivpu/ivpu_pm.c
@@ -115,41 +115,57 @@ err_power_down:
 	return ret;
 }
 
-static void ivpu_pm_recovery_work(struct work_struct *work)
+static void ivpu_pm_reset_begin(struct ivpu_device *vdev)
 {
-	struct ivpu_pm_info *pm = container_of(work, struct ivpu_pm_info, recovery_work);
-	struct ivpu_device *vdev = pm->vdev;
-	char *evt[2] = {"IVPU_PM_EVENT=IVPU_RECOVER", NULL};
-	int ret;
-
-	ivpu_err(vdev, "Recovering the NPU (reset #%d)\n", atomic_read(&vdev->pm->reset_counter));
-
-	ret = pm_runtime_resume_and_get(vdev->drm.dev);
-	if (ret)
-		ivpu_err(vdev, "Failed to resume NPU: %d\n", ret);
-
-	ivpu_jsm_state_dump(vdev);
-	ivpu_dev_coredump(vdev);
+	pm_runtime_disable(vdev->drm.dev);
 
 	atomic_inc(&vdev->pm->reset_counter);
 	atomic_set(&vdev->pm->reset_pending, 1);
 	down_write(&vdev->pm->reset_lock);
+}
+
+static void ivpu_pm_reset_complete(struct ivpu_device *vdev)
+{
+	int ret;
 
-	ivpu_suspend(vdev);
 	ivpu_pm_prepare_cold_boot(vdev);
 	ivpu_jobs_abort_all(vdev);
 	ivpu_ms_cleanup_all(vdev);
 
 	ret = ivpu_resume(vdev);
-	if (ret)
+	if (ret) {
 		ivpu_err(vdev, "Failed to resume NPU: %d\n", ret);
+		pm_runtime_set_suspended(vdev->drm.dev);
+	} else {
+		pm_runtime_set_active(vdev->drm.dev);
+	}
 
 	up_write(&vdev->pm->reset_lock);
 	atomic_set(&vdev->pm->reset_pending, 0);
 
-	kobject_uevent_env(&vdev->drm.dev->kobj, KOBJ_CHANGE, evt);
 	pm_runtime_mark_last_busy(vdev->drm.dev);
-	pm_runtime_put_autosuspend(vdev->drm.dev);
+	pm_runtime_enable(vdev->drm.dev);
+}
+
+static void ivpu_pm_recovery_work(struct work_struct *work)
+{
+	struct ivpu_pm_info *pm = container_of(work, struct ivpu_pm_info, recovery_work);
+	struct ivpu_device *vdev = pm->vdev;
+	char *evt[2] = {"IVPU_PM_EVENT=IVPU_RECOVER", NULL};
+
+	ivpu_err(vdev, "Recovering the NPU (reset #%d)\n", atomic_read(&vdev->pm->reset_counter));
+
+	ivpu_pm_reset_begin(vdev);
+
+	if (!pm_runtime_status_suspended(vdev->drm.dev)) {
+		ivpu_jsm_state_dump(vdev);
+		ivpu_dev_coredump(vdev);
+		ivpu_suspend(vdev);
+	}
+
+	ivpu_pm_reset_complete(vdev);
+
+	kobject_uevent_env(&vdev->drm.dev->kobj, KOBJ_CHANGE, evt);
 }
 
 void ivpu_pm_trigger_recovery(struct ivpu_device *vdev, const char *reason)
@@ -328,16 +344,13 @@ void ivpu_pm_reset_prepare_cb(struct pci
 	struct ivpu_device *vdev = pci_get_drvdata(pdev);
 
 	ivpu_dbg(vdev, PM, "Pre-reset..\n");
-	atomic_inc(&vdev->pm->reset_counter);
-	atomic_set(&vdev->pm->reset_pending, 1);
 
-	pm_runtime_get_sync(vdev->drm.dev);
-	down_write(&vdev->pm->reset_lock);
-	ivpu_prepare_for_reset(vdev);
-	ivpu_hw_reset(vdev);
-	ivpu_pm_prepare_cold_boot(vdev);
-	ivpu_jobs_abort_all(vdev);
-	ivpu_ms_cleanup_all(vdev);
+	ivpu_pm_reset_begin(vdev);
+
+	if (!pm_runtime_status_suspended(vdev->drm.dev)) {
+		ivpu_prepare_for_reset(vdev);
+		ivpu_hw_reset(vdev);
+	}
 
 	ivpu_dbg(vdev, PM, "Pre-reset done.\n");
 }
@@ -345,18 +358,12 @@ void ivpu_pm_reset_prepare_cb(struct pci
 void ivpu_pm_reset_done_cb(struct pci_dev *pdev)
 {
 	struct ivpu_device *vdev = pci_get_drvdata(pdev);
-	int ret;
 
 	ivpu_dbg(vdev, PM, "Post-reset..\n");
-	ret = ivpu_resume(vdev);
-	if (ret)
-		ivpu_err(vdev, "Failed to set RESUME state: %d\n", ret);
-	up_write(&vdev->pm->reset_lock);
-	atomic_set(&vdev->pm->reset_pending, 0);
-	ivpu_dbg(vdev, PM, "Post-reset done.\n");
 
-	pm_runtime_mark_last_busy(vdev->drm.dev);
-	pm_runtime_put_autosuspend(vdev->drm.dev);
+	ivpu_pm_reset_complete(vdev);
+
+	ivpu_dbg(vdev, PM, "Post-reset done.\n");
 }
 
 void ivpu_pm_init(struct ivpu_device *vdev)


