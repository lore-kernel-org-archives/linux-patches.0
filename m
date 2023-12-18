Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E113C1D134;
	Mon, 18 Dec 2023 13:53:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wtFzYik6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A291C433C7;
	Mon, 18 Dec 2023 13:53:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702907591;
	bh=RiX9Wa1RMRMc51E4etZz1+7VZY6ZsXJx9oQm5Q/HpEE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wtFzYik6inHAOnqn6wVvliaspucSsPGBlHCLPcQiecnRC0PFnmnWtcyA0OSlwijtV
	 Q8SuJxJ1Cq6UI7oZVVwURe7KtSbMZV9XebJTDkdF9j2ejJQ390R1RHyfFAUDrfq7en
	 kchioYQ/9Ii32jZJLSWRKGCiXDvG0wohL9tHnUvE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fiona Ebner <f.ebner@proxmox.com>,
	Dongli Zhang <dongli.zhang@oracle.com>,
	Jonathan Woithe <jwoithe@just42.net>,
	Bjorn Helgaas <bhelgaas@google.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>
Subject: [PATCH 4.19 16/36] Revert "PCI: acpiphp: Reassign resources on bridge if necessary"
Date: Mon, 18 Dec 2023 14:51:26 +0100
Message-ID: <20231218135042.439566084@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231218135041.876499958@linuxfoundation.org>
References: <20231218135041.876499958@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bjorn Helgaas <bhelgaas@google.com>

commit 5df12742b7e3aae2594a30a9d14d5d6e9e7699f4 upstream.

This reverts commit 40613da52b13fb21c5566f10b287e0ca8c12c4e9 and the
subsequent fix to it:

  cc22522fd55e ("PCI: acpiphp: Use pci_assign_unassigned_bridge_resources() only for non-root bus")

40613da52b13 fixed a problem where hot-adding a device with large BARs
failed if the bridge windows programmed by firmware were not large enough.

cc22522fd55e ("PCI: acpiphp: Use pci_assign_unassigned_bridge_resources()
only for non-root bus") fixed a problem with 40613da52b13: an ACPI hot-add
of a device on a PCI root bus (common in the virt world) or firmware
sending ACPI Bus Check to non-existent Root Ports (e.g., on Dell Inspiron
7352/0W6WV0) caused a NULL pointer dereference and suspend/resume hangs.

Unfortunately the combination of 40613da52b13 and cc22522fd55e caused other
problems:

  - Fiona reported that hot-add of SCSI disks in QEMU virtual machine fails
    sometimes.

  - Dongli reported a similar problem with hot-add of SCSI disks.

  - Jonathan reported a console freeze during boot on bare metal due to an
    error in radeon GPU initialization.

Revert both patches to avoid adding these problems.  This means we will
again see the problems with hot-adding devices with large BARs and the NULL
pointer dereferences and suspend/resume issues that 40613da52b13 and
cc22522fd55e were intended to fix.

Fixes: 40613da52b13 ("PCI: acpiphp: Reassign resources on bridge if necessary")
Fixes: cc22522fd55e ("PCI: acpiphp: Use pci_assign_unassigned_bridge_resources() only for non-root bus")
Reported-by: Fiona Ebner <f.ebner@proxmox.com>
Closes: https://lore.kernel.org/r/9eb669c0-d8f2-431d-a700-6da13053ae54@proxmox.com
Reported-by: Dongli Zhang <dongli.zhang@oracle.com>
Closes: https://lore.kernel.org/r/3c4a446a-b167-11b8-f36f-d3c1b49b42e9@oracle.com
Reported-by: Jonathan Woithe <jwoithe@just42.net>
Closes: https://lore.kernel.org/r/ZXpaNCLiDM+Kv38H@marvin.atrad.com.au
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Igor Mammedov <imammedo@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/hotplug/acpiphp_glue.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

--- a/drivers/pci/hotplug/acpiphp_glue.c
+++ b/drivers/pci/hotplug/acpiphp_glue.c
@@ -510,15 +510,12 @@ static void enable_slot(struct acpiphp_s
 				if (pass && dev->subordinate) {
 					check_hotplug_bridge(slot, dev);
 					pcibios_resource_survey_bus(dev->subordinate);
-					if (pci_is_root_bus(bus))
-						__pci_bus_size_bridges(dev->subordinate, &add_list);
+					__pci_bus_size_bridges(dev->subordinate,
+							       &add_list);
 				}
 			}
 		}
-		if (pci_is_root_bus(bus))
-			__pci_bus_assign_resources(bus, &add_list, NULL);
-		else
-			pci_assign_unassigned_bridge_resources(bus->self);
+		__pci_bus_assign_resources(bus, &add_list, NULL);
 	}
 
 	acpiphp_sanitize_bus(bus);


