Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5969937F007;
	Tue, 10 Mar 2026 11:29:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773142184; cv=none; b=ACvQk2wwCSg71k9J5jDwDEFaFlt+o199gilOZrb6GRUtxdCGQpmV7GoH9YNiHxgU1FOt2wVxXBzcfbrY1QwemCYkKyIOmN7C+8ig+hTPbCfm+BBeEOwHIV3QV1iFUgx5s2JgkzZy7F8S3z+91ZEPiVLQEBijMbVmmbxBUJNgPG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773142184; c=relaxed/simple;
	bh=W0yIdMJA03+kAevfZYgB4i3bl6we7rlgpQsUHhPAYww=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rJeyV/y0xh1NYQAOJbd5u6dFksOhIv/DhXJbef/IEtEKEtq9kZ9Pa9dppTvz6og2IRIE/qsslXeFp4qE8y7HcJ35e65NvVVZvuWaZ9kaUnEEhHaBr2sWCvgks6xc5ifc/f46cKen4iL/m+eIy2RxkqlcANruiEP5PJHQnwHO0j0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QtLdt5Hy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QtLdt5Hy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C6E2C2BCAF;
	Tue, 10 Mar 2026 11:29:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773142184;
	bh=W0yIdMJA03+kAevfZYgB4i3bl6we7rlgpQsUHhPAYww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QtLdt5HyzaVcNhl/Es45Z+jycd3uNTmOxQAuhzCQsbGJ9xbLfriztj0EqGmLH7Rdm
	 6xsLYu3xgmEJE6q3gz4T9II+CSktqpsSj3DYGCZf91SgvneyMLyzEVpedgkgE8etdu
	 JQdexoS57xk14/H0+GYe+RsXE4c0jKOJP9qrozP0yrWk9gSs8vZoC+YaczIMQGckct
	 ENmrBhu0gCiQ1bOA+4UOBf7cRgOJbcJhFxcXtC692ahEPGo0Fl8UyA8S94Py27gMe6
	 aQVOSJISyuud8bfiqBZ1MNpa5arDU2g7vPBGNyE4E3nA+m2yNCW/A1/hQOCgvSb8Na
	 UuJYMAUVXxDmA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Zhanjun Dong <zhanjun.dong@intel.com>,
	Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 273/314] drm/xe/gsc: Fix GSC proxy cleanup on early initialization failure
Date: Tue, 10 Mar 2026 07:18:52 -0400
Message-ID: <11cb6031a50c91c7b9006e9e865ab5adf933d82c.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Zhanjun Dong <zhanjun.dong@intel.com>

[ Upstream commit b3368ecca9538b88ddf982ea99064860fd5add97 ]

xe_gsc_proxy_remove undoes what is done in both xe_gsc_proxy_init and
xe_gsc_proxy_start; however, if we fail between those 2 calls, it is
possible that the HW forcewake access hasn't been initialized yet and so
we hit errors when the cleanup code tries to write GSC register. To
avoid that, split the cleanup in 2 functions so that the HW cleanup is
only called if the HW setup was completed successfully.

Since the HW cleanup (interrupt disabling) is now removed from
xe_gsc_proxy_remove, the cleanup on error paths in xe_gsc_proxy_start
must be updated to disable interrupts before returning.

Fixes: ff6cd29b690b ("drm/xe: Cleanup unwind of gt initialization")
Signed-off-by: Zhanjun Dong <zhanjun.dong@intel.com>
Reviewed-by: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
Signed-off-by: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
Link: https://patch.msgid.link/20260220225308.101469-1-zhanjun.dong@intel.com
(cherry picked from commit 2b37c401b265c07b46408b5cb36a4b757c9b5060)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_gsc_proxy.c | 43 +++++++++++++++++++++++++------
 drivers/gpu/drm/xe/xe_gsc_types.h |  2 ++
 2 files changed, 37 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_gsc_proxy.c b/drivers/gpu/drm/xe/xe_gsc_proxy.c
