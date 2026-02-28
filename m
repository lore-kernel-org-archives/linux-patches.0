Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25E49301EE6;
	Sat, 28 Feb 2026 17:56:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301410; cv=none; b=VHd3clX6GbXnJoeQQz09g6nE+L4hQ5dnmjCPFMAPH3lUtjnI95NBK5c0lALTpdO4JSo7zWo9M7Ruq91meqijZlIt8qR2CcbOiI69mXTguo1DcuQM2gWaskbBdRx/Fkps1PpvJ9aLaBTHGdwZQPGrITtsxozHdPX9xHyAG448kGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301410; c=relaxed/simple;
	bh=MenJfSJBb9oAi44ExVGtxlUCrnQXJC9zI93xwrmb4rA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fcsnKSwEiMggD8boA6fraAanly4Ovqm90FiOoALdY1bJgZjP+uxrNm6J/9Qns0afwfVE3IlG+NvA63Q0CQIYIDGFg/kCAqmVLclN9h0CkLCNoFmp6DFBSEP+0UBrbUPovf0riLy9gfBwP5qh5qokmJ/YNuvtJ/Jts3FVixQarf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sPDbgzfZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sPDbgzfZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62246C116D0;
	Sat, 28 Feb 2026 17:56:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301410;
	bh=MenJfSJBb9oAi44ExVGtxlUCrnQXJC9zI93xwrmb4rA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sPDbgzfZAxLuL99O1TF5yYnISP38sxYOJxc4pGa7bYqxJ7Wpjyq0MzRle1yNmNor1
	 rBwJirbDy9M+nmnBiy/LL+XfUo2VToF13KFMt198Q5vmRfFIxaMds1uSr/wnI4d7gV
	 RXuCIE4KaDxDjOXF4240+th8hTaXW43gbWLwdJ9mzCDUkpU0RuCkmg+5m+Q9Y0zgEd
	 wF3+2AQJQG3uvZzqpUV20foi3L/9xWkWe78ypa+LoAv9WKDXpQFi44KHmekEocO3v+
	 Ngu8Xe/SLFIGyaf1Rxd+U1BJ7N0UBqnY5YLI72g0rzUSUWtubb+lYtRWlmgMVJoTZR
	 /2vj2dbt/rpCg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Brian Norris <briannorris@chromium.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	stable@vger.kernel.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 599/752] PCI/PM: Prevent runtime suspend until devices are fully initialized
Date: Sat, 28 Feb 2026 12:45:10 -0500
Message-ID: <20260228174750.1542406-599-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Brian Norris <briannorris@chromium.org>

[ Upstream commit 51c0996dadaea20d73eb0495aeda9cb0422243e8 ]

Previously, it was possible for a PCI device to be runtime-suspended before
it was fully initialized. When that happened, the suspend process could
save invalid device state, for example, before BAR assignment. Restoring
the invalid state during resume may leave the device non-functional.

Prevent runtime suspend for PCI devices until they are fully initialized by
deferring pm_runtime_enable().

More details on how exactly this may occur:

  1. PCI device is created by pci_scan_slot() or similar

  2. As part of pci_scan_slot(), pci_pm_init() puts the device in D0 and
     prevents runtime suspend prevented via pm_runtime_forbid()

  3. pci_device_add() adds the underlying 'struct device' via device_add(),
     which means user space can allow runtime suspend, e.g.,

       echo auto > /sys/bus/pci/devices/.../power/control

  4. PCI device receives BAR configuration
     (pci_assign_unassigned_bus_resources(), etc.)

  5. pci_bus_add_device() applies final fixups, saves device state, and
     tries to attach a driver

The device may potentially be suspended between #3 and #5, so this is racy
with user space (udev or similar).

Many PCI devices are enumerated at subsys_initcall time and so will not
race with user space, but devices created later by hotplug or modular
pwrctrl or host controller drivers are susceptible to this race.

More runtime PM details at the first Link: below.

Link: https://lore.kernel.org/all/0e35a4e1-894a-47c1-9528-fc5ffbafd9e2@samsung.com/
Signed-off-by: Brian Norris <briannorris@chromium.org>
[bhelgaas: update comments per https://lore.kernel.org/r/CAJZ5v0iBNOmMtqfqEbrYyuK2u+2J2+zZ-iQd1FvyCPjdvU2TJg@mail.gmail.com]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260122094815.v5.1.I60a53c170a8596661883bd2b4ef475155c7aa72b@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/bus.c | 8 ++++++++
 drivers/pci/pci.c | 8 +++++++-
 2 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/bus.c b/drivers/pci/bus.c
index 9daf13ed3714e..81a6d356729ef 100644
--- a/drivers/pci/bus.c
+++ b/drivers/pci/bus.c
@@ -14,6 +14,7 @@
 #include <linux/of.h>
 #include <linux/of_platform.h>
 #include <linux/platform_device.h>
+#include <linux/pm_runtime.h>
 #include <linux/proc_fs.h>
 #include <linux/slab.h>
 
@@ -378,6 +379,13 @@ void pci_bus_add_device(struct pci_dev *dev)
 		put_device(&pdev->dev);
 	}
 
+	/*
+	 * Enable runtime PM, which potentially allows the device to
+	 * suspend immediately, only after the PCI state has been
+	 * configured completely.
+	 */
+	pm_runtime_enable(&dev->dev);
+
 	if (!dn || of_device_is_available(dn))
 		pci_dev_allow_binding(dev);
 
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index d147e412668bf..7858121344655 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -3225,8 +3225,14 @@ void pci_pm_init(struct pci_dev *dev)
 poweron:
 	pci_pm_power_up_and_verify_state(dev);
 	pm_runtime_forbid(&dev->dev);
+
+	/*
+	 * Runtime PM will be enabled for the device when it has been fully
+	 * configured, but since its parent and suppliers may suspend in
+	 * the meantime, prevent them from doing so by changing the
+	 * device's runtime PM status to "active".
+	 */
 	pm_runtime_set_active(&dev->dev);
-	pm_runtime_enable(&dev->dev);
 }
 
 static unsigned long pci_ea_flags(struct pci_dev *dev, u8 prop)
-- 
2.51.0

