Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C181A47604A;
	Tue, 13 Oct 2026 12:17:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893825; cv=none; b=tOX+OFmfX7qK/uNFmBJNwVIgPJp72wRTmVRf2TDziYQC61qBHxB0TtC7l7UiMCrTWEzJ46C7o7MQRVfebjiz4gKjR5yM0W9/FDfyPEjBY/0IVJ6sJA4XGtgowV4EyZ9E6eRFcnoFLVZZbh2xJikBuJUfacFSSPKZFap2Bb9y8xI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893825; c=relaxed/simple;
	bh=YXXGbSjKKgK0AgliHbwCoy2w8mIHwOJhwdI76a30kxg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jlHI573acBw+ZSGQIwKDh/AsfB7KYg/NfuaKBk9/8U62keg5o7j3NUube/xqOw4jTDPCQrRP1MownDMuOW/HiNBXcSnL25KmLplZ9KvKbdo7h474tNpP1bBqs8QLnhZQrsJRfK+Ywe+TO/1izRq/uRMxy5m8WfYXNBO9E9JsR/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LpGhboF0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LpGhboF0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D61D1F000FF;
	Tue, 13 Oct 2026 12:17:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893824;
	bh=g4Bwwof32R0ixRcUU07tXkB251LgZMUDNDuyY5YKpJY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LpGhboF0SkOKF0sWkg9aerqPkJEQLDKCFP9QOkVn+n3DMWEZRb91RYwaLXWh3CtOD
	 +CTmhIrUC4289t8lq9njNn4PhyHh/pdcMus4+06OMTEWregdN+vxE6B/H4R+9kJSaR
	 uYJCb1IbuuDnRJ/xE4cFDTdAeEg5yfi+poPMFkt4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prasanna Kumar T S M <ptsm@linux.microsoft.com>,
	Michal Simek <michal.simek@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 356/621] soc: xilinx: Fix race condition in event registration
Date: Tue, 13 Oct 2026 13:35:51 +0200
Message-ID: <20261013112929.297491727@linuxfoundation.org>
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

From: Prasanna Kumar T S M <ptsm@linux.microsoft.com>

[ Upstream commit fb445935338405110baca8f541a2df3b4cb8d712 ]

The zynqmp_power driver registers handlers for suspend and subsystem
restart events using register_event(). However, the work structures
(zynqmp_pm_init_suspend_work and zynqmp_pm_init_restart_work) used by
these handlers were allocated and initialized after the registration
call.

This created a race window where, if the firmware triggered an event
immediately after registration but before allocation, the callback
(suspend_event_callback or subsystem_restart_event_callback) would
dereference a NULL pointer in work_pending(), leading to a crash.

Fix this by allocating and initializing the work structures before
registering the events.

Fixes: fcf544ac6439 ("soc: xilinx: Add cb event for subsystem restart")
Signed-off-by: Prasanna Kumar T S M <ptsm@linux.microsoft.com>
Signed-off-by: Michal Simek <michal.simek@amd.com>
Link: https://lore.kernel.org/r/20260320060306.1540928-1-ptsm@linux.microsoft.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/xilinx/zynqmp_power.c | 43 ++++++++++++-------------------
 1 file changed, 17 insertions(+), 26 deletions(-)

diff --git a/drivers/soc/xilinx/zynqmp_power.c b/drivers/soc/xilinx/zynqmp_power.c
index 26cbb52049d8d..e5d5c4f8cbdbd 100644
--- a/drivers/soc/xilinx/zynqmp_power.c
+++ b/drivers/soc/xilinx/zynqmp_power.c
@@ -303,18 +303,18 @@ static int zynqmp_pm_probe(struct platform_device *pdev)
 	 * is not available to use) or -ENODEV(Xilinx Event Manager not compiled),
 	 * then use ipi-mailbox or interrupt method.
 	 */
+	zynqmp_pm_init_suspend_work = devm_kzalloc(&pdev->dev,
+						   sizeof(struct zynqmp_pm_work_struct),
+						   GFP_KERNEL);
+	if (!zynqmp_pm_init_suspend_work)
+		return -ENOMEM;
+
+	INIT_WORK(&zynqmp_pm_init_suspend_work->callback_work,
+		  zynqmp_pm_init_suspend_work_fn);
+
 	ret = register_event(&pdev->dev, PM_INIT_SUSPEND_CB, 0, 0, false,
 			     suspend_event_callback);
 	if (!ret) {
-		zynqmp_pm_init_suspend_work = devm_kzalloc(&pdev->dev,
-							   sizeof(struct zynqmp_pm_work_struct),
-							   GFP_KERNEL);
-		if (!zynqmp_pm_init_suspend_work)
-			return -ENOMEM;
-
-		INIT_WORK(&zynqmp_pm_init_suspend_work->callback_work,
-			  zynqmp_pm_init_suspend_work_fn);
-
 		ret = zynqmp_pm_get_family_info(&pm_family_code);
 		if (ret < 0)
 			return ret;
@@ -326,14 +326,6 @@ static int zynqmp_pm_probe(struct platform_device *pdev)
 		else
 			return -ENODEV;
 
-		ret = register_event(&pdev->dev, PM_NOTIFY_CB, node_id, EVENT_SUBSYSTEM_RESTART,
-				     false, subsystem_restart_event_callback);
-		if (ret) {
-			dev_err(&pdev->dev, "Failed to Register with Xilinx Event manager %d\n",
-				ret);
-			return ret;
-		}
-
 		zynqmp_pm_init_restart_work = devm_kzalloc(&pdev->dev,
 							   sizeof(struct zynqmp_pm_work_struct),
 							   GFP_KERNEL);
@@ -342,19 +334,18 @@ static int zynqmp_pm_probe(struct platform_device *pdev)
 
 		INIT_WORK(&zynqmp_pm_init_restart_work->callback_work,
 			  zynqmp_pm_subsystem_restart_work_fn);
+
+		ret = register_event(&pdev->dev, PM_NOTIFY_CB, node_id, EVENT_SUBSYSTEM_RESTART,
+				     false, subsystem_restart_event_callback);
+		if (ret) {
+			dev_err(&pdev->dev, "Failed to Register with Xilinx Event manager %d\n",
+				ret);
+			return ret;
+		}
 	} else if (ret != -EACCES && ret != -ENODEV) {
 		dev_err(&pdev->dev, "Failed to Register with Xilinx Event manager %d\n", ret);
 		return ret;
 	} else if (of_property_present(pdev->dev.of_node, "mboxes")) {
-		zynqmp_pm_init_suspend_work =
-			devm_kzalloc(&pdev->dev,
-				     sizeof(struct zynqmp_pm_work_struct),
-				     GFP_KERNEL);
-		if (!zynqmp_pm_init_suspend_work)
-			return -ENOMEM;
-
-		INIT_WORK(&zynqmp_pm_init_suspend_work->callback_work,
-			  zynqmp_pm_init_suspend_work_fn);
 		client = devm_kzalloc(&pdev->dev, sizeof(*client), GFP_KERNEL);
 		if (!client)
 			return -ENOMEM;
-- 
2.53.0



