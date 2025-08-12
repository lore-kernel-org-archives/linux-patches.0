Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF5412CA9;
	Tue, 12 Aug 2025 18:47:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024472; cv=none; b=lPkCj4wlFtUe/nBKhv1eW9pVzzpA2LPuUJEUQHozf3k2w4DxjKXF3zxm2Ta1nZXM6uSAa/EnENWHBLNo3+oKdLwE06QfKxCA3ZsBwdiZFMDLuS1n/hqsTZzv7U93tw685YHMUdi5+ALY6triW8BnN6cch7vBmmc9GsRCjrnEPb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024472; c=relaxed/simple;
	bh=YOjYB8T6KUjQaNNQGoxwF0G1hHcrb0Yd68Sv6A+yf30=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KHl+2VmavTIUzp/ZDABT0R2xELcQLNuv+7a6YMCaQjHnGxBqMKwj125FmiCV3mhZq+1/R/SK04l6S/rTWpvLs6d3JKhoJx4x6k8aS9pK0DB/CEvHi7xqA1aFYEvDTPm3RBTig+KM7t2jOjtPXew0kWUaTGfqHUJ3Vmo9yDis1Qc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QDL0LxWd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QDL0LxWd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50F76C4CEF0;
	Tue, 12 Aug 2025 18:47:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024471;
	bh=YOjYB8T6KUjQaNNQGoxwF0G1hHcrb0Yd68Sv6A+yf30=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QDL0LxWdUSBRfcRHLKo3iuiUmPIxtn3KzgrB5AGv/0tKhOhlx7M1wL18VYaX277Ak
	 cev2l8PItOmyBuc9a9VyVzsuH+zKEptqckYiK9NR5RL8nn8nV+pHqjUtXqRJ15yUtk
	 cjOZ6DXoLTNMk7GDPMjAVcG6qDUJjL85243MzgyU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Parav Pandit <parav@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 350/627] RDMA/counter: Check CAP_NET_RAW check in user namespace for RDMA counters
Date: Tue, 12 Aug 2025 19:30:45 +0200
Message-ID: <20250812173432.598473603@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Parav Pandit <parav@nvidia.com>

[ Upstream commit 449728196d65fce513dbacf4d3696764be1c6524 ]

Currently, the capability check is done in the default
init_user_ns user namespace. When a process runs in a
non default user namespace, such check fails.

Since the RDMA device is a resource within a network namespace,
use the network namespace associated with the RDMA device to
determine its owning user namespace.

Fixes: 1bd8e0a9d0fd ("RDMA/counter: Allow manual mode configuration support")
Signed-off-by: Parav Pandit <parav@nvidia.com>
Link: https://patch.msgid.link/68e2064e72e94558a576fdbbb987681a64f6fea8.1750963874.git.leon@kernel.org
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/counters.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/counters.c b/drivers/infiniband/core/counters.c
index e6ec7b7a40af..c3aa6d7fc66b 100644
--- a/drivers/infiniband/core/counters.c
+++ b/drivers/infiniband/core/counters.c
@@ -461,7 +461,7 @@ static struct ib_qp *rdma_counter_get_qp(struct ib_device *dev, u32 qp_num)
 		return NULL;
 
 	qp = container_of(res, struct ib_qp, res);
-	if (qp->qp_type == IB_QPT_RAW_PACKET && !capable(CAP_NET_RAW))
+	if (qp->qp_type == IB_QPT_RAW_PACKET && !rdma_dev_has_raw_cap(dev))
 		goto err;
 
 	return qp;
-- 
2.39.5



