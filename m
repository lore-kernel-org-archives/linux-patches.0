Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 980B544AB7F;
	Tue, 21 Jul 2026 21:21:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668919; cv=none; b=bL+ujjvjZwUyJ6Wo8huzTzSPCtN0TElc8wasAhFN4e3m+NCJU6zjO1gRDrGRsVvRRwco5iiNxyikDHcoNzqPcQEG6xMK0nQP1Tzf2W1GBKFqAnBPnsQ70kvKjjnoBT7VSsmyWcHmqXMQ+6RoX0T0rsOAo3+ML80LdyfuPOxeVEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668919; c=relaxed/simple;
	bh=RQhukHgmGZ8NQYQCEwRzRrBxVGOPcg2dVgCjZ9dxFHE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WcxTz3gyUotkJOzW9Xv++NycaS74OtgbrIl/QKWeoc+HoJTtxaf8s5lnNbz9K0ppyiidDEVjeflMtkK/iNkReodIR7syQXTlxN7f1EP9MXHr+2iLUNP3nWs6G0v58ldCSzTEH9KoXnnvJ4ri1vwVYYbm0UpvjNF/4ZORfIKqLwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WrIvHAv4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WrIvHAv4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A8A31F000E9;
	Tue, 21 Jul 2026 21:21:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668918;
	bh=UXOq+XH5MqXhE2vvStAKIh5tC6GTI3tT5tlgZte1NZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WrIvHAv4kGw7RWDczAms2tbtWUX9Egl7xDu//hVMocUga2vF8XzeDGPNkQLGtZrsQ
	 aHAbqUbw0Hq44YONbK45z+2ZEbCSGLFHsm9IR6z6vA7iF66yOSwig2jpGOsq1dwCZh
	 gas3M/ENChriCv+ebtPSSkbkmntuzHc+FpLbI8iI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tristan Madani <tristan@talencesecurity.com>,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0358/1067] RDMA/rxe: Copy WQE to local buffer in non-SRQ receive path
Date: Tue, 21 Jul 2026 17:15:59 +0200
Message-ID: <20260721152432.621419107@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tristan Madani <tristmd@gmail.com>

[ Upstream commit d6ab440240a04b8737ee4c7bb21af9182e451733 ]

For non-SRQ QPs, the responder reads WQE fields directly from the
shared queue buffer mapped into userspace. This allows a malicious
user to modify fields like num_sge or sge entries while the kernel
is processing the WQE, leading to out-of-bounds reads in
rxe_resp_check_length() and copy_data().

Introduce get_recv_wqe() that validates num_sge and copies the WQE
to a kernel-local buffer before processing, matching the approach
already used for SRQ WQEs in get_srq_wqe(). The srq_wqe buffer is
reused since SRQ and non-SRQ paths are mutually exclusive per QP.

Fixes: 8700e3e7c485 ("Soft RoCE driver")
Link: https://patch.msgid.link/r/20260518215040.1598586-3-tristan@talencesecurity.com
Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
Reviewed-by: Zhu Yanjun <yanjun.zhu@linux.dev>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe_resp.c | 27 ++++++++++++++++++++++++---
 1 file changed, 24 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_resp.c b/drivers/infiniband/sw/rxe/rxe_resp.c
index 04d527453f975f..b933531d9d6d3d 100644
--- a/drivers/infiniband/sw/rxe/rxe_resp.c
+++ b/drivers/infiniband/sw/rxe/rxe_resp.c
@@ -346,6 +346,29 @@ static enum resp_states get_srq_wqe(struct rxe_qp *qp)
 	return RESPST_CHK_LENGTH;
 }
 
+static enum resp_states rxe_get_recv_wqe(struct rxe_qp *qp)
+{
+	struct rxe_queue *q = qp->rq.queue;
+	struct rxe_recv_wqe *wqe;
+	unsigned int num_sge;
+	size_t size;
+
+	wqe = queue_head(q, QUEUE_TYPE_FROM_CLIENT);
+	if (!wqe)
+		return RESPST_ERR_RNR;
+
+	num_sge = wqe->dma.num_sge;
+	if (unlikely(num_sge > qp->rq.max_sge)) {
+		rxe_dbg_qp(qp, "invalid num_sge in recv WQE\n");
+		return RESPST_ERR_MALFORMED_WQE;
+	}
+	size = sizeof(*wqe) + num_sge * sizeof(struct rxe_sge);
+	memcpy(&qp->resp.srq_wqe, wqe, size);
+
+	qp->resp.wqe = &qp->resp.srq_wqe.wqe;
+	return RESPST_CHK_LENGTH;
+}
+
 static enum resp_states check_resource(struct rxe_qp *qp,
 				       struct rxe_pkt_info *pkt)
 {
@@ -384,9 +407,7 @@ static enum resp_states check_resource(struct rxe_qp *qp,
 		if (srq)
 			return get_srq_wqe(qp);
 
-		qp->resp.wqe = queue_head(qp->rq.queue,
-				QUEUE_TYPE_FROM_CLIENT);
-		return (qp->resp.wqe) ? RESPST_CHK_LENGTH : RESPST_ERR_RNR;
+		return rxe_get_recv_wqe(qp);
 	}
 
 	return RESPST_CHK_LENGTH;
-- 
2.53.0



