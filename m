Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 750FA143C41;
	Tue, 23 Apr 2024 21:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908705; cv=none; b=AHTblvNAUtU3MQMrnGsEyrzZJzXAh5CAAg9J+SlNgLAerkUwsCdOO4Oh4EgcFfis/kxe8p4wYSwNlg58VgWA10akrqnAGnPk0JR+gBTMWG/6r/QWcTKB+rbP7MMkpZb9wkceVEcMdt9UPV4+RL7ZX+q9jaJx2fiXd7PePIt9PQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908705; c=relaxed/simple;
	bh=DXx3KRPXYqmWtdNU0T9BOdd2PmdlUrRIG4g5oZjxBUk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=klVZaacDo9Q5b5DozKuLwp9NzpRJsovRmL/aBjX374ybdzXFe4vuZb4B31VHK7BYYPBnSFMn1G7Rr1XFwRE+7PXDjPkUHcTKpa5kq2KYkU18dudfdy3rhWHDYlMHHY23o6vMjxZrCW+fW+RknVnMKz0qTPO4WKGaBa6F8TCpyKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q3GO3+sb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q3GO3+sb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40AB9C3277B;
	Tue, 23 Apr 2024 21:45:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908705;
	bh=DXx3KRPXYqmWtdNU0T9BOdd2PmdlUrRIG4g5oZjxBUk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q3GO3+sblUS35SLTMoTazhquHkgzITJuwHQZ8FR8GuigkyuRg9+z6vQDs8cyfHn4d
	 FDP4pNeeOetNOhIsnhx2/M/20CTw7LYLiHKJu2nr22oOLskBtY+gCJX5kUCScKgGkQ
	 5P6xX6+iIHGO7jHVe5x7pesdOqLBuglBV/V9+OLQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Pastore <mike@oobak.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 060/141] PCI: Delay after FLR of Solidigm P44 Pro NVMe
Date: Tue, 23 Apr 2024 14:38:48 -0700
Message-ID: <20240423213855.197611419@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213853.356988651@linuxfoundation.org>
References: <20240423213853.356988651@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Pastore <mike@oobak.org>

[ Upstream commit 0ac448e0d29d6ba978684b3fa2e3ac7294ec2475 ]

Prevent KVM hang when a Solidgm P44 Pro NVMe is passed through to a guest
via IOMMU and the guest is subsequently rebooted.

A similar issue was identified and patched by 51ba09452d11 ("PCI: Delay
after FLR of Intel DC P3700 NVMe") and the same fix can be applied for this
case. (Intel spun off their NAND and SSD business as Solidigm and sold it
to SK Hynix in late 2021.)

Link: https://lore.kernel.org/r/20230507073519.9737-1-mike@oobak.org
Signed-off-by: Mike Pastore <mike@oobak.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/quirks.c    | 10 ++++++----
 include/linux/pci_ids.h |  2 ++
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index d8d3f817e95cb..92169dc71468e 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -4011,10 +4011,11 @@ static int nvme_disable_and_flr(struct pci_dev *dev, bool probe)
 }
 
 /*
- * Intel DC P3700 NVMe controller will timeout waiting for ready status
- * to change after NVMe enable if the driver starts interacting with the
- * device too soon after FLR.  A 250ms delay after FLR has heuristically
- * proven to produce reliably working results for device assignment cases.
+ * Some NVMe controllers such as Intel DC P3700 and Solidigm P44 Pro will
+ * timeout waiting for ready status to change after NVMe enable if the driver
+ * starts interacting with the device too soon after FLR.  A 250ms delay after
+ * FLR has heuristically proven to produce reliably working results for device
+ * assignment cases.
  */
 static int delay_250ms_after_flr(struct pci_dev *dev, bool probe)
 {
@@ -4101,6 +4102,7 @@ static const struct pci_dev_reset_methods pci_dev_reset_methods[] = {
 	{ PCI_VENDOR_ID_SAMSUNG, 0xa804, nvme_disable_and_flr },
 	{ PCI_VENDOR_ID_INTEL, 0x0953, delay_250ms_after_flr },
 	{ PCI_VENDOR_ID_INTEL, 0x0a54, delay_250ms_after_flr },
+	{ PCI_VENDOR_ID_SOLIDIGM, 0xf1ac, delay_250ms_after_flr },
 	{ PCI_VENDOR_ID_CHELSIO, PCI_ANY_ID,
 		reset_chelsio_generic_dev },
 	{ PCI_VENDOR_ID_HUAWEI, PCI_DEVICE_ID_HINIC_VF,
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 73cc1e7dd15ad..9e9794d03c9fc 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -158,6 +158,8 @@
 
 #define PCI_VENDOR_ID_LOONGSON		0x0014
 
+#define PCI_VENDOR_ID_SOLIDIGM		0x025e
+
 #define PCI_VENDOR_ID_TTTECH		0x0357
 #define PCI_DEVICE_ID_TTTECH_MC322	0x000a
 
-- 
2.43.0



