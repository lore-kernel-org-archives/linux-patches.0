Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9119D2877E8;
	Sat, 12 Sep 2026 16:15:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789229724; cv=none; b=DHpseB3mfGd2/qvpjqlgHriazC6Vn1/337T2Rn+5Oq0bF2gLPM3ebGjKb9ybSw7rNXZqTkCAk62sQfFQLG5EkDnokaVAx4MVTHzAZiTVnMvwIHnHEwVbZzxQMf/qgXobn0ynMAJYlU+i780Kk7MdxyppSMLVyViBXopl2pw8fO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789229724; c=relaxed/simple;
	bh=0Dkxhk+XDMtgkVFDHd/lZsjQd4fIFuFIcoZvTlnTYzg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HGe1O2/8EH5vHcxS91JCuaE8l8Mu56Ehwl7ZIy/f2zeDrxeU6bvL8nZ5Pl/r9jGjLNek5l5kDvZ2++99W+JXQpI5frxpfRzxg8q8Vpxn2CDEfHpuBAA7Zn9Ux+SsYH6bHpDX+4i/eNOXNex7SZ5FItsy75dh+/ctnzdBsu1cqUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nfg0UjL3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nfg0UjL3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C1E61F000FF;
	Sat, 12 Sep 2026 16:15:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789229723;
	bh=jxDVfnaw17r0bbycOAVfCxpgddR7YGSBwg5mX+6pyJU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nfg0UjL3bYbXpBiCIVKXsvkgsfXFTTaUWHbGabtGZoueKcFtPe7LLp/g2TaDWK1M6
	 QnrMfQ6BssargmoOJqJg2KFSIHPfhaG9gwq6aAgH7qxuVEJlvrX2s9eDLHDf2kl3JO
	 cnGLcI8dacCMCFyurUC1Ur+SURk77kob5W8aPdvs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Romanovsky <leonro@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0605/1191] RDMA/hfi1: Remove redundant PCI device ID validation
Date: Sat, 12 Sep 2026 08:55:33 +0200
Message-ID: <20260912065601.836777204@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index e3573e833a0de..e42ca12421831 100644
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



