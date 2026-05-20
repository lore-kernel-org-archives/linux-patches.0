Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48BEA3DA5B6;
	Wed, 20 May 2026 16:42:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295345; cv=none; b=M5xxroRfVwTNXd81DN1dcv4w6bK66jyc4DP+BefHF2HBKSePZrvyowmHJreqYM0PLJxUO0OeQakyDU0j9b35glxEe933Xfq+SxqrmwI+ACFB+ttvHPKsON5INDPyK52ENtY8j0Mww8mRK+tVl5OsQR1fuaCtDT/7RMSrD2Zs4QM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295345; c=relaxed/simple;
	bh=vsNzI81PXxjz8XM6KsawAA5QoNMrD0nckv+Gj+K8Ddk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qMIgFxT0NvjVpS6vL3L2e8KvtdFu7pZKE0budmzmMs2ZB0c2snHqpLumHH6PL5PuZl+ONKNz0dltzQTvcSsKpeTkipEwcqBBrwZEboCk52ya8kgufprbhdc/r28DgpQIjmie2Yr+Nqq511ahVpdJgcC+xu6O5mJCV4JeiKvwnso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SEGmbf8w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SEGmbf8w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91D0F1F00893;
	Wed, 20 May 2026 16:42:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295343;
	bh=VHgMQ47FLjAkVdnu/4gvhmpM4HogHS65f0YBpWmLVaU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SEGmbf8wvEzKZLctICSmgaYRGjt5jRErXc8tCfUSCVl5fi0aXBI7m2xK7GBh0wXnc
	 wczAZw4GJjbVX6mpo0g9LkiobB9+CZdSBykddf7UWKn7Q28RR8cxnDIoKWuOF99n8d
	 xg70EtYjTXSa4MmMJMr6FtVzWXCLXGJGLylSGMWs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gunthorpe <jgg@nvidia.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0381/1146] iommu/riscv: Remove overflows on the invalidation path
Date: Wed, 20 May 2026 18:10:31 +0200
Message-ID: <20260520162156.821287136@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Gunthorpe <jgg@nvidia.com>

[ Upstream commit 40a13b49957937427bc23e78eb50679df4396a47 ]

Since RISC-V supports a sign extended page table it should support
a gather->end of ULONG_MAX, but if this happens it will infinite loop
because of the overflow.

Also avoid overflow computing the length by moving the +1 to the other
side of the <

Fixes: 488ffbf18171 ("iommu/riscv: Paging domain support")
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/riscv/iommu.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/iommu/riscv/iommu.c b/drivers/iommu/riscv/iommu.c
index 6ac7e3edef8aa..3ec99c979d473 100644
--- a/drivers/iommu/riscv/iommu.c
+++ b/drivers/iommu/riscv/iommu.c
@@ -931,8 +931,6 @@ static void riscv_iommu_iotlb_inval(struct riscv_iommu_domain *domain,
 	struct riscv_iommu_bond *bond;
 	struct riscv_iommu_device *iommu, *prev;
 	struct riscv_iommu_command cmd;
-	unsigned long len = end - start + 1;
-	unsigned long iova;
 
 	/*
 	 * For each IOMMU linked with this protection domain (via bonds->dev),
@@ -975,11 +973,14 @@ static void riscv_iommu_iotlb_inval(struct riscv_iommu_domain *domain,
 
 		riscv_iommu_cmd_inval_vma(&cmd);
 		riscv_iommu_cmd_inval_set_pscid(&cmd, domain->pscid);
-		if (len && len < RISCV_IOMMU_IOTLB_INVAL_LIMIT) {
-			for (iova = start; iova < end; iova += PAGE_SIZE) {
+		if (end - start < RISCV_IOMMU_IOTLB_INVAL_LIMIT - 1) {
+			unsigned long iova = start;
+
+			do {
 				riscv_iommu_cmd_inval_set_addr(&cmd, iova);
 				riscv_iommu_cmd_send(iommu, &cmd);
-			}
+			} while (!check_add_overflow(iova, PAGE_SIZE, &iova) &&
+				 iova < end);
 		} else {
 			riscv_iommu_cmd_send(iommu, &cmd);
 		}
-- 
2.53.0



