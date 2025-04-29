Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4083624DFF3;
	Tue, 29 Apr 2025 17:55:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949302; cv=none; b=Qmfb4hdSMXyYAHTJl/C4O7HWzwk1gxyIEHGLL5Ai+qmLCmBb/vvVZIoUlYc7nsu1DPjoj63tZczyVpk8XAUXbPCSMr/YqgZAP4pvu/MsqIPRJlLwjQfGgZ9NnNkUzNomWpKymnpUnQxJoOMZVfjz3NVNxKXXLLu9g4dCaSR9u/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949302; c=relaxed/simple;
	bh=5f1KFwrmx6d3zNz+CUNCVc6bNzz3K4MJNFX6hPnXXzg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FOsacwpcmalof6AQq1bV1kEcShWAy+VRqb6c9RXEJlu1HAYdckHGr2+KBSHULy8/ykd2rvZAO2MrFx2/Hb1fzHVKU+p6z73Bd0BbXDgUV3oXPIt70BG9Mz4da6Ko4rY0m8BzDGOyLh264BuYydC+bSHAlsukqSdpMtY9NqYdWYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oHsI+pB9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oHsI+pB9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0E75C4CEE3;
	Tue, 29 Apr 2025 17:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949302;
	bh=5f1KFwrmx6d3zNz+CUNCVc6bNzz3K4MJNFX6hPnXXzg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oHsI+pB9vPD3NHH5IhkCyE9Oru7syPhz2dHVBeidB12HNPDjCX3FUyvG2oT0UO4oR
	 x1PN3P1pHymDpRHrH0+8d+XF2PX0C2SkEC+BzWCot5HESvDPs0War/p6YnksLZuqK2
	 EyJUn4NKvucCfO9PBdUumoDaeYLOumr2c4vfJw78=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bjorn Helgaas <bhelgaas@google.com>,
	Kai-Heng Feng <kai.heng.feng@canonical.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 275/373] PCI: Coalesce host bridge contiguous apertures
Date: Tue, 29 Apr 2025 18:42:32 +0200
Message-ID: <20250429161134.437519046@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kai-Heng Feng <kai.heng.feng@canonical.com>

[ Upstream commit 7c3855c423b17f6ca211858afb0cef20569914c7 ]

Built-in graphics at 07:00.0 on HP EliteDesk 805 G6 doesn't work because
graphics can't get the BAR it needs.  The BIOS configuration is
correct: BARs 0 and 2 both fit in the 00:08.1 bridge window.

But that 00:08.1 window covers two host bridge apertures from _CRS.
Previously we assumed this was illegal, so we clipped the window to fit
into one aperture (see 0f7e7aee2f37 ("PCI: Add pci_bus_clip_resource() to
clip to fit upstream window")).

  pci_bus 0000:00: root bus resource [mem 0x10020200000-0x100303fffff window]
  pci_bus 0000:00: root bus resource [mem 0x10030400000-0x100401fffff window]

  pci 0000:00:08.1:   bridge window [mem 0x10030000000-0x100401fffff 64bit pref]
  pci 0000:07:00.0: reg 0x10: [mem 0x10030000000-0x1003fffffff 64bit pref]
  pci 0000:07:00.0: reg 0x18: [mem 0x10040000000-0x100401fffff 64bit pref]

  pci 0000:00:08.1: can't claim BAR 15 [mem 0x10030000000-0x100401fffff 64bit pref]: no compatible bridge window
  pci 0000:00:08.1: [mem 0x10030000000-0x100401fffff 64bit pref] clipped to [mem 0x10030000000-0x100303fffff 64bit pref]
  pci 0000:00:08.1:   bridge window [mem 0x10030000000-0x100303fffff 64bit pref]

  pci 0000:07:00.0: can't claim BAR 0 [mem 0x10030000000-0x1003fffffff 64bit pref]: no compatible bridge window
  pci 0000:07:00.0: can't claim BAR 2 [mem 0x10040000000-0x100401fffff 64bit pref]: no compatible bridge window

However, the host bridge apertures are contiguous, so there's no need to
clip in this case.  Coalesce contiguous apertures so we can allocate from
the entire contiguous region.

Previous commit 65db04053efe ("PCI: Coalesce host bridge contiguous
apertures") was similar but sorted the apertures, and Guenter Roeck
reported a regression in ppc:sam460ex qemu emulation from nvme; see
https://lore.kernel.org/all/20210709231529.GA3270116@roeck-us.net/

[bhelgaas: commit log]
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=212013
Suggested-by: Bjorn Helgaas <bhelgaas@google.com>
Link: https://lore.kernel.org/r/20210713125007.1260304-1-kai.heng.feng@canonical.com
Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Stable-dep-of: 804443c1f278 ("PCI: Fix reference leak in pci_register_host_bridge()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/probe.c | 31 +++++++++++++++++++++++++++----
 1 file changed, 27 insertions(+), 4 deletions(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 3ad0b2839041c..3ed2eb893dcca 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -883,11 +883,11 @@ static void pci_set_bus_msi_domain(struct pci_bus *bus)
 static int pci_register_host_bridge(struct pci_host_bridge *bridge)
 {
 	struct device *parent = bridge->dev.parent;
-	struct resource_entry *window, *n;
+	struct resource_entry *window, *next, *n;
 	struct pci_bus *bus, *b;
-	resource_size_t offset;
+	resource_size_t offset, next_offset;
 	LIST_HEAD(resources);
-	struct resource *res;
+	struct resource *res, *next_res;
 	char addr[64], *fmt;
 	const char *name;
 	int err;
@@ -969,11 +969,34 @@ static int pci_register_host_bridge(struct pci_host_bridge *bridge)
 	if (nr_node_ids > 1 && pcibus_to_node(bus) == NUMA_NO_NODE)
 		dev_warn(&bus->dev, "Unknown NUMA node; performance will be reduced\n");
 
+	/* Coalesce contiguous windows */
+	resource_list_for_each_entry_safe(window, n, &resources) {
+		if (list_is_last(&window->node, &resources))
+			break;
+
+		next = list_next_entry(window, node);
+		offset = window->offset;
+		res = window->res;
+		next_offset = next->offset;
+		next_res = next->res;
+
+		if (res->flags != next_res->flags || offset != next_offset)
+			continue;
+
+		if (res->end + 1 == next_res->start) {
+			next_res->start = res->start;
+			res->flags = res->start = res->end = 0;
+		}
+	}
+
 	/* Add initial resources to the bus */
 	resource_list_for_each_entry_safe(window, n, &resources) {
-		list_move_tail(&window->node, &bridge->windows);
 		offset = window->offset;
 		res = window->res;
+		if (!res->end)
+			continue;
+
+		list_move_tail(&window->node, &bridge->windows);
 
 		if (res->flags & IORESOURCE_BUS)
 			pci_bus_insert_busn_res(bus, bus->number, res->end);
-- 
2.39.5



