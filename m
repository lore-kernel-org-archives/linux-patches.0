Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E245326938;
	Sat, 12 Sep 2026 14:25:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789223141; cv=none; b=TBMWvlYr9r0F+RO0MQtYTmEhhltZvWUsiDYBs1DX2MIp/U5T/DWjiSJIPVZU74p+KdaIy5rmDast4B2rJHnZRxqRBZ67MZ8L57wK8vb+CnjIkiQ0lpcTWU9KBDJJsxXUW2ZOKBvNd3gk8YtOf7fg5MKkESUmahTIdmpfYQlBF6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789223141; c=relaxed/simple;
	bh=nYmfWnOIuEbAa/mcdSrxKaISVyltWPYOr8qIeKuSvJ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G1p66RFrPGPgBd2DArOArcyILqyPQ4RYMqAbzn7pky6fEDRvXOPZsoaFD8TqhJVwshUk0qgVoQgQnIDSjZdVy8jpEIqxx6oUATZJXXHozjXwQ3C+TC1QGhODa9UOOy14RsphCW+wjJyu4V9gVr0Vtf87pM3pXLX6KMi2PI2RQ7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Itg9yCqd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Itg9yCqd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E55D21F000FF;
	Sat, 12 Sep 2026 14:25:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789223140;
	bh=UHVdTlbHH9JZtzG/oA1I07pnurjz76OWu4O9xcSifqE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Itg9yCqdDVnam34uJPTo0A26N2rJrBuFbHjwN0+j8whgbnTnubmhBDow077br1fOx
	 WG4Mg4e+helgH3CrsjXOD3BtL/yA0syX/zjZQWVT8AxMKMKCV+Sur7HaIaGDbNo21u
	 KLV4vsfA2Xaf6YXinxQPEC9hZezkbPEKm4dAq4Bw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Romanovsky <leonro@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0730/1424] RDMA/hfi1: Remove redundant PCI device ID validation
Date: Sat, 12 Sep 2026 08:52:42 +0200
Message-ID: <20260912065623.640538248@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leon Romanovsky <leonro@nvidia.com>

[ Upstream commit af9117d02f50514c998714b23820de71d0aa5d24 ]

The PCI core calls init_one() only after pci_match_device() has selected
an ID. For normal probing, hfi1_pci_tbl already restricts matches to the
two supported Intel device IDs. Dynamic IDs and driver_override are
explicit requests to attempt binding, so the probe should not second-guess
the PCI core's decision.

Remove the redundant check.

Link: https://patch.msgid.link/20260708-clean-init-one-hfi1-v1-3-b9e9641268a5@nvidia.com
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Stable-dep-of: 9f674ba674a0 ("RDMA/hfi1: Allocate device data after PCI initialization")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hfi1/init.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/init.c b/drivers/infiniband/hw/hfi1/init.c
index 0a14f0ad38361..2f5319f9d2990 100644
--- a/drivers/infiniband/hw/hfi1/init.c
+++ b/drivers/infiniband/hw/hfi1/init.c
@@ -1564,15 +1564,6 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	/* First, lock the non-writable module parameters */
 	HFI1_CAP_LOCK();
 
-	/* Validate dev ids */
-	if (!(ent->device == PCI_DEVICE_ID_INTEL0 ||
-	      ent->device == PCI_DEVICE_ID_INTEL1)) {
-		dev_err(&pdev->dev, "Failing on unknown Intel deviceid 0x%x\n",
-			ent->device);
-		ret = -ENODEV;
-		goto bail;
-	}
-
 	/* Allocate the dd so we can get to work */
 	dd = hfi1_alloc_devdata(pdev, NUM_IB_PORTS *
 				sizeof(struct hfi1_pportdata));
-- 
2.53.0



