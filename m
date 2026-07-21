Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A71C246AA82;
	Tue, 21 Jul 2026 15:36:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648191; cv=none; b=qc+T9P/CjPPrUOlNnj7TqirUSgMSXXc/GpVU/hsKLtO8riGhU/BfLaoYEM2viE4gJ4duntxo9491JpJpzXtDigHeB0HUxXFdXcphSrJcpt2POcTq9khGcTJ1TkhrqbldjGm/SuVeu5mRzufkleMXAsvktNyeVFkY5sjS2RztkDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648191; c=relaxed/simple;
	bh=Vxu/B6VwwAOVezPspwd/3MOA4xqrIkGPZN2yUnarNh4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BlMUihtX+Xdtd88a8qFBhiekYvyX+gE2Xk6YcMwCbFWgYiA5qJo2s0LU8rV3xnO06/olI55FqtpSIdvuE+Y9Omyw1ODWKo1PMb9FNvOdXkr4ICYvcxD5K+yr75m/7dPeSMMFfvF1qJS+Wi4xK5NqmREgF+JZKfoMTo1YTX08EQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T/rCtRlT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T/rCtRlT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0976A1F00A3A;
	Tue, 21 Jul 2026 15:36:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648190;
	bh=19jD++DXMzhCyL2rGrujWxucfuH7MccjdFMJLBR5Pvk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T/rCtRlTZ4GiNFO4Lm6/71EFW48SRk04nqFhdjzzsLHPlLBv6Qy9j4YXYaYoBr8sC
	 xi8ot1twKW/BrD9bJHzfz6WRVLOn8yilGeyF6CM3v3K3cwoe17NhCZxYIBh5xujFyP
	 YEzrj7q78bxrjZaH5L8Sptnvg7VUC+WjK4VvPzds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prasanna Kumar T S M <ptsm@linux.microsoft.com>,
	Michal Simek <michal.simek@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0106/2077] soc: xilinx: Fix race condition in event registration
Date: Tue, 21 Jul 2026 16:56:19 +0200
Message-ID: <20260721152555.193528023@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 9085db1b480aa3..9dd938bd01d840 100644
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



