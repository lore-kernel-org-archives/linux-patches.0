Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 708837404E;
	Sat, 17 Oct 2026 16:32:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254722; cv=none; b=kU4e/2bllvEgF+HEZQMx9oCCzy+9lMKdo3dRQxn5/tdU964TNohHSH9gCkOmCQCAua1BGxEafQsmBWq6QKik2hzHNKLJlF/Tvu2bl3erQFMZykDM5i/Lspek/lJvqI3m8dKV7qhZG6ioxiyZZK4u3y9CALoDIsge+6i5RHOBE/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254722; c=relaxed/simple;
	bh=q/5DhUyt/JBUUlROFh1bPlO1lgYjrHwKDCIUqGj4E7c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OkeNfIjSJsUax6iKUzR5GAI1/ekAknOw2FeoqKeApQi7PLXVf/16nSdAopvovWDiVIPgPHXsqm61gkvcdDBCggxJm0uPO+/hXr4tCIgU8kz4mvUTTWd/Leig+dRwGxQUpeHqzHMxsfBOmpi7+VS4W5J7scF1GTgGoLIlKFWX1dA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=idhohqWX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="idhohqWX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C887B1F000C4;
	Sat, 17 Oct 2026 16:32:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254721;
	bh=gRx1aYeppEJDmYgGZf6Cz41qEd2RMZHiasfy9nvxSgU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=idhohqWX8gKlr118VmDeKEVZBdas/7Y6LhKzWv7E2fpzO2YgOaKlEdnNvxPQ/6XmP
	 /RjXyZQGeQ7RjboApXJZCl8YJ2fp/zYnwzZtXj9XkFollErt14nuDpwr0LBh1uOznT
	 KP83323EeUX4QlvvzKkFOQJaTF/ehe6zWeZwYtwE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prasanna Kumar T S M <ptsm@linux.microsoft.com>,
	Michal Simek <michal.simek@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 540/869] soc: xilinx: Fix race condition in event registration
Date: Sat, 17 Oct 2026 17:56:21 +0200
Message-ID: <20261017160050.942470045@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 84ef7c87dfaa3..92f1ab1d269b8 100644
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
 		ret = zynqmp_pm_get_family_info(&pm_family_code, &pm_sub_family_code);
 		if (ret < 0)
 			return ret;
@@ -324,14 +324,6 @@ static int zynqmp_pm_probe(struct platform_device *pdev)
 		else
 			node_id = PM_DEV_ACPU_0;
 
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
@@ -340,19 +332,18 @@ static int zynqmp_pm_probe(struct platform_device *pdev)
 
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



