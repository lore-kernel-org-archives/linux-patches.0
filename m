Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11F391DE8A5;
	Tue,  3 Dec 2024 15:57:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241477; cv=none; b=VxFC3WPq479uPZmEx7owT2ZgrxLJcMzi3vzI7/9g2bKdjn86WxM3Zr34g4H9xE7zQ2bLC6gsF4b2RVek9gaLYp4G5UH2bF1AaWkksE+yVBpG6xJil+vJLrTU9d9/ScRcoymdDMCxM0xDn8UDQkZNrOo/No87tr3lIXYx0GAP86U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241477; c=relaxed/simple;
	bh=JmKby0VjcpLt93AG4UPFQ1tRWUpoEtZLULK6Q84a5Ao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XDp6eKA/hqtHQNyTyvlrHuykJINAw1Qx4o5Ooaz+0N+/L8uHveS4/v00fTzYS9A1PsJr/KFU0PTdtsFPs8BrcT+joeukWbfVSp4zS7WHvjQZvQ4iTdvzMFnOVU+Ih/rf5L+tRj9En6mHdVd4/ZTxihTA6Tz1TViWnDFmqgOgwUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GJW0cBFR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GJW0cBFR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7541EC4CECF;
	Tue,  3 Dec 2024 15:57:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241476;
	bh=JmKby0VjcpLt93AG4UPFQ1tRWUpoEtZLULK6Q84a5Ao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GJW0cBFRryPgZfs4HW9ygiNR5q7JIoxUQyyASXlMns+dHvghIsaatxmziT17bS6A3
	 OAaHcBY/QrHQO+CXu1DCuW72TkkP5pUZjz3yGgFFLxg2I0qPY4wyZndlpTS9EI7b9h
	 tI8VymN2D/OBpdA2sBCIQ808cBl3sOVJOelyBUwo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 428/826] RDMA/hns: Fix out-of-order issue of requester when setting FENCE
Date: Tue,  3 Dec 2024 15:42:35 +0100
Message-ID: <20241203144800.459310807@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junxian Huang <huangjunxian6@hisilicon.com>

[ Upstream commit 5dbcb1c1900f45182b5651c89257c272f1f3ead7 ]

The FENCE indicator in hns WQE doesn't ensure that response data from
a previous Read/Atomic operation has been written to the requester's
memory before the subsequent Send/Write operation is processed. This
may result in the subsequent Send/Write operation accessing the original
data in memory instead of the expected response data.

Unlike FENCE, the SO (Strong Order) indicator blocks the subsequent
operation until the previous response data is written to memory and a
bresp is returned. Set the SO indicator instead of FENCE to maintain
strict order.

Fixes: 9a4435375cd1 ("IB/hns: Add driver files for hns RoCE driver")
Signed-off-by: Junxian Huang <huangjunxian6@hisilicon.com>
Link: https://patch.msgid.link/20241108075743.2652258-2-huangjunxian6@hisilicon.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 2 +-
 drivers/infiniband/hw/hns/hns_roce_hw_v2.h | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index d1c075fb0ad89..707e96ce222c5 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -575,7 +575,7 @@ static inline int set_rc_wqe(struct hns_roce_qp *qp,
 	if (WARN_ON(ret))
 		return ret;
 
-	hr_reg_write(rc_sq_wqe, RC_SEND_WQE_FENCE,
+	hr_reg_write(rc_sq_wqe, RC_SEND_WQE_SO,
 		     (wr->send_flags & IB_SEND_FENCE) ? 1 : 0);
 
 	hr_reg_write(rc_sq_wqe, RC_SEND_WQE_SE,
diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.h b/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
index 3b3c6259ace0e..dedb1853e193e 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
@@ -924,6 +924,7 @@ struct hns_roce_v2_rc_send_wqe {
 #define RC_SEND_WQE_OWNER RC_SEND_WQE_FIELD_LOC(7, 7)
 #define RC_SEND_WQE_CQE RC_SEND_WQE_FIELD_LOC(8, 8)
 #define RC_SEND_WQE_FENCE RC_SEND_WQE_FIELD_LOC(9, 9)
+#define RC_SEND_WQE_SO RC_SEND_WQE_FIELD_LOC(10, 10)
 #define RC_SEND_WQE_SE RC_SEND_WQE_FIELD_LOC(11, 11)
 #define RC_SEND_WQE_INLINE RC_SEND_WQE_FIELD_LOC(12, 12)
 #define RC_SEND_WQE_WQE_INDEX RC_SEND_WQE_FIELD_LOC(30, 15)
-- 
2.43.0



