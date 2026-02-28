Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21BCE33F8AD
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:52:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301132; cv=none; b=Vgx13Z+MEmM44bM1WcBAJBMIvgYfkLkm5Gb4V2YhKG/L/FZkjPXznU3cbgy+om9nbiJV4EkeM2kkEoigZTvuTPxVqg8K+QbbayuVkpUlMZNqB8+mbj4GTCesbGxuyHW/uTqvMWE/YM+d6DbpHqwFm/TZ2/XgOmxRaOLBlL8KXLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301132; c=relaxed/simple;
	bh=hMXizx8oORLrJR2qT3z54JC1eEZJrZ9YI1XXXZed91M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HqXzym+F6HhTkSuDYv25TylVPXzv/lshbz6CEDTV31s4T9qcIVw1PMvlLcsNbiSVM/J4FeOus7bpgteZFq1gdFUNmUl+2nTPb7/h2Lp9LGyIeCPlKDyQxfRXi5tmZ/L05U6bb5DwEEUoecu8xiMtzSkxcRna6x4kRLba0ulB7AE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f1+eAJRC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f1+eAJRC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E39CC116D0;
	Sat, 28 Feb 2026 17:52:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301132;
	bh=hMXizx8oORLrJR2qT3z54JC1eEZJrZ9YI1XXXZed91M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f1+eAJRC2ivOM2a9/K62G6Qcdnvkb9C6InKusiKSGiOkmI1DJwsITt2gP7EdFgcW2
	 t4RnUQE9xgiZogs5ogW5QT8oRMw3VdZQzYpPIv/qbYJB8Q9ta6Blox21Z7AsPovKKo
	 ejaAhP+w9HOtI14VgXUtjXN2IUuwZCyut20Elgk2C4NKA+Pz96SUaqZTJDh6RkdFMF
	 sWKSFO3ilgoqPonr8VmcBUUs0K9ZWXLEW/lt8CstCD0HdU6yi/WdjWPx6IUMF2EkEh
	 VtvlvJqTiUJtxrKu1rde5nr6Qz6v03QZBXsaLmCN6rp0v/08B7+0dGY0OsLD6EdFH/
	 ZGtz59y8Uf3Ow==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Keith Busch <kbusch@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 291/752] PCI: Fix pci_slot_lock () device locking
Date: Sat, 28 Feb 2026 12:40:02 -0500
Message-ID: <20260228174750.1542406-291-sashal@kernel.org>
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

From: Keith Busch <kbusch@kernel.org>

[ Upstream commit 1f5e57c622b4dc9b8e7d291d560138d92cfbe5bf ]

Like pci_bus_lock(), pci_slot_lock() needs to lock the bridge device to
prevent warnings like:

  pcieport 0000:e2:05.0: unlocked secondary bus reset via: pciehp_reset_slot+0x55/0xa0

Take and release the lock for the bridge providing the slot for the
lock/trylock and unlock routines.

Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Link: https://patch.msgid.link/20260130165953.751063-3-kbusch@meta.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pci.c | 23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 82e323b5aaa25..31d443f819a7c 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -5438,10 +5438,9 @@ static int pci_bus_trylock(struct pci_bus *bus)
 /* Do any devices on or below this slot prevent a bus reset? */
 static bool pci_slot_resettable(struct pci_slot *slot)
 {
-	struct pci_dev *dev;
+	struct pci_dev *dev, *bridge = slot->bus->self;
 
-	if (slot->bus->self &&
-	    (slot->bus->self->dev_flags & PCI_DEV_FLAGS_NO_BUS_RESET))
+	if (bridge && (bridge->dev_flags & PCI_DEV_FLAGS_NO_BUS_RESET))
 		return false;
 
 	list_for_each_entry(dev, &slot->bus->devices, bus_list) {
@@ -5458,7 +5457,10 @@ static bool pci_slot_resettable(struct pci_slot *slot)
 /* Lock devices from the top of the tree down */
 static void pci_slot_lock(struct pci_slot *slot)
 {
-	struct pci_dev *dev;
+	struct pci_dev *dev, *bridge = slot->bus->self;
+
+	if (bridge)
+		pci_dev_lock(bridge);
 
 	list_for_each_entry(dev, &slot->bus->devices, bus_list) {
 		if (!dev->slot || dev->slot != slot)
@@ -5473,7 +5475,7 @@ static void pci_slot_lock(struct pci_slot *slot)
 /* Unlock devices from the bottom of the tree up */
 static void pci_slot_unlock(struct pci_slot *slot)
 {
-	struct pci_dev *dev;
+	struct pci_dev *dev, *bridge = slot->bus->self;
 
 	list_for_each_entry(dev, &slot->bus->devices, bus_list) {
 		if (!dev->slot || dev->slot != slot)
@@ -5483,12 +5485,18 @@ static void pci_slot_unlock(struct pci_slot *slot)
 		else
 			pci_dev_unlock(dev);
 	}
+
+	if (bridge)
+		pci_dev_unlock(bridge);
 }
 
 /* Return 1 on successful lock, 0 on contention */
 static int pci_slot_trylock(struct pci_slot *slot)
 {
-	struct pci_dev *dev;
+	struct pci_dev *dev, *bridge = slot->bus->self;
+
+	if (bridge && !pci_dev_trylock(bridge))
+		return 0;
 
 	list_for_each_entry(dev, &slot->bus->devices, bus_list) {
 		if (!dev->slot || dev->slot != slot)
@@ -5513,6 +5521,9 @@ static int pci_slot_trylock(struct pci_slot *slot)
 		else
 			pci_dev_unlock(dev);
 	}
+
+	if (bridge)
+		pci_dev_unlock(bridge);
 	return 0;
 }
 
-- 
2.51.0

