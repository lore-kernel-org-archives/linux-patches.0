Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA07F7603F;
	Mon,  6 Jan 2025 15:33:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177626; cv=none; b=f3LJZC81QKAb1/45jVPMXOcvNvHgttweFQRjo/i6f1HZD30e/cl/uNwOQ6pJyfVU6w6+49VDc2uAnNi4q4w+AruhxyQSA3k1EBBXSBxjh39D3q7n9r5HyW2q6XEPB17B2usQg9bepfc+ITFSTq7l0JErKXIksr6aa42wjgU5RR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177626; c=relaxed/simple;
	bh=SIgfofJWBzbqwUNT6xW5j9CPRwjwy4seq6NvonfwM6Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z7t4mVh6TwvEEfxv+t452guii3Zz8qbA2fPXO9JGCbeW9rh/iH1IRbAHN1/3h8Kmg0wBzcCcniM0ig50/35tiFScI1ZJFsJa9wapi/dnqgk2Meg1XbW+NHvpewL7+KGIWFh1AvxZndSkRv270jjPFGCYEtqWIRHkph0x4NrzZuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YOYUBUuA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YOYUBUuA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4BA4C4CED2;
	Mon,  6 Jan 2025 15:33:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177626;
	bh=SIgfofJWBzbqwUNT6xW5j9CPRwjwy4seq6NvonfwM6Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YOYUBUuAUxZ5GU3O0fOZ3BesNsWaXXynenp6uMKlFO5uprdPcMrNQL3S1xcGjwsrQ
	 iiqNUKpFur1pr/nwC+UAAPvHzs42vRRguetL/ltYtr19k/qNcecERz97mfE5MTEmED
	 ZvJg4LkK5fUhihDzQ+KP+A4Xfm/crUG92HgOF848=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 195/222] RDMA/bnxt_re: Fix the max WQE size for static WQE support
Date: Mon,  6 Jan 2025 16:16:39 +0100
Message-ID: <20250106151158.143078276@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151150.585603565@linuxfoundation.org>
References: <20250106151150.585603565@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Selvin Xavier <selvin.xavier@broadcom.com>

[ Upstream commit 227f51743b61fe3f6fc481f0fb8086bf8c49b8c9 ]

When variable size WQE is supported, max_qp_sges reported
is more than 6. For devices that supports variable size WQE,
the Send WQE size calculation is wrong when an an older library
that doesn't support variable size WQE is used.

Set the WQE size to 128 when static WQE is supported.

Fixes: de1d364c3815 ("RDMA/bnxt_re: Add support for Variable WQE in Genp7 adapters")
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
Link: https://patch.msgid.link/1725444253-13221-3-git-send-email-selvin.xavier@broadcom.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/ib_verbs.c | 21 ++++++++++-----------
 drivers/infiniband/hw/bnxt_re/qplib_sp.h |  2 ++
 2 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
index 540998ddbb44..13c65ec58256 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -992,23 +992,22 @@ static int bnxt_re_setup_swqe_size(struct bnxt_re_qp *qp,
 	align = sizeof(struct sq_send_hdr);
 	ilsize = ALIGN(init_attr->cap.max_inline_data, align);
 
-	sq->wqe_size = bnxt_re_get_wqe_size(ilsize, sq->max_sge);
-	if (sq->wqe_size > bnxt_re_get_swqe_size(dev_attr->max_qp_sges))
-		return -EINVAL;
-	/* For gen p4 and gen p5 backward compatibility mode
-	 * wqe size is fixed to 128 bytes
+	/* For gen p4 and gen p5 fixed wqe compatibility mode
+	 * wqe size is fixed to 128 bytes - ie 6 SGEs
 	 */
-	if (sq->wqe_size < bnxt_re_get_swqe_size(dev_attr->max_qp_sges) &&
-			qplqp->wqe_mode == BNXT_QPLIB_WQE_MODE_STATIC)
-		sq->wqe_size = bnxt_re_get_swqe_size(dev_attr->max_qp_sges);
+	if (qplqp->wqe_mode == BNXT_QPLIB_WQE_MODE_STATIC) {
+		sq->wqe_size = bnxt_re_get_swqe_size(BNXT_STATIC_MAX_SGE);
+		sq->max_sge = BNXT_STATIC_MAX_SGE;
+	} else {
+		sq->wqe_size = bnxt_re_get_wqe_size(ilsize, sq->max_sge);
+		if (sq->wqe_size > bnxt_re_get_swqe_size(dev_attr->max_qp_sges))
+			return -EINVAL;
+	}
 
 	if (init_attr->cap.max_inline_data) {
 		qplqp->max_inline_data = sq->wqe_size -
 			sizeof(struct sq_send_hdr);
 		init_attr->cap.max_inline_data = qplqp->max_inline_data;
-		if (qplqp->wqe_mode == BNXT_QPLIB_WQE_MODE_STATIC)
-			sq->max_sge = qplqp->max_inline_data /
-				sizeof(struct sq_sge);
 	}
 
 	return 0;
diff --git a/drivers/infiniband/hw/bnxt_re/qplib_sp.h b/drivers/infiniband/hw/bnxt_re/qplib_sp.h
index b91e6a85e75d..aeacd0a9a92c 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_sp.h
+++ b/drivers/infiniband/hw/bnxt_re/qplib_sp.h
@@ -358,4 +358,6 @@ int bnxt_qplib_modify_cc(struct bnxt_qplib_res *res,
 #define BNXT_VAR_MAX_SGE        13
 #define BNXT_RE_MAX_RQ_WQES     65536
 
+#define BNXT_STATIC_MAX_SGE	6
+
 #endif /* __BNXT_QPLIB_SP_H__*/
-- 
2.39.5



