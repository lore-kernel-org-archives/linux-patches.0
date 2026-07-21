Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 957C92DF3EA;
	Tue, 21 Jul 2026 18:53:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659999; cv=none; b=eJo6iVmbpYlsGbC2fUZm16c8Zo86Qs//LXjY/JwckkxwzD0lKGi4mTLRW60iFR5vjJfJ8G2P3VBZBFtliaNU78Yl7EoTfuErFpmpRpodMq/fDFFh7aWSurL4QzIt6SzkGaQpiEQqhttX6ohcWEpFmEq9t/TN2f0g77qY8R+LhtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659999; c=relaxed/simple;
	bh=geoh1+f0SeEhJgxS6ArO6VdGdhQV82b6Jd/UqgqcppU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LI0VXru2aJX1s58Ch8Xghgs/Bhs8IW+5xnI+Ue4h0RVD8BUxsw7ywLGvT3wqtXxaOSrzdyujTxQLUSaI955daoDSPyDFpb4P6YW7MKdGUcldGlCoSSZbXo3DgXnetyseZRCdV6RkBsa9JgOIGbwv99DOX2t9ytXGqYJQ6GOCmTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aNlkNLxj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aNlkNLxj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0770D1F00ACF;
	Tue, 21 Jul 2026 18:53:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659998;
	bh=+lp6x428u6HM8mflHIFwC/4xfsNaoI7ZuCf2zShbAX0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aNlkNLxjmGybKrgIRqr39f21T9QKkCcI+DijojG+yqTpYwks/Q864awQCKJYnvgGj
	 kqMFfrMZE+oMTwNtEv7WOy+gwaBNkkMcwrBI+8m/GuTz80gjAJZ01KfMrLSKxuz6vC
	 wqibGiznRkuCIOKLhP5fZEGKehtWqXZbZLlMvjHY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0812/2077] RDMA/bnxt_re: Add a max slot check for SQ
Date: Tue, 21 Jul 2026 17:08:05 +0200
Message-ID: <20260721152611.944203779@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index e97c17727da162..24270371a0a562 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -1721,6 +1721,9 @@ static int bnxt_re_init_qp_attr(struct bnxt_re_qp *qp, struct bnxt_re_pd *pd,
 		return qptype;
 	qplqp->type = (u8)qptype;
 	qplqp->wqe_mode = bnxt_re_is_var_size_supported(rdev, uctx);
+	if (uctx && qplqp->wqe_mode == BNXT_QPLIB_WQE_MODE_VARIABLE &&
+	    (!ureq->sq_slots || ureq->sq_slots > BNXT_RE_MAX_SQ_SLOTS))
+		return -EINVAL;
 	if (fixed_que_attr) {
 		if (qplqp->wqe_mode != BNXT_QPLIB_WQE_MODE_VARIABLE)
 			return -EOPNOTSUPP;
diff --git a/drivers/infiniband/hw/bnxt_re/qplib_sp.h b/drivers/infiniband/hw/bnxt_re/qplib_sp.h
index 9fadd637cb5b10..c4193ae75b54da 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_sp.h
+++ b/drivers/infiniband/hw/bnxt_re/qplib_sp.h
@@ -369,6 +369,7 @@ int bnxt_qplib_destroy_flow(struct bnxt_qplib_res *res);
 #define BNXT_VAR_MAX_SLOT_ALIGN 256
 #define BNXT_VAR_MAX_SGE        13
 #define BNXT_RE_MAX_RQ_WQES     65536
+#define BNXT_RE_MAX_SQ_SLOTS    65536
 
 #define BNXT_STATIC_MAX_SGE	6
 
-- 
2.53.0



