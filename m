Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 957261487CD;
	Thu, 12 Dec 2024 15:27:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017269; cv=none; b=mhi/iY4xNC3K91CkyIFjoAAYZ6HzATIdlW8Qrhebm+OQD8Rqnr+qm7aOQUes3K5b24PbCrJ9SyTOKEkJ1RUIMVZ7Y4IpGw4psjToX8erHj1EtUjDRGozS9vYxCx+PabhHvcaONYi3sNF7+v85eIN2W94YafbIGPquq/ZoXRbTT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017269; c=relaxed/simple;
	bh=lvASbpKw7EAQ92LxD4W3maO0smYG50Um4tf3PfP1r1Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=COgcQSyvMkqO2pTcbXYLzvJxhtn2VKlnMrFs7IGPXcI/VkdMA4HHAOLGDbnYCExAJuPbFnB7+6wC1l4vZXoM0nPR6uAoyFA3O43C0VY/e/Th7Wn87CholRJSVLtd6CtK+jj10Ws2wGduGsC/smapb5B5S37RBRTF+/3dG8Znqtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lbDx2jvl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lbDx2jvl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8344C4CECE;
	Thu, 12 Dec 2024 15:27:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017269;
	bh=lvASbpKw7EAQ92LxD4W3maO0smYG50Um4tf3PfP1r1Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lbDx2jvlmCNiwkdgIEnHmOtTwoMkDLQWsYj37o8vqlt5I7A3uMcSLp18b5ucUKNu4
	 UTIrwow7I75TFwzxyRom+vvFbVpL48pX+XwTkN6yEjiHtEC+cQDRgjMKLrtl8MaF5m
	 K1cF29gyoUbCVez7GqGoZGrJZYT8BAfDv5Uq0rb0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Harrison <John.C.Harrison@Intel.com>,
	Julia Filipchuk <julia.filipchuk@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 431/466] drm/xe/devcoredump: Use drm_puts and already cached local variables
Date: Thu, 12 Dec 2024 16:00:00 +0100
Message-ID: <20241212144323.900526881@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: John Harrison <John.C.Harrison@Intel.com>

[ Upstream commit 9d86d080cfb3ab935c842ac5525a90430a14c998 ]

There are a bunch of calls to drm_printf with static strings. Switch
them to drm_puts instead.

There are also a bunch of 'coredump->snapshot.XXX' references when
'coredump->snapshot' has alread been cached locally as 'ss'. So use
'ss->XXX' instead.

Signed-off-by: John Harrison <John.C.Harrison@Intel.com>
Reviewed-by: Julia Filipchuk <julia.filipchuk@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241003004611.2323493-3-John.C.Harrison@Intel.com
Stable-dep-of: 5dce85fecb87 ("drm/xe: Move the coredump registration to the worker thread")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_devcoredump.c | 40 ++++++++++++++---------------
 1 file changed, 20 insertions(+), 20 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_devcoredump.c b/drivers/gpu/drm/xe/xe_devcoredump.c
index bdb76e834e4c3..d23719d5c2a3d 100644
--- a/drivers/gpu/drm/xe/xe_devcoredump.c
+++ b/drivers/gpu/drm/xe/xe_devcoredump.c
@@ -85,9 +85,9 @@ static ssize_t __xe_devcoredump_read(char *buffer, size_t count,
 
 	p = drm_coredump_printer(&iter);
 
-	drm_printf(&p, "**** Xe Device Coredump ****\n");
-	drm_printf(&p, "kernel: " UTS_RELEASE "\n");
-	drm_printf(&p, "module: " KBUILD_MODNAME "\n");
+	drm_puts(&p, "**** Xe Device Coredump ****\n");
+	drm_puts(&p, "kernel: " UTS_RELEASE "\n");
+	drm_puts(&p, "module: " KBUILD_MODNAME "\n");
 
 	ts = ktime_to_timespec64(ss->snapshot_time);
 	drm_printf(&p, "Snapshot time: %lld.%09ld\n", ts.tv_sec, ts.tv_nsec);
@@ -96,20 +96,20 @@ static ssize_t __xe_devcoredump_read(char *buffer, size_t count,
 	drm_printf(&p, "Process: %s\n", ss->process_name);
 	xe_device_snapshot_print(xe, &p);
 
-	drm_printf(&p, "\n**** GuC CT ****\n");
-	xe_guc_ct_snapshot_print(coredump->snapshot.ct, &p);
-	xe_guc_exec_queue_snapshot_print(coredump->snapshot.ge, &p);
+	drm_puts(&p, "\n**** GuC CT ****\n");
+	xe_guc_ct_snapshot_print(ss->ct, &p);
+	xe_guc_exec_queue_snapshot_print(ss->ge, &p);
 
-	drm_printf(&p, "\n**** Job ****\n");
-	xe_sched_job_snapshot_print(coredump->snapshot.job, &p);
+	drm_puts(&p, "\n**** Job ****\n");
+	xe_sched_job_snapshot_print(ss->job, &p);
 
-	drm_printf(&p, "\n**** HW Engines ****\n");
+	drm_puts(&p, "\n**** HW Engines ****\n");
 	for (i = 0; i < XE_NUM_HW_ENGINES; i++)
-		if (coredump->snapshot.hwe[i])
-			xe_hw_engine_snapshot_print(coredump->snapshot.hwe[i],
-						    &p);
-	drm_printf(&p, "\n**** VM state ****\n");
-	xe_vm_snapshot_print(coredump->snapshot.vm, &p);
+		if (ss->hwe[i])
+			xe_hw_engine_snapshot_print(ss->hwe[i], &p);
+
+	drm_puts(&p, "\n**** VM state ****\n");
+	xe_vm_snapshot_print(ss->vm, &p);
 
 	return count - iter.remain;
 }
@@ -247,18 +247,18 @@ static void devcoredump_snapshot(struct xe_devcoredump *coredump,
 	if (xe_force_wake_get(gt_to_fw(q->gt), XE_FORCEWAKE_ALL))
 		xe_gt_info(ss->gt, "failed to get forcewake for coredump capture\n");
 
-	coredump->snapshot.ct = xe_guc_ct_snapshot_capture(&guc->ct, true);
-	coredump->snapshot.ge = xe_guc_exec_queue_snapshot_capture(q);
-	coredump->snapshot.job = xe_sched_job_snapshot_capture(job);
-	coredump->snapshot.vm = xe_vm_snapshot_capture(q->vm);
+	ss->ct = xe_guc_ct_snapshot_capture(&guc->ct, true);
+	ss->ge = xe_guc_exec_queue_snapshot_capture(q);
+	ss->job = xe_sched_job_snapshot_capture(job);
+	ss->vm = xe_vm_snapshot_capture(q->vm);
 
 	for_each_hw_engine(hwe, q->gt, id) {
 		if (hwe->class != q->hwe->class ||
 		    !(BIT(hwe->logical_instance) & adj_logical_mask)) {
-			coredump->snapshot.hwe[id] = NULL;
+			ss->hwe[id] = NULL;
 			continue;
 		}
-		coredump->snapshot.hwe[id] = xe_hw_engine_snapshot_capture(hwe);
+		ss->hwe[id] = xe_hw_engine_snapshot_capture(hwe);
 	}
 
 	queue_work(system_unbound_wq, &ss->work);
-- 
2.43.0



