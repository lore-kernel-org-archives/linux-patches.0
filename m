Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2A11235358;
	Sat, 12 Sep 2026 07:34:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198443; cv=none; b=h/JMLFecAMq9x046ClkeVK+IXDzy+90JeIO9rf9JHMPC2ZX4aI9xf19b/avc49C9gRiUnHbHyk1YxQ0J7NVNo2cf5AM1MXZUwPRq5khM5pGcBwEIGTsvCKncOKT/xFnbD8ap4z+Qt06qlD77EOjw34aodYMzvicYvtsauVmJIrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198443; c=relaxed/simple;
	bh=MBrILGEqouqgehAJ6nsKgTIA7zBWirVx2XIKhKe+SDU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CAnBFKCFXAJ84fAXIwuVc8iuJEuJuZ2mt4zXYEnuj3DV6jY72nD10kZY2EocgS1MXOcs1m0pnCt/JDaglqh9SGnuANTx6oJsy6QJeCVsVYvddnBT+ZyuEpFf/HCT6j29oh5h0rd+0KyRmjOdPffD7GY+5wWrYlvTSHCoPuiIr1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yGkS7Y+8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yGkS7Y+8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B683C1F000FF;
	Sat, 12 Sep 2026 07:34:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789198442;
	bh=kzqN7iprRWReG2aYxnq7F89cO0KY8SjnOh4ZZOIQlX8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yGkS7Y+8q8yETdJsOM1KVo3zLS7waFfQhdC2F1oRcqDA6sBYtu3rl7LKeIdpzqo97
	 DaqcZlNbylB7oTiT4UrONXMqAdn9hpr7ltYRunIkBCRKHe+X26zIHmTqIZArGR36FT
	 nZZ6l+MEEQYVHnrXAN9deVI+HzsqYNy4783NJ0YU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0364/1815] RDMA/hfi1: Initialize debugfs after probe completes
Date: Sat, 12 Sep 2026 08:35:14 +0200
Message-ID: <20260912065657.448695679@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 0ec1d8123e180..c5f005e5b812c 100644
--- a/drivers/infiniband/hw/hfi1/init.c
+++ b/drivers/infiniband/hw/hfi1/init.c
@@ -1656,11 +1656,8 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
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
@@ -1693,6 +1690,7 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	}
 
 	sdma_start(dd);
+	hfi1_dbg_ibdev_init(&dd->verbs_dev);
 
 	return 0;
 
-- 
2.53.0



