Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EAC417DFFA;
	Sat, 12 Sep 2026 09:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789207177; cv=none; b=nruVFJywy0WXzjFz2ssYtE6mR7LbpB3sv9VGK5sQBc4JHXDe+HctW1P3bXFBGUX+Gg0Xq1zUOj7Nf+GMNHvLh0QkrogKbbo40AIY6CUnnNmVSoP7xhO5ILV2tumhnmhdcKndHvhMoDN5JXNZlM5UX/ARHIIPEcf7ATupw+ClUY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789207177; c=relaxed/simple;
	bh=m1WFruepR83Llg059udNcUUvgEs2eZ3sEnfNyhpCKzc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ANxZDefVrMvG37BdL2uytD41OM7UuoYMau5xJ/SGNzGVmCeH1vwRNeD85tJtznEHI2mPdK40bW/rjJ5AqCzQ3KasqS8tqHjoUbp+P5NxP77oKQ+uUkXx0FCe7Ufel7s0lg5woFxUF8d4WQg0HPNTOJBYP1XQOSEw9j7GoAdZfoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cpMW9QVj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cpMW9QVj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CC241F000FF;
	Sat, 12 Sep 2026 09:59:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789207175;
	bh=O4LabD0zABLNnfW3GjrllkQfSKrHtRROmZWZLhLUXsE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cpMW9QVj5uEEbSuhB+i4xHQTpwf+Yq0xxnn+p4jroEGeGukdwk7ZyT/q+JVPHyV35
	 gaIDPsCG66eGBekCIVedAe2fySL7M2yKFiflszeE//g5j7N92CceRtSMXcvOhtAex+
	 493wZyvPj5XgjmFcNY3CcYgmTGfD8zBorR2Ootp4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0358/1518] RDMA/hfi1: Initialize debugfs after probe completes
Date: Sat, 12 Sep 2026 08:42:07 +0200
Message-ID: <20260912065631.570003367@linuxfoundation.org>
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

[ Upstream commit bb18740b302f6f222ce3d5a7e5c45a52a90df805 ]

Commit ed6f653fe430 ("staging/rdma/hfi1: Fix debugfs access race") moved
debugfs creation after device initialization and IB registration so users
cannot access the files before the driver is ready. However, init_one()
still creates them before character device creation and SDMA startup
finish.

Move hfi1_dbg_ibdev_init() to the end of the successful probe path,
matching hfi1_dbg_ibdev_exit() as the first action in remove_one().

Fixes: ed6f653fe430 ("staging/rdma/hfi1: Fix debugfs access race")
Link: https://patch.msgid.link/20260708-clean-init-one-hfi1-v1-12-b9e9641268a5@nvidia.com
Reviewed-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hfi1/init.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/init.c b/drivers/infiniband/hw/hfi1/init.c
index 6253d8088abd6..f0b3d53243687 100644
--- a/drivers/infiniband/hw/hfi1/init.c
+++ b/drivers/infiniband/hw/hfi1/init.c
@@ -1647,11 +1647,8 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	 * we still create devices, so diags, etc. can be used
 	 * to determine cause of problem.
 	 */
-	if (!initfail && !ret) {
+	if (!initfail && !ret)
 		dd->flags |= HFI1_INITTED;
-		/* create debufs files after init and ib register */
-		hfi1_dbg_ibdev_init(&dd->verbs_dev);
-	}
 
 	j = hfi1_device_create(dd);
 	if (j)
@@ -1684,6 +1681,7 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	}
 
 	sdma_start(dd);
+	hfi1_dbg_ibdev_init(&dd->verbs_dev);
 
 	return 0;
 
-- 
2.53.0



