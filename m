Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E4C518E34E;
	Mon, 28 Oct 2024 06:47:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098027; cv=none; b=JDb7zxan9HuY8f4XQFWtxCGh9AnoYE/EG2UXSIeEbfY6278yMNEi38xnflfMkDIKfhcYlC6T4jaPp7+8kfICAqicbKZA6B/SbwPN0nmyNAb+1QfPyp0DmlI/XwYya/VEyNZrbqRWCIlCjLFQigBN3njyPqMLD/sK3Z4CheZ0Tzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098027; c=relaxed/simple;
	bh=UkDf5TR8HNu5YM6euS9OXZLw+oSU7BOQv6Ma/9CXD/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QuAHAyiRmn1MBK9BAKJtAtNGdhWvHxkwp4DrOfvOce1SArkAquVMCfH1yKhfViOvBingSWQm+/359ug1wbST3J/hbRu1NqP7cVLRf5pkcGQwBFFy8akhvJoBZw9nE9ATP5m0G7f+HEekQoBJlUmnlMSRtQNeEQCcnb8nTzJBa0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IsJdG6tJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IsJdG6tJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E5B4C4CEC3;
	Mon, 28 Oct 2024 06:47:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098027;
	bh=UkDf5TR8HNu5YM6euS9OXZLw+oSU7BOQv6Ma/9CXD/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IsJdG6tJHIW1AGBcj05IZmiZAX0TJUgHwjoUC3ioCr4FjjztT3wmfEmGxaah34/K7
	 uILKR/evkcuTNaQ1hhSb7wZM4cj3GAyA4Zd6qdbY8L1OtBeHFcX7Xa4YcZCSQp5tru
	 FS36WoaNMCbxJk7CU0DR2cPXkaRV3NlqKoE3McJQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chandramohan Akula <chandramohan.akula@broadcom.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 045/261] RDMA/bnxt_re: Change the sequence of updating the CQ toggle value
Date: Mon, 28 Oct 2024 07:23:07 +0100
Message-ID: <20241028062313.140508588@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chandramohan Akula <chandramohan.akula@broadcom.com>

[ Upstream commit 2df411353dacc4b0c911f8c4944f8ffab955391c ]

Currently the CQ toggle value in the shared page (read by the userlib) is
updated as part of the cqn_handler. There is a potential race of
application calling the CQ ARM doorbell immediately and using the old
toggle value.

Change the sequence of updating CQ toggle value to update in the
bnxt_qplib_service_nq function immediately after reading the toggle value
to be in sync with the HW updated value.

Fixes: e275919d9669 ("RDMA/bnxt_re: Share a page to expose per CQ info with userspace")
Link: https://patch.msgid.link/r/1728373302-19530-9-git-send-email-selvin.xavier@broadcom.com
Signed-off-by: Chandramohan Akula <chandramohan.akula@broadcom.com>
Reviewed-by: Selvin Xavier <selvin.xavier@broadcom.com>
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/main.c     | 8 +-------
 drivers/infiniband/hw/bnxt_re/qplib_fp.c | 5 +++++
 2 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/main.c b/drivers/infiniband/hw/bnxt_re/main.c
index c905a51aabfba..9b7093eb439c6 100644
--- a/drivers/infiniband/hw/bnxt_re/main.c
+++ b/drivers/infiniband/hw/bnxt_re/main.c
@@ -1257,15 +1257,9 @@ static int bnxt_re_cqn_handler(struct bnxt_qplib_nq *nq,
 {
 	struct bnxt_re_cq *cq = container_of(handle, struct bnxt_re_cq,
 					     qplib_cq);
-	u32 *cq_ptr;
 
-	if (cq->ib_cq.comp_handler) {
-		if (cq->uctx_cq_page) {
-			cq_ptr = (u32 *)cq->uctx_cq_page;
-			*cq_ptr = cq->qplib_cq.toggle;
-		}
+	if (cq->ib_cq.comp_handler)
 		(*cq->ib_cq.comp_handler)(&cq->ib_cq, cq->ib_cq.cq_context);
-	}
 
 	return 0;
 }
diff --git a/drivers/infiniband/hw/bnxt_re/qplib_fp.c b/drivers/infiniband/hw/bnxt_re/qplib_fp.c
index 19bb45329a19b..03d517be9c52e 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_fp.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_fp.c
@@ -327,6 +327,7 @@ static void bnxt_qplib_service_nq(struct tasklet_struct *t)
 		case NQ_BASE_TYPE_CQ_NOTIFICATION:
 		{
 			struct nq_cn *nqcne = (struct nq_cn *)nqe;
+			struct bnxt_re_cq *cq_p;
 
 			q_handle = le32_to_cpu(nqcne->cq_handle_low);
 			q_handle |= (u64)le32_to_cpu(nqcne->cq_handle_high)
@@ -337,6 +338,10 @@ static void bnxt_qplib_service_nq(struct tasklet_struct *t)
 			cq->toggle = (le16_to_cpu(nqe->info10_type) &
 					NQ_CN_TOGGLE_MASK) >> NQ_CN_TOGGLE_SFT;
 			cq->dbinfo.toggle = cq->toggle;
+			cq_p = container_of(cq, struct bnxt_re_cq, qplib_cq);
+			if (cq_p->uctx_cq_page)
+				*((u32 *)cq_p->uctx_cq_page) = cq->toggle;
+
 			bnxt_qplib_armen_db(&cq->dbinfo,
 					    DBC_DBC_TYPE_CQ_ARMENA);
 			spin_lock_bh(&cq->compl_lock);
-- 
2.43.0



