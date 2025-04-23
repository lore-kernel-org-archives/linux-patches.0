Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7399F269826;
	Wed, 23 Apr 2025 14:48:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745419718; cv=none; b=DXTqyN4Gja0jo1GtRgEhLS7ZnNGgHUzTQKnG4ItYn+Iu2yHT3C4y4Nqo4YQ4WUoy3ok2nfrJX3aAvCT1fErZTYKv547TQ7fi7fik6yBpgHKibXQWzoAMP4l9PmQxusJyF7flTcDCFHGxkzeioWPslwMhPnvu/KuHINuMFd+ktbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745419718; c=relaxed/simple;
	bh=WEnNbO5WFK27nfWZPcLu6JCXCwO1BfFiCC164Lyptso=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i+rJbAGnnXGL1GeYIiJ6Z+JnqI7Hgv+09X7Pvrj+lm+pF8bjRwYs7ZQNcumZjDOjYJMQPbuQVi5Fp/RHtjMVKSuMGe0ays7Gt+DaXe7nAUMpQeLPy3ZTK9zWXmtJrr2//wpz7f7z1hqGCUNCVUzVkDERwhMxGsTTd03t0UKieWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Be+gymBD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Be+gymBD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06259C4CEE2;
	Wed, 23 Apr 2025 14:48:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745419718;
	bh=WEnNbO5WFK27nfWZPcLu6JCXCwO1BfFiCC164Lyptso=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Be+gymBDMltT48W9TlC2iDl7FZpASiI9DGuNIOhbd0Qz+3AwvCxTwX6UQmcXyDxra
	 zoTX/H9Gc+KNjEtNTaH7Ujlp4RIAwbPvdlEaexooiV5QOoE7RQszmlADx/A0fPVpCM
	 mEMvIfrJ2orhGgx1itCDHfrCDnmJfv5Lf0QY2VNk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 015/241] RDMA/bnxt_re: Fix budget handling of notification queue
Date: Wed, 23 Apr 2025 16:41:19 +0200
Message-ID: <20250423142621.141849860@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
References: <20250423142620.525425242@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/ib_verbs.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
index 6f5db32082dd7..cb9b820c613d6 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -1784,8 +1784,6 @@ int bnxt_re_destroy_srq(struct ib_srq *ib_srq, struct ib_udata *udata)
 	bnxt_qplib_destroy_srq(&rdev->qplib_res, qplib_srq);
 	ib_umem_release(srq->umem);
 	atomic_dec(&rdev->stats.res.srq_count);
-	if (nq)
-		nq->budget--;
 	return 0;
 }
 
@@ -1907,8 +1905,6 @@ int bnxt_re_create_srq(struct ib_srq *ib_srq,
 			goto fail;
 		}
 	}
-	if (nq)
-		nq->budget++;
 	active_srqs = atomic_inc_return(&rdev->stats.res.srq_count);
 	if (active_srqs > rdev->stats.res.srq_watermark)
 		rdev->stats.res.srq_watermark = active_srqs;
@@ -3078,7 +3074,6 @@ int bnxt_re_destroy_cq(struct ib_cq *ib_cq, struct ib_udata *udata)
 	ib_umem_release(cq->umem);
 
 	atomic_dec(&rdev->stats.res.cq_count);
-	nq->budget--;
 	kfree(cq->cql);
 	return 0;
 }
-- 
2.39.5



