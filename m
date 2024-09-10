Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BDBE1552FD;
	Tue, 10 Sep 2024 10:45:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725965122; cv=none; b=M0DC67ARVe7LN8gDtFUziNUP0Xib85f+L+EyAmfVcSAXz8LkZDVFDrfEdnY4rT/f0o2lRb/9ElUGXr8xvtBySj/B1oY8PVIk3gy29olgaPLcer4ziIXai60ACD6J64l6SdyG+GUvGiYcv2K6DkFdgyD20pCgWSvGSl/yv/Z45go=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725965122; c=relaxed/simple;
	bh=xLZRTOiHvyynuxW+tdiSLwf0Sbv2BCgiVK5KaU9lJic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XGy5htV8e4y3QTvXALFqtAMamNvKjZQq4rU9lBQSMLBz6Yg12iXMsTQiHBjqwOxs3R0b8GQxvCXmj5BkwmkYZ1fhE+ce/Om+47cD6R+qXjOWG6A/BCHNo5+vGKTtarbaJjqAcjJ4bB6a9a3YYJq+A2Rq3EKAsN+6CPhsjGhi0A8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FTYbkhM/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FTYbkhM/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 236A7C4CEC3;
	Tue, 10 Sep 2024 10:45:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725965122;
	bh=xLZRTOiHvyynuxW+tdiSLwf0Sbv2BCgiVK5KaU9lJic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FTYbkhM/Cw8Pg/hxEmiwVWTw7eyL1VikZ5pNDEx+KythNjj/s97XdUxq0Cwhr/0mp
	 P2nHhlrZWUpJarsGxlrThNWTmORNB7Ngzu/57j9gqInjXS8MUU4LOSxJHkBmNRNMzw
	 zRjujgfZKtUPUyMu6j3z5a2uKGsRPo2pi/dy6z30=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Imre Deak <imre.deak@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Keith Busch <kbusch@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Kalle Valo <kvalo@kernel.org>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 144/186] PCI: Add missing bridge lock to pci_bus_lock()
Date: Tue, 10 Sep 2024 11:33:59 +0200
Message-ID: <20240910092600.535369366@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092554.645718780@linuxfoundation.org>
References: <20240910092554.645718780@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Williams <dan.j.williams@intel.com>

[ Upstream commit a4e772898f8bf2e7e1cf661a12c60a5612c4afab ]

One of the true positives that the cfg_access_lock lockdep effort
identified is this sequence:

  WARNING: CPU: 14 PID: 1 at drivers/pci/pci.c:4886 pci_bridge_secondary_bus_reset+0x5d/0x70
  RIP: 0010:pci_bridge_secondary_bus_reset+0x5d/0x70
  Call Trace:
   <TASK>
   ? __warn+0x8c/0x190
   ? pci_bridge_secondary_bus_reset+0x5d/0x70
   ? report_bug+0x1f8/0x200
   ? handle_bug+0x3c/0x70
   ? exc_invalid_op+0x18/0x70
   ? asm_exc_invalid_op+0x1a/0x20
   ? pci_bridge_secondary_bus_reset+0x5d/0x70
   pci_reset_bus+0x1d8/0x270
   vmd_probe+0x778/0xa10
   pci_device_probe+0x95/0x120

Where pci_reset_bus() users are triggering unlocked secondary bus resets.
Ironically pci_bus_reset(), several calls down from pci_reset_bus(), uses
pci_bus_lock() before issuing the reset which locks everything *but* the
bridge itself.

For the same motivation as adding:

  bridge = pci_upstream_bridge(dev);
  if (bridge)
    pci_dev_lock(bridge);

to pci_reset_function() for the "bus" and "cxl_bus" reset cases, add
pci_dev_lock() for @bus->self to pci_bus_lock().

