Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A83E42EBB8D;
	Tue, 21 Jul 2026 20:36:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666215; cv=none; b=PhFHuGYNr7/LfY7qD9XaBxZBrMrReRxHqQKjAJkG0XkaLrrkiEMuR1phVQjlhUB+Imw0bcch9uZkm7VwJFoKYoNaZbJpYQK58ndUOYf3NTwyTpUQIj+zobDjpPvMMlRYVZVoCKQFG/AtjE/8pOkdYw0u4LztYQmUJALlnkSm4fw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666215; c=relaxed/simple;
	bh=37/5ld0qdqD3FYCYAr5iXi0MDwZZPC4NGaZ3A8/GxqA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EMd9TPcwGNp+PT70x0lh46DnRb93009lQitPd3mAVriIoZfe8CLMBb1oE+9R41O9HKgCNffc4d+Nx8S1LmxSbsN5MmiGmYijM46hWyNfvVz3SbrQaChDhu8jLULm3VQR2c1Jll1WTAU1KSc1nMPFC81rj6VK/DNXxm7AZoKbG8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BqZ6+SFv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BqZ6+SFv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14CE21F000E9;
	Tue, 21 Jul 2026 20:36:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666214;
	bh=QNflqTjlY3EWn91Ki5zDq4tCL/hAW0vqksubmFm5C/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BqZ6+SFvbZYlstTwcYp6lqmhOcWsPugEuyOlb7fEdke5VzKqd+Nhx07s0Mpk36Zvu
	 hlu7xLBwQus59uZ5KaucQKp7tow+wlZ3R4C+npDQ1vRIqQAmMCqpqczkdR+9zOfjLI
	 IKSTjEvTMv2PKGK3SZtzwcXO4NBobXcqgFJ7xwJg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Romanovsky <leonro@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0555/1266] =?UTF-8?q?RDMA/mlx5:=20Release=20the=20HW=E2=80=91provided=20UAR?= =?UTF-8?q?=20index=20rather=20than=20the=20SW=20one?=
Date: Tue, 21 Jul 2026 17:16:32 +0200
Message-ID: <20260721152454.284668749@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index d523bc9052ede3..10422dee6db818 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -2282,7 +2282,7 @@ static int uar_mmap(struct mlx5_ib_dev *dev, enum mlx5_ib_mmap_cmd cmd,
 	if (!dyn_uar)
 		return err;
 
-	mlx5_cmd_uar_dealloc(dev->mdev, idx, context->devx_uid);
+	mlx5_cmd_uar_dealloc(dev->mdev, uar_index, context->devx_uid);
 
 free_bfreg:
 	mlx5_ib_free_bfreg(dev, bfregi, bfreg_dyn_idx);
-- 
2.53.0



