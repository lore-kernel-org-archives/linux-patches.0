Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69D1C3BBF2;
	Mon, 14 Oct 2024 15:00:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918022; cv=none; b=kRwcN70EGuvMYKPJwB0J8IDOZhjFme3mI43kRmk+BhmHXgaXQZH8oBBAdzZg9sdgKWUmxR35qhgIw1w7cEaOS02n3REXPlg6vXxK2sXH3mVgH3QqyNxZ71nAkuKrPNv+LQ6JqeGLKZovM81/WArv9JjEYLrZl9PMkFE2A/GSFfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918022; c=relaxed/simple;
	bh=DEU6npEd9RuAYYQhbC9O6iZhGg1LDx/I2+pGMw8Eo4Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iGN9gvZCH/7WMZrnTLm4IhAe5vYXpXWkahyZPj1sfPW0Gg6rIAdi1Vx7gaTm85grt37pFsO8EcvN60/zf81FH8XC5pcQd7SlLNfFUY7eHQqwZtH1Z/iRMOmuXjzzHNgtzSJm4HT7wNwcvf80U8cc9dR6UsKdpbWP5wHQKaoF47o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2sN+qMY/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2sN+qMY/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDD9EC4CEC3;
	Mon, 14 Oct 2024 15:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918022;
	bh=DEU6npEd9RuAYYQhbC9O6iZhGg1LDx/I2+pGMw8Eo4Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2sN+qMY/fsGLwLl3UCWUT1EagrpGe3A4FMS9oal/XHYAJ0sQMth5gG0bvNjy8sGT8
	 oNjd0ljz45br4HCPdOYB1XpdcpNP9qE1Se0p8LA7+yMx9XVTYSVAZPMNknDiERBHk5
	 jaFgkQyrrkJ9Y4f/+L1BYAkr4r7k2LwWDbZqMukc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 200/798] PCI: Wait for Link before restoring Downstream Buses
Date: Mon, 14 Oct 2024 16:12:34 +0200
Message-ID: <20241014141225.782982322@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index c845bc3e38e3f..0baf5c03ef4cb 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -5747,8 +5747,10 @@ static void pci_bus_restore_locked(struct pci_bus *bus)
 
 	list_for_each_entry(dev, &bus->devices, bus_list) {
 		pci_dev_restore(dev);
-		if (dev->subordinate)
+		if (dev->subordinate) {
+			pci_bridge_wait_for_secondary_bus(dev, "bus reset");
 			pci_bus_restore_locked(dev->subordinate);
+		}
 	}
 }
 
@@ -5782,8 +5784,10 @@ static void pci_slot_restore_locked(struct pci_slot *slot)
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



