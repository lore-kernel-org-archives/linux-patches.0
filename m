Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A177502B7A;
	Mon, 31 Aug 2026 13:41:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183720; cv=none; b=fjNJgin6IKE4tsdCZ7RcJ7Bb+3QFKSLglSLPU1AMUX8Up49aNaC9I8EpVB5zOSS9MG8nDPnsjKcKPLtQLqTmyYOI9kzeb1QbS04tIo/mo4pZ2EmTbKrxedvfuRa8doBUo+P5PNepUqPSRodQAalI7mrUaHR9ONXc76eCbtWl5EA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183720; c=relaxed/simple;
	bh=WWD2Ql2Z4g+9fo4/urRGhmffawy8vMh55yVayotG9Tw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DXXSeuWIdA7ZNURcKOeRDBXtlgAc2wJnFGmfjOsPEZ80yZqVKKQ5hzHvKm3ceQwzT8tYTdf1MDGIyA2ZN9Jp+b1/HNyEfHpUAxlfdEPtkjkjnuf4HmrQ8cyu+C5ZVDMIcG5Hjh5IkRbVPaBiAkxKNyW3zrzDfT4cOC7RfzAHVhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0Qhs7wFn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0Qhs7wFn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBD9A1F00A3F;
	Mon, 31 Aug 2026 13:41:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788183719;
	bh=lwSzhMhCxYFFAVTwR9VVx7heB3uEWTOXm5OiGz1dMyY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0Qhs7wFnhSx+07H7VHcxHY30I1pYowGb7bjOfVNUVnDd46tZFDIhgD4e90sGtrxLo
	 kLcMZ42/7QkckvEroQ2/Fekx1abGxEkSbvh+qnZ5EV8kisF8xbivF4qGPKbiTiUpEl
	 IhaCJQB30xo87vFnjinnQ8RIEv+yU8NGmfHI+OqQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Ibrahim Hashimov <security@auditcode.ai>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 02/76] RDMA/rxe: Fix responder UAF on IB_QP_MAX_DEST_RD_ATOMIC modify_qp
Date: Mon, 31 Aug 2026 15:33:34 +0200
Message-ID: <20260831133359.306889063@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.185608553@linuxfoundation.org>
References: <20260831133359.185608553@linuxfoundation.org>
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
index f3dff1aea96af..61cbf05fbf583 100644
--- a/drivers/infiniband/sw/rxe/rxe_qp.c
+++ b/drivers/infiniband/sw/rxe/rxe_qp.c
@@ -172,6 +172,7 @@ static void free_rd_atomic_resources(struct rxe_qp *qp)
 		}
 		kfree(qp->resp.resources);
 		qp->resp.resources = NULL;
+		qp->resp.res = NULL;
 	}
 }
 
@@ -709,11 +710,23 @@ int rxe_qp_from_attr(struct rxe_qp *qp, struct ib_qp_attr *attr, int mask,
 
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



