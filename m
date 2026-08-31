Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F5D045FFB4;
	Mon, 31 Aug 2026 13:45:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183914; cv=none; b=RMzl2S2LbvWdNukvs6lgvtXdngn3YJZHe9UUo3VkLTfKBfNWzZva3m9hvrRgXchLQKmX4nEDw1jh8/3FcufXt2oB4XeNqSad2oTP2ZtaF9W8hfFrUich+yugwi3zLqYvfYhTkgvx9FzwtStPvFYmfMqi4rE2HcZcL9mySnHuXJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183914; c=relaxed/simple;
	bh=6IPylq5SMf7g1tYC2y1h87AxhYxyFueQTOqGTvjsmA0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ApViMXeypnFpuMKueHYsMQ+eKypa9D+WDe5OoLe3u8Oz6d5g32sbBN6C3TMrt/+RraY20hi/CVpFnR9cZeFCajOZjLgD6/t5QlsBNF92lHrlUo62N92NAcBNXZvJWD60pZPEo5UBBucxjz2lmTxne3E8Q27Y9IP6W8w+ojd8QVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KYPpk+qK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KYPpk+qK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A83F21F00ACA;
	Mon, 31 Aug 2026 13:45:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788183912;
	bh=esc0gNEbs/3vkvJNfGjs74pWlyWujs3gszdiKF0v5TA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KYPpk+qK/JmvYG0HWCCff4E4SR+Vg6MW5Jqq5MN4IbU9rlkX719UJoesjgVrOAjlY
	 J8imyGZb7HrdrmWLoUTw4XsmiXdy3Hnxm8ciDpLQrSepMvewfx904tLArdZ4A0oWvE
	 0xuFr6NeunUBfddOOsifUj80hn9uC9Tdtd4SsIxA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Ibrahim Hashimov <security@auditcode.ai>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 01/83] RDMA/rxe: Fix responder UAF on IB_QP_MAX_DEST_RD_ATOMIC modify_qp
Date: Mon, 31 Aug 2026 15:33:37 +0200
Message-ID: <20260831133359.278435374@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.207714926@linuxfoundation.org>
References: <20260831133359.207714926@linuxfoundation.org>
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
 drivers/infiniband/sw/rxe/rxe_qp.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_qp.c b/drivers/infiniband/sw/rxe/rxe_qp.c
index 95f1c1c2949de..0af697c6469db 100644
--- a/drivers/infiniband/sw/rxe/rxe_qp.c
+++ b/drivers/infiniband/sw/rxe/rxe_qp.c
@@ -124,6 +124,7 @@ static void free_rd_atomic_resources(struct rxe_qp *qp)
 		}
 		kfree(qp->resp.resources);
 		qp->resp.resources = NULL;
+		qp->resp.res = NULL;
 	}
 }
 
@@ -660,11 +661,23 @@ int rxe_qp_from_attr(struct rxe_qp *qp, struct ib_qp_attr *attr, int mask,
 
 		qp->attr.max_dest_rd_atomic = max_dest_rd_atomic;
 
+		/*
+		 * Not gated by IB_QP_STATE, so the responder task is live.
+		 * Quiesce recv_task like rxe_qp_reset() before swapping the
+		 * rd_atomic array, so rxe_receiver() cannot race the free/
+		 * realloc.
+		 */
+		rxe_disable_task(&qp->recv_task);
 		free_rd_atomic_resources(qp);
-
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



