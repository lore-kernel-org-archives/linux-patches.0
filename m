Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 584AC5012AB;
	Wed, 30 Sep 2026 15:32:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790782368; cv=none; b=unMO3eiLlbCUkwuOJMSPGC5M56fjLFxS5Zjn3HVbXlMQ7Ze5P8UtWIstbEJ/FTdtoXdPS5LWNylQbzELpaais2YxRICbnUcYrGRk3CtopTCvVlIWe7aZclMNguzYzuLJHppZCtPGYnfkmpB7X2n6um5BSPoSnkV67Emlj/kDzN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790782368; c=relaxed/simple;
	bh=843iHe7p4UnzR4HHsaZK2FnDdp59yEWt1UuDV7gIg1E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SgR3z4zNaGkFg8JS6GmAC0eIdqNAn5l8q39X9bMNFtXTe5Cqkh0ku1+Dsp9ePPfgw0zxCBv2ItaKEHXue/WG/AEgctpQh0jSo00R+vL1N38NPHROZYEFaecW4w8zfvwYB35Q/weJ/CV0zvfOIQLRQcm7Rq+34EARtyxQORq6gaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tl2DbXJD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tl2DbXJD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC9481F00899;
	Wed, 30 Sep 2026 15:32:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790782354;
	bh=6jlHHLrZ+qBokbkBcdClpzP8ZSVFtVSGph2TJYFLXJw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tl2DbXJDAW4hN58DF+8scTBB4RI/8Vypiws2jRKw0CyJj4pTSqjtSwrm9h56ehd1A
	 GnSB7VMD2BRs4XETN41qsgcP5Ncd2XxmsLcG+vAa5gNUd2dUvWtvfgka+KKb6b7f2l
	 jhFpTtPlSkRs4U/inNYNjr59AOafFNHHRk7WarJM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukas Wunner <lukas@wunner.de>,
	Bjorn Helgaas <bhelgaas@google.com>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 005/595] PCI: Stop setting cached power state to unknown on unbind
Date: Wed, 30 Sep 2026 17:18:18 +0200
Message-ID: <20260930152347.831103053@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lukas Wunner <lukas@wunner.de>

[ Upstream commit d462c8e89e84bfb6417e6b4c88e0cb7cc747ba41 ]

When a PCI device is unbound from its driver, pci_device_remove() sets the
cached power state in pci_dev->current_state to PCI_UNKNOWN.  This was
introduced by commit 2449e06a5696 ("PCI: reset pci device state to unknown
state for resume") to invalidate the cached power state in case the system
is subsequently put to sleep.

For bound devices, the cached power state is set to PCI_UNKNOWN in
pci_pm_suspend_noirq(), immediately before entering system sleep.

Extend to unbound devices for consistency.

This obviates the need to change the cached power state on unbind, so stop
doing so.

Signed-off-by: Lukas Wunner <lukas@wunner.de>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Mario Limonciello (AMD) <superm1@kernel.org>
Link: https://patch.msgid.link/af7d11d3ceb231acc90829f7a5c8400c2446744f.1776415510.git.lukas@wunner.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pci-driver.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index fe15e59e7c56e..c831988a30306 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -463,13 +463,6 @@ static int pci_device_remove(struct device *dev)
 	/* Undo the runtime PM settings in local_pci_probe() */
 	pm_runtime_put_sync(dev);
 
-	/*
-	 * If the device is still on, set the power state as "unknown",
-	 * since it might change by the next time we load the driver.
-	 */
-	if (pci_dev->current_state == PCI_D0)
-		pci_dev->current_state = PCI_UNKNOWN;
-
 	/*
 	 * We would love to complain here if pci_dev->is_enabled is set, that
 	 * the driver should have called pci_disable_device(), but the
@@ -808,7 +801,7 @@ static int pci_pm_suspend_noirq(struct device *dev)
 
 	if (!pm) {
 		pci_save_state(pci_dev);
-		goto Fixup;
+		goto set_unknown;
 	}
 
 	if (pm->suspend_noirq) {
@@ -865,6 +858,7 @@ static int pci_pm_suspend_noirq(struct device *dev)
 		goto Fixup;
 	}
 
+set_unknown:
 	pci_pm_set_unknown_state(pci_dev);
 
 	/*
-- 
2.53.0



