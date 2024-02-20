Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 326C476C9C;
	Tue, 20 Feb 2024 21:13:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463596; cv=none; b=Cz4FnPMF4zrgCu8BDC1QtrbaeQewGehqvEzvxQ6QiwjHmRb7/WRSPKdp7wOJPv0FftP2CTQzOSo05QGByswXTQl9gmBmqdTPvl9TuiwLXOd0Shz1+cDV4Dn4MPyFcQDNTavUw/g4jww6B3AcrERy4DsCVZKyX+HeeWSulO2Mb84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463596; c=relaxed/simple;
	bh=1khHsTbyGZDMT97fjnzh39b8oTcjblOlbj+FVu2IP4o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KOtZ3w28s8lQs6xzepdxZ4tr/TyPv32aVUXI5XLUhxIxVvre/VDUh5FQxVZ5Ywy+XyO5DC5cHQ+R8xw66l9od2jgZSV6j2Loc32LV3CHZp0FreymBDq9BpZZyHTgeZU1aAtr1y2qttgzbuSwKzrOxGa4x5VHvLgcoTCDQkPo1uU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ySe34f9c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ySe34f9c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67568C433F1;
	Tue, 20 Feb 2024 21:13:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463595;
	bh=1khHsTbyGZDMT97fjnzh39b8oTcjblOlbj+FVu2IP4o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ySe34f9cm8LJFws1aV2zUOPwKD7ZktyenodDdaP/kkj+wG+NqeRZC9fXnxnE+7AJJ
	 QblkKHE1WSZYJ5Gtx3+zEd7/F7tF1MXZq0P8GriObXbkJEl0mTkwxoxzwrrqy4sUEp
	 SPy85Uh3g99npMm3zAP+XVNr30ma6ACG3PjyO4T0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sanath S <sanath.s@amd.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Lukas Wunner <lukas@wunner.de>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 093/331] PCI: Fix active state requirement in PME polling
Date: Tue, 20 Feb 2024 21:53:29 +0100
Message-ID: <20240220205640.503420365@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Williamson <alex.williamson@redhat.com>

[ Upstream commit 41044d5360685e78a869d40a168491a70cdb7e73 ]

The commit noted in fixes added a bogus requirement that runtime PM managed
devices need to be in the RPM_ACTIVE state for PME polling.  In fact, only
devices in low power states should be polled.

However there's still a requirement that the device config space must be
accessible, which has implications for both the current state of the polled
device and the parent bridge, when present.  It's not sufficient to assume
the bridge remains in D0 and cases have been observed where the bridge
passes the D0 test, but the PM state indicates RPM_SUSPENDING and config
space of the polled device becomes inaccessible during pci_pme_wakeup().

Therefore, since the bridge is already effectively required to be in the
RPM_ACTIVE state, formalize this in the code and elevate the PM usage count
to maintain the state while polling the subordinate device.

This resolves a regression reported in the bugzilla below where a
Thunderbolt/USB4 hierarchy fails to scan for an attached NVMe endpoint
downstream of a bridge in a D3hot power state.

Link: https://lore.kernel.org/r/20240123185548.1040096-1-alex.williamson@redhat.com
Fixes: d3fcd7360338 ("PCI: Fix runtime PM race with PME polling")
Reported-by: Sanath S <sanath.s@amd.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=218360
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Tested-by: Sanath S <sanath.s@amd.com>
Reviewed-by: Rafael J. Wysocki <rafael@kernel.org>
Cc: Lukas Wunner <lukas@wunner.de>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pci.c | 37 ++++++++++++++++++++++---------------
 1 file changed, 22 insertions(+), 15 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 59d6cb1a3a9d..06fc6f532d6c 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -2434,29 +2434,36 @@ static void pci_pme_list_scan(struct work_struct *work)
 		if (pdev->pme_poll) {
 			struct pci_dev *bridge = pdev->bus->self;
 			struct device *dev = &pdev->dev;
-			int pm_status;
+			struct device *bdev = bridge ? &bridge->dev : NULL;
+			int bref = 0;
 
 			/*
-			 * If bridge is in low power state, the
-			 * configuration space of subordinate devices
-			 * may be not accessible
+			 * If we have a bridge, it should be in an active/D0
+			 * state or the configuration space of subordinate
+			 * devices may not be accessible or stable over the
+			 * course of the call.
 			 */
-			if (bridge && bridge->current_state != PCI_D0)
-				continue;
+			if (bdev) {
+				bref = pm_runtime_get_if_active(bdev, true);
+				if (!bref)
+					continue;
+
+				if (bridge->current_state != PCI_D0)
+					goto put_bridge;
+			}
 
 			/*
-			 * If the device is in a low power state it
-			 * should not be polled either.
+			 * The device itself should be suspended but config
+			 * space must be accessible, therefore it cannot be in
+			 * D3cold.
 			 */
-			pm_status = pm_runtime_get_if_active(dev, true);
-			if (!pm_status)
-				continue;
-
-			if (pdev->current_state != PCI_D3cold)
+			if (pm_runtime_suspended(dev) &&
+			    pdev->current_state != PCI_D3cold)
 				pci_pme_wakeup(pdev, NULL);
 
-			if (pm_status > 0)
-				pm_runtime_put(dev);
+put_bridge:
+			if (bref > 0)
+				pm_runtime_put(bdev);
 		} else {
 			list_del(&pme_dev->list);
 			kfree(pme_dev);
-- 
2.43.0



