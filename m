Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 413C6882B
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 15:12:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8A5BC433EF;
	Fri, 10 Mar 2023 15:12:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678461131;
	bh=3/zx3gKSnsH46b7wmWLNAFpB6zm6ZDxjWnra673Vzdw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Snm874z+YthvkM53ygT8Qgo2NosQVB+wUl32Fuv7RmeymbOI42rAziTi/pbaZMPMM
	 nd8BepoEgm08hyKOS7jJLDGlEL/7iefYTuUOfgan4afm+FCysXzkYQcvrnu65SOq+u
	 Jyb+wSB+NN6asFhm9DJl948WyAxHzHRAGo5ST2xA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Berg <benjamin.berg@intel.com>,
	Richard Weinberger <richard@nod.at>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 036/136] um: virt-pci: properly remove PCI device from bus
Date: Fri, 10 Mar 2023 14:42:38 +0100
Message-Id: <20230310133708.149323900@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133706.811226272@linuxfoundation.org>
References: <20230310133706.811226272@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Benjamin Berg <benjamin.berg@intel.com>

[ Upstream commit 339b84dcd7113dd076419ea2a47128cc53450305 ]

Triggering a bus rescan will not cause the PCI device to be removed. It
is required to explicitly stop and remove the device from the bus.

Fixes: 68f5d3f3b654 ("um: add PCI over virtio emulation driver")
Signed-off-by: Benjamin Berg <benjamin.berg@intel.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/um/drivers/virt-pci.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/arch/um/drivers/virt-pci.c b/arch/um/drivers/virt-pci.c
index 2829347d1e906..d762d726b66cf 100644
--- a/arch/um/drivers/virt-pci.c
+++ b/arch/um/drivers/virt-pci.c
@@ -618,22 +618,33 @@ static void um_pci_virtio_remove(struct virtio_device *vdev)
 	struct um_pci_device *dev = vdev->priv;
 	int i;
 
-        /* Stop all virtqueues */
-        vdev->config->reset(vdev);
-        vdev->config->del_vqs(vdev);
-
 	device_set_wakeup_enable(&vdev->dev, false);
 
 	mutex_lock(&um_pci_mtx);
 	for (i = 0; i < MAX_DEVICES; i++) {
 		if (um_pci_devices[i].dev != dev)
 			continue;
+
 		um_pci_devices[i].dev = NULL;
 		irq_free_desc(dev->irq);
+
+		break;
 	}
 	mutex_unlock(&um_pci_mtx);
 
-	um_pci_rescan();
+	if (i < MAX_DEVICES) {
+		struct pci_dev *pci_dev;
+
+		pci_dev = pci_get_slot(bridge->bus, i);
+		if (pci_dev)
+			pci_stop_and_remove_bus_device_locked(pci_dev);
+	}
+
+	/* Stop all virtqueues */
+	virtio_reset_device(vdev);
+	dev->cmd_vq = NULL;
+	dev->irq_vq = NULL;
+	vdev->config->del_vqs(vdev);
 
 	kfree(dev);
 }
-- 
2.39.2



