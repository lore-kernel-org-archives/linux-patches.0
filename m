Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4347D2E06E4;
	Sat, 12 Sep 2026 12:19:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789215542; cv=none; b=q1y+0/aFaFFxkveutTJA+AIodQU4KJS/qIL61JZOHkimtoml9zJNVnCl5SZxBXRh3bhGaA661kb2YWm0FlVmrAKKaHmtgqNYzwbBbM+OYOqrRGJxm30yPEgPRRzXNwfnkEw/qiLw8n+f8qomhRF+hu8tCZTlTAmtYLcily70H3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789215542; c=relaxed/simple;
	bh=B2iI5qKGtKTDRWzdNn0dPWoNyPGfofDIn2pV4bCENgc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rxr/8srDbqnb4tAluJ70fHNn4RFqcN/yOKaEzDIIpRiqZ1mOGrkGOCl1QYE4Kb9Pv14y937axx4SavApDU8ix6h9WlJJuoy+5Xbxl0CILPL4tWqouJZj5y9z8sL70nAo5oivyQy3HpDZMDNwTR0B1NQEdrBjS++EQ3XACwIO0/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EzsG8XFn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EzsG8XFn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E5031F000FF;
	Sat, 12 Sep 2026 12:18:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789215541;
	bh=M/nIns4di8vkOhUd5JTAN+hrv9euKRJ4HXd3kuJjS6A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EzsG8XFnkxeyB5PMfKl34PgRwKs5K0/bTjcTVcu0kxZyOVKxcVgN3xX/RhdNJflOP
	 bFR4styJploPwv40R1D3jpVrCNASto4Tvw/nWKEltb9Ivz1DnOAz9lpJDE7Fw0/5Sn
	 Mqsu+pkLagOy+W/AUL2t7C8DAFoSuP1R/W1NQLCg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0516/1376] RDMA/hfi1: Initialize debugfs after probe completes
Date: Sat, 12 Sep 2026 08:49:02 +0200
Message-ID: <20260912065619.036935816@linuxfoundation.org>
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
index d6846d77f9479..c862ae679c9ca 100644
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



