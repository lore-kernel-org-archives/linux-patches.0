Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E84813B2B3;
	Tue, 27 Feb 2024 13:46:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041600; cv=none; b=BPM6bAJn/SYswCsyOHgouzvdYvHcT+nKRjVLG/XI+SqpPqdjUS+Yfgq6fNxinTEYSImSgGBshZtOJWZniZYPy0KrrkXpZNeOMJ4MrT9hQlbrOSSc7t6HS46FqIcCJRLby4Q7h6GiccghhFqliAPsButtkAazqvZXG2WMSdNCA/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041600; c=relaxed/simple;
	bh=Zkx6RuWrKQnIePnnyS+4v7vKnbA0eZ4TCVmMs/QF0cs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pMf3DMxMAkOU84RTOPy/EHL2kSoaXyd7DzdkW2/PNbL21Y6rZP40YrtdWLUC+9JNWaAlMNL9Yg2HV/pq0a/9cuZy/hPAbpSPp+Fetu4SSU1xl5Paaqi3+OYqebzUFjSBX7wdqYHTmIxJs/lVA0SMB1NaLWhi4ippHLjD/1VbIE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A6WSZXm6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A6WSZXm6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42C9CC433C7;
	Tue, 27 Feb 2024 13:46:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041599;
	bh=Zkx6RuWrKQnIePnnyS+4v7vKnbA0eZ4TCVmMs/QF0cs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A6WSZXm6dvNUIytgk9rGVVg/xe5uvYvJW4zXJc57wedViU+xQSIgV3dfoG1c45lwZ
	 8znmyOwk1atN3duRED5OtEuzMDWPiy2E7MNG8JfaczXmMzEa4UeqwV4CwqTERSbUcn
	 Jqxo5esXkTlzEMx02+EFCcGPVm8+JVFK3c8iQ46U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 36/52] RDMA/bnxt_re: Return error for SRQ resize
Date: Tue, 27 Feb 2024 14:26:23 +0100
Message-ID: <20240227131549.717615070@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131548.514622258@linuxfoundation.org>
References: <20240227131548.514622258@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>

[ Upstream commit 3687b450c5f32e80f179ce4b09e0454da1449eac ]

SRQ resize is not supported in the driver. But driver is not
returning error from bnxt_re_modify_srq() for SRQ resize.

Fixes: 37cb11acf1f7 ("RDMA/bnxt_re: Add SRQ support for Broadcom adapters")
Signed-off-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
Link: https://lore.kernel.org/r/1705985677-15551-5-git-send-email-selvin.xavier@broadcom.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/ib_verbs.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
index f8c9caa8aad6d..e365fa8251c16 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -1475,7 +1475,7 @@ int bnxt_re_modify_srq(struct ib_srq *ib_srq, struct ib_srq_attr *srq_attr,
 	switch (srq_attr_mask) {
 	case IB_SRQ_MAX_WR:
 		/* SRQ resize is not supported */
-		break;
+		return -EINVAL;
 	case IB_SRQ_LIMIT:
 		/* Change the SRQ threshold */
 		if (srq_attr->srq_limit > srq->qplib_srq.max_wqe)
@@ -1490,13 +1490,12 @@ int bnxt_re_modify_srq(struct ib_srq *ib_srq, struct ib_srq_attr *srq_attr,
 		/* On success, update the shadow */
 		srq->srq_limit = srq_attr->srq_limit;
 		/* No need to Build and send response back to udata */
-		break;
+		return 0;
 	default:
 		dev_err(rdev_to_dev(rdev),
 			"Unsupported srq_attr_mask 0x%x", srq_attr_mask);
 		return -EINVAL;
 	}
-	return 0;
 }
 
 int bnxt_re_query_srq(struct ib_srq *ib_srq, struct ib_srq_attr *srq_attr)
-- 
2.43.0



