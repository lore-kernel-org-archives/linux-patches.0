Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD89C3FBB65;
	Fri, 15 May 2026 16:08:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861306; cv=none; b=U9cPmz96tgGKe0J3T6/lFRkeDue8feloKo9XenUcNMuYPyDbWyNvbFqk0AWUZZmQXIf1WQgPUUEkHS53JgjEdv6rsxlAcGVS50AoICmgP616Px3yshmzE4PBAqzUuKL6Xegd491IkOJY2y+RBC2P4FokZ+4UcdFtQDqKuVZ2etw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861306; c=relaxed/simple;
	bh=lvEH8Mhck5b2TCuskyrw0zs9BxeQiQojqKOmFo+Fj4A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XilM6PFcFBmbywMEmLbvXxex5tdGV6NVbeRA8g7OeTCRKF1U7diJjY+3iHUE7axH4fOPNv6b/ix8WH6suTVYsxuwqeb98/90y+3IonYjaUkpkrhsCEnlNYxb3h3Eyo61IN393ajahzF/sEdNMHhhYcwYIve6v4GLq4D98qTyQyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mJY1GgiC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mJY1GgiC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4541CC2BCB0;
	Fri, 15 May 2026 16:08:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861306;
	bh=lvEH8Mhck5b2TCuskyrw0zs9BxeQiQojqKOmFo+Fj4A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mJY1GgiCP2k2zs1uUekw9XYJbP0Aobfh5fo0VzK8y8u93HR6Exon7iHD27G29ZY6X
	 WoW2NqsmcLCinAgQbAQRjck2wjjiEOSnL7OyG1Dzz6lcyv1XHk00pM5NJRkNgIb8mB
	 xWLxatPC6Zl07csAEP1vxhic/9bQqaAHKTVadxyo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 6.6 277/474] RDMA/mlx4: Fix resource leak on error in mlx4_ib_create_srq()
Date: Fri, 15 May 2026 17:46:26 +0200
Message-ID: <20260515154720.994715346@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

From: Jason Gunthorpe <jgg@nvidia.com>

commit c54c7e4cb679c0aaa1cb489b9c3f2cd98e63a44c upstream.

Sashiko points out that mlx4_srq_alloc() was not undone during error
unwind, add the missing call to mlx4_srq_free().

Cc: stable@vger.kernel.org
Fixes: 225c7b1feef1 ("IB/mlx4: Add a driver Mellanox ConnectX InfiniBand adapters")
Link: https://sashiko.dev/#/patchset/0-v1-e911b76a94d1%2B65d95-rdma_udata_rep_jgg%40nvidia.com?part=8
Link: https://patch.msgid.link/r/11-v1-41f3135e5565+9d2-rdma_ai_fixes1_jgg@nvidia.com
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/hw/mlx4/srq.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/infiniband/hw/mlx4/srq.c
+++ b/drivers/infiniband/hw/mlx4/srq.c
@@ -193,13 +193,15 @@ int mlx4_ib_create_srq(struct ib_srq *ib
 	if (udata)
 		if (ib_copy_to_udata(udata, &srq->msrq.srqn, sizeof (__u32))) {
 			err = -EFAULT;
-			goto err_wrid;
+			goto err_srq;
 		}
 
 	init_attr->attr.max_wr = srq->msrq.max - 1;
 
 	return 0;
 
+err_srq:
+	mlx4_srq_free(dev->dev, &srq->msrq);
 err_wrid:
 	if (udata)
 		mlx4_ib_db_unmap_user(ucontext, &srq->db);


