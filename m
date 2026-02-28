Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9671B333434
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:03:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301832; cv=none; b=WP9Mi8SQdrDNXgE/aDvPMkRP7YdIOPDTmQJaNZaMkulbjKNK/0CFzbo+AJIKaMcwdYp9xZTAVvNr1VFCkTVDi8TFP1Eqyn0cE+7/XrN7Er69CRamvKUMz0Fm9rAngPM8yWloMJSF0KHaYbsN8PawuixLblx/jGdWX4N3fe0KH+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301832; c=relaxed/simple;
	bh=HJJwIyVcAl4sQZmPgw6CLzcqTt1yCNYbCzhDM2Qn5/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cp76IKRAElETmNRgPS5oGkdleMNbX8Ytth+sAfcyqXrYqiod529ibRgo5GimGfWcT3fSFsPSP8eKA8/wbaOlWE8fNmvZ114r11JYdiCsYFyL8mLi4QE4+K7Q4Z2CfbFCkaksWuaiHJPKofyX3n5VdmNXHimu5/FNwbGZnnHPiS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KGjU4L/0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KGjU4L/0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2DD9C19423;
	Sat, 28 Feb 2026 18:03:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301832;
	bh=HJJwIyVcAl4sQZmPgw6CLzcqTt1yCNYbCzhDM2Qn5/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KGjU4L/0vCgNsDyHRc53l8a9b3LrhsaZxe/PZ7h1tLn096GZQWKmfOFyjWBwVfBkK
	 0mq86xjKznf0UcMCrYv49hP8KuRHS7qfiHkeOecQZ/FQeaaUqMorQHAMyxQs/QSyXd
	 d7+DggwZ6Nlqius4NH7phA7kvfqxWZ/z2pY0NKbKHPKdyWkQv0g27bKmBMtQsK/Rn5
	 eCB3eG4Wi6JyfmdQ8p/zjvKkSDNauqTl2H/bM5VMgdl2wEQjAxs3UnTe7wb5RLSf2A
	 UVbA3GGSsTe2U/5/BJjrEZjXACKkpon5vtsGomiCsEKNzsyCk2iw+QuZ5u78wESQke
	 Jc9qaFHtpnyZA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Chengchang Tang <tangchengchang@huawei.com>,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 249/385] RDMA/hns: Notify ULP of remaining soft-WCs during reset
Date: Sat, 28 Feb 2026 12:57:51 -0500
Message-ID: <20260228180011.1568201-249-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

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
index 1e9f6415077a0..5e1ea6335c113 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -3683,6 +3683,23 @@ static void hns_roce_v2_write_cqc(struct hns_roce_dev *hr_dev,
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
@@ -3691,6 +3708,12 @@ static int hns_roce_v2_req_notify_cq(struct ib_cq *ibcq,
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

