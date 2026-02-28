Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA1E62DB7B2
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:04:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301849; cv=none; b=ipLvWf3uXietofNaDK7iUER2L9CjnegHstKcrKQiraVG2bgsxUVGQ3h9HgtUlOgLLfUFuZhpUUlfyL0zOUx9pqzRuE1TtZKRE7QpAm2dn7KHpCuL1p/kJodLD1D7CiZQMViLzFA7TGs3BEdE70+5JV+zBTVZbB1Pic1CMKCIrNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301849; c=relaxed/simple;
	bh=xZkRwEKAwSYh9J8clEkpIKYq0OgcoKOHalnN4zhMOJI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BtCo0aNY71vO9f4vcJ5RMqYBzLS/HWHHXM5jf9wODAwh4qise0b6xcFSwzDDFmMYewdt6JPjgGmj3GSy2HLaNM152fVxLsvkFcCY1Fcu1VoCYkrSh6Dv9CB5xr9wF2qCnIpcjApybyLbHdsdi/vVcPlkAY4faJJCjguKHHqTyHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DO14gPcV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DO14gPcV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BD39C116D0;
	Sat, 28 Feb 2026 18:04:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301849;
	bh=xZkRwEKAwSYh9J8clEkpIKYq0OgcoKOHalnN4zhMOJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DO14gPcVOYRcDcqKi4RSrLbcvDgsljs5PNdl1IpI1KUIAAB6cB1axg4KE2pMFB0Ge
	 m3wu6CGOegy15I7Yyl+CmtngzUlknDSn7Vt9zSUJw4rCPNCX4PNhy7vOEh3xMk4a5u
	 xdL0wYAo5a+0PSUlp8Q9MRq+ClI8vanlgk6Yina5qWFcK90JZOjQOa9HtVbI/1O/S7
	 mGZFUPbQnMd6IVg0D7S6RG3VUqkZgMSO096ZSB0vdZyxRU3c05SogLIdMT938GX8Cf
	 tQYXZFpN16i9OvdbBwnXFLwmyLfLWNiYwKXiDOUJyFNeObR6pV5690091rQ2rKn4HG
	 TvXA40/berqlQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: "Anthony Pighin (Nokia)" <anthony.pighin@nokia.com>,
	Alex Williamson <alex@shazbot.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 270/385] vfio/pci: Lock upstream bridge for vfio_pci_core_disable()
Date: Sat, 28 Feb 2026 12:58:12 -0500
Message-ID: <20260228180011.1568201-270-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: "Anthony Pighin (Nokia)" <anthony.pighin@nokia.com>

[ Upstream commit 962ae6892d8bd208b2d1e2b358f07551ddc8d32f ]

The commit 7e89efc6e9e4 ("Lock upstream bridge for pci_reset_function()")
added locking of the upstream bridge to the reset function. To catch
paths that are not properly locked, the commit 920f6468924f ("Warn on
missing cfg_access_lock during secondary bus reset") added a warning
if the PCI configuration space was not locked during a secondary bus reset
request.

When a VFIO PCI device is released from userspace ownership, an attempt
to reset the PCI device function may be made. If so, and the upstream bridge
is not locked, the release request results in a warning:

   pcieport 0000:00:00.0: unlocked secondary bus reset via:
   pci_reset_bus_function+0x188/0x1b8

Add missing upstream bridge locking to vfio_pci_core_disable().

Fixes: 7e89efc6e9e4 ("PCI: Lock upstream bridge for pci_reset_function()")
Signed-off-by: Anthony Pighin <anthony.pighin@nokia.com>
Link: https://lore.kernel.org/r/BN0PR08MB695171D3AB759C65B6438B5D838DA@BN0PR08MB6951.namprd08.prod.outlook.com
Signed-off-by: Alex Williamson <alex@shazbot.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/pci/vfio_pci_core.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index c7ea0b23924af..5f545b45078f8 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -590,6 +590,7 @@ EXPORT_SYMBOL_GPL(vfio_pci_core_enable);
 
 void vfio_pci_core_disable(struct vfio_pci_core_device *vdev)
 {
+	struct pci_dev *bridge;
 	struct pci_dev *pdev = vdev->pdev;
 	struct vfio_pci_dummy_resource *dummy_res, *tmp;
 	struct vfio_pci_ioeventfd *ioeventfd, *ioeventfd_tmp;
@@ -696,12 +697,20 @@ void vfio_pci_core_disable(struct vfio_pci_core_device *vdev)
 	 * We can not use the "try" reset interface here, which will
 	 * overwrite the previously restored configuration information.
 	 */
-	if (vdev->reset_works && pci_dev_trylock(pdev)) {
-		if (!__pci_reset_function_locked(pdev))
-			vdev->needs_reset = false;
-		pci_dev_unlock(pdev);
+	if (vdev->reset_works) {
+		bridge = pci_upstream_bridge(pdev);
+		if (bridge && !pci_dev_trylock(bridge))
+			goto out_restore_state;
+		if (pci_dev_trylock(pdev)) {
+			if (!__pci_reset_function_locked(pdev))
+				vdev->needs_reset = false;
+			pci_dev_unlock(pdev);
+		}
+		if (bridge)
+			pci_dev_unlock(bridge);
 	}
 
+out_restore_state:
 	pci_restore_state(pdev);
 out:
 	pci_disable_device(pdev);
-- 
2.51.0

