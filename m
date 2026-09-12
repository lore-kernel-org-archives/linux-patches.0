Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAF493ACEFB;
	Sat, 12 Sep 2026 18:44:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789238685; cv=none; b=XY9HMcFGnfbNPGI1vTB3YcuDvdeXcgUy/L+szizaq6/MLktuH2Y58kd7FELirRtXzsKuYQGjUbv8Dczu4rpNH6K7+AOR17U6AAs4c53+w7PYLUzXkS4Rt95r8z83mYKSKcvkhdcA7FLcD71e+VoAEpCDGxLMDu05x4B1VeRbLaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789238685; c=relaxed/simple;
	bh=O1ohFZMKy9tjSRJ6YeG2/BvzA5FZPy8QAXWZ7kIwM24=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YcbliNtlgVHxQPKHAn2wH1QafYZ+/dFZjLMrZ81sgk9eKD4lU577flFS29yPty2Q8nHy3uexWZrNYD3jjn5AlgIIJrr7XAfd9CaLE+qZXgc8ZrB9G/1oHz9w5/Dq3+msqsZCAHy6BHgZVIekdigCjrgvMPex/5Z6wwTxZkxhMEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I7upO5ZL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I7upO5ZL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F2971F000FF;
	Sat, 12 Sep 2026 18:44:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789238683;
	bh=1CCtEdgLw8UmWVH+1mAf6Dij9mrowLMlN9GUuodGRRk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I7upO5ZL27PtOtVW2ft1jNVLB3eJPrgw93iIgMkYlOAyzseqXHWXjv8wr5yMOXH+w
	 T6CJkyuWRyAUjOxBWFD8kOn/SRVzpTLmjKAXUrh1txQ1+pw14geiOCrRw/RoAM2t0f
	 KyTERSAYtoxg8VX44rmRyVhBxkBCKg/xuxRHCayc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 512/935] RDMA/hfi1: Initialize debugfs after probe completes
Date: Sat, 12 Sep 2026 08:59:02 +0200
Message-ID: <20260912065538.565888730@linuxfoundation.org>
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
index a3ad89f6b954a..e487095f213c9 100644
--- a/drivers/infiniband/hw/hfi1/init.c
+++ b/drivers/infiniband/hw/hfi1/init.c
@@ -1637,11 +1637,8 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
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
@@ -1674,6 +1671,7 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	}
 
 	sdma_start(dd);
+	hfi1_dbg_ibdev_init(&dd->verbs_dev);
 
 	return 0;
 
-- 
2.53.0



