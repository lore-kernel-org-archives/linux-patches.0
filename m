Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55C6F2F617C;
	Sat, 12 Sep 2026 18:44:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789238669; cv=none; b=tnTgssu0sGOQICefHLFb6fGvKi/tNVT9XPM/p9tSKHGXaU2M1V4iFJfx5wefsx+Tp3lL4JTofsATWd4pN/4kTeQGkP/ZB3RDkkUsU6l7I01iZPubJQkDKzH71LUoBnUQ3Hmd/3WxqwV1xYB4jFdPgjqUpKUXl+0j4JimUo7ZtVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789238669; c=relaxed/simple;
	bh=YOtJEHVDlv3BeNIsRW+VG4ArW7kmZctqpWrW2RnD8+w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aao8Nr0cmuqmmQTV0qzRdvgqCxWUPhWXLQuWp9QB7UenT3AuHx3Med22N00NznpBoCdS+K92dWETk5PPTr6NcvCYGhhSNtzgHF0YOMQhzO6ECayVp/BjMLn2lO0kltJtqULRb52GRiB47sU9XL340QGe1gql8dBUd73KRovkFMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SEGbs0EQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SEGbs0EQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F48A1F000FF;
	Sat, 12 Sep 2026 18:44:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789238668;
	bh=ZUHIkGTfApe2ZOGaQ0pZwlfpGJVrbMSPjMBHTmLslSI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SEGbs0EQCCRrF4DsIafUWpzohDT6DFYvEriaRnSjBsIKVmuAgaACmIvQXZUfyF4a9
	 +Zlx/kMpnLfX9zdyWYhaaM2hhubVAZEXXr+VSOK19t9b4Oqxwk5fYGxuZv8Qs5WDd+
	 69GFZo7t+Gyp48eDgl+zFL7YalTVA9w9SvS5GQVo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Romanovsky <leonro@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 509/935] RDMA/hfi1: Remove redundant PCI device ID validation
Date: Sat, 12 Sep 2026 08:58:59 +0200
Message-ID: <20260912065538.493938215@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 1a3930c2db7e5..23f98ab437f63 100644
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



