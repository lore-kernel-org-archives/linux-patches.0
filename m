Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D57B4E66B8;
	Tue, 13 Oct 2026 12:15:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893703; cv=none; b=Wc2qbgatkBeSVO3+qA45nJJZ/QURSTC+RcecuCkMzShOWXMDSUN7l0hAJgV1qWgBPf29crQuoK1bmkI8Ao7fjuilIcDueeghIE9ub8VUgDe4x0lJ7RISHpo4z86LjebXfBI+cxR3bxV982xUik/+AvXTWEA/wJMRipaWGNrPir8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893703; c=relaxed/simple;
	bh=3EBkey0ujreIdrquWZz0hrSnPFx5bu0PGl7lk/xD1M8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cxjuGzm34VHF6jzeHEOz+nwBwUSEWoiqq5/DEaxJ8spRoosiQpMJgspvcynA2BxW5RXkWk5KPO4Vc1sESAn+tz1tjyVGwEkUbxPdJPkSfEtSjYc3B769pAlLNCJAvgHmjqywWmr/BNIW7X5qdmONUfZZTF5Yb+5BC5fNDfHms6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xXafqrus; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xXafqrus"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 582481F000FF;
	Tue, 13 Oct 2026 12:15:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893701;
	bh=m6qrbwXaa1eZOJBcALg0mJoJYyZHXy1sEpkApEJenXQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xXafqrus4RY0P+qp7BAsoJvp/GtwfVp1hlvxv8pTwUtSKE6SXzYS4Qs2abOElLUyK
	 oCcqaa2pv0QaUefq0QcVq96Vvk15vhMTO8T3t8c89RdEBjh9VJaHIMlNtRP5mGlami
	 J/j/0U3cfBgKBi+mxfm0Lw1b1+c86V2ni+0diKwU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 297/621] RDMA/bnxt_re: Add a max slot check for SQ
Date: Tue, 13 Oct 2026 13:34:52 +0200
Message-ID: <20261013112927.903448938@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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
index 64b6e572e7047..48d5133671c4b 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -1473,6 +1473,9 @@ static int bnxt_re_init_qp_attr(struct bnxt_re_qp *qp, struct bnxt_re_pd *pd,
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
index 5a45c55c6464c..7e332aca50161 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_sp.h
+++ b/drivers/infiniband/hw/bnxt_re/qplib_sp.h
@@ -367,6 +367,7 @@ int bnxt_qplib_destroy_flow(struct bnxt_qplib_res *res);
 #define BNXT_VAR_MAX_SLOT_ALIGN 256
 #define BNXT_VAR_MAX_SGE        13
 #define BNXT_RE_MAX_RQ_WQES     65536
+#define BNXT_RE_MAX_SQ_SLOTS    65536
 
 #define BNXT_STATIC_MAX_SGE	6
 
-- 
2.53.0



