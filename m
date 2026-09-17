Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5CFC4CDDDF;
	Thu, 17 Sep 2026 17:46:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667208; cv=none; b=rjEvJJtGx5K7nnOoeebT/J3d4bRbaaFiXmicuVbQalxYGDauRZESfEHprTT/heOeq8bhRPWSJRKSKFieLQObnyMZzp5Z+9afLWkIrHA95hjd337RAJCHrh7UdTDKrKNQSjx8P9Ev00bN4rWNLeLuFOGH3q0jb2AYVCGthY5zHjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667208; c=relaxed/simple;
	bh=dulYP9qAWeH2BP3oM63xeZYTOFh8UnKWXkQ0ZBrUOD8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YaSnrX6WkDbNFGvCyNar9pWfVCB+5wvPpGGG/yj8JEVFk3h9vUOskkc3+wMzf8oPE4I+za/IMMG39z3tIHnfrxkXIZxWJmVNnmbt37QjJ9RtxTUoO0g+IGcV6Jbi4YyqNolhtwJJHiD+wui34lG5YQYow8kIODEsvG/jL+WTSYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IAB/LhKe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IAB/LhKe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0960B1F000FF;
	Thu, 17 Sep 2026 17:46:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667207;
	bh=XISRK/nifg6IBFOnk/209S97I3SfsXDFc2xKr7Lee5o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IAB/LhKeYXC+87kcye0bwnVp/+9WheU4fQIQaRJmZTlIiOjWDBm8c3ylc1HSXZYg3
	 x8NTZfl4bWOIn947yRpXXnbnQffhNfpb3AMsROZqa+c0tyDufMm3uCWblnV6YtY7Xo
	 XuuE5gQ7+UogIDZLkiFWi5xAizyBWDrRYn+RVAlg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukas Wunner <lukas@wunner.de>,
	Bjorn Helgaas <bhelgaas@google.com>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0017/1102] PCI: Stop setting cached power state to unknown on unbind
Date: Thu, 17 Sep 2026 15:59:20 +0100
Message-ID: <20260917151539.860456780@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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
index f0fbe45bfb9a1..0eb246a07c87a 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -490,13 +490,6 @@ static void pci_device_remove(struct device *dev)
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
@@ -874,7 +867,7 @@ static int pci_pm_suspend_noirq(struct device *dev)
 
 	if (!pm) {
 		pci_save_state(pci_dev);
-		goto Fixup;
+		goto set_unknown;
 	}
 
 	if (pm->suspend_noirq) {
@@ -926,6 +919,7 @@ static int pci_pm_suspend_noirq(struct device *dev)
 		goto Fixup;
 	}
 
+set_unknown:
 	pci_pm_set_unknown_state(pci_dev);
 
 	/*
-- 
2.53.0



