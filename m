Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AA893033C9;
	Tue, 31 Mar 2026 17:02:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976564; cv=none; b=BEc/yK1sA6YSB7Cm4ubPJttxuayipGbXYBCf0NZmfXHxYLDNCHvqSVJwl5lcTLm1OGuq98s1deaXgCXgB8Smd3D1mTjqHi4XYQGa8J4Ou7oEW8xWdm4dWkwGY+2AV+bemivxGlEGMP6mds090NcqohaDpEwY66ih4sfIfbOQKgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976564; c=relaxed/simple;
	bh=2YgpsOOB7dKEXaXQVJR9M+LIjpmPTM0/jcmiAvFd0bk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=byZEEIoslU3xL19cBPTDR9RkMbLagOaLNUBdHTSFNEJMfrBcMIVtGh+TzgjtvnlfIMbjJw37icl+bMyrVDVB+4mai27ZmAwOpsEQEaFbb/jVksBiJmNd0rXS9dCQPgWOA3Y5DcqhOq7SxaYKtbiN8eMC34sUNuAuc4e3++fyUK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kb52dFqD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kb52dFqD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34516C19423;
	Tue, 31 Mar 2026 17:02:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976564;
	bh=2YgpsOOB7dKEXaXQVJR9M+LIjpmPTM0/jcmiAvFd0bk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kb52dFqD4hjgwzvLx0D4W83h4vc5NXpL68bvtvE1xch1a1cJJhsI6xDt5FbB0xWe3
	 RAAwFnL10FzGWZ6kqSd/fV88ih9j7ju8cdOyl5fgi+NuSKcUoGlYIMWs+NdwkFYPJc
	 /eqy2YGSHh0DebN02uuXSVsEfqpjoILPD+mvBJ9g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tatyana Nikolova <tatyana.e.nikolova@intel.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 142/309] RDMA/irdma: Update ibqp state to error if QP is already in error state
Date: Tue, 31 Mar 2026 18:20:45 +0200
Message-ID: <20260331161758.700271249@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
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

From: Tatyana Nikolova <tatyana.e.nikolova@intel.com>

[ Upstream commit 8c1f19a2225cf37b3f8ab0b5a8a5322291cda620 ]

In irdma_modify_qp() update ibqp state to error if the irdma QP is already
in error state, otherwise the ibqp state which is visible to the consumer
app remains stale.

Fixes: b48c24c2d710 ("RDMA/irdma: Implement device supported verb APIs")
Signed-off-by: Tatyana Nikolova <tatyana.e.nikolova@intel.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/irdma/verbs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/infiniband/hw/irdma/verbs.c b/drivers/infiniband/hw/irdma/verbs.c
index f53b8f0d7ca83..c2449f5721eeb 100644
--- a/drivers/infiniband/hw/irdma/verbs.c
+++ b/drivers/infiniband/hw/irdma/verbs.c
@@ -1541,6 +1541,7 @@ int irdma_modify_qp_roce(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 		case IB_QPS_ERR:
 		case IB_QPS_RESET:
 			if (iwqp->iwarp_state == IRDMA_QP_STATE_ERROR) {
+				iwqp->ibqp_state = attr->qp_state;
 				spin_unlock_irqrestore(&iwqp->lock, flags);
 				if (udata && udata->inlen) {
 					if (ib_copy_from_udata(&ureq, udata,
@@ -1746,6 +1747,7 @@ int irdma_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr, int attr_mask,
 		case IB_QPS_ERR:
 		case IB_QPS_RESET:
 			if (iwqp->iwarp_state == IRDMA_QP_STATE_ERROR) {
+				iwqp->ibqp_state = attr->qp_state;
 				spin_unlock_irqrestore(&iwqp->lock, flags);
 				if (udata && udata->inlen) {
 					if (ib_copy_from_udata(&ureq, udata,
-- 
2.53.0



