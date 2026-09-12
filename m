Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6517426ED46;
	Sat, 12 Sep 2026 19:48:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242522; cv=none; b=udUfXHtM1hwZzCar/ujb3nMx3eJ/7n61rNLxK0oVuZB2HpQOwY21wTzO4gBZCwA2/uQuIPrgn/C9F2a9zRgKI/Cqw7RobimWfecMVgUWpel/t+3c0xNnXCnQpryAEsdjnAMHJmQh+QMaQw58JEStk1WD9apAoaxVfjyg5Gr7Hds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242522; c=relaxed/simple;
	bh=0D4DGpZZ8DBpTFZsE1noY30KwyoH/67xVqLFi1r7ayk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YaT3pDecYat5zLymZD1LJNU9sA3m50njgnA5zarrAi/T+wClqDpYAoD0G7MkCvf7W3eQm2T3l+Ghzadd6yhDl5tLk4o8o+r651F2aoGIHyjSZzb8Jse1fMacFFDr4aYeFzEgV+qEVCRfqcJIvXUa25k5oEk0LTad7mFJwrFS6iE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WRwyEpFV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WRwyEpFV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C09461F000FF;
	Sat, 12 Sep 2026 19:48:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242521;
	bh=x5n8PfcZl9DefO/HwbqYHRCnSr4zeSiXM+q30l8zbVg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WRwyEpFVtVobPzu5HqooxPQdtbESB9GJtFWrQcz7m4LERSRIu2qN/b7Bpe5rvgH9O
	 k+O6FoTb/W0m0bGUTyqqt05HjPexMAAnQn+kFjWbNZHMnXvLBddEb/bYHY+q4aaOTz
	 f+isbGA7cVOLkd51sR4OFUcMksxtSQPenBacxR3o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 434/798] RDMA/hfi1: Initialize debugfs after probe completes
Date: Sat, 12 Sep 2026 09:01:02 +0200
Message-ID: <20260912065527.092411802@linuxfoundation.org>
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
index d130465dcfa1b..80476b7a398be 100644
--- a/drivers/infiniband/hw/hfi1/init.c
+++ b/drivers/infiniband/hw/hfi1/init.c
@@ -1679,11 +1679,8 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
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
@@ -1715,6 +1712,7 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	}
 
 	sdma_start(dd);
+	hfi1_dbg_ibdev_init(&dd->verbs_dev);
 
 	return 0;
 
-- 
2.53.0



