Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96EC32C17A0;
	Wed, 25 Feb 2026 06:56:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002595; cv=none; b=qpxHNMZig2es0QTXL8Y96xG5YFbPlUA5jpfo2qwe4MwM76iLv1SE9u5FSPoztFTcu5OYKWnx3UZSrxHKDSJafj+TD+Ji8r3Q/UvjntA1QVzelIorWvx5tpg0TGsNJWLA1qR39wNw9qjE/tf9WbQZUF2I0ac7xcW1W8/5d7uG+tY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002595; c=relaxed/simple;
	bh=Iot/tD3brpKBvVFMUnpWR2Z15msWnkMPgGyUvFRFj14=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XMAvH+9hIm1GAbvFjNQ9c91yndj5p95fxGaAM8w5PMOK8WgDfmrrYQmPJCaXx4qpPIwUmxXxEoUT2IJ3T+scywHZ2GX9xrhSuGBUARuvEqIiVFn5y7kI/pVwROGKvC1M75xMuOdTORBsIV1LVTmvy0iS/8tylltsQOxZ0hsBqa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fEwbEMhK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fEwbEMhK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 670B7C2BC86;
	Wed, 25 Feb 2026 06:56:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002595;
	bh=Iot/tD3brpKBvVFMUnpWR2Z15msWnkMPgGyUvFRFj14=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fEwbEMhKdBlsfyY5FFYBANp8UUDR9whbEiUIzbaMSP3bQjt2KVkK1JyDTNdkjeHBb
	 /KLRX7VHc2eJ+tiKhC5T108pPtfMN5VEQvgKNQnYKejS6vq3/4yV9C8U/D7aRn9jDy
	 D1ifuPR4W3T2nhnxz41pVNhsCLd2C7Wpkb9uofuA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 340/641] RDMA/hns: Fix RoCEv1 failure due to DSCP
Date: Tue, 24 Feb 2026 17:21:06 -0800
Message-ID: <20260225012356.907143207@linuxfoundation.org>
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

From: Junxian Huang <huangjunxian6@hisilicon.com>

[ Upstream commit 84bd5d60f0a2b9c763c5e6d0b3d8f4f61f6c5470 ]

DSCP is not supported in RoCEv1, but get_dscp() is still called. If
get_dscp() returns an error, it'll eventually cause create_ah to fail
even when using RoCEv1.

Correct the return value and avoid calling get_dscp() when using
RoCEv1.

Fixes: ee20cc17e9d8 ("RDMA/hns: Support DSCP")
Signed-off-by: Junxian Huang <huangjunxian6@hisilicon.com>
Link: https://patch.msgid.link/20260104064057.1582216-4-huangjunxian6@hisilicon.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_ah.c    | 23 +++++++++---------
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 28 ++++++++++++----------
 2 files changed, 26 insertions(+), 25 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_ah.c b/drivers/infiniband/hw/hns/hns_roce_ah.c
index 307c35888b300..3b6c6a6e9f977 100644
--- a/drivers/infiniband/hw/hns/hns_roce_ah.c
+++ b/drivers/infiniband/hw/hns/hns_roce_ah.c
@@ -61,7 +61,7 @@ int hns_roce_create_ah(struct ib_ah *ibah, struct rdma_ah_init_attr *init_attr,
 	u8 tclass = get_tclass(grh);
 	u8 priority = 0;
 	u8 tc_mode = 0;
-	int ret;
+	int ret = 0;
 
 	if (hr_dev->pci_dev->revision == PCI_REVISION_ID_HIP08 && udata) {
 		ret = -EOPNOTSUPP;
@@ -78,19 +78,18 @@ int hns_roce_create_ah(struct ib_ah *ibah, struct rdma_ah_init_attr *init_attr,
 	ah->av.flowlabel = grh->flow_label;
 	ah->av.udp_sport = get_ah_udp_sport(ah_attr);
 	ah->av.tclass = tclass;
+	ah->av.sl = rdma_ah_get_sl(ah_attr);
 
-	ret = hr_dev->hw->get_dscp(hr_dev, tclass, &tc_mode, &priority);
-	if (ret == -EOPNOTSUPP)
-		ret = 0;
-
-	if (ret && grh->sgid_attr->gid_type == IB_GID_TYPE_ROCE_UDP_ENCAP)
-		goto err_out;
+	if (grh->sgid_attr->gid_type == IB_GID_TYPE_ROCE_UDP_ENCAP) {
+		ret = hr_dev->hw->get_dscp(hr_dev, tclass, &tc_mode, &priority);
+		if (ret == -EOPNOTSUPP)
+			ret = 0;
+		else if (ret)
+			goto err_out;
 
-	if (tc_mode == HNAE3_TC_MAP_MODE_DSCP &&
-	    grh->sgid_attr->gid_type == IB_GID_TYPE_ROCE_UDP_ENCAP)
-		ah->av.sl = priority;
-	else
-		ah->av.sl = rdma_ah_get_sl(ah_attr);
+		if (tc_mode == HNAE3_TC_MAP_MODE_DSCP)
+			ah->av.sl = priority;
+	}
 
 	if (!check_sl_valid(hr_dev, ah->av.sl)) {
 		ret = -EINVAL;
diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index cb0bbc4167b0d..b0e7c5c6e2ff5 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -4975,20 +4975,22 @@ static int hns_roce_set_sl(struct ib_qp *ibqp,
 	struct ib_device *ibdev = &hr_dev->ib_dev;
 	int ret;
 
-	ret = hns_roce_hw_v2_get_dscp(hr_dev, get_tclass(&attr->ah_attr.grh),
-				      &hr_qp->tc_mode, &hr_qp->priority);
-	if (ret && ret != -EOPNOTSUPP &&
-	    grh->sgid_attr->gid_type == IB_GID_TYPE_ROCE_UDP_ENCAP) {
-		ibdev_err_ratelimited(ibdev,
-				      "failed to get dscp, ret = %d.\n", ret);
-		return ret;
-	}
+	hr_qp->sl = rdma_ah_get_sl(&attr->ah_attr);
 
-	if (hr_qp->tc_mode == HNAE3_TC_MAP_MODE_DSCP &&
-	    grh->sgid_attr->gid_type == IB_GID_TYPE_ROCE_UDP_ENCAP)
-		hr_qp->sl = hr_qp->priority;
-	else
-		hr_qp->sl = rdma_ah_get_sl(&attr->ah_attr);
+	if (grh->sgid_attr->gid_type == IB_GID_TYPE_ROCE_UDP_ENCAP) {
+		ret = hns_roce_hw_v2_get_dscp(hr_dev,
+					      get_tclass(&attr->ah_attr.grh),
+					      &hr_qp->tc_mode, &hr_qp->priority);
+		if (ret && ret != -EOPNOTSUPP) {
+			ibdev_err_ratelimited(ibdev,
+					      "failed to get dscp, ret = %d.\n",
+					      ret);
+			return ret;
+		}
+
+		if (hr_qp->tc_mode == HNAE3_TC_MAP_MODE_DSCP)
+			hr_qp->sl = hr_qp->priority;
+	}
 
 	if (!check_sl_valid(hr_dev, hr_qp->sl))
 		return -EINVAL;
-- 
2.51.0



