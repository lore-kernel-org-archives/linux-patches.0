Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8FFD472F70;
	Tue, 21 Jul 2026 17:49:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656145; cv=none; b=rsnLfDAcfXTeorW1OmM/3zx7zU7JQF5j9clFmFPJzDK5+gIjnwXUjmyB++ltWqjjF/1tP9lkmV7/0cg4qFBr9GhBiE2/Banod5DCC2Ur/CuKrpOKpO34P9Ch6bc39FaF+Bylq76ZDN0qyv1aaaqOAdOMC4JF0oTu0/Yjydt2Do4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656145; c=relaxed/simple;
	bh=cFrzGIR7Q935HvwFa8eyZ38fV5K/2Pdr0t0O6qU6C8o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FZe80MO6/RTgsIHyd9z15HHXsHQ9MgI0dRSweOQgDGqbK3NaaZ9ZIdv9qva+p1JmkRy4l9tog2kIlANYlUv6oj4riaWkdrLUYaE7jMrFkyOGT151EOLIko4eU3SxrnfmAAT90nP0t3+Hu9WYmVmx8MmSPgVu230xGhskTY55Ct0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ibdQVp+H; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ibdQVp+H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B3CC1F000E9;
	Tue, 21 Jul 2026 17:49:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656143;
	bh=44wFSD5t8ojPSn5jfX/19SV1Xd82kPW6HTrhUpIHIKQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ibdQVp+HK1tk/M4G3SWw/t6F+WQUUyDentUzhVP9LKPys4tlbOTPQR7/LzdwXt5Mx
	 u2iJm4XUjGAoZ0hke3LnlKWVAbUxaHiEo6eTwJ6z+0L45rQ2bBY5e8/WDNN6ErC8ZL
	 QIs6taph+dFhvnnyvcCS9S43q6Y0EGIOaQ3Xcv1Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tristan Madani <tristan@talencesecurity.com>,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0274/1611] RDMA/rxe: Copy WQE to local buffer in non-SRQ receive path
Date: Tue, 21 Jul 2026 17:06:30 +0200
Message-ID: <20260721152521.215651706@linuxfoundation.org>
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
index 12669297468890..995805e16d78b3 100644
--- a/drivers/infiniband/sw/rxe/rxe_resp.c
+++ b/drivers/infiniband/sw/rxe/rxe_resp.c
@@ -309,6 +309,29 @@ static enum resp_states get_srq_wqe(struct rxe_qp *qp)
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
@@ -329,9 +352,7 @@ static enum resp_states check_resource(struct rxe_qp *qp,
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



