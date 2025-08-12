Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF3CE2EAB97;
	Tue, 12 Aug 2025 18:15:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022538; cv=none; b=X6Oy+UbZKQLCZX3x8YNntNt9AQhm93a274eS48hE/fmTKYnPjbfGoyOWF1hmfsdL24XtP9q4zCxTa3dg6fxsbT/nw4UVg4mwxDQ2WiTYRdb1SZqw82U8dyGtZiIboRJkH+tYAsLWZNk9ipOqDRmwb66VnAB5ZuqJSpvm+4Vy6K4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022538; c=relaxed/simple;
	bh=zdSgA62vMlGnBJHdBTFiF/vUTsb3kMBPsMdt18zd1dE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QZovJT5El9b6aocodFEuZq62kqexIqUrQcHhjHUXdoyX5P+pEoufRMlKYpD8/y4FFNHItL7aOtnYEiNNw+AkeQaUsD3WSYA3IxagWlW6Wz0nDtwi/y7bIDdQihZK6r6NAO870182e0/zMYRTA4iYqj8cL7Sdf4TnDHpaEGb92Z8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UNd+2m+c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UNd+2m+c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F052C4CEF0;
	Tue, 12 Aug 2025 18:15:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022537;
	bh=zdSgA62vMlGnBJHdBTFiF/vUTsb3kMBPsMdt18zd1dE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UNd+2m+cIOFOJV+lF6irk3mMt3RkfybIsLGLj6VDUvdtHGKQ9d3R1UuYE7PyhYQWK
	 M/hJ6WZ+Gm5yif7Bg25KfGyQH0/9Lz4tywhNAEM5irdQnxUuMOXSNMacAPpOuSslPL
	 CkEcRZgXHDfjQv1Fw/lP9yrcL1pq7NMGqm1jfV3g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	wenglianfa <wenglianfa@huawei.com>,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 185/369] RDMA/hns: Fix HW configurations not cleared in error flow
Date: Tue, 12 Aug 2025 19:28:02 +0200
Message-ID: <20250812173021.730066638@linuxfoundation.org>
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
index 13b55390db63..6c4e0ea20224 100644
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



