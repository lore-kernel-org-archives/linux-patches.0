Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 939A2217F35;
	Tue, 12 Aug 2025 19:16:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026196; cv=none; b=hx/33fPAal2AgkfO7j/3pZq3fJ4H5bu/btJG1i0/tNwUf0ebG1Cmg7igIx6F36Qep8VxyQQdLdJsI2eGL3sCV6kQ//y9WCBBVAOjj0TiIAoxo/aeHH39crwKoxgigTO61kc/R1m5Q6FJqYvmwysSKg1mLxL6Ypq4EpZlfvlQTtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026196; c=relaxed/simple;
	bh=uC6dvvLxb0w7ElDRudKt3Fa0hSIrrq16aU7FEvsdijY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o59dkDd7zHK1e/SzBtuQzIlUDIvhUyG1FDpZ4h31LZiafKukIbhl9nzhVB+XZ5pL72v7zGQLkJD6suRZo/IoUoVUlIxIDLxslN3hlvrIVzBTPj9e/BRZxAK0539Mgnx4g6e1eKZ6+Efg3/aXm/v8AwE9QEPjeNQ9+IugBkQGum8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fBSgbb4X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fBSgbb4X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0F45C4CEF0;
	Tue, 12 Aug 2025 19:16:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026196;
	bh=uC6dvvLxb0w7ElDRudKt3Fa0hSIrrq16aU7FEvsdijY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fBSgbb4XWj8DHCt+ZNqe77IyjGikIgrg5khI0l6psV0uz9KGqWdEAR7i0AffD96ll
	 R4vskcQwi806eUkEpCd8tIic2xrO17YiIpRJZODttmslAHuZ3E7kvXjP6UULKDUVOh
	 5tSPXmNAllQINp+2vBHzvIkFDbqOqV4HMs5z/9KQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	wenglianfa <wenglianfa@huawei.com>,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 266/480] RDMA/hns: Fix HW configurations not cleared in error flow
Date: Tue, 12 Aug 2025 19:47:54 +0200
Message-ID: <20250812174408.409595109@linuxfoundation.org>
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

From: wenglianfa <wenglianfa@huawei.com>

[ Upstream commit 998b41cb20b02c4e28ac558e4e7f8609d659ec05 ]

hns_roce_clear_extdb_list_info() will eventually do some HW
configurations through FW, and they need to be cleared by
calling hns_roce_function_clear() when the initialization
fails.

Fixes: 7e78dd816e45 ("RDMA/hns: Clear extended doorbell info before using")
Signed-off-by: wenglianfa <wenglianfa@huawei.com>
Signed-off-by: Junxian Huang <huangjunxian6@hisilicon.com>
Link: https://patch.msgid.link/20250703113905.3597124-3-huangjunxian6@hisilicon.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index 126990bf74b4..217c252fc722 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -2986,7 +2986,7 @@ static int hns_roce_v2_init(struct hns_roce_dev *hr_dev)
 
 	ret = get_hem_table(hr_dev);
 	if (ret)
-		goto err_clear_extdb_failed;
+		goto err_get_hem_table_failed;
 
 	if (hr_dev->is_vf)
 		return 0;
@@ -3001,6 +3001,8 @@ static int hns_roce_v2_init(struct hns_roce_dev *hr_dev)
 
 err_llm_init_failed:
 	put_hem_table(hr_dev);
+err_get_hem_table_failed:
+	hns_roce_function_clear(hr_dev);
 err_clear_extdb_failed:
 	if (hr_dev->pci_dev->revision == PCI_REVISION_ID_HIP08)
 		free_mr_exit(hr_dev);
-- 
2.39.5



