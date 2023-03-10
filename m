Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07BE88481
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:02:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 806E4C433EF;
	Fri, 10 Mar 2023 14:02:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678456954;
	bh=BPvNuEoIcrDhMCnlwaSg0666iVjyarZBp9q3ys8goR4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AeKpOjCnpq31qPGmTR857ux1RilxYhWrbu9T8lt65wZa7whLHNLJxvEfsCYT/tD2F
	 ySNRPVclmG4s7cEPvgqOqoVIcDcXvHoLd3dRp3JitkQFUa0RUPh8J3Z9s+ghtnFWHj
	 If4M5Wx7B4ymyc3KdOnKBzpxI59Awtv4/CSTOOn8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Chiu <chris.chiu@canonical.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 175/211] PCI: Distribute available resources for root buses, too
Date: Fri, 10 Mar 2023 14:39:15 +0100
Message-Id: <20230310133724.141324700@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.689332661@linuxfoundation.org>
References: <20230310133718.689332661@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mika Westerberg <mika.westerberg@linux.intel.com>

[ Upstream commit 7180c1d08639f28e63110ad35815f7a1785b8a19 ]

Previously we distributed spare resources only upon hot-add, so if the
initial root bus scan found devices that had not been fully configured by
the BIOS, we allocated only enough resources to cover what was then
present. If some of those devices were hotplug bridges, we did not leave
any additional resource space for future expansion.

Distribute the available resources for root buses, too, to make this work
the same way as the normal hotplug case.

A previous commit to do this was reverted due to a regression reported by
Jonathan Cameron:

  e96e27fc6f79 ("PCI: Distribute available resources for root buses, too")
  5632e2beaf9d ("Revert "PCI: Distribute available resources for root buses, too"")

This commit changes pci_bridge_resources_not_assigned() to work with
bridges that do not have all the resource windows programmed by the boot
firmware (previously we expected all I/O, memory and prefetchable memory
were programmed).

Link: https://bugzilla.kernel.org/show_bug.cgi?id=216000
Link: https://lore.kernel.org/r/20220905080232.36087-5-mika.westerberg@linux.intel.com
Link: https://lore.kernel.org/r/20230131092405.29121-4-mika.westerberg@linux.intel.com
Reported-by: Chris Chiu <chris.chiu@canonical.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/setup-bus.c | 57 ++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 56 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index b7b8dddb77722..c690572b10ce7 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -1770,7 +1770,10 @@ static void adjust_bridge_window(struct pci_dev *bridge, struct resource *res,
 	}
 
 	res->end = res->start + new_size - 1;
-	remove_from_list(add_list, res);
+
+	/* If the resource is part of the add_list, remove it now */
+	if (add_list)
+		remove_from_list(add_list, res);
 }
 
 static void remove_dev_resource(struct resource *avail, struct pci_dev *dev,
@@ -1972,6 +1975,8 @@ static void pci_bridge_distribute_available_resources(struct pci_dev *bridge,
 	if (!bridge->is_hotplug_bridge)
 		return;
 
+	pci_dbg(bridge, "distributing available resources\n");
+
 	/* Take the initial extra resources from the hotplug port */
 	available_io = bridge->resource[PCI_BRIDGE_IO_WINDOW];
 	available_mmio = bridge->resource[PCI_BRIDGE_MEM_WINDOW];
@@ -1983,6 +1988,54 @@ static void pci_bridge_distribute_available_resources(struct pci_dev *bridge,
 					       available_mmio_pref);
 }
 
+static bool pci_bridge_resources_not_assigned(struct pci_dev *dev)
+{
+	const struct resource *r;
+
+	/*
+	 * If the child device's resources are not yet assigned it means we
+	 * are configuring them (not the boot firmware), so we should be
+	 * able to extend the upstream bridge resources in the same way we
+	 * do with the normal hotplug case.
+	 */
+	r = &dev->resource[PCI_BRIDGE_IO_WINDOW];
+	if (r->flags && !(r->flags & IORESOURCE_STARTALIGN))
+		return false;
+	r = &dev->resource[PCI_BRIDGE_MEM_WINDOW];
+	if (r->flags && !(r->flags & IORESOURCE_STARTALIGN))
+		return false;
+	r = &dev->resource[PCI_BRIDGE_PREF_MEM_WINDOW];
+	if (r->flags && !(r->flags & IORESOURCE_STARTALIGN))
+		return false;
+
+	return true;
+}
+
+static void
+pci_root_bus_distribute_available_resources(struct pci_bus *bus,
+					    struct list_head *add_list)
+{
+	struct pci_dev *dev, *bridge = bus->self;
+
+	for_each_pci_bridge(dev, bus) {
+		struct pci_bus *b;
+
+		b = dev->subordinate;
+		if (!b)
+			continue;
+
+		/*
+		 * Need to check "bridge" here too because it is NULL
+		 * in case of root bus.
+		 */
+		if (bridge && pci_bridge_resources_not_assigned(dev))
+			pci_bridge_distribute_available_resources(bridge,
+								  add_list);
+		else
+			pci_root_bus_distribute_available_resources(b, add_list);
+	}
+}
+
 /*
  * First try will not touch PCI bridge res.
  * Second and later try will clear small leaf bridge res.
@@ -2022,6 +2075,8 @@ void pci_assign_unassigned_root_bus_resources(struct pci_bus *bus)
 	 */
 	__pci_bus_size_bridges(bus, add_list);
 
+	pci_root_bus_distribute_available_resources(bus, add_list);
+
 	/* Depth last, allocate resources and update the hardware. */
 	__pci_bus_assign_resources(bus, add_list, &fail_head);
 	if (add_list)
-- 
2.39.2



