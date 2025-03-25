Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D28D22561D7;
	Tue, 25 Mar 2025 12:32:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905956; cv=none; b=unGwXA63AmBVSiGYRVaDLUTQobsL7/xZYktUXwkLCOYhCK4U17XTwNyN6zh7Hp7YIsRLG/q4dpuU8zLtiG3ndAfKIyBueWCfe7Tvgvzjz1C3miMDWZoHuvy3gSKv673xzTJzbF3EpkEQ84+e5l5GH6enlsOYMBe4a99Jiom0evI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905956; c=relaxed/simple;
	bh=w8/0nEMMefRkThNlCZYhPcV2Vw5SdpRcuTPQHoiRLuc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r6xu4TPCp2QN5SeQoA4VEATp+iFpjEt3iz5YeSclNKYohUwy1O/nm9OlHqRPxui1dyETBDWxezTm4PMA4fcPCbyChUwdO2v/myrOP3dkER+Mhz2a62SqTq0wXtGSIzci827VeiKDveqHKXqX1uu37Ibmz3P8hknz+yiJMo1u96Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w9VVnIw2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w9VVnIw2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 879FCC4CEE4;
	Tue, 25 Mar 2025 12:32:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905956;
	bh=w8/0nEMMefRkThNlCZYhPcV2Vw5SdpRcuTPQHoiRLuc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w9VVnIw2foHxCUBzLjowpX8uovWj+0BxBN9WgkG0tTwCVy6lLfuV4wpi5yK5mFM09
	 ZGsbaPVOdlchykX+DB/b6Ta2PQZdMT8pMpOwZfME1SPgV9tQcJOzfIVGpK94Y6GoD0
	 dpCqZwTcuvXqpTCZJRcPqFwSMxvnACE7CkXkfZ5M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 026/119] RDMA/hns: Fix a missing rollback in error path of hns_roce_create_qp_common()
Date: Tue, 25 Mar 2025 08:21:24 -0400
Message-ID: <20250325122149.736535444@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122149.058346343@linuxfoundation.org>
References: <20250325122149.058346343@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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



