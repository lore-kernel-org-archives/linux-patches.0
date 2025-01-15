Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C4D1248BD1;
	Wed, 15 Jan 2025 10:57:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938646; cv=none; b=SbZJXEXFlSutozq8Imu9ajJ5oRC6xWk+yLLEbkMMgrd+ixSjXxdStqaxjPT/YV4TD68eXshiXK12iUwImxv8rIczt3YBQzd55xWyHvFcBn7DJYHT6r3Dj5ONRnBEf9uQVdNWZ1hUbK1Eft/lpOPrzeHVA/EY6qGV098ts4Fzk8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938646; c=relaxed/simple;
	bh=b9MsDex2u/9S5543YmKDlF+nDWhpC3e/mE2oqGiNEAY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TuzZQ1J0eYiTOhP/Ab92K3C/KdiS2cysC+P79eVON772Zc0j5ztBoIfalScyQPDSS1uDNBMgAuSOC+ZboGYisnX4vbXQyZvPUOXGjvbeU3dLdpoBDklP9F8Vi3TOsbUxTeF75iDg8h1uhBAXv0NO6HXp7CPWbn3yhpjlGZmWCZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=liy/g7hb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="liy/g7hb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87E7FC4CEDF;
	Wed, 15 Jan 2025 10:57:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938646;
	bh=b9MsDex2u/9S5543YmKDlF+nDWhpC3e/mE2oqGiNEAY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=liy/g7hbBlcCdgS47s3xiLHKLTsuXIFI/4QIL3BVU4yHot3pkJUA3kY83D5T5LEw5
	 4G1rrK3s+K+nrr4a1hNk+4jXihxQmgINnSVrNPhafA4W7ERh7y8NqEFZHNGw3y+R8i
	 PqWQ+yyCmbZbOPIwepA5xvWnmxBMjtsEjy6YnPjE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	"Maciej S. Szmigiero" <mail@maciej.szmigiero.name>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 054/129] platform/x86/amd/pmc: Only disable IRQ1 wakeup where i8042 actually enabled it
Date: Wed, 15 Jan 2025 11:37:09 +0100
Message-ID: <20250115103556.523648488@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103554.357917208@linuxfoundation.org>
References: <20250115103554.357917208@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index f49b1bb258c7..70907e8f3ea9 100644
--- a/drivers/platform/x86/amd/pmc/pmc.c
+++ b/drivers/platform/x86/amd/pmc/pmc.c
@@ -878,6 +878,10 @@ static int amd_pmc_suspend_handler(struct device *dev)
 {
 	struct amd_pmc_dev *pdev = dev_get_drvdata(dev);
 
+	/*
+	 * Must be called only from the same set of dev_pm_ops handlers
+	 * as i8042_pm_suspend() is called: currently just from .suspend.
+	 */
 	if (pdev->disable_8042_wakeup && !disable_workarounds) {
 		int rc = amd_pmc_wa_irq1(pdev);
 
@@ -890,7 +894,9 @@ static int amd_pmc_suspend_handler(struct device *dev)
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



