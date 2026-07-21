Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F7AE46D0A0;
	Tue, 21 Jul 2026 18:03:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657030; cv=none; b=Y5UCJHGqgHJ02MJof5Rkky+ymX0iJjnX3JNT0dK8Z5G8NsHpWIv2R03Ef4evTpk2XCv2Q6rtw+xzuJ9JDIOTzdj7i+xHszjwsSEAfxKGW5KHkLKT36nhvqWDHV6t6zj0srCaD54oTLThI7MoySdW42iw9Vc0IoNBo7scY3PR0ZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657030; c=relaxed/simple;
	bh=4MsnCrgTK9WTDY20AAt6vfLre9bEe67sHj6uQF2siHo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kBt1yz2pK8ngDCAOCuYrAgTkRr3oGta2KJ5FyJHFjW26P2V4+7YT6jxIRxUxAEvAB4mlOFIBIqUepdNZP8xdDeXYRVJzlvfEAiLNyI6NSEOL8aGd2eqKUUG8L+ixHCVTO64DLfETLsMLguFiGYLycop6dxVeJpGF3fzhX+fH4N4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Clw1EWny; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Clw1EWny"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C0391F000E9;
	Tue, 21 Jul 2026 18:03:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657029;
	bh=2bWa2YklDbgnvG98jIVEtCX6cEHkZIdYtLEOYmjDJPk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Clw1EWnyJNzeGHI6t990/vBvengU513d3wkNA0GOL2Y9VJiraq/+6gI/CgYzmxlGQ
	 RfgQwv5NtZoX5h2edCMCNCvK9icHk5u/5qVUDNbnM9YNYXz59Tp9L1BvqH9xBRCduC
	 rVx9ihT9UvWdT7H2Ijhdq8M/Cz5Cw7eDk0fIAMq0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0557/1611] RDMA/bnxt_re: Free SRQ toggle page after firmware teardown
Date: Tue, 21 Jul 2026 17:11:13 +0200
Message-ID: <20260721152527.907160158@linuxfoundation.org>
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

From: Selvin Xavier <selvin.xavier@broadcom.com>

[ Upstream commit 131e2918b9b0529687e67e2e58047304027f095a ]

Free the toggle page only after firmware teardown completes so that
an NQ interrupt arriving during bnxt_qplib_destroy_srq() won't write
the toggle values to an already-freed page. Move free_page() after
bnxt_qplib_destroy_srq().

Fixes: 181028a0d84c ("RDMA/bnxt_re: Share a page to expose per SRQ info with userspace")
Link: https://patch.msgid.link/r/20260615224751.232802-3-selvin.xavier@broadcom.com
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/ib_verbs.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
index c1645de495a725..36b64e1cc0b0c2 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -1826,11 +1826,11 @@ int bnxt_re_destroy_srq(struct ib_srq *ib_srq, struct ib_udata *udata)
 	struct bnxt_re_dev *rdev = srq->rdev;
 	struct bnxt_qplib_srq *qplib_srq = &srq->qplib_srq;
 
-	if (rdev->chip_ctx->modes.toggle_bits & BNXT_QPLIB_SRQ_TOGGLE_BIT) {
-		free_page((unsigned long)srq->uctx_srq_page);
+	if (rdev->chip_ctx->modes.toggle_bits & BNXT_QPLIB_SRQ_TOGGLE_BIT)
 		hash_del(&srq->hash_entry);
-	}
 	bnxt_qplib_destroy_srq(&rdev->qplib_res, qplib_srq);
+	if (rdev->chip_ctx->modes.toggle_bits & BNXT_QPLIB_SRQ_TOGGLE_BIT)
+		free_page((unsigned long)srq->uctx_srq_page);
 	ib_umem_release(srq->umem);
 	atomic_dec(&rdev->stats.res.srq_count);
 	return 0;
-- 
2.53.0



