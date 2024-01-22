Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E7285A7B8;
	Tue, 23 Jan 2024 01:45:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974334; cv=none; b=rFzoVOSd83KQ0PFIufpiaAAACEoc5kXurre5kXBm34SDAEk0pRTKIBcgSFi1LmsP4Asc5b4/+GvRYJmSrwj9YUkgTwCKVXU3P23WdusPMgl/tZpfPQYB4W6H6drODeze8ku7pWdILVeRVocFVbKNgUVnIR5JSVrmnNOCNVkNyRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974334; c=relaxed/simple;
	bh=wPO1/fu4+Jwn0K4SdRUsbgMJAYP1jGrq+2PiWCR42io=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IdJzMcuADX1eaPwZZw/2rddBxaMSu/tG8utguY7o0o3WEMEcebsoF8MNy4L+zVq+wy0Sz3jWg0gC4601uDdkPCo4iokhVWuKjTivHs4NKKyMRnlqjUGMuawdS6Lyt58Lr7tt27lCKgzPdUcb15smx/T2HSS9eKpZ72CnVnSEKxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RwfF25F9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RwfF25F9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E586C43394;
	Tue, 23 Jan 2024 01:45:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974333;
	bh=wPO1/fu4+Jwn0K4SdRUsbgMJAYP1jGrq+2PiWCR42io=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RwfF25F9ymV6jlZprdkQQ8CLJxEfwMJiicyjEFzJy4mjo8aRDCGkoF4hCk66kvVAU
	 4uqIWRwxSZ2fYLe1iCTP1g1h+/QfMrCICGUR7RHzUBN7b6/6ZMWbhxGetqk9mo/kI/
	 AnX7/vTChNL4zqnYfvgHfIqHAKBvutqi4uuaJSw4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 179/374] RDMA/hns: Fix inappropriate err code for unsupported operations
Date: Mon, 22 Jan 2024 15:57:15 -0800
Message-ID: <20240122235750.872077434@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junxian Huang <huangjunxian6@hisilicon.com>

[ Upstream commit f45b83ad39f8033e717b1eee57e81811113d5a84 ]

EOPNOTSUPP is more situable than EINVAL for allocating XRCD while XRC
is not supported and unsupported resizing SRQ.

Fixes: 32548870d438 ("RDMA/hns: Add support for XRC on HIP09")
Fixes: 221109e64316 ("RDMA/hns: Add interception for resizing SRQs")
Signed-off-by: Junxian Huang <huangjunxian6@hisilicon.com>
Link: https://lore.kernel.org/r/20231114123449.1106162-2-huangjunxian6@hisilicon.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 2 +-
 drivers/infiniband/hw/hns/hns_roce_pd.c    | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index 6d8f3aa9d6aa..7376f012ece1 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -5442,7 +5442,7 @@ static int hns_roce_v2_modify_srq(struct ib_srq *ibsrq,
 
 	/* Resizing SRQs is not supported yet */
 	if (srq_attr_mask & IB_SRQ_MAX_WR)
-		return -EINVAL;
+		return -EOPNOTSUPP;
 
 	if (srq_attr_mask & IB_SRQ_LIMIT) {
 		if (srq_attr->srq_limit > srq->wqe_cnt)
diff --git a/drivers/infiniband/hw/hns/hns_roce_pd.c b/drivers/infiniband/hw/hns/hns_roce_pd.c
index 81ffad77ae42..21bc26bd92d9 100644
--- a/drivers/infiniband/hw/hns/hns_roce_pd.c
+++ b/drivers/infiniband/hw/hns/hns_roce_pd.c
@@ -161,7 +161,7 @@ int hns_roce_alloc_xrcd(struct ib_xrcd *ib_xrcd, struct ib_udata *udata)
 	int ret;
 
 	if (!(hr_dev->caps.flags & HNS_ROCE_CAP_FLAG_XRC))
-		return -EINVAL;
+		return -EOPNOTSUPP;
 
 	ret = hns_roce_xrcd_alloc(hr_dev, &xrcd->xrcdn);
 	if (ret)
-- 
2.43.0