index 464282a89eef3..a6f6f0ea56526 100644
--- a/drivers/gpu/drm/xe/xe_gsc_proxy.c
+++ b/drivers/gpu/drm/xe/xe_gsc_proxy.c
@@ -435,16 +435,12 @@ static int proxy_channel_alloc(struct xe_gsc *gsc)
 	return 0;
 }
 
-static void xe_gsc_proxy_remove(void *arg)
+static void xe_gsc_proxy_stop(struct xe_gsc *gsc)
 {
-	struct xe_gsc *gsc = arg;
 	struct xe_gt *gt = gsc_to_gt(gsc);
 	struct xe_device *xe = gt_to_xe(gt);
 	unsigned int fw_ref = 0;
 
-	if (!gsc->proxy.component_added)
-		return;
-
 	/* disable HECI2 IRQs */
 	xe_pm_runtime_get(xe);
 	fw_ref = xe_force_wake_get(gt_to_fw(gt), XE_FW_GSC);
@@ -458,6 +454,30 @@ static void xe_gsc_proxy_remove(void *arg)
 	xe_pm_runtime_put(xe);
 
 	xe_gsc_wait_for_worker_completion(gsc);
+	gsc->proxy.started = false;
+}
+
+static void xe_gsc_proxy_remove(void *arg)
+{
+	struct xe_gsc *gsc = arg;
+	struct xe_gt *gt = gsc_to_gt(gsc);
+	struct xe_device *xe = gt_to_xe(gt);
+
+	if (!gsc->proxy.component_added)
+		return;
+
+	/*
+	 * GSC proxy start is an async process that can be ongoing during
+	 * Xe module load/unload. Using devm managed action to register
+	 * xe_gsc_proxy_stop could cause issues if Xe module unload has
+	 * already started when the action is registered, potentially leading
+	 * to the cleanup being called at the wrong time. Therefore, instead
+	 * of registering a separate devm action to undo what is done in
+	 * proxy start, we call it from here, but only if the start has
+	 * completed successfully (tracked with the 'started' flag).
+	 */
+	if (gsc->proxy.started)
+		xe_gsc_proxy_stop(gsc);
 
 	component_del(xe->drm.dev, &xe_gsc_proxy_component_ops);
 	gsc->proxy.component_added = false;
@@ -513,6 +533,7 @@ int xe_gsc_proxy_init(struct xe_gsc *gsc)
  */
 int xe_gsc_proxy_start(struct xe_gsc *gsc)
 {
+	struct xe_gt *gt = gsc_to_gt(gsc);
 	int err;
 
 	/* enable the proxy interrupt in the GSC shim layer */
@@ -524,12 +545,18 @@ int xe_gsc_proxy_start(struct xe_gsc *gsc)
 	 */
 	err = xe_gsc_proxy_request_handler(gsc);
 	if (err)
-		return err;
+		goto err_irq_disable;
 
 	if (!xe_gsc_proxy_init_done(gsc)) {
-		xe_gt_err(gsc_to_gt(gsc), "GSC FW reports proxy init not completed\n");
-		return -EIO;
+		xe_gt_err(gt, "GSC FW reports proxy init not completed\n");
+		err = -EIO;
+		goto err_irq_disable;
 	}
 
+	gsc->proxy.started = true;
 	return 0;
+
+err_irq_disable:
+	gsc_proxy_irq_toggle(gsc, false);
+	return err;
 }
diff --git a/drivers/gpu/drm/xe/xe_gsc_types.h b/drivers/gpu/drm/xe/xe_gsc_types.h
index 97c056656df05..5aaa2a75861fd 100644
--- a/drivers/gpu/drm/xe/xe_gsc_types.h
+++ b/drivers/gpu/drm/xe/xe_gsc_types.h
@@ -58,6 +58,8 @@ struct xe_gsc {
 		struct mutex mutex;
 		/** @proxy.component_added: whether the component has been added */
 		bool component_added;
+		/** @proxy.started: whether the proxy has been started */
+		bool started;
 		/** @proxy.bo: object to store message to and from the GSC */
 		struct xe_bo *bo;
 		/** @proxy.to_gsc: map of the memory used to send messages to the GSC */
-- 
2.51.0

