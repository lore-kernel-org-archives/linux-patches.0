Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A9FF26B0AE;
	Tue, 12 Aug 2025 19:16:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026213; cv=none; b=JN6Ppi77YWfmX+ijfU8eWqHIm7SCAm+ibFI3vb1CplbbmD0IeWG1W8Yyslc4tfwzvU4J73174frvCO756rAO4RkLgxMAkuV4nJ67aysyXo2TDgKNFg0NkPJrJwlJRrUVk9Dmbv8jV5+0jfvFNgmFjcLKw/cbm0q8/TlX8+y0FhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026213; c=relaxed/simple;
	bh=GVE3nQ3iVMTuKBf9dyiVcVvFF3Rk8nCthCiFpTWszNM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rC9XCQI9rRuIwCxj6yX/tXnfjVrfaWaYrVRMWmP1JuViIl5/7CsfU2Oa6vzCwg8XyKrXd06CIzBjtmOBLovmGDG+D5TPa78t/tZyCYVXJqkpbDPXSicY3aXdm/1K+rjhOLa6zxDgXfwHMFG25VPDTYfLgm71Fg1sasOFYMrK4Ds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iObRpx3X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iObRpx3X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DBE5C4CEF0;
	Tue, 12 Aug 2025 19:16:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026212;
	bh=GVE3nQ3iVMTuKBf9dyiVcVvFF3Rk8nCthCiFpTWszNM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iObRpx3XAPKYMkAYYcVRrk6+FzX+a8XkH0+MvztmSv3IXoqFufb7ywK/SKSzYMpp+
	 90Nq8pbw7H3LnL+Ug7aIpnU6z8sB9zkdqHOWgZRRUPB2EbBLBGJmCjsAQfALgTncEI
	 A5ybp4aILrmTya3RNVaOOEBfvZ0zyXGH5W5aLEWs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 271/480] RDMA/hns: Fix accessing uninitialized resources
Date: Tue, 12 Aug 2025 19:47:59 +0200
Message-ID: <20250812174408.619386666@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junxian Huang <huangjunxian6@hisilicon.com>

[ Upstream commit 278c18a4a78a9a6bf529ef45ccde512a5686ea9d ]

hr_dev->pgdir_list and hr_dev->pgdir_mutex won't be initialized if
CQ/QP record db are not enabled, but they are also needed when using
SRQ with SRQ record db enabled. Simplified the logic by always
initailizing the reosurces.

Fixes: c9813b0b9992 ("RDMA/hns: Support SRQ record doorbell")
Signed-off-by: Junxian Huang <huangjunxian6@hisilicon.com>
Link: https://patch.msgid.link/20250703113905.3597124-5-huangjunxian6@hisilicon.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_main.c | 16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_main.c b/drivers/infiniband/hw/hns/hns_roce_main.c
index 623610b3e2ec..11fa64044a8d 100644
--- a/drivers/infiniband/hw/hns/hns_roce_main.c
+++ b/drivers/infiniband/hw/hns/hns_roce_main.c
@@ -947,10 +947,7 @@ static int hns_roce_init_hem(struct hns_roce_dev *hr_dev)
 static void hns_roce_teardown_hca(struct hns_roce_dev *hr_dev)
 {
 	hns_roce_cleanup_bitmap(hr_dev);
-
-	if (hr_dev->caps.flags & HNS_ROCE_CAP_FLAG_CQ_RECORD_DB ||
-	    hr_dev->caps.flags & HNS_ROCE_CAP_FLAG_QP_RECORD_DB)
-		mutex_destroy(&hr_dev->pgdir_mutex);
+	mutex_destroy(&hr_dev->pgdir_mutex);
 }
 
 /**
@@ -968,11 +965,8 @@ static int hns_roce_setup_hca(struct hns_roce_dev *hr_dev)
 	INIT_LIST_HEAD(&hr_dev->qp_list);
 	spin_lock_init(&hr_dev->qp_list_lock);
 
-	if (hr_dev->caps.flags & HNS_ROCE_CAP_FLAG_CQ_RECORD_DB ||
-	    hr_dev->caps.flags & HNS_ROCE_CAP_FLAG_QP_RECORD_DB) {
-		INIT_LIST_HEAD(&hr_dev->pgdir_list);
-		mutex_init(&hr_dev->pgdir_mutex);
-	}
+	INIT_LIST_HEAD(&hr_dev->pgdir_list);
+	mutex_init(&hr_dev->pgdir_mutex);
 
 	hns_roce_init_uar_table(hr_dev);
 
@@ -1004,9 +998,7 @@ static int hns_roce_setup_hca(struct hns_roce_dev *hr_dev)
 
 err_uar_table_free:
 	ida_destroy(&hr_dev->uar_ida.ida);
-	if (hr_dev->caps.flags & HNS_ROCE_CAP_FLAG_CQ_RECORD_DB ||
-	    hr_dev->caps.flags & HNS_ROCE_CAP_FLAG_QP_RECORD_DB)
-		mutex_destroy(&hr_dev->pgdir_mutex);
+	mutex_destroy(&hr_dev->pgdir_mutex);
 
 	return ret;
 }
-- 
2.39.5



