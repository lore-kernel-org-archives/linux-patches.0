Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA9254F3EAA;
	Wed, 30 Sep 2026 17:01:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787691; cv=none; b=XHmacFrrpAOvrg1pp+3OEDcq+MwZdhqtOXWswXyDG3rhuGF9/1L14uJAKjlbcyBy5PrrO5wGZoYLFk3jxHjqBYgqr8ZzN9VQK/RZKqYbeUBzLfhsNEtKPsjY8Mw4Zx7dwNNbwg6qpdBDrqJ8pwN57qeCNSCgnN1mCDeVeXOH2BU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787691; c=relaxed/simple;
	bh=sBAsI1PQfBw3kxmZicPhVlxXCPj5YsuJyNF7/jWmaPI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eGvrdGI7envA0tOvyJ0j+MhjePlArE2ki+z8sLqs2qWeXtup00U8KCGEk2KpJ5/3WxV7ZbbcOPOzpUorchuqUDPa4IU8V1R+y0Sbl9GKrd1jYBpEFU57JfZZMn2psH+5E7336RFPD+spUXBlOKyF1oCBB51LbatWHV4jDidCm2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SL1hOXtu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SL1hOXtu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 504AC1F000FF;
	Wed, 30 Sep 2026 17:01:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787689;
	bh=DYgVZ6dWivLiUBuG00B5aYfCpRmuwBwrD/EpEeycML8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SL1hOXtunEhACH151WFPcHdKL2cWF3BueWe/3GH2GfK+AeIoSpOQo7VNvhaqyFdCv
	 ahJJV8wCWFQ9FOlrLEtuUWPJrXUehHVFukYnd3bwi8zHupwPg7IerVhHy++yAyorgf
	 tBtg1F49tzhKJaOO37HTtDiVEs6br0ZxcVGImnMg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Liz Fong-Jones <lizf@honeycomb.io>,
	Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 7.2 319/457] PCI: Fix BAR resize for devices on a root bus
Date: Wed, 30 Sep 2026 17:27:04 +0200
Message-ID: <20260930152352.910470973@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
User-Agent: quilt/0.69
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liz Fong-Jones <lizf@honeycomb.io>

commit d58384c22739848efe14b34e9586e4f1242f33c0 upstream.

pci_do_resource_release_and_resize() releases device BARs that share a
bridge window with the BAR being resized, but when the device sits directly
on a root bus (pdev->bus->self == NULL) it then skips resource assignment
entirely and returns success, leaving the BARs it just released unassigned
(IORESOURCE_UNSET).

Skipping pbus_reassign_bridge_resources() is correct in that case -- there
is no bridge window to adjust -- but the device BARs still have to be
reassigned. Before the BAR release was consolidated into the PCI core, this
case worked for amdgpu because the driver released the BARs itself and then
called pci_assign_unassigned_bus_resources() unconditionally after the
resize, which assigns unassigned device BARs also on a root bus. Commit
db92e3fef53e ("drm/amdgpu: Remove driver side BAR release before resize")
removed that call, so nothing assigns the released BARs anymore.

This breaks amdgpu completely on the SolidRun HoneyComb LX2K (NXP LX2160A,
arm64, ACPI), where ACPI doesn't expose the Root Port so the GPU endpoint
appears directly on a "root bus" of its segment:

  amdgpu 0004:01:00.0: BAR 0 [mem 0xa400000000-0xa40fffffff 64bit pref]: releasing
  amdgpu 0004:01:00.0: BAR 2 [mem 0xa410000000-0xa4101fffff 64bit pref]: releasing
  amdgpu 0004:01:00.0: sw_init of IP block <gmc_v8_0> failed -19
  amdgpu 0004:01:00.0: amdgpu_device_ip_init failed
  amdgpu 0004:01:00.0: Fatal error during GPU init

No error is logged because the resize path reports success; amdgpu then
finds BAR 0 IORESOURCE_UNSET and bails out with -ENODEV.

When there is no upstream bridge, call pci_bus_assign_resources() on the
root bus to place the BARs released above, using the same alignment-sorted
algorithm as normal enumeration instead of a manual per-BAR loop. This also
walks the rest of the hierarchy under the root bus, as
pci_assign_unassigned_bus_resources() used to for amdgpu before commit
db92e3fef53e ("drm/amdgpu: Remove driver side BAR release before resize")
removed that call -- the core-side fix that commit asked for ("such a
problem should be fixed inside pci_resize_resource() instead").

pci_bus_assign_resources() returns void, so failure is detected by checking
whether the released BARs are still assigned afterward; if not, roll back
as in the bridged case. This is stricter than the bridged path -- it fails
on any unplaced resource, not just required ones -- since a root bus
typically has one shared window, and failing loudly seemed better than
leaving something silently unassigned.

The root bus path also had a locking bug that any fix here necessarily
touches: the old "goto out" jumped to up_read(&pci_bus_sem) without a
matching down_read() (as does the "goto restore" taken when
pci_dev_res_add_to_list() fails in the release loop). Take pci_bus_sem
before the BAR release loop so every path through the function holds it
exactly once.

Fixes: 337b1b566db0 ("PCI: Fix restoring BARs on BAR resize rollback path")
Link: https://bugs.launchpad.net/ubuntu/+source/linux-hwe-7.0/+bug/2159596
Suggested-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Assisted-by: Claude:claude-fable-5 checkpatch
Assisted-by: Claude:claude-sonnet-5
Signed-off-by: Liz Fong-Jones <lizf@honeycomb.io>
[bhelgaas: commit log]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260918035633.566823-1-lizf@honeycomb.io
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/setup-bus.c |   25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -2380,6 +2380,7 @@ int pci_do_resource_release_and_resize(s
 	struct resource *res = pci_resource_n(pdev, resno);
 	struct pci_dev_resource *dev_res;
 	struct pci_bus *bus = pdev->bus;
+	struct pci_dev *bridge = pci_upstream_bridge(pdev);
 	struct resource *b_win, *r;
 	LIST_HEAD(saved);
 	unsigned int i;
@@ -2397,6 +2398,8 @@ int pci_do_resource_release_and_resize(s
 	if (ret)
 		return ret;
 
+	down_read(&pci_bus_sem);
+
 	pci_dev_for_each_resource(pdev, r, i) {
 		if (i >= PCI_BRIDGE_RESOURCES)
 			break;
@@ -2415,13 +2418,21 @@ int pci_do_resource_release_and_resize(s
 
 	pci_resize_resource_set_size(pdev, resno, size);
 
-	if (!bus->self)
-		goto out;
-
-	down_read(&pci_bus_sem);
-	ret = pbus_reassign_bridge_resources(bus, res, &saved);
-	if (ret)
-		goto restore;
+	if (bridge) {
+		ret = pbus_reassign_bridge_resources(bus, res, &saved);
+		if (ret)
+			goto restore;
+	} else {
+		/* No bridge window to adjust; let the core reassign the bus. */
+		pci_bus_assign_resources(bus);
+
+		list_for_each_entry(dev_res, &saved, list) {
+			if (!resource_assigned(dev_res->res)) {
+				ret = -ENOSPC;
+				goto restore;
+			}
+		}
+	}
 
 out:
 	up_read(&pci_bus_sem);