Link: https://lore.kernel.org/r/171711747501.1628941.15217746952476635316.stgit@dwillia2-xfh.jf.intel.com
Reported-by: Imre Deak <imre.deak@intel.com>
Closes: http://lore.kernel.org/r/6657833b3b5ae_14984b29437@dwillia2-xfh.jf.intel.com.notmuch
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
[bhelgaas: squash in recursive locking deadlock fix from Keith Busch:
https://lore.kernel.org/r/20240711193650.701834-1-kbusch@meta.com]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Tested-by: Hans de Goede <hdegoede@redhat.com>
Tested-by: Kalle Valo <kvalo@kernel.org>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pci.c | 35 +++++++++++++++++++++--------------
 1 file changed, 21 insertions(+), 14 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 09d5fa637b98..800df0f1417d 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -5260,10 +5260,12 @@ static void pci_bus_lock(struct pci_bus *bus)
 {
 	struct pci_dev *dev;
 
+	pci_dev_lock(bus->self);
 	list_for_each_entry(dev, &bus->devices, bus_list) {
-		pci_dev_lock(dev);
 		if (dev->subordinate)
 			pci_bus_lock(dev->subordinate);
+		else
+			pci_dev_lock(dev);
 	}
 }
 
@@ -5275,8 +5277,10 @@ static void pci_bus_unlock(struct pci_bus *bus)
 	list_for_each_entry(dev, &bus->devices, bus_list) {
 		if (dev->subordinate)
 			pci_bus_unlock(dev->subordinate);
-		pci_dev_unlock(dev);
+		else
+			pci_dev_unlock(dev);
 	}
+	pci_dev_unlock(bus->self);
 }
 
 /* Return 1 on successful lock, 0 on contention */
@@ -5284,15 +5288,15 @@ static int pci_bus_trylock(struct pci_bus *bus)
 {
 	struct pci_dev *dev;
 
+	if (!pci_dev_trylock(bus->self))
+		return 0;
+
 	list_for_each_entry(dev, &bus->devices, bus_list) {
-		if (!pci_dev_trylock(dev))
-			goto unlock;
 		if (dev->subordinate) {
-			if (!pci_bus_trylock(dev->subordinate)) {
-				pci_dev_unlock(dev);
+			if (!pci_bus_trylock(dev->subordinate))
 				goto unlock;
-			}
-		}
+		} else if (!pci_dev_trylock(dev))
+			goto unlock;
 	}
 	return 1;
 
@@ -5300,8 +5304,10 @@ static int pci_bus_trylock(struct pci_bus *bus)
 	list_for_each_entry_continue_reverse(dev, &bus->devices, bus_list) {
 		if (dev->subordinate)
 			pci_bus_unlock(dev->subordinate);
-		pci_dev_unlock(dev);
+		else
+			pci_dev_unlock(dev);
 	}
+	pci_dev_unlock(bus->self);
 	return 0;
 }
 
@@ -5333,9 +5339,10 @@ static void pci_slot_lock(struct pci_slot *slot)
 	list_for_each_entry(dev, &slot->bus->devices, bus_list) {
 		if (!dev->slot || dev->slot != slot)
 			continue;
-		pci_dev_lock(dev);
 		if (dev->subordinate)
 			pci_bus_lock(dev->subordinate);
+		else
+			pci_dev_lock(dev);
 	}
 }
 
@@ -5361,14 +5368,13 @@ static int pci_slot_trylock(struct pci_slot *slot)
 	list_for_each_entry(dev, &slot->bus->devices, bus_list) {
 		if (!dev->slot || dev->slot != slot)
 			continue;
-		if (!pci_dev_trylock(dev))
-			goto unlock;
 		if (dev->subordinate) {
 			if (!pci_bus_trylock(dev->subordinate)) {
 				pci_dev_unlock(dev);
 				goto unlock;
 			}
-		}
+		} else if (!pci_dev_trylock(dev))
+			goto unlock;
 	}
 	return 1;
 
@@ -5379,7 +5385,8 @@ static int pci_slot_trylock(struct pci_slot *slot)
 			continue;
 		if (dev->subordinate)
 			pci_bus_unlock(dev->subordinate);
-		pci_dev_unlock(dev);
+		else
+			pci_dev_unlock(dev);
 	}
 	return 0;
 }
-- 
2.43.0



