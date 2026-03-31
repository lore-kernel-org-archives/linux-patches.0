Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E746425CD9;
	Tue, 31 Mar 2026 16:38:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975086; cv=none; b=PbUC5TdvjGMeXPEYbWyB/veFsmHcXyqTOTM6JB6BMDcWvWt81KIozlSb9kwe60clOrT7+Xvs3FH4NPtTtzF30NGnU4J5j0IC/3xnENpuNJfyv+xzkB4h0vUr2o2kC87/JbAQQWBW+aa7MY/eSc5Gyx4vxzuZfBBawjClh+eGMZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975086; c=relaxed/simple;
	bh=5M4d4Nm/DJjm8HbAl6ba3xM+rzHIDqOHaDjL6+M57Og=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AyTVvCLjgnLds+1EO1z0FopLbUzgArqSUuiYz1u0gPqKkW13sOyXDusoDsBYbgjuD/xsJLWUsFfp30+olmBfohFSQD+Z5UPbEWuibO6fLmr1exOrnlxm8qCP72QA4fdUuLrm49867y8qltTYMEtJ6GqQjDxaJBoaWI2MjC7bas8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SBePnWgn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SBePnWgn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3576C19423;
	Tue, 31 Mar 2026 16:38:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975086;
	bh=5M4d4Nm/DJjm8HbAl6ba3xM+rzHIDqOHaDjL6+M57Og=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SBePnWgncp1fhubpwghkMBGiooYMJFnpjPIVrZbWzHNqvl/hqkqomtCYSDJKRaPyz
	 krpMHhM3xHhgWA647wm10VAT0N2rCyUDcWp5U5qy4drQutxBC3trDjdUGUtu5rrHib
	 5+qngiUc4SySk8oV4O2ODUkJd4dgIdq4HfnoQeQA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tatyana Nikolova <tatyana.e.nikolova@intel.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 157/342] RDMA/irdma: Update ibqp state to error if QP is already in error state
Date: Tue, 31 Mar 2026 18:19:50 +0200
Message-ID: <20260331161804.786837598@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
index d279a015094be..c34188e322085 100644
--- a/drivers/infiniband/hw/irdma/verbs.c
+++ b/drivers/infiniband/hw/irdma/verbs.c
@@ -1540,6 +1540,7 @@ int irdma_modify_qp_roce(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 		case IB_QPS_ERR:
 		case IB_QPS_RESET:
 			if (iwqp->iwarp_state == IRDMA_QP_STATE_ERROR) {
+				iwqp->ibqp_state = attr->qp_state;
 				spin_unlock_irqrestore(&iwqp->lock, flags);
 				if (udata && udata->inlen) {
 					if (ib_copy_from_udata(&ureq, udata,
@@ -1745,6 +1746,7 @@ int irdma_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr, int attr_mask,
 		case IB_QPS_ERR:
 		case IB_QPS_RESET:
 			if (iwqp->iwarp_state == IRDMA_QP_STATE_ERROR) {
+				iwqp->ibqp_state = attr->qp_state;
 				spin_unlock_irqrestore(&iwqp->lock, flags);
 				if (udata && udata->inlen) {
 					if (ib_copy_from_udata(&ureq, udata,
-- 
2.53.0



