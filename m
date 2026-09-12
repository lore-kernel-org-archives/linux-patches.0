Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1AAF34CFDA;
	Sat, 12 Sep 2026 12:16:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789215381; cv=none; b=eVtpUr79+eXRN1+NuU9X/fuojHG+eZhWS284/7FDEn6WQMRKfoxDOGIgmSREbEsp6WV9LJhni6/fg+KYSFmFdJYCB8NQUg+11ett7wp0WKD1Ks8SI/Uym+QaPypd7n50/etqjmhrlHS9pI3vvutpAzVV5jIieXN+ImUT5ecU5Io=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789215381; c=relaxed/simple;
	bh=FHgk40OGBu2f6hFKaE7LCyZ33Q7y+RuyLApmvmqn3GI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Np/jERdoAFgNSmVKdP0Dg0NZMYfdkSVO+EbSMz0WyS0rTWoqb0BXDMbXzqaVYmvuPD+8EbqPA8CM1V/jLXR51MGB17sWqhh7deYaidF79HSYG2Vm4dFANhvbymiKwKdQYx5EYV/VXNYtYxV0cmJ1nOr9dRx+PQmy0aP0xVrCels=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QwESYH5R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QwESYH5R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C8A61F000FF;
	Sat, 12 Sep 2026 12:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789215380;
	bh=LRvYsagbDgMmSmk504OBJJgutQVNFkC95mztZoG0mFY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QwESYH5RyAF4H/fjN8/aMqgsJSfcd7dTtE42E4B4ot+rCwJGPf4cy6fUSNTBZDNjQ
	 6qzy5iyGmhPgqPoPN3y6MkQxX//T8z3Cg7h22HjsYgNKQ5XGp2GHtnKXvEWf+3gIBL
	 Fjeol7l/KDAuH/ZCHCKFewyCF41lauY0SetY6eRI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Romanovsky <leonro@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0513/1376] RDMA/hfi1: Remove redundant PCI device ID validation
Date: Sat, 12 Sep 2026 08:48:59 +0200
Message-ID: <20260912065618.971856291@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index d6331f90222d8..fc6c01d64050e 100644
--- a/drivers/infiniband/hw/hfi1/init.c
+++ b/drivers/infiniband/hw/hfi1/init.c
@@ -1563,15 +1563,6 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
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



