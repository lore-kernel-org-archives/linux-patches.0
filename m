Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABB9139EF2C;
	Sat, 17 Oct 2026 17:52:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259537; cv=none; b=HXVOg2amp9B/6hDGhuzwb4jNe3BG0+aWi26UlhNiVF6NiwvrzuaocV+hnZkROZAPybdQtB02hI/1U3twz1CRuwfA5NtCP+kzFuL4Xeh+bQDPY/U3/YJz6Cy790MgIQpuFS/iEOh+W94s42DTDYVcEjxXPtGOwV623idKKmywrck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259537; c=relaxed/simple;
	bh=Cke4iF4aGHWqbRnkQvkLgwb3BmRyW06NVRkq1YZonf4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PKFjZF9AswkLLTXXnvHvy3No5qdypGFRRYjDZZO6NJzFUr4I5nbLpfjGm6/NWSX9ORv4HrktBKtaLZMoiVNtX8Cpqdlqp9On3zuylcZbxnxNn7qi0WhR+nZ1EKe7ndXZQurveFnUNiI+jvlkHGQlNSCn7rf+9kRneB+E6gmYYno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PtCIiWQN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PtCIiWQN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0334D1F000C4;
	Sat, 17 Oct 2026 17:52:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259536;
	bh=N0DQmCPx6TH6m82Ai2MYsRRYKN3DlP4YHkSs3bXypRs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PtCIiWQNZYXDHRtv8RanrksoLlQAIQnagwOYp243LiRcYuRZ0kPN86dtrzjGXCx4/
	 Z0TCLIIqqR5hBT/6Hc6+IaKzBrSteeObYbmsVz3WV3N8K0GSrybNpAl3UbSXAltBhO
	 ZzPu8ZJWneiazzuAYcpGplxU6FDWrX+RkTKD76oU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Ibrahim Hashimov <security@auditcode.ai>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1248/1674] RDMA/rxe: Fix responder UAF on IB_QP_MAX_DEST_RD_ATOMIC modify_qp
Date: Sat, 17 Oct 2026 17:58:40 +0200
Message-ID: <20261017160503.170388522@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ibrahim Hashimov <security@auditcode.ai>

[ Upstream commit 6f7014237405e7f032b5c53a82d9eccf6161c291 ]

rxe_qp_from_attr() handles IB_QP_MAX_DEST_RD_ATOMIC outside the
IB_QP_STATE path, so it holds no state_lock and runs while the responder
task rxe_receiver() (recv_task on rxe_wq) is live. A modify_qp() setting
only that attribute calls free_rd_atomic_resources() then
alloc_rd_atomic_resources(), swapping qp->resp.resources[] while
rxe_prepare_res()/find_resource() walk it; free_rd_atomic_resources()
also leaves the cached pointer qp->resp.res dangling. A local
unprivileged user can race the free/realloc into a use-after-free in
rxe_receiver() (local DoS).

Drain recv_task around the swap with rxe_disable_task()/rxe_enable_task(),
as rxe_qp_reset() already does when tearing this array down, re-enabling
only after alloc_rd_atomic_resources() succeeds so the responder never
resumes against a NULL qp->resp.resources on the ENOMEM path. Also clear
qp->resp.res in free_rd_atomic_resources(), like the rxe_resp.c
completion paths.

Reproduced under KASAN; the slab-use-after-free in rxe_receiver() is gone.

Fixes: 8700e3e7c485 ("Soft RoCE driver")
Reviewed-by: Zhu Yanjun <yanjun.zhu@linux.dev>
Signed-off-by: Ibrahim Hashimov <security@auditcode.ai>
Link: https://patch.msgid.link/20260712121720.78001-1-security@auditcode.ai
Assisted-by: AuditCode-AI:2026.07
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe_qp.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/infiniband/sw/rxe/rxe_qp.c b/drivers/infiniband/sw/rxe/rxe_qp.c
index 6478a1f9eff53..c3e1ada9b6a11 100644
--- a/drivers/infiniband/sw/rxe/rxe_qp.c
+++ b/drivers/infiniband/sw/rxe/rxe_qp.c
@@ -124,6 +124,7 @@ static void free_rd_atomic_resources(struct rxe_qp *qp)
 		}
 		kfree(qp->resp.resources);
 		qp->resp.resources = NULL;
+		qp->resp.res = NULL;
 	}
 }
 
@@ -658,12 +659,25 @@ int rxe_qp_from_attr(struct rxe_qp *qp, struct ib_qp_attr *attr, int mask,
 		int max_dest_rd_atomic = attr->max_dest_rd_atomic ?
 			roundup_pow_of_two(attr->max_dest_rd_atomic) : 0;
 
+		/*
+		 * Not gated by IB_QP_STATE, so the responder task is live.
+		 * Quiesce recv_task like rxe_qp_reset() before swapping the
+		 * rd_atomic array, so rxe_receiver() cannot race the free/
+		 * realloc.
+		 */
+		rxe_disable_task(&qp->recv_task);
 		free_rd_atomic_resources(qp);
 
 		qp->attr.max_dest_rd_atomic = max_dest_rd_atomic;
 		err = alloc_rd_atomic_resources(qp, max_dest_rd_atomic);
+		/*
+		 * On ENOMEM leave recv_task quiesced: qp->resp.resources is
+		 * NULL and rxe_prepare_res()/find_resource() would deref it.
+		 * Re-enable only after a fresh array is installed.
+		 */
 		if (err)
 			return err;
+		rxe_enable_task(&qp->recv_task);
 	}
 
 	if (mask & IB_QP_EN_SQD_ASYNC_NOTIFY)
-- 
2.53.0



