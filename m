Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4EC01D0491;
	Wed,  2 Oct 2024 13:36:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876214; cv=none; b=rRoJDdt6bMUKubCRtC8bErZ2QdJKfLz63TdPGlmMXmIp++HtlvRtlXtjOXAN1TSSEUVTezjdTYJfwioHhLfAEYaiA2xd+ESNvdmtZXUbSgcDaQTuhyyPzct/GAXGwevyckv9Eaal/t6Y8V4IGxRgTnznPeSXLAA1dal/Pi+RrgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876214; c=relaxed/simple;
	bh=tiJL+PV6Q8UjPpOGd/t5wS8ACfEQiaqqGN0As5ztFTI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bs/x69ow//g7B4G3M/o9vltK8gYbr0U96BB0dtqaNQ/Nvs8pRsBolNAuEA5m69rcSWZO/O/2izYIyq9WHBk/Y8IOlrFnYZGwA6SB3BQ69qLh76OVfWjxn597PVv4ufqx/zXOyLIGjIBAtaNV/+3wIUqRdta8ORdqPm2pO2I1/Ys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J6NCzVPn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J6NCzVPn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C1D3C4CEC5;
	Wed,  2 Oct 2024 13:36:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876214;
	bh=tiJL+PV6Q8UjPpOGd/t5wS8ACfEQiaqqGN0As5ztFTI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J6NCzVPn0uv9S+VO8aNb3QQgyBVIZj3DWJz8DK6gEJEwNSMdIOfV/quWWPNgNT0t2
	 bBSRRUP1LGuGRA+7A5oDUfDbOSMMLjLwn10gkyT26ujoXRodCsXtbdMMThJvsuVY5g
	 //CGHtZRprhY3EmskWLr7koqY4Ke6GoWgxLF/Zok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 368/695] PCI: Wait for Link before restoring Downstream Buses
Date: Wed,  2 Oct 2024 14:56:06 +0200
Message-ID: <20241002125837.138543570@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index ffaaca0978cbc..5c1d53398f95d 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -5672,8 +5672,10 @@ static void pci_bus_restore_locked(struct pci_bus *bus)
 
 	list_for_each_entry(dev, &bus->devices, bus_list) {
 		pci_dev_restore(dev);
-		if (dev->subordinate)
+		if (dev->subordinate) {
+			pci_bridge_wait_for_secondary_bus(dev, "bus reset");
 			pci_bus_restore_locked(dev->subordinate);
+		}
 	}
 }
 
@@ -5707,8 +5709,10 @@ static void pci_slot_restore_locked(struct pci_slot *slot)
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



