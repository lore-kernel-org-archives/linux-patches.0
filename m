Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDAD826F288;
	Sat, 30 May 2026 17:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160550; cv=none; b=JEaG9cWlIGvVZLca/7t5GXD2PcrlLHptxpYrS6YU0WtjCML3gzxPCLPcjcz4ziXoT507PZl83tf198kv95i3MLPvg0bS8U8mZGapHIdArb9u9Zg38XPAQNadmkCwiw/0Pe+fsz4jWYlUBsT30uOdU8FWQuYXXJE4grZL0NcEDdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160550; c=relaxed/simple;
	bh=j/T9HV/dMLNtDAO0vHvo6Q2r4XGMFd8ewZq6jm3Pj84=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WeELkMSbJNNK5mmgKnI/BTqgAFf5Uc7rQA0HBMJHMRwuzUnKipB2Xzxvox0vbnNVcs702qSRK9pnWZVIMvoJqIl5Db1/x6WGhej0Ha+s9E0VvmSjvdAyFo4FgtzhXqj6P4lL/bXW7QxnmNxaflO9gJT90lLP0HW2Nk7hhnF5Sk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oS/Sru1H; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oS/Sru1H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA9DE1F00893;
	Sat, 30 May 2026 17:02:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160549;
	bh=gV1S7ZZyyDyHzFkKuEjf7hkKBBmun+Oyspby76941s0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oS/Sru1Hrmw1ojXlh58XIMzMETyMNAFM3eYFYs1QqtUcw5bjsX+b3/QpURzioCg+m
	 fe7NHcy6ZAZay++DaT6bwVYfEjBvdsDlO3EbefeuFYB3iv/ysyXxDlUNksauTiVzTD
	 Gf04cTckjfJpZbgp3aMzG+ikpsw3Kcrp9g7x0wfs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 6.1 367/969] RDMA/mlx4: Fix resource leak on error in mlx4_ib_create_srq()
Date: Sat, 30 May 2026 17:58:11 +0200
Message-ID: <20260530160310.457661996@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


