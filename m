Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8057817109B;
	Mon, 28 Oct 2024 06:46:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098018; cv=none; b=Vo/9evTkcZJBUsFp7gNNxc43iMGEaQpZqFnsXXseUCmoaE4k6ZUxKbZjrhEHUIhCmEIdi6LcJf3aXnxdPZPFgKIZFAwYc72QUN+qBCS/VB/94SdBS/BMZsqL7uw8Cwr3t25FzMLNVTpplR3F/2eHoQ0rB3N6klymXTh9X45m7LU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098018; c=relaxed/simple;
	bh=7+oqrvtHbnw2U9Q5tHDSlRymF+oiR2PTX34TFWAoob0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qiyrb7p0sP18k7nAqdape7vdTwbhCN3cDZ1q1wWEztU0y06YydZWNvASmwy9hU/Ke/NVSiKxIRhwDTXaLQOtNuTnh50uWrlbz0DrAcYk7WT1ACMTGlMGrtDuIxPdnBG7gOQpTH/yiYAVvTaa3t+NeMuqf/IzKksSFYhnF4atBg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S4vpdnf6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S4vpdnf6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E98EC4CEC3;
	Mon, 28 Oct 2024 06:46:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098018;
	bh=7+oqrvtHbnw2U9Q5tHDSlRymF+oiR2PTX34TFWAoob0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S4vpdnf6hNjgVxq70ASVWbAxWiiz3gdTaFTuy0aW3Zii/alQKbk8xQJeFQaU7aggB
	 IiF0NJlH9DPaH/VFj9nQ9tkqE+5a8cWmLgxZgT9roJrIjQ/Jgypu4E8nxwvCMcPGie
	 bPS+9aFyaPt3iTuFr+oRJZTtE7dFue6Oqy1NbGMg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Saravanan Vajravel <saravanan.vajravel@broadcom.com>,
	Chandramohan Akula <chandramohan.akula@broadcom.com>,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 041/261] RDMA/bnxt_re: Fix incorrect dereference of srq in async event
Date: Mon, 28 Oct 2024 07:23:03 +0100
Message-ID: <20241028062313.036642235@linuxfoundation.org>
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

From: Kashyap Desai <kashyap.desai@broadcom.com>

[ Upstream commit 87b4d8d28f6af8fc62766a8af7a5467b37053dfa ]

Currently driver is not getting correct srq. Dereference only if qplib has
a valid srq.

Fixes: b02fd3f79ec3 ("RDMA/bnxt_re: Report async events and errors")
Link: https://patch.msgid.link/r/1728373302-19530-4-git-send-email-selvin.xavier@broadcom.com
Reviewed-by: Saravanan Vajravel <saravanan.vajravel@broadcom.com>
Reviewed-by: Chandramohan Akula <chandramohan.akula@broadcom.com>
Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/main.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/main.c b/drivers/infiniband/hw/bnxt_re/main.c
index 2a450d7ad1990..e06adb2dfe6f9 100644
--- a/drivers/infiniband/hw/bnxt_re/main.c
+++ b/drivers/infiniband/hw/bnxt_re/main.c
@@ -1012,12 +1012,15 @@ static int bnxt_re_handle_unaffi_async_event(struct creq_func_event
 static int bnxt_re_handle_qp_async_event(struct creq_qp_event *qp_event,
 					 struct bnxt_re_qp *qp)
 {
-	struct bnxt_re_srq *srq = container_of(qp->qplib_qp.srq, struct bnxt_re_srq,
-					       qplib_srq);
 	struct creq_qp_error_notification *err_event;
+	struct bnxt_re_srq *srq = NULL;
 	struct ib_event event = {};
 	unsigned int flags;
 
+	if (qp->qplib_qp.srq)
+		srq =  container_of(qp->qplib_qp.srq, struct bnxt_re_srq,
+				    qplib_srq);
+
 	if (qp->qplib_qp.state == CMDQ_MODIFY_QP_NEW_STATE_ERR &&
 	    rdma_is_kernel_res(&qp->ib_qp.res)) {
 		flags = bnxt_re_lock_cqs(qp);
-- 
2.43.0



