Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 076D11D0797;
	Wed,  2 Oct 2024 14:10:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878207; cv=none; b=aqer698tlIxwrcFyhuLvjCMi8lOTFWqfW1h+oN8HfJk2nCjUJOe6A6xUMdRrnmZQ7qb3g6PWK3/tSVJDv+YPiVT+7xkCNl8nV+uby1lg/k5sb/7JH9x57MToksbXCl48d9FDRKFEIpSR+1JFCQ+VNREqhojiV3P2UDA8qUzV+EM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878207; c=relaxed/simple;
	bh=7ppr5TR9ND+5kTrtQEtbCQy7M6IcCu2qVV1qER0i0HQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hfvvETZihKB9O0kyA7vNlMu3GAwHB1aPzlICQ9beornTC5Co9o/NiC4oQudgbso8A1wZPJCFteXv+SCOVzfOSVrEqPUJNwRn2WUn11MMvxc0fHl6iFSOLA9P2U7ePGBW9deJ+xzE+lTUQphGZiTZkTfyqvTSJ5m1MVA1Tkaz4OQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sEQUcgI6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sEQUcgI6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81430C4CEC2;
	Wed,  2 Oct 2024 14:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878206;
	bh=7ppr5TR9ND+5kTrtQEtbCQy7M6IcCu2qVV1qER0i0HQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sEQUcgI6qdSdPMfxB0PGQZjWCQM4tpfwGppL60O2YT3cGnoL6HUQeKtPvWGvPNFmp
	 UVV+ETbs2h57q4J6RrAMr7ApRZn2pTQEuI+XSa4ZoohGgg5IHIy4VG40jHPIM/e0H4
	 2zR42x0ArLmiingVEmG3wdyahvPu5+41QzKjhvhw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 333/634] PCI: Wait for Link before restoring Downstream Buses
Date: Wed,  2 Oct 2024 14:57:13 +0200
Message-ID: <20241002125824.247510794@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

[ Upstream commit 3e40aa29d47e231a54640addf6a09c1f64c5b63f ]

__pci_reset_bus() calls pci_bridge_secondary_bus_reset() to perform the
reset and also waits for the Secondary Bus to become again accessible.
__pci_reset_bus() then calls pci_bus_restore_locked() that restores the PCI
devices connected to the bus, and if necessary, recursively restores also
the subordinate buses and their devices.

The logic in pci_bus_restore_locked() does not take into account that after
restoring a device on one level, there might be another Link Downstream
that can only start to come up after restore has been performed for its
Downstream Port device. That is, the Link may require additional wait until
it becomes accessible.

Similarly, pci_slot_restore_locked() lacks wait.

Amend pci_bus_restore_locked() and pci_slot_restore_locked() to wait for
the Secondary Bus before recursively performing the restore of that bus.

Fixes: 090a3c5322e9 ("PCI: Add pci_reset_slot() and pci_reset_bus()")
Link: https://lore.kernel.org/r/20240808121708.2523-1-ilpo.jarvinen@linux.intel.com
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pci.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 8db214d4b1d46..c20ce49eecc94 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -5598,8 +5598,10 @@ static void pci_bus_restore_locked(struct pci_bus *bus)
 
 	list_for_each_entry(dev, &bus->devices, bus_list) {
 		pci_dev_restore(dev);
-		if (dev->subordinate)
+		if (dev->subordinate) {
+			pci_bridge_wait_for_secondary_bus(dev, "bus reset");
 			pci_bus_restore_locked(dev->subordinate);
+		}
 	}
 }
 
@@ -5633,8 +5635,10 @@ static void pci_slot_restore_locked(struct pci_slot *slot)
 		if (!dev->slot || dev->slot != slot)
 			continue;
 		pci_dev_restore(dev);
-		if (dev->subordinate)
+		if (dev->subordinate) {
+			pci_bridge_wait_for_secondary_bus(dev, "slot reset");
 			pci_bus_restore_locked(dev->subordinate);
+		}
 	}
 }
 
-- 
2.43.0



