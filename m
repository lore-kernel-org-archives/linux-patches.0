Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A1E0611A
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:41:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 165A3C433C7;
	Mon, 28 Aug 2023 10:41:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693219265;
	bh=rAJrWuU0wKOlwBAbMKOo42DrguaMzsnXXVkcJr9cOF8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zfrZg6cuTUPKeW9rgTQjAw0YkXo9uvrrzn0Gv1tzdhjkZSfJguDmFA6JY1qx3VNDJ
	 1eC3KGUrj5EyaShgjGux6Y0XN2f01E6m34T8PxJejR0lHBt8R1HNEXC4XN3LPzPhKY
	 m8ZN1klTyMNNF+xPwSmtTOuOoM+6nYyyg/TjOvTk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Igor Mammedov <imammedo@redhat.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 095/158] PCI: acpiphp: Reassign resources on bridge if necessary
Date: Mon, 28 Aug 2023 12:13:12 +0200
Message-ID: <20230828101200.497193588@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101157.322319621@linuxfoundation.org>
References: <20230828101157.322319621@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Igor Mammedov <imammedo@redhat.com>

[ Upstream commit 40613da52b13fb21c5566f10b287e0ca8c12c4e9 ]

When using ACPI PCI hotplug, hotplugging a device with large BARs may fail
if bridge windows programmed by firmware are not large enough.

Reproducer:
  $ qemu-kvm -monitor stdio -M q35  -m 4G \
      -global ICH9-LPC.acpi-pci-hotplug-with-bridge-support=on \
      -device id=rp1,pcie-root-port,bus=pcie.0,chassis=4 \
      disk_image

 wait till linux guest boots, then hotplug device:
   (qemu) device_add qxl,bus=rp1

 hotplug on guest side fails with:
   pci 0000:01:00.0: [1b36:0100] type 00 class 0x038000
   pci 0000:01:00.0: reg 0x10: [mem 0x00000000-0x03ffffff]
   pci 0000:01:00.0: reg 0x14: [mem 0x00000000-0x03ffffff]
   pci 0000:01:00.0: reg 0x18: [mem 0x00000000-0x00001fff]
   pci 0000:01:00.0: reg 0x1c: [io  0x0000-0x001f]
   pci 0000:01:00.0: BAR 0: no space for [mem size 0x04000000]
   pci 0000:01:00.0: BAR 0: failed to assign [mem size 0x04000000]
   pci 0000:01:00.0: BAR 1: no space for [mem size 0x04000000]
   pci 0000:01:00.0: BAR 1: failed to assign [mem size 0x04000000]
   pci 0000:01:00.0: BAR 2: assigned [mem 0xfe800000-0xfe801fff]
   pci 0000:01:00.0: BAR 3: assigned [io  0x1000-0x101f]
   qxl 0000:01:00.0: enabling device (0000 -> 0003)
   Unable to create vram_mapping
   qxl: probe of 0000:01:00.0 failed with error -12

However when using native PCIe hotplug
  '-global ICH9-LPC.acpi-pci-hotplug-with-bridge-support=off'
it works fine, since kernel attempts to reassign unused resources.

Use the same machinery as native PCIe hotplug to (re)assign resources.

Link: https://lore.kernel.org/r/20230424191557.2464760-1-imammedo@redhat.com
Signed-off-by: Igor Mammedov <imammedo@redhat.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Rafael J. Wysocki <rafael@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/hotplug/acpiphp_glue.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/pci/hotplug/acpiphp_glue.c b/drivers/pci/hotplug/acpiphp_glue.c
index 98be06ac2af24..8a0f2bf888536 100644
--- a/drivers/pci/hotplug/acpiphp_glue.c
+++ b/drivers/pci/hotplug/acpiphp_glue.c
@@ -496,7 +496,6 @@ static void enable_slot(struct acpiphp_slot *slot, bool bridge)
 				acpiphp_native_scan_bridge(dev);
 		}
 	} else {
-		LIST_HEAD(add_list);
 		int max, pass;
 
 		acpiphp_rescan_slot(slot);
@@ -510,12 +509,10 @@ static void enable_slot(struct acpiphp_slot *slot, bool bridge)
 				if (pass && dev->subordinate) {
 					check_hotplug_bridge(slot, dev);
 					pcibios_resource_survey_bus(dev->subordinate);
-					__pci_bus_size_bridges(dev->subordinate,
-							       &add_list);
 				}
 			}
 		}
-		__pci_bus_assign_resources(bus, &add_list, NULL);
+		pci_assign_unassigned_bridge_resources(bus->self);
 	}
 
 	acpiphp_sanitize_bus(bus);
-- 
2.40.1



