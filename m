Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D720638DC7B;
	Sat, 12 Sep 2026 19:50:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242640; cv=none; b=jpMEPu8yPYMYVraaRApw245fOAnnMFFWkKjRosOfceFz6LsfqFhJaI1M31x9tn3BnObkD7K/42rsuqU/RyXh+xT+2uf6wC4/8cqIc0vojLm+Mj/96rAOpqXsGmOD16NRVIr4BHo5yoWqOMU0AWIzUJfm1LIEcJiYh5q6A+pkwoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242640; c=relaxed/simple;
	bh=UZ6MGdA3N/vE4fLIU8Q7yxRGFjLjyTL866EhLUGjTwM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kIwu3c0dNkOYv3mD2HarYbqbk6FfZpLJEVnI2T5hSWRj6CU2mh2nQjORSVbxrv2jFWqj64MMPA8wTalyEJy4H1j4aR8ZHpOm302a7BiPbEK+7LKo55AXgscwYFs5xXHuWZhUfSg5SxhjqkpkiwHt3KEhk3wXa5ho8v7Kt6zMUT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cUjQIhkj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cUjQIhkj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D62A1F00893;
	Sat, 12 Sep 2026 19:50:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242637;
	bh=ZRdJeh/HSI5kAIk6Y0RjC9RrsNvPSjuhVd9U6viFwK4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cUjQIhkjWKZydsmSkF/xBNsU6yVFTrmyHI5dlC6ZHftozMYKCcbfwPbg1s2ZzsUL/
	 MeS/r7AXhps3pCNXFE7KIY5/BwKENM2acoJC37zsLGPGcruEMYPjCerTsAglcS/DQU
	 KLtbyX76dI823YGyeJkrjaZNa2rxwPkxHfjQ9PUo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Romanovsky <leonro@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 431/798] RDMA/hfi1: Remove redundant PCI device ID validation
Date: Sat, 12 Sep 2026 09:00:59 +0200
Message-ID: <20260912065527.024701800@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index c4d098344d8e2..990078d58170d 100644
--- a/drivers/infiniband/hw/hfi1/init.c
+++ b/drivers/infiniband/hw/hfi1/init.c
@@ -1605,15 +1605,6 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
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



