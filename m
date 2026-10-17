Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BB112C026C;
	Sat, 17 Oct 2026 16:27:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254479; cv=none; b=EU7WcDoCaXi0OfchFRmtzhxRSHR1TWcHkZRRosWy8LrVefrK7YRYO2SdFa/yhAsMy7xPcsMU58Io92UbIQMUJGS11NoYZPvZi3G3/qrruTe5q9rBHWoO4JgrXkDPtCNJWaZC675pj9ZrMZ/XLptvQrlc4i7ZvDt6XibEHeXNtM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254479; c=relaxed/simple;
	bh=/hF8qPr3zcEzJAkKixANKsGQcWM6JRKCsq94mcKdCqY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YVrfuqkH5PtV5qIyEsbWu5ZL31dNr65E39BT4Eitcq14Ggi5VLdxEbS+IVbM3/tFNSoVLLEwysmKl4wjz1FrrrQQ7A/PE+Sk+GxgO4opyHkcDHkS+RsqTj8WnnvvB77n9fXlnZl1snTWEdEVpB2TtRlmsALGtuArZTKyNRXVnpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vMdwUltQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vMdwUltQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 818EA1F000C4;
	Sat, 17 Oct 2026 16:27:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254478;
	bh=vphrWCwn/MeOXVO0eneWRT95tKZmaZbJBKMa+ZTD/9w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vMdwUltQmIqsdboRM9drCEu6eYw6aPckSVyIuQeNuaRMzCXlKwX3rjYE5roXiAmrt
	 LoN/Fc9sIo58TwYJQYQXExYfOk8i+AXmYRlP4ANGK9z7kSza2n2CwS756GdvR2Cuou
	 ihjgCcVkQ/LeV5NznsNh66mvrWX4Ti2Xr/zd1RvQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 459/869] RDMA/bnxt_re: Fix budget handling of notification queue
Date: Sat, 17 Oct 2026 17:55:00 +0200
Message-ID: <20261017160048.904133069@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

From: Kashyap Desai <kashyap.desai@broadcom.com>

[ Upstream commit 6b395d31146a3fae775823ea8570a37b922f6685 ]

The cited commit in Fixes tag introduced a bug which can cause hang
of completion queue processing because of notification queue budget
goes to zero.

Found while doing nfs over rdma mount and umount.
Below message is noticed because of the existing bug.

kernel: cm_destroy_id_wait_timeout: cm_id=00000000ff6c6cc6 timed out. state 11 -> 0, refcnt=1

Fix to handle this issue -
Driver will not change nq->budget upon create and destroy of cq and srq
rdma resources.

Fixes: cb97b377a135 ("RDMA/bnxt_re: Refurbish CQ to NQ hash calculation")
Link: https://patch.msgid.link/r/20250324040935.90182-1-kalesh-anakkur.purayil@broadcom.com
Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
Signed-off-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Stable-dep-of: 131e2918b9b0 ("RDMA/bnxt_re: Free SRQ toggle page after firmware teardown")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/ib_verbs.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
index 324825ecf6b2c..7a17088186cb7 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -1733,8 +1733,6 @@ int bnxt_re_destroy_srq(struct ib_srq *ib_srq, struct ib_udata *udata)
 	bnxt_qplib_destroy_srq(&rdev->qplib_res, qplib_srq);
 	ib_umem_release(srq->umem);
 	atomic_dec(&rdev->stats.res.srq_count);
-	if (nq)
-		nq->budget--;
 	return 0;
 }
 
@@ -1856,8 +1854,6 @@ int bnxt_re_create_srq(struct ib_srq *ib_srq,
 			goto fail;
 		}
 	}
-	if (nq)
-		nq->budget++;
 	active_srqs = atomic_inc_return(&rdev->stats.res.srq_count);
 	if (active_srqs > rdev->stats.res.srq_watermark)
 		rdev->stats.res.srq_watermark = active_srqs;
@@ -2995,7 +2991,6 @@ int bnxt_re_destroy_cq(struct ib_cq *ib_cq, struct ib_udata *udata)
 	ib_umem_release(cq->umem);
 
 	atomic_dec(&rdev->stats.res.cq_count);
-	nq->budget--;
 	kfree(cq->cql);
 	return 0;
 }
-- 
2.53.0



