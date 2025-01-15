Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D289248BB2;
	Wed, 15 Jan 2025 10:47:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938062; cv=none; b=F3D6xTxXbOcGaf47fzNMmD2V4rE4WD23ZMOMLLcSQFRC1jOG9jdbF0ZaTzuC7iifDo4KV2Zo6lsdeJP4jMokf9ovUw/8Qr4Er2kVnQOM4H7Q3pJ+BPpUeRA6cI8XrrYeuporRCEOblwOH4gpxAXDc+B0TJcZZ8xIzblW7nuNGPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938062; c=relaxed/simple;
	bh=X7QsN6eKCgjWT7RJYrCjayMt/kjaNpo//LueSCso1aM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OfgsYM1JMErFJBOYS9mh6QCZZWsoufxXZXerOQXzEWnsffoEsasa7IHDisSSkUDs2UX1T/f6y7Qvec4u96I6SlKYKx7UOCV81oFWUxKvIOI3ld7BRzZIi5bj6H700UTPEpi8AQ0m8+U0m436Tp+ltbj6llRbWKFNkuhqkyRIb5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B1zIn0wp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B1zIn0wp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C115EC4CEE1;
	Wed, 15 Jan 2025 10:47:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938062;
	bh=X7QsN6eKCgjWT7RJYrCjayMt/kjaNpo//LueSCso1aM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B1zIn0wpLjfB9MUxGJiUIiSqUgMgTUXbZXHR2Jop27YPzhYE4D9/TehNjF9CspYH/
	 NS6IzsuK+oaayG+0/fnzh6E9HfkLEahvXLq/6NIAk/7nB8NmfRqvn5kN/kDYi1/IBp
	 GPOhKSfnOPUitTHLc+yQK9j6vh840CzEumW9EY1Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	"Maciej S. Szmigiero" <mail@maciej.szmigiero.name>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 072/189] platform/x86/amd/pmc: Only disable IRQ1 wakeup where i8042 actually enabled it
Date: Wed, 15 Jan 2025 11:36:08 +0100
Message-ID: <20250115103609.231599931@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103606.357764746@linuxfoundation.org>
References: <20250115103606.357764746@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maciej S. Szmigiero <mail@maciej.szmigiero.name>

[ Upstream commit dd410d784402c5775f66faf8b624e85e41c38aaf ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/amd/pmc/pmc.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/amd/pmc/pmc.c b/drivers/platform/x86/amd/pmc/pmc.c
index 5669f94c3d06..4d3acfe849bf 100644
--- a/drivers/platform/x86/amd/pmc/pmc.c
+++ b/drivers/platform/x86/amd/pmc/pmc.c
@@ -947,6 +947,10 @@ static int amd_pmc_suspend_handler(struct device *dev)
 {
 	struct amd_pmc_dev *pdev = dev_get_drvdata(dev);
 
+	/*
+	 * Must be called only from the same set of dev_pm_ops handlers
+	 * as i8042_pm_suspend() is called: currently just from .suspend.
+	 */
 	if (pdev->disable_8042_wakeup && !disable_workarounds) {
 		int rc = amd_pmc_wa_irq1(pdev);
 
@@ -959,7 +963,9 @@ static int amd_pmc_suspend_handler(struct device *dev)
 	return 0;
 }
 
-static DEFINE_SIMPLE_DEV_PM_OPS(amd_pmc_pm, amd_pmc_suspend_handler, NULL);
+static const struct dev_pm_ops amd_pmc_pm = {
+	.suspend = amd_pmc_suspend_handler,
+};
 
 static const struct pci_device_id pmc_pci_ids[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, AMD_CPU_ID_PS) },
-- 
2.39.5



