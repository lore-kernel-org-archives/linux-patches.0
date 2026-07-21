Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1EB43B6C01;
	Tue, 21 Jul 2026 20:32:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665972; cv=none; b=SjPn7VpOgYMz+Ye4IdZEBdv5HIv276JFwMMT7Qz1gzzPml5EqibhG563OGQuwMEB9pdBYSKiHTBKyl2rlMGUvzpf6yxoK/hd7exhnHeCUam5nSjbgEoeN8onW3l+haTnbXBxhcmzdScIywCkaHrDvQd0ZnPnYo6tLdQeGTPJmI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665972; c=relaxed/simple;
	bh=B+3PzwfyIohbUBQpmCX3R605+1XL5ZbXSkMGMq2Gcqc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NcsTJoUtFxUXTZWD0x+VUyGIqTWmtPCll101mP9NZMTqERQ3JMXfsgKXiBNzZlLBBRlakLz5Gk6Oe8NhGrzfrvs3hxpIyfdRxwQOXSfPu57XwJr4EYRiShw9JzxArVxGlCVSCjGWNV58/P4l/+io+9VitxLeIVivW/d3162Vjx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c+4GgXRA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c+4GgXRA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2480B1F000E9;
	Tue, 21 Jul 2026 20:32:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665971;
	bh=pDFc+OElMv7WAjguRsBjDxH7ggIrcBA94EVnCncIYL0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c+4GgXRANXA8DnI74tHhf9dT7c4K+CaWDB9E0h9v4IiZ6Xu3Z+ogD2lKMabOJkIwg
	 S+hmV6KKblxSaltotWTKWIRD2PrC+2lzPYgtxU2pdGYrZ8+lpnyQoOatAsvL3N+WHc
	 4RqlYNZjKMFNaqyvGynd8uCVnBWpfIs7EpxxxRDE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tristan Madani <tristan@talencesecurity.com>,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0463/1266] RDMA/rxe: Copy WQE to local buffer in non-SRQ receive path
Date: Tue, 21 Jul 2026 17:15:00 +0200
Message-ID: <20260721152452.194943774@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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
index c7bdc3d22053eb..539a30ec98219a 100644
--- a/drivers/infiniband/sw/rxe/rxe_resp.c
+++ b/drivers/infiniband/sw/rxe/rxe_resp.c
@@ -319,6 +319,29 @@ static enum resp_states get_srq_wqe(struct rxe_qp *qp)
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
@@ -339,9 +362,7 @@ static enum resp_states check_resource(struct rxe_qp *qp,
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



