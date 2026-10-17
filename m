Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CA4636B93B;
	Sat, 17 Oct 2026 16:27:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254473; cv=none; b=uXOQDHDg7GerY0Bnndc7YKUjkZmRz/mWekl5AQ2Y5RtLUlNju0y+teOOY3AB0BQJBt+JMv96ZyOTQ1gxzH3TUtHgPKlJbXArY0JV0K0H8vqbG2MWrwS3F7svQtJuJ8IKJWUX4srbliQ0f3q8Af0qdUEVishpW8PmfRjJVUs/xM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254473; c=relaxed/simple;
	bh=WYBsI8dYenDZ+PkgfGwY7hxc/fdJ0JPjUqCwa3O+OYE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m2qD6a3olrYKZbNsGBhm6r7zBiPY71ukJyDR2BfNbECjBb7yhxyg+TB6Nbc/RburNW5R82/aesUoOX0omy0ipE7ApuoJctUky2AW6uMoX9+y7Xs65mK3djAWRiLYqA8pTQasSEvU3+sNCJUyjgJQvhB8FeEpkxEkzA7+9BkJ5o8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0d5R/rxq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0d5R/rxq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 729521F000C4;
	Sat, 17 Oct 2026 16:27:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254472;
	bh=QbxGuMoibOMVIOTbiVecuHryVk6PJ69qgECAibOdQ0A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0d5R/rxq6a22Xiy1PDV1qNrEQKvFMWUjLvwovpVtklSZlXm4O4j2psTIjVGhvB51X
	 Q51fMiloDyl2jt5BJO93yu2jjvZVu+/+BtMrI7KwyabqaMTqfyNhg9WJ6FlX8/zD0o
	 JWYr31XiZuBW/iC1mL00Jn+fTQLN0Zbdvi5rTMGI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 457/869] RDMA/bnxt_re: Add a max slot check for SQ
Date: Sat, 17 Oct 2026 17:54:58 +0200
Message-ID: <20261017160048.853909485@linuxfoundation.org>
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

From: Selvin Xavier <selvin.xavier@broadcom.com>

[ Upstream commit dc95931b7e1326dacae547874bf38c092e5960d8 ]

The variable WQE mode must be validated against
the maximum slots supported by HW. The max supported
value is 64K. Adding a max and min check and fail if user
supplied value is more than the max supported and zero.

Fixes: d8ea645d6984 ("RDMA/bnxt_re: Handle variable WQE support for user applications")
Link: https://patch.msgid.link/r/20260615224751.232802-10-selvin.xavier@broadcom.com
Reviewed-by: Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/ib_verbs.c | 3 +++
 drivers/infiniband/hw/bnxt_re/qplib_sp.h | 1 +
 2 files changed, 4 insertions(+)

diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
index 339e9be2e8f24..86de1d9bca6b2 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -1402,6 +1402,9 @@ static int bnxt_re_init_qp_attr(struct bnxt_re_qp *qp, struct bnxt_re_pd *pd,
 	}
 	qplqp->type = (u8)qptype;
 	qplqp->wqe_mode = bnxt_re_is_var_size_supported(rdev, uctx);
+	if (uctx && qplqp->wqe_mode == BNXT_QPLIB_WQE_MODE_VARIABLE &&
+	    (!ureq->sq_slots || ureq->sq_slots > BNXT_RE_MAX_SQ_SLOTS))
+		return -EINVAL;
 	if (init_attr->qp_type == IB_QPT_RC) {
 		qplqp->max_rd_atomic = dev_attr->max_qp_rd_atom;
 		qplqp->max_dest_rd_atomic = dev_attr->max_qp_init_rd_atom;
diff --git a/drivers/infiniband/hw/bnxt_re/qplib_sp.h b/drivers/infiniband/hw/bnxt_re/qplib_sp.h
index fcfef5cbb38d4..92f3131a9a829 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_sp.h
+++ b/drivers/infiniband/hw/bnxt_re/qplib_sp.h
@@ -357,6 +357,7 @@ int bnxt_qplib_modify_cc(struct bnxt_qplib_res *res,
 #define BNXT_VAR_MAX_SLOT_ALIGN 256
 #define BNXT_VAR_MAX_SGE        13
 #define BNXT_RE_MAX_RQ_WQES     65536
+#define BNXT_RE_MAX_SQ_SLOTS    65536
 
 #define BNXT_STATIC_MAX_SGE	6
 
-- 
2.53.0



