Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D115A26B2B3;
	Tue, 25 Mar 2025 12:37:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742906269; cv=none; b=OBqyNGMdFR5swRVeA4UOgeUPikjkmCqeDkMSj1OZ5o/54tQVipT3MyZR5hoKbHQqex+JhWdi/2AtXKIcTCsxlHdwPzVgskJ2iWoS+RtH/gQfz9CJYXxwSXJANOJrXwFt6rp9zN8+q6SAZRKBRmnF07W8u8zXxU9rpWz+L7rgRpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742906269; c=relaxed/simple;
	bh=mihGpEh87Ea2GDSMfIn32bIjwtZVN5AI+OIpLtwSr/8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J92BOfr2g5A+OCFhgG6CbU4G2cr9fpHOFVcM+WdW6PxZCU1kOVgDBGbDIQKnC1Tj3LfuF6J8myVLhqb565OHoviK5yWtuZEjhQKX5vwgl+D7EOGgIOzTMT9JuzE4CQ4+K2Ty4i3j6xB54o81vgMkbGYS7e5JZ28PmX22Sx00Ue8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P+1lDpxO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P+1lDpxO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2761CC4CEE4;
	Tue, 25 Mar 2025 12:37:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742906269;
	bh=mihGpEh87Ea2GDSMfIn32bIjwtZVN5AI+OIpLtwSr/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P+1lDpxOK+qO4HglqjVHb0MO6F9atrgAJ42jEsj8ienp53LmdkxMGHDBoTYZ4q1+G
	 Xsb4/eXzrzsiV2bp16mtHlZH6HHHyenswh2l9C4QLggK8OVwo/AA0kLzf44NZ/vXVV
	 5VsUOi2F6oOaz9mlAbAEXO0Vd2JhjiuRQvfW4kmM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 027/116] RDMA/hns: Fix a missing rollback in error path of hns_roce_create_qp_common()
Date: Tue, 25 Mar 2025 08:21:54 -0400
Message-ID: <20250325122149.909833125@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122149.207086105@linuxfoundation.org>
References: <20250325122149.207086105@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junxian Huang <huangjunxian6@hisilicon.com>

[ Upstream commit 444907dd45cbe62fd69398805b6e2c626fab5b3a ]

When ib_copy_to_udata() fails in hns_roce_create_qp_common(),
hns_roce_qp_remove() should be called in the error path to
clean up resources in hns_roce_qp_store().

Fixes: 0f00571f9433 ("RDMA/hns: Use new SQ doorbell register for HIP09")
Signed-off-by: Junxian Huang <huangjunxian6@hisilicon.com>
Link: https://patch.msgid.link/20250311084857.3803665-6-huangjunxian6@hisilicon.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_qp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_qp.c b/drivers/infiniband/hw/hns/hns_roce_qp.c
index 8408f9a5c309d..52b671156246b 100644
--- a/drivers/infiniband/hw/hns/hns_roce_qp.c
+++ b/drivers/infiniband/hw/hns/hns_roce_qp.c
@@ -1220,7 +1220,7 @@ static int hns_roce_create_qp_common(struct hns_roce_dev *hr_dev,
 				       min(udata->outlen, sizeof(resp)));
 		if (ret) {
 			ibdev_err(ibdev, "copy qp resp failed!\n");
-			goto err_store;
+			goto err_flow_ctrl;
 		}
 	}
 
-- 
2.39.5



