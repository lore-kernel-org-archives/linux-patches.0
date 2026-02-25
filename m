Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E695920C012;
	Wed, 25 Feb 2026 01:35:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983358; cv=none; b=YoFiFP0Fu0UvDqp8duQjkHhl9DvGSowgk1U/zM0PFP1svIhvC0MJRawUEu3JYJ9gioL0NbU4WO/DBff9XnYRRoloLtrezjHwmiPm8p6j2k2mAoTsgGXTfTU7/CThmOJvdsNUwYw18h1cZnMuaxLYplDbgNYECEj9QLEtbgeCjyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983358; c=relaxed/simple;
	bh=reHL0jNDARjTYeESqVGJPYg70r7HnOFpjwS/sGxBJh4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UQAk0Fux2b8tqkNMbSWqVosBgrBwW69r85Vb8F62rSbkiPVnv6ClO92IEmPNTby6egZJXxpamrLyzqhupLg4G+G8nKf8jxFjdsxjOzdRshj6etumUgqesrG1DcNiZ6NwGTVEVQOmLaLIw5WN27j1+CK19vJWrGReWHxgQSlqICg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0EaiWmHL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0EaiWmHL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0777C116D0;
	Wed, 25 Feb 2026 01:35:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983357;
	bh=reHL0jNDARjTYeESqVGJPYg70r7HnOFpjwS/sGxBJh4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0EaiWmHLh4FqyIDKlqTB+GH1MnQBJI3t9bNklL6Ql48Rd2xKKc4sUSm0MU+1pQD0X
	 ts8Q65nVAbL3VOyFW7yNizzqOYbxCzXTxzJJhZW3fme80miWPvUg4D/HkmEPxXgWdo
	 tSv5zblfLJ4SFoyn8RG0dN43E3f8d+PMUPSrq8nY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 442/781] RDMA/hns: Return actual error code instead of fixed EINVAL
Date: Tue, 24 Feb 2026 17:19:11 -0800
Message-ID: <20260225012410.541896163@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junxian Huang <huangjunxian6@hisilicon.com>

[ Upstream commit 8cda8acbb1f8c6c0fec45b7166bb558b5af59da8 ]

query_cqc() and query_mpt() may return various error codes in
different cases. Return actual error code instead of fixed EINVAL.

Fixes: f2b070f36d1b ("RDMA/hns: Support CQ's restrack raw ops for hns driver")
Fixes: 3d67e7e236ad ("RDMA/hns: Support MR's restrack raw ops for hns driver")
Signed-off-by: Junxian Huang <huangjunxian6@hisilicon.com>
Link: https://patch.msgid.link/20260104064057.1582216-3-huangjunxian6@hisilicon.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_restrack.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_restrack.c b/drivers/infiniband/hw/hns/hns_roce_restrack.c
index 230187dda6a07..085791cc617c4 100644
--- a/drivers/infiniband/hw/hns/hns_roce_restrack.c
+++ b/drivers/infiniband/hw/hns/hns_roce_restrack.c
@@ -51,7 +51,7 @@ int hns_roce_fill_res_cq_entry_raw(struct sk_buff *msg, struct ib_cq *ib_cq)
 
 	ret = hr_dev->hw->query_cqc(hr_dev, hr_cq->cqn, &context);
 	if (ret)
-		return -EINVAL;
+		return ret;
 
 	ret = nla_put(msg, RDMA_NLDEV_ATTR_RES_RAW, sizeof(context), &context);
 
@@ -177,7 +177,7 @@ int hns_roce_fill_res_mr_entry_raw(struct sk_buff *msg, struct ib_mr *ib_mr)
 
 	ret = hr_dev->hw->query_mpt(hr_dev, hr_mr->key, &context);
 	if (ret)
-		return -EINVAL;
+		return ret;
 
 	ret = nla_put(msg, RDMA_NLDEV_ATTR_RES_RAW, sizeof(context), &context);
 
-- 
2.51.0



