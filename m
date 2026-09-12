Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E696F41B8CC;
	Sat, 12 Sep 2026 09:59:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789207162; cv=none; b=UhOFR6xbBqSv5NXNPDxBx61GvnteuRZy20J/Ecb/TRVax32JE5mroApFzBnHG5z0qbkvKSL7b5P5F9NCDuQkAU18B+ERjVRtb8N6CiyrnGkBrRTutcnhvSn3XJfCHKWJwBOp1moAhbpT9u8qrBtKq9cAeBLe8bRkoEHaNNdOln4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789207162; c=relaxed/simple;
	bh=PgyCnX9J9dINSaS5/ZGJF/lyvtJ9mwcMkT7L832I5ok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t4PMaQ7yU/9hO1e9LWouRAverE1kbQE84rx1Hw6LFRZbwBc4GE0VqHz4B184tBcGoNVMKO5oFX2r0W15rD+L1dbiDPXm9p6S6qF1+JJSqPtgpEhvK7Ls929VEbsBTDQNzgPymrYP8D88CCR97Pm7w3tkvoDkQ8B5WFqDoq2ROJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nXaPeinP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nXaPeinP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBA4B1F000FF;
	Sat, 12 Sep 2026 09:59:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789207160;
	bh=LcshXsvB+TGbIdVs2PLFyn1m0hrPpSuk+uMp9kNu6kk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nXaPeinPRXvt4Wz3E21QPaKnIR4FRGXg4BqCKL/z8v56zDP7jfSO3avV5OaNtqBE+
	 qm4OpY4KZqpInzPg9GqEN4jVih99KNEL4bJBj8Pm0mETAFT6yq/HNPjurNALTTfv6p
	 A17cTFDeXy1wmhAbgrRmF0VwTzqE7B8RpZl78qeg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Romanovsky <leonro@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0355/1518] RDMA/hfi1: Remove redundant PCI device ID validation
Date: Sat, 12 Sep 2026 08:42:04 +0200
Message-ID: <20260912065631.504296812@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index cb6851a5df60e..b20c0c0ddfa79 100644
--- a/drivers/infiniband/hw/hfi1/init.c
+++ b/drivers/infiniband/hw/hfi1/init.c
@@ -1573,15 +1573,6 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
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



