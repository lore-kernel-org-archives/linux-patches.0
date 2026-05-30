Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0508541A8F;
	Sat, 30 May 2026 18:34:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780166048; cv=none; b=bj2kJKf2iXjc3bTzRlFA1kWIteMptCOJVc5ciWMtQRHFrtu/fpMt41SS9dU3ow19PH3sWA52PwkzgLrecPEwIo+AEobPDUKQQ6ULaVMBdSmLISE+TBpqKk/MidFKyFdbKuuDtFGHrqzm2ValLgVBWn7ZVhoXta3MqrXGrAzt+oc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780166048; c=relaxed/simple;
	bh=YU5dXB8lm3jHpweldr4+LjITVwHm5wtSjwmOdu31QmY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bC1xzy/sQc/kIkTFTVW22C6nbAwfCrrVNE8Una/NbOegPVC1YTH/IX6YVZ2wJe5bbHbp98Z7Fwt/ygJ3lbaWcnVIuktN2SLso8LmIuzi7dfvCgZOfsY1EGNgtLBM9i6C7W29VjQSIh5doI+ZtmBBwC3SHuTqMYynRCgimahFTnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CafUU/QQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CafUU/QQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B4F21F00893;
	Sat, 30 May 2026 18:34:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780166047;
	bh=FI/yl1zr7OjlmRKOjg2l0/tXtDMmpYo5Iyov6d6PtHQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CafUU/QQjGwLn1s7kELEo/hLZzDxDfKEOIT84J0ow83svXDnfYvn3B99Aor799Zgk
	 h0Xvw/SZevtEKaI7DlYwtv+QIaKpsAm8lK0bL4qgu7VvcrAxCHWydyGADFfAXrEZtz
	 3XXVCv2NDd4qlbicg4V67SU+MtnhP9JCyTn/H4NA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 5.10 259/589] RDMA/mlx4: Fix resource leak on error in mlx4_ib_create_srq()
Date: Sat, 30 May 2026 18:02:20 +0200
Message-ID: <20260530160231.776935931@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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
@@ -189,13 +189,15 @@ int mlx4_ib_create_srq(struct ib_srq *ib
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


