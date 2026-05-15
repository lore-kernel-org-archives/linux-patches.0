Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92F803E0089;
	Fri, 15 May 2026 16:07:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861278; cv=none; b=AWf2YjRw1AC6Su2B2ilanomrjxXQ11bW4z6Xys03GCQ6P5gpN5mpVoTstpNdaKnMdBwX3wQaZBjcWLeHkoBd4cdR9V2pM8JMhnjGcb6fvpKaqeVXVNVb7IWTeHDrazSjeF9nlxh1qH/1RCy1+d8zpZxUmkx4yGN0v/e+vYDQoB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861278; c=relaxed/simple;
	bh=Sa8y0EUcWacKEXHAklDHyL95i0GcjYlkDIP8FavF2Gs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DJAWUYpOuR403Cq0AXNmktLBhkixibIaDc4oJVSn3nXAF5sJqCtv5eDaMg3OBjZCtOFT/y7Q82SdivqPqh6XSBRCI7HIoBQQbxycUcQx17UvV45zpFU7mVX6mQdP1wF5jis/GLHtT91nlstGnr439vNu157zwZRI9l5xNl08JfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MzmX6y/T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MzmX6y/T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDF86C2BCB0;
	Fri, 15 May 2026 16:07:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861278;
	bh=Sa8y0EUcWacKEXHAklDHyL95i0GcjYlkDIP8FavF2Gs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MzmX6y/TSurLDQVrLdgeyDL1aahh3+vbXJ8+geXxMNYc1TGIlMok9eDW1FHx80Zxr
	 coVRK8E2z6MaxvAjbtQB9QVp5YlUJhkPIa/mC8jhWuyJs8M3TLzC9NhBGXBbUSv0d2
	 RuHGaxv5gCJ8a2/EyTqIYDdR0U2kic4e0BNMyc64=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 6.6 267/474] RDMA/hns: Fix unlocked call to hns_roce_qp_remove()
Date: Fri, 15 May 2026 17:46:16 +0200
Message-ID: <20260515154720.778786299@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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
@@ -1082,6 +1082,7 @@ static int hns_roce_create_qp_common(str
 	struct hns_roce_ib_create_qp_resp resp = {};
 	struct ib_device *ibdev = &hr_dev->ib_dev;
 	struct hns_roce_ib_create_qp ucmd = {};
+	unsigned long flags;
 	int ret;
 
 	mutex_init(&hr_qp->mutex);
@@ -1165,7 +1166,13 @@ static int hns_roce_create_qp_common(str
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


