Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 259CA63BB
	for <patches@lists.linux.dev>; Mon, 20 Feb 2023 14:01:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F6A8C433EF;
	Mon, 20 Feb 2023 14:01:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676901697;
	bh=UAK0CyBSGCXSNUyHpIppeaXbRFbax6hoe6kXlhew7WM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JgH7FdGeF5fXXXMmYxQgtlkM8OUT64yKp2iXvmTPpKlr+DlJSunkeA7YGvA99kL+d
	 pIxQ21MxHB7P7YL6R30ckh9DWgKGM9TR3LnKBbB0ZcJ8ZvXvwOvfMnUh7iTIrIA1lc
	 La62eKcNiLYJ4VTpHkLpOLk7F+IH2Npd/5GsFWVc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Keith Busch <kbusch@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH 6.1 116/118] nvme-pci: refresh visible attrs for cmb attributes
Date: Mon, 20 Feb 2023 14:37:12 +0100
Message-Id: <20230220133605.032953693@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133600.368809650@linuxfoundation.org>
References: <20230220133600.368809650@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Keith Busch <kbusch@kernel.org>

commit e917a849c3fc317c4a5f82bb18726000173d39e6 upstream.

The sysfs group containing the cmb attributes is registered before the
driver knows if they need to be visible or not. Update the group when
cmb attributes are known to exist so the visibility setting is correct.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=217037
Fixes: 86adbf0cdb9ec65 ("nvme: simplify transport specific device attribute handling")
Signed-off-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/host/pci.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -109,6 +109,7 @@ struct nvme_queue;
 
 static void nvme_dev_disable(struct nvme_dev *dev, bool shutdown);
 static bool __nvme_disable_io_queues(struct nvme_dev *dev, u8 opcode);
+static void nvme_update_attrs(struct nvme_dev *dev);
 
 /*
  * Represents an NVM Express device.  Each nvme_dev is a PCI function.
@@ -1967,6 +1968,8 @@ static void nvme_map_cmb(struct nvme_dev
 	if ((dev->cmbsz & (NVME_CMBSZ_WDS | NVME_CMBSZ_RDS)) ==
 			(NVME_CMBSZ_WDS | NVME_CMBSZ_RDS))
 		pci_p2pmem_publish(pdev, true);
+
+	nvme_update_attrs(dev);
 }
 
 static int nvme_set_host_mem(struct nvme_dev *dev, u32 bits)
@@ -2250,6 +2253,11 @@ static const struct attribute_group *nvm
 	NULL,
 };
 
+static void nvme_update_attrs(struct nvme_dev *dev)
+{
+	sysfs_update_group(&dev->ctrl.device->kobj, &nvme_pci_dev_attrs_group);
+}
+
 /*
  * nirqs is the number of interrupts available for write and read
  * queues. The core already reserved an interrupt for the admin queue.


