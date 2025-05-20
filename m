Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 907D72459F7;
	Tue, 20 May 2025 14:00:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747749628; cv=none; b=ngdIVBPxD7taTkONk3OhZn0f13CsZY+B4Udq+wkMmJFhvQz7bdnQegeSUtVfYIIwSadJc1X6cNqWbS2ciWUr8dripo0XvHQwEc5vxX70+kwSOwHaC1kMQGOIepPLvb5KCC/1TLb6AnwZnMUtr8/ct4IPHfViMtp4keWL7x4z2og=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747749628; c=relaxed/simple;
	bh=hMpgHqRvpbyQikFcBwjjxd591oS8jSRpa6tb9OWl2Dg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=n9LkI/leOSiRKgQbMhgBUQka8tC60PVdAov/SMpP7r+xZnjtn0O2TGXyw/OvHDRetpP0MvgR+e9yk7cC+W3TUPE/iQxcdhgP1ZguSxf6Qo/6mLj6oJgjQPu3xaE7btVYPaAOoz/cXy42H+MPmMK36SNyv66UC4RVf3XemZqbX64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OTR9UIMt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OTR9UIMt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19592C4CEEF;
	Tue, 20 May 2025 14:00:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747749628;
	bh=hMpgHqRvpbyQikFcBwjjxd591oS8jSRpa6tb9OWl2Dg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OTR9UIMtuUEXJGRPLRm7zfjkN0o3i2po0wOvAiVi+ES+h9Tb8KL+v/WF8lRwXHMTA
	 cQa3cnihH0HTvpofQZk3gWTPrUe+jS08CYABgiXcJTD8WwSazvR+mYnFnBIYiIW+nx
	 EFKXZwfGXly3wmMBdSLvTp6lxeJu9GFtXfDs/O10=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	"Maciej S. Szmigiero" <mail@maciej.szmigiero.name>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Zhaoyang Li <lizy04@hust.edu.cn>
Subject: [PATCH 6.1 92/97] platform/x86/amd/pmc: Only disable IRQ1 wakeup where i8042 actually enabled it
Date: Tue, 20 May 2025 15:50:57 +0200
Message-ID: <20250520125804.265727497@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125800.653047540@linuxfoundation.org>
References: <20250520125800.653047540@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maciej S. Szmigiero <mail@maciej.szmigiero.name>

commit dd410d784402c5775f66faf8b624e85e41c38aaf upstream.

Wakeup for IRQ1 should be disabled only in cases where i8042 had
actually enabled it, otherwise "wake_depth" for this IRQ will try to
drop below zero and there will be an unpleasant WARN() logged:

kernel: atkbd serio0: Disabling IRQ1 wakeup source to avoid platform firmware bug
kernel: ------------[ cut here ]------------
kernel: Unbalanced IRQ 1 wake disable
kernel: WARNING: CPU: 10 PID: 6431 at kernel/irq/manage.c:920 irq_set_irq_wake+0x147/0x1a0

The PMC driver uses DEFINE_SIMPLE_DEV_PM_OPS() to define its dev_pm_ops
which sets amd_pmc_suspend_handler() to the .suspend, .freeze, and
.poweroff handlers. i8042_pm_suspend(), however, is only set as
the .suspend handler.

Fix the issue by call PMC suspend handler only from the same set of
dev_pm_ops handlers as i8042_pm_suspend(), which currently means just
the .suspend handler.

To reproduce this issue try hibernating (S4) the machine after a fresh boot
without putting it into s2idle first.

Fixes: 8e60615e8932 ("platform/x86/amd: pmc: Disable IRQ1 wakeup for RN/CZN")
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Maciej S. Szmigiero <mail@maciej.szmigiero.name>
Link: https://lore.kernel.org/r/c8f28c002ca3c66fbeeb850904a1f43118e17200.1736184606.git.mail@maciej.szmigiero.name
[ij: edited the commit message.]
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Zhaoyang Li <lizy04@hust.edu.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/amd/pmc.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/platform/x86/amd/pmc.c
+++ b/drivers/platform/x86/amd/pmc.c
@@ -834,6 +834,10 @@ static int __maybe_unused amd_pmc_suspen
 {
 	struct amd_pmc_dev *pdev = dev_get_drvdata(dev);
 
+	/*
+	* Must be called only from the same set of dev_pm_ops handlers
+	* as i8042_pm_suspend() is called: currently just from .suspend.
+	*/
 	if (pdev->cpu_id == AMD_CPU_ID_CZN) {
 		int rc = amd_pmc_czn_wa_irq1(pdev);
 
@@ -846,7 +850,9 @@ static int __maybe_unused amd_pmc_suspen
 	return 0;
 }
 
-static SIMPLE_DEV_PM_OPS(amd_pmc_pm, amd_pmc_suspend_handler, NULL);
+static const struct dev_pm_ops amd_pmc_pm = {
+	.suspend = amd_pmc_suspend_handler,
+};
 
 #endif
 


