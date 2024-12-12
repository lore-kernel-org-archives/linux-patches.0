Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5001C223E71;
	Thu, 12 Dec 2024 16:06:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019617; cv=none; b=Tpj8XgOa8VEKYWMn4VqL0LHbouqYXFDit3NsmWdr2r1XafIH9R88Azdd5lv2M9wd4SUXUhjNuq4xY3EBq1xZsI82NNDnUYdLC/kbjnZOuh8uaLMgwi08zprQhiqroGAOR4R5r/fasIztybQcWwmjMjrc/GeqYjUxx8rLwpDsD80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019617; c=relaxed/simple;
	bh=GcCtPwwXBR3u4f6/yVCLzQPXwa/nVtHGY5NP9DmH9fs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QhIXqrxPc5X/ZYglyGh3scfVGLQroBklJFl48UBcAAP3x6/wKxKi1SHBumiuu/MdBK0VUZZ5xhH9LkvOVOcbW55eO/S8YPH+ghQlVr02Y+SKLERPuNYkABmprdz4O0yJxwUUCkbhwQjCkUNYBS7wRhIov9VjPOTOr+T152J7Ank=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LhuzBH2y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LhuzBH2y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7200C4CECE;
	Thu, 12 Dec 2024 16:06:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734019617;
	bh=GcCtPwwXBR3u4f6/yVCLzQPXwa/nVtHGY5NP9DmH9fs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LhuzBH2yUIx9/pp2GHCP6uEyennEbwG2epqMUtGjEq276GNyw4UwZquIdBIqKXq3d
	 rKN4ovj6otU/0jbqWZUNYYeatrUPVbaLTuZhfo33d9xRU5xKKrfHn0hK0CnoOGFwHX
	 wDcA7cn1WF5i/MnzDbllJgmsvShik/US/mG7/p8s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengchang Tang <tangchengchang@huawei.com>,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 226/772] RDMA/hns: Remove unnecessary QP type checks
Date: Thu, 12 Dec 2024 15:52:51 +0100
Message-ID: <20241212144359.245058715@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junxian Huang <huangjunxian6@hisilicon.com>

[ Upstream commit b9989ab3f61ec459cbaf0a492fea3168bbfa4c7a ]

It is not necessary to check the type of the queue on IO path because
unsupported QP type cannot be created.

Link: https://lore.kernel.org/r/20230523121641.3132102-2-huangjunxian6@hisilicon.com
Signed-off-by: Chengchang Tang <tangchengchang@huawei.com>
Signed-off-by: Junxian Huang <huangjunxian6@hisilicon.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Stable-dep-of: 323275ac2ff1 ("RDMA/hns: Fix cpu stuck caused by printings during reset")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 24 +++-------------------
 1 file changed, 3 insertions(+), 21 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index 8b371d6ecbac9..b190e0cd86b45 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -373,17 +373,10 @@ static int check_send_valid(struct hns_roce_dev *hr_dev,
 			    struct hns_roce_qp *hr_qp)
 {
 	struct ib_device *ibdev = &hr_dev->ib_dev;
-	struct ib_qp *ibqp = &hr_qp->ibqp;
 
-	if (unlikely(ibqp->qp_type != IB_QPT_RC &&
-		     ibqp->qp_type != IB_QPT_GSI &&
-		     ibqp->qp_type != IB_QPT_UD)) {
-		ibdev_err(ibdev, "not supported QP(0x%x)type!\n",
-			  ibqp->qp_type);
-		return -EOPNOTSUPP;
-	} else if (unlikely(hr_qp->state == IB_QPS_RESET ||
-		   hr_qp->state == IB_QPS_INIT ||
-		   hr_qp->state == IB_QPS_RTR)) {
+	if (unlikely(hr_qp->state == IB_QPS_RESET ||
+		     hr_qp->state == IB_QPS_INIT ||
+		     hr_qp->state == IB_QPS_RTR)) {
 		ibdev_err(ibdev, "failed to post WQE, QP state %u!\n",
 			  hr_qp->state);
 		return -EINVAL;
@@ -777,17 +770,6 @@ static int hns_roce_v2_post_send(struct ib_qp *ibqp,
 static int check_recv_valid(struct hns_roce_dev *hr_dev,
 			    struct hns_roce_qp *hr_qp)
 {
-	struct ib_device *ibdev = &hr_dev->ib_dev;
-	struct ib_qp *ibqp = &hr_qp->ibqp;
-
-	if (unlikely(ibqp->qp_type != IB_QPT_RC &&
-		     ibqp->qp_type != IB_QPT_GSI &&
-		     ibqp->qp_type != IB_QPT_UD)) {
-		ibdev_err(ibdev, "unsupported qp type, qp_type = %d.\n",
-			  ibqp->qp_type);
-		return -EOPNOTSUPP;
-	}
-
 	if (unlikely(hr_dev->state >= HNS_ROCE_DEVICE_STATE_RST_DOWN))
 		return -EIO;
 
-- 
2.43.0



