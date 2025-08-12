Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1B1C61FFE;
	Tue, 12 Aug 2025 18:15:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022555; cv=none; b=b/bKDEIQfxqISC02JmlILNP+/D8v7EKIdiv2xpgDbTfOyiYFgxDGQ2Bhp9czHAL6aKLrT/zmiFIeih+9f/PBmdcNRsxrbdVy0KqHTY3mlABNBTIWYSEgAV5d/MZl12dFplUA7jn4eSWZ6P7zfRiYisgkGayJOK7DGXX7NSSnSCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022555; c=relaxed/simple;
	bh=O5fcJqewp8pouwYB/2xl9UQECQ+9m/c/qXVx/gqsZfs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PpGUhEiBspXc8lyDKzdbKzdtsJFT5ChCNAomlMYq5gJJmx9HM7+VHIUu20ybB/tPtldSi7nxvawamJ0BtM/XQji8/FmK9CQiM5He+j2E/g2vSVt5VkUbtxa5PqXogGzmy2zudVPG7l36LdaJK4Drem5Ssdej+fDGnSZ/4SPn3Xo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DGc953yj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DGc953yj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77D17C4CEF0;
	Tue, 12 Aug 2025 18:15:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022554;
	bh=O5fcJqewp8pouwYB/2xl9UQECQ+9m/c/qXVx/gqsZfs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DGc953yjINT8PZqB5LlswJoql+YEKiTu58KtwBT8fypsqkwcrGr9sPtA6vPdXPYyF
	 zuA5EFtxkA2+YyVfil0R1NcrHGk0SfkdxJgLTN694QaW78w6mRxR0tiGL09Jbw1WVF
	 mr55mbr3ZjXOYYwFG2UoB2vvqhbL2DIxL524ym3s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 190/369] RDMA/hns: Fix accessing uninitialized resources
Date: Tue, 12 Aug 2025 19:28:07 +0200
Message-ID: <20250812173021.915503442@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
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



