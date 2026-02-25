Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BABF18B0A;
	Wed, 25 Feb 2026 01:35:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983341; cv=none; b=lHwxayburrrUBAxe29ghVaAbCZHmthU90gqEvfJPHqzvKZb5a2lWBYVX6WN6ntkhh9X+l103G2j2H4zCx+DF9R6QP8fYC1fwr8Ex2HviPrBSyCtYJZSobjvSHzO7W2t5bTds4w2dJW7hK1Qan1gegmdG1qCnF3m93dBVCyazMTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983341; c=relaxed/simple;
	bh=CchCZ7PgvW4H14IlsVOJDEejxBFjHr36cu7uVaz323A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TKanVkdHm8iwUETU0apFt8k0NCBUoS2EdXqyyvTSpqZ+LnqFEirKA98vm80qtuUU7ku/ohla9eEb5AAL2JN+irO3Ka+tPnBMfozviUMQndCcXY+QX/12GRpiaXc/lE9VJtNZk1hJCzGaMw+fontGRnd8EOItdWSciwhY7mhf97k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I/KHAFFs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I/KHAFFs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 183CDC116D0;
	Wed, 25 Feb 2026 01:35:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983341;
	bh=CchCZ7PgvW4H14IlsVOJDEejxBFjHr36cu7uVaz323A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I/KHAFFsOEgu4xreTcTHlEglItRnqm9F2WrB24p0zKm+jcHR035INEDTyJ+bsMRES
	 3FNL+gcA6zH6KZ2fUvWq3OiVkmK7hReBP4hrRAmOYHAcHbtZJ7uI+Lx1bJrglPlzWI
	 GWZ1MrHTutIaiQ2uI2pW7HJmpv0yA+99gxvqB0nE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anthony Pighin <anthony.pighin@nokia.com>,
	Alex Williamson <alex@shazbot.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 470/781] vfio/pci: Lock upstream bridge for vfio_pci_core_disable()
Date: Tue, 24 Feb 2026 17:19:39 -0800
Message-ID: <20260225012411.348618427@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anthony Pighin (Nokia) <anthony.pighin@nokia.com>

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
index 3a11e6f450f70..72c33b399800e 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -588,6 +588,7 @@ EXPORT_SYMBOL_GPL(vfio_pci_core_enable);
 
 void vfio_pci_core_disable(struct vfio_pci_core_device *vdev)
 {
+	struct pci_dev *bridge;
 	struct pci_dev *pdev = vdev->pdev;
 	struct vfio_pci_dummy_resource *dummy_res, *tmp;
 	struct vfio_pci_ioeventfd *ioeventfd, *ioeventfd_tmp;
@@ -694,12 +695,20 @@ void vfio_pci_core_disable(struct vfio_pci_core_device *vdev)
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



