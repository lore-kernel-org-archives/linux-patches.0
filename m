Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29EAA3CF42;
	Wed, 21 Feb 2024 14:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708525408; cv=none; b=ITTKfDIrkj4ajFBWn3F42Y2UIEQHjPLUHMhFDc7qtNYxZjpoqCiAF+tZ3IHE1Sn71/SO7y/nAUpBGzePX+cstWVzUmlnn2HSAOSO2l2B1onemiQUEPBoCyk2RLfL2f6NM8ME6ePHgslRLazE3xYKjWAHrJ+/fctJzFi0UFSvUL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708525408; c=relaxed/simple;
	bh=ZT/GXNB3Ui7g/T1/y4nS+64ab7EAkd6xg+RZomtp2WE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZveEv5owCXPAfZdJS0rzN5gDi9IRLL90sdCALnIRf1km6FtCvKkmEhMv+DjUve9RGrrT2dP5EqcnIp5WUwKPUZ2c+IH1Dmy+we9vt6wd0G6QC0/c9VKHjnCVXkRDVnzO8scEUzEQ28MlotpnyJuRzHJW/kFi/S5hXfH5pYIgBPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aba7CRzz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aba7CRzz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79B02C433C7;
	Wed, 21 Feb 2024 14:23:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708525408;
	bh=ZT/GXNB3Ui7g/T1/y4nS+64ab7EAkd6xg+RZomtp2WE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aba7CRzzVFVb1Tr0kH5tmkgOYpw7c9ZyM043yplY6sECVEE4xWGkVOm/1tjtqOLsm
	 YLmH1h67TGbSHwCedCYazHFbD2EHJ/6wa0+Qkec1LNOOfqdQ0ejPnnQN0O5773BjQv
	 y+sA4QzJZVDV+KgSLfqU1p6iJq/pCnWCgAxzA5+I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Stodden <dns@arista.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Dmitry Safonov <dima@arista.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 147/267] PCI: switchtec: Fix stdev_release() crash after surprise hot remove
Date: Wed, 21 Feb 2024 14:08:08 +0100
Message-ID: <20240221125944.671325300@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125940.058369148@linuxfoundation.org>
References: <20240221125940.058369148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Stodden <dns@arista.com>

[ Upstream commit df25461119d987b8c81d232cfe4411e91dcabe66 ]

A PCI device hot removal may occur while stdev->cdev is held open. The call
to stdev_release() then happens during close or exit, at a point way past
switchtec_pci_remove(). Otherwise the last ref would vanish with the
trailing put_device(), just before return.

At that later point in time, the devm cleanup has already removed the
stdev->mmio_mrpc mapping. Also, the stdev->pdev reference was not a counted
one. Therefore, in DMA mode, the iowrite32() in stdev_release() will cause
a fatal page fault, and the subsequent dma_free_coherent(), if reached,
would pass a stale &stdev->pdev->dev pointer.

Fix by moving MRPC DMA shutdown into switchtec_pci_remove(), after
stdev_kill(). Counting the stdev->pdev ref is now optional, but may prevent
future accidents.

Reproducible via the script at
https://lore.kernel.org/r/20231113212150.96410-1-dns@arista.com

Link: https://lore.kernel.org/r/20231122042316.91208-2-dns@arista.com
Signed-off-by: Daniel Stodden <dns@arista.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
Reviewed-by: Dmitry Safonov <dima@arista.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/switch/switchtec.c | 25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff --git a/drivers/pci/switch/switchtec.c b/drivers/pci/switch/switchtec.c
index 2c9c3061894b..0037f368f62b 100644
--- a/drivers/pci/switch/switchtec.c
+++ b/drivers/pci/switch/switchtec.c
@@ -1082,13 +1082,6 @@ static void stdev_release(struct device *dev)
 {
 	struct switchtec_dev *stdev = to_stdev(dev);
 
-	if (stdev->dma_mrpc) {
-		iowrite32(0, &stdev->mmio_mrpc->dma_en);
-		flush_wc_buf(stdev);
-		writeq(0, &stdev->mmio_mrpc->dma_addr);
-		dma_free_coherent(&stdev->pdev->dev, sizeof(*stdev->dma_mrpc),
-				stdev->dma_mrpc, stdev->dma_mrpc_dma_addr);
-	}
 	kfree(stdev);
 }
 
@@ -1131,7 +1124,7 @@ static struct switchtec_dev *stdev_create(struct pci_dev *pdev)
 		return ERR_PTR(-ENOMEM);
 
 	stdev->alive = true;
-	stdev->pdev = pdev;
+	stdev->pdev = pci_dev_get(pdev);
 	INIT_LIST_HEAD(&stdev->mrpc_queue);
 	mutex_init(&stdev->mrpc_mutex);
 	stdev->mrpc_busy = 0;
@@ -1165,6 +1158,7 @@ static struct switchtec_dev *stdev_create(struct pci_dev *pdev)
 	return stdev;
 
 err_put:
+	pci_dev_put(stdev->pdev);
 	put_device(&stdev->dev);
 	return ERR_PTR(rc);
 }
@@ -1407,6 +1401,18 @@ static int switchtec_init_pci(struct switchtec_dev *stdev,
 	return 0;
 }
 
+static void switchtec_exit_pci(struct switchtec_dev *stdev)
+{
+	if (stdev->dma_mrpc) {
+		iowrite32(0, &stdev->mmio_mrpc->dma_en);
+		flush_wc_buf(stdev);
+		writeq(0, &stdev->mmio_mrpc->dma_addr);
+		dma_free_coherent(&stdev->pdev->dev, sizeof(*stdev->dma_mrpc),
+				  stdev->dma_mrpc, stdev->dma_mrpc_dma_addr);
+		stdev->dma_mrpc = NULL;
+	}
+}
+
 static int switchtec_pci_probe(struct pci_dev *pdev,
 			       const struct pci_device_id *id)
 {
@@ -1464,6 +1470,9 @@ static void switchtec_pci_remove(struct pci_dev *pdev)
 	ida_simple_remove(&switchtec_minor_ida, MINOR(stdev->dev.devt));
 	dev_info(&stdev->dev, "unregistered.\n");
 	stdev_kill(stdev);
+	switchtec_exit_pci(stdev);
+	pci_dev_put(stdev->pdev);
+	stdev->pdev = NULL;
 	put_device(&stdev->dev);
 }
 
-- 
2.43.0



