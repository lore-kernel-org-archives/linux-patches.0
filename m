Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C62A46DFE0;
	Tue, 21 Jul 2026 17:57:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656676; cv=none; b=INdHzXxJY0koNZSVGoo1qKhqZWtt9V8z4Rg1MEGY+pW9AAa6cBvRo2r6ACKBM2Gx0xAVrbkbSrfigZd7JqP8npQkBOd04GG9IXXgxLH4Dusjl14p8j9NQS3ifQ3Uqf+gapqa2GuryhBQMMEf6G3kmkLPBl2K6MaM8FICiNLa9IU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656676; c=relaxed/simple;
	bh=6ko9AqJVlyasmh6gNhbfceqAnjyArE7qnqw66exNPQA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q5n2Oc5Lj5BQcAuQSNOmOt43IN354gIEoX6cZnKbAbhX99R4L/jhpQb7czDjhai8Qu9jJJR28ZG7JDZMmhYesxzjxAK8xx4p2lWwB9hORaWm/5t9eGNckCsdbsbyESQqJX9mfzB6K18Z5BT7A4iBipkchhQV68jvyHLqiQjSIIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fT1rgd3B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fT1rgd3B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B88A01F00A3A;
	Tue, 21 Jul 2026 17:57:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656671;
	bh=dbke2y/zwMdLPQ8etsNS8f2r394OSv70/Bt582tcmgQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fT1rgd3B0QjyF9KuEQv1Gjjgtu8wsCRG1pqg51x408p1ADWsFLzMOzy1YQhv8LJRQ
	 SfJqW1BuOvYACn2owl6etrdaTFS1JdkmNP2nhYhmTD4zMeOkn84DRWMWoNTUAP0E48
	 A64Ob8TZm+jknO8zkoVK09ujHOHqQKe/+cqb1FsM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Romanovsky <leonro@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0476/1611] =?UTF-8?q?RDMA/mlx5:=20Release=20the=20HW=E2=80=91provided=20UAR?= =?UTF-8?q?=20index=20rather=20than=20the=20SW=20one?=
Date: Tue, 21 Jul 2026 17:09:52 +0200
Message-ID: <20260721152526.035155919@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

[ Upstream commit 449ae7927152e46acbe5f19f97eafdae6d3a96b1 ]

Free the UAR index returned by the hardware.

Fixes: 4ed131d0bb15 ("IB/mlx5: Expose dynamic mmap allocation")
Link: https://patch.msgid.link/r/20260611-fix-uar-release-v1-1-f5464d845dbf@nvidia.com
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 012386e8cdd4ad..09709ae5bd4712 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -2460,7 +2460,7 @@ static int uar_mmap(struct mlx5_ib_dev *dev, enum mlx5_ib_mmap_cmd cmd,
 	if (!dyn_uar)
 		return err;
 
-	mlx5_cmd_uar_dealloc(dev->mdev, idx, context->devx_uid);
+	mlx5_cmd_uar_dealloc(dev->mdev, uar_index, context->devx_uid);
 
 free_bfreg:
 	mlx5_ib_free_bfreg(dev, bfregi, bfreg_dyn_idx);
-- 
2.53.0



