Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 376432C17A0;
	Wed, 25 Feb 2026 06:56:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002596; cv=none; b=ePCF5SGzgMS/GbIIcMW/uhzW1ILzEyqJQ5mooYmCq9181arbtVj5gN1exyCL6PM8vkGQ6H45EnneJ3GXbKDT/XysloeWX94BuN6qBbVp5WNPtoKYThNWSnqu40t7R+h6Mpe3l4CY0NcppmOe3lDACDeHFJZnEeSZVE3EsT9OLRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002596; c=relaxed/simple;
	bh=XzXflIM/79lTYgxbktQfUAPSRNU/MhAiah8Mj6AiVkA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YGNFXMn52viCROiW9yOuFf/sVO2hT5N/NCnAobZuotpZh9Jij2+nND00U52HimMMuPEsVVwk/zXBZKZTei7Y2yzvLMxThVoxylpBecdT8xTDILd6MSbmlFmrxuMOnoeAYWk6mbQcx//jaAxrxEi1bH9auwai9KtblsMUvR1u3kE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j3WfV/+N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j3WfV/+N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E72BC116D0;
	Wed, 25 Feb 2026 06:56:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002596;
	bh=XzXflIM/79lTYgxbktQfUAPSRNU/MhAiah8Mj6AiVkA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j3WfV/+N8L5Cr17WsboI+1gU7thrPyMp8SWL0maIhD7ighbX8s6t5CrkZqSVl1/SX
	 bmpH1+/lZ57YOw/tBtstD2ybFXpCejSiYI+IWMRZZi6NXhNjgnBpGfKD7qPowPmzHA
	 NzIqI0I20WfIbmhwdWN10UbWEkxJcLsywg+ejvt0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengchang Tang <tangchengchang@huawei.com>,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 341/641] RDMA/hns: Notify ULP of remaining soft-WCs during reset
Date: Tue, 24 Feb 2026 17:21:07 -0800
Message-ID: <20260225012356.929564230@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

From: Chengchang Tang <tangchengchang@huawei.com>

[ Upstream commit 0789f929900d85b80b343c5f04f8b9444e991384 ]

During a reset, software-generated WCs cannot be reported via
interrupts. This may cause the ULP to miss some WCs.

To avoid this, add check in the CQ arm process: if a hardware reset
has occurred and there are still unreported soft-WCs, notify the ULP
to handle the remaining WCs, thereby preventing any loss of completions.

Fixes: 626903e9355b ("RDMA/hns: Add support for reporting wc as software mode")
Signed-off-by: Chengchang Tang <tangchengchang@huawei.com>
Signed-off-by: Junxian Huang <huangjunxian6@hisilicon.com>
Link: https://patch.msgid.link/20260104064057.1582216-5-huangjunxian6@hisilicon.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 23 ++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index b0e7c5c6e2ff5..f895731ad74a0 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -3661,6 +3661,23 @@ static void hns_roce_v2_write_cqc(struct hns_roce_dev *hr_dev,
 		     HNS_ROCE_V2_CQ_DEFAULT_INTERVAL);
 }
 
+static bool left_sw_wc(struct hns_roce_dev *hr_dev, struct hns_roce_cq *hr_cq)
+{
+	struct hns_roce_qp *hr_qp;
+
+	list_for_each_entry(hr_qp, &hr_cq->sq_list, sq_node) {
+		if (hr_qp->sq.head != hr_qp->sq.tail)
+			return true;
+	}
+
+	list_for_each_entry(hr_qp, &hr_cq->rq_list, rq_node) {
+		if (hr_qp->rq.head != hr_qp->rq.tail)
+			return true;
+	}
+
+	return false;
+}
+
 static int hns_roce_v2_req_notify_cq(struct ib_cq *ibcq,
 				     enum ib_cq_notify_flags flags)
 {
@@ -3669,6 +3686,12 @@ static int hns_roce_v2_req_notify_cq(struct ib_cq *ibcq,
 	struct hns_roce_v2_db cq_db = {};
 	u32 notify_flag;
 
+	if (hr_dev->state >= HNS_ROCE_DEVICE_STATE_RST_DOWN) {
+		if ((flags & IB_CQ_REPORT_MISSED_EVENTS) &&
+		    left_sw_wc(hr_dev, hr_cq))
+			return 1;
+		return 0;
+	}
 	/*
 	 * flags = 0, then notify_flag : next
 	 * flags = 1, then notify flag : solocited
-- 
2.51.0



