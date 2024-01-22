Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 104FF64CF0;
	Tue, 23 Jan 2024 01:57:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975075; cv=none; b=UqvFhyeV7GL/rJtKCsKDQbHnyEwnYRAoBYy1i1M/wXFFwg8w/L8xUFpykiDoifIAwcwkPh8PfXtkewCrVbRERtxBMgy0oWgdFJmD+6xKGDba/UDEK10fJBRJG6NJGO0wJtfx52zrL1c1z2psXd0iKxQcwIkU1BkOF6QnjBsO7fY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975075; c=relaxed/simple;
	bh=DbzXNpG4I9eyUQhk+0u0AvoHrEdGamo0l+WL/gaIdkI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ExMNdmfq8EMEX/4JinmYY+4U2qItiIR7TmWz/tAveQQj446UQhmCmV9pZO5IJ8cTstrpiYB5lapPVLVPuw4r2Tkq/cXMHjcdKypZRVz0za2XrzaBHz/3wNWasnHA9dP+BHERUYHLuPTz263ar95o0gQ5CQ62RyHNKvRvvEjRKfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J/slD6SZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J/slD6SZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85410C433F1;
	Tue, 23 Jan 2024 01:57:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975074;
	bh=DbzXNpG4I9eyUQhk+0u0AvoHrEdGamo0l+WL/gaIdkI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J/slD6SZENoihL5ZRHw8M5vvNCTRePb6HFkGyulnFTC2cFLCkSZzGb+9C2CGYF4cw
	 H7ZpWNGy7Ozj7Lp7wFTbPI6IxzwIqa9DIrClIOIpfCmdjcP3UEHZIYjcYSIptDElS4
	 sNbSfiy8bW1xLFp6e5lLWYjy46kXtBFc8C9k4c28=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 227/583] RDMA/hns: Fix inappropriate err code for unsupported operations
Date: Mon, 22 Jan 2024 15:54:38 -0800
Message-ID: <20240122235818.947435452@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 486d635b6e3a..84c18996517c 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -5634,7 +5634,7 @@ static int hns_roce_v2_modify_srq(struct ib_srq *ibsrq,
 
 	/* Resizing SRQs is not supported yet */
 	if (srq_attr_mask & IB_SRQ_MAX_WR)
-		return -EINVAL;
+		return -EOPNOTSUPP;
 
 	if (srq_attr_mask & IB_SRQ_LIMIT) {
 		if (srq_attr->srq_limit > srq->wqe_cnt)
diff --git a/drivers/infiniband/hw/hns/hns_roce_pd.c b/drivers/infiniband/hw/hns/hns_roce_pd.c
index 783e71852c50..bd1fe89ca205 100644
--- a/drivers/infiniband/hw/hns/hns_roce_pd.c
+++ b/drivers/infiniband/hw/hns/hns_roce_pd.c
@@ -150,7 +150,7 @@ int hns_roce_alloc_xrcd(struct ib_xrcd *ib_xrcd, struct ib_udata *udata)
 	int ret;
 
 	if (!(hr_dev->caps.flags & HNS_ROCE_CAP_FLAG_XRC))
-		return -EINVAL;
+		return -EOPNOTSUPP;
 
 	ret = hns_roce_xrcd_alloc(hr_dev, &xrcd->xrcdn);
 	if (ret)
-- 
2.43.0



