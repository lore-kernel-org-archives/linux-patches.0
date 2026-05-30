Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82807481DD;
	Sat, 30 May 2026 17:02:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160524; cv=none; b=gZwOTo9zbeUl6OogYlBrukZ7XUcZTQNLy9UXEcQ4LPZnJkp1uNh9HmdZkRnZHV2KSDrO/b8VqG02uLRMM/gPh6VxCyE7FTCwWu+EvKpPM8xN+lukhAOnTRT5K+Ws0ECz2qfrV+LC5GxgWcKuRB49CC4tOYx/i1ZZAYsmHwkRnKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160524; c=relaxed/simple;
	bh=DcEJxQsjUAK7bjvVcIH2UBKOOVOc7713Uhii/rqZoYk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TgyldSbI/r+QJ3PucehZgKK4+gtAQISKDTbWU/bb+UnfpUGjlbKVMI9Niuyep+RyIWTW9BbY43kE8GE2vH15Gs/NUg+0rgzQGiPPUmnxMl2RNiHkEGmE5zu5j2mwjNy3RIlEFhqu2PfCLEwpZtioVsWkxXr+qDXgqor2ali2fO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JflU2m/M; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JflU2m/M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB2611F00893;
	Sat, 30 May 2026 17:02:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160523;
	bh=PnlV8vNub7bg4hYAD5NcaHJP8YVP92l9uNDKexMTyKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JflU2m/MuhNI9zOHIQ7CQA49Ndi2u8P268I8tjlmCZx1LcS5yElPx+MlL9d2K36QC
	 xoUDqBjxkv/jJpKNSHbXMzczdGb2g5FRYLCs9McEGPBeMc10Aw87dK2xCCp/ff33sb
	 XmvY4OqwW1rgFC0onaKheyES1jRebtNLWEwD2b3U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 6.1 361/969] RDMA/hns: Fix unlocked call to hns_roce_qp_remove()
Date: Sat, 30 May 2026 17:58:05 +0200
Message-ID: <20260530160310.301683776@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

From: Jason Gunthorpe <jgg@nvidia.com>

commit 0c99acbc8b6c6dd526ae475a48ee1897b61072fb upstream.

Sashiko points out that hns_roce_qp_remove() requires the caller to hold
locks.  The error flow in hns_roce_create_qp_common() doesn't hold those
locks for the error unwind so it risks corrupting memory.

Grab the same locks the other two callers use.

Cc: stable@vger.kernel.org
Fixes: e088a685eae9 ("RDMA/hns: Support rq record doorbell for the user space")
Link: https://sashiko.dev/#/patchset/0-v2-1c49eeb88c48%2B91-rdma_udata_rep_jgg%40nvidia.com?part=9
Link: https://patch.msgid.link/r/15-v1-41f3135e5565+9d2-rdma_ai_fixes1_jgg@nvidia.com
Reviewed-by: Junxian Huang <huangjunxian6@hisilicon.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/hw/hns/hns_roce_qp.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/infiniband/hw/hns/hns_roce_qp.c
+++ b/drivers/infiniband/hw/hns/hns_roce_qp.c
@@ -1146,6 +1146,7 @@ static int hns_roce_create_qp_common(str
 	struct hns_roce_ib_create_qp_resp resp = {};
 	struct ib_device *ibdev = &hr_dev->ib_dev;
 	struct hns_roce_ib_create_qp ucmd = {};
+	unsigned long flags;
 	int ret;
 
 	mutex_init(&hr_qp->mutex);
@@ -1229,7 +1230,13 @@ static int hns_roce_create_qp_common(str
 	return 0;
 
 err_flow_ctrl:
+	spin_lock_irqsave(&hr_dev->qp_list_lock, flags);
+	hns_roce_lock_cqs(init_attr->send_cq ? to_hr_cq(init_attr->send_cq) : NULL,
+			  init_attr->recv_cq ? to_hr_cq(init_attr->recv_cq) : NULL);
 	hns_roce_qp_remove(hr_dev, hr_qp);
+	hns_roce_unlock_cqs(init_attr->send_cq ? to_hr_cq(init_attr->send_cq) : NULL,
+			    init_attr->recv_cq ? to_hr_cq(init_attr->recv_cq) : NULL);
+	spin_unlock_irqrestore(&hr_dev->qp_list_lock, flags);
 err_store:
 	free_qpc(hr_dev, hr_qp);
 err_qpc:


