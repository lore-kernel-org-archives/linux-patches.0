Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77F443F9D2;
	Tue, 12 Aug 2025 18:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022534; cv=none; b=vDwYMOm6sEMbdMpko4pACbcA5VGuCEIQfYvZDJgR7UnbsXu00fMXDK3GoeJaVLOiXM3SiyVMop6fE3dWUzue11ds/oGKtkSbZjcVnF3Ol23FecN20wuCj+ICCWRWL7WzM0bksh1oLyb8qyA8t2tGXim1+mFJYxl2Bx4lg1/bEaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022534; c=relaxed/simple;
	bh=WhDC/DUNWmY684bKa6eBuxLl5ptjKzDwEd4bimxcE1E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EgvCajuJSCIGX9HaTkLaYDBA8KcEJ2HesfzIBmSvfxG5BY4SSaDHyAB9xmMcSrpSIjLW/d2HGTcT2S+n/5h89ckXUE8PEK+NPrVc3RqNDrlzGmC0pzEhWU1m2z0shXZdJrilwqQH7ykJcuTWIR0krlcySBhxkN+Ftp4wDtpLFJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MRUjXvNQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MRUjXvNQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCA1EC4CEF0;
	Tue, 12 Aug 2025 18:15:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022534;
	bh=WhDC/DUNWmY684bKa6eBuxLl5ptjKzDwEd4bimxcE1E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MRUjXvNQn6Re2TgZ+sBe1iMTaW9ikEpWmR1ACkpXHHmPWZ3eODGVsusRrvene+6BG
	 Df2ruWyPxKRI3z5uWAJw9bTgSYBo8L7ajTZrIGse1/MXyz0xK5GwjE9PsGlP5aC0wn
	 n8fCBvKv2PmuPK/YPU1dJ5dTLvJiF50qdZ69mmZk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	wenglianfa <wenglianfa@huawei.com>,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 184/369] RDMA/hns: Fix double destruction of rsv_qp
Date: Tue, 12 Aug 2025 19:28:01 +0200
Message-ID: <20250812173021.691599945@linuxfoundation.org>
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

[ Upstream commit c6957b95ecc5b63c5a4bb4ecc28af326cf8f6dc8 ]

rsv_qp may be double destroyed in error flow, first in free_mr_init(),
and then in hns_roce_exit(). Fix it by moving the free_mr_init() call
into hns_roce_v2_init().

list_del corruption, ffff589732eb9b50->next is LIST_POISON1 (dead000000000100)
WARNING: CPU: 8 PID: 1047115 at lib/list_debug.c:53 __list_del_entry_valid+0x148/0x240
...
Call trace:
 __list_del_entry_valid+0x148/0x240
 hns_roce_qp_remove+0x4c/0x3f0 [hns_roce_hw_v2]
 hns_roce_v2_destroy_qp_common+0x1dc/0x5f4 [hns_roce_hw_v2]
 hns_roce_v2_destroy_qp+0x22c/0x46c [hns_roce_hw_v2]
 free_mr_exit+0x6c/0x120 [hns_roce_hw_v2]
 hns_roce_v2_exit+0x170/0x200 [hns_roce_hw_v2]
 hns_roce_exit+0x118/0x350 [hns_roce_hw_v2]
 __hns_roce_hw_v2_init_instance+0x1c8/0x304 [hns_roce_hw_v2]
 hns_roce_hw_v2_reset_notify_init+0x170/0x21c [hns_roce_hw_v2]
 hns_roce_hw_v2_reset_notify+0x6c/0x190 [hns_roce_hw_v2]
 hclge_notify_roce_client+0x6c/0x160 [hclge]
 hclge_reset_rebuild+0x150/0x5c0 [hclge]
 hclge_reset+0x10c/0x140 [hclge]
 hclge_reset_subtask+0x80/0x104 [hclge]
 hclge_reset_service_task+0x168/0x3ac [hclge]
 hclge_service_task+0x50/0x100 [hclge]
 process_one_work+0x250/0x9a0
 worker_thread+0x324/0x990
 kthread+0x190/0x210
 ret_from_fork+0x10/0x18

Fixes: fd8489294dd2 ("RDMA/hns: Fix Use-After-Free of rsv_qp on HIP08")
Signed-off-by: wenglianfa <wenglianfa@huawei.com>
Signed-off-by: Junxian Huang <huangjunxian6@hisilicon.com>
Link: https://patch.msgid.link/20250703113905.3597124-2-huangjunxian6@hisilicon.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 25 +++++++++++-----------
 drivers/infiniband/hw/hns/hns_roce_main.c  |  6 +++---
 2 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index 81e44b738122..13b55390db63 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -2971,14 +2971,22 @@ static int hns_roce_v2_init(struct hns_roce_dev *hr_dev)
 {
 	int ret;
 
+	if (hr_dev->pci_dev->revision == PCI_REVISION_ID_HIP08) {
+		ret = free_mr_init(hr_dev);
+		if (ret) {
+			dev_err(hr_dev->dev, "failed to init free mr!\n");
+			return ret;
+		}
+	}
+
 	/* The hns ROCEE requires the extdb info to be cleared before using */
 	ret = hns_roce_clear_extdb_list_info(hr_dev);
 	if (ret)
-		return ret;
+		goto err_clear_extdb_failed;
 
 	ret = get_hem_table(hr_dev);
 	if (ret)
-		return ret;
+		goto err_clear_extdb_failed;
 
 	if (hr_dev->is_vf)
 		return 0;
@@ -2993,6 +3001,9 @@ static int hns_roce_v2_init(struct hns_roce_dev *hr_dev)
 
 err_llm_init_failed:
 	put_hem_table(hr_dev);
+err_clear_extdb_failed:
+	if (hr_dev->pci_dev->revision == PCI_REVISION_ID_HIP08)
+		free_mr_exit(hr_dev);
 
 	return ret;
 }
@@ -7027,21 +7038,11 @@ static int __hns_roce_hw_v2_init_instance(struct hnae3_handle *handle)
 		goto error_failed_roce_init;
 	}
 
-	if (hr_dev->pci_dev->revision == PCI_REVISION_ID_HIP08) {
-		ret = free_mr_init(hr_dev);
-		if (ret) {
-			dev_err(hr_dev->dev, "failed to init free mr!\n");
-			goto error_failed_free_mr_init;
-		}
-	}
 
 	handle->priv = hr_dev;
 
 	return 0;
 
-error_failed_free_mr_init:
-	hns_roce_exit(hr_dev);
-
 error_failed_roce_init:
 	kfree(hr_dev->priv);
 
diff --git a/drivers/infiniband/hw/hns/hns_roce_main.c b/drivers/infiniband/hw/hns/hns_roce_main.c
index e7a497cc125c..623610b3e2ec 100644
--- a/drivers/infiniband/hw/hns/hns_roce_main.c
+++ b/drivers/infiniband/hw/hns/hns_roce_main.c
@@ -965,6 +965,9 @@ static int hns_roce_setup_hca(struct hns_roce_dev *hr_dev)
 
 	spin_lock_init(&hr_dev->sm_lock);
 
+	INIT_LIST_HEAD(&hr_dev->qp_list);
+	spin_lock_init(&hr_dev->qp_list_lock);
+
 	if (hr_dev->caps.flags & HNS_ROCE_CAP_FLAG_CQ_RECORD_DB ||
 	    hr_dev->caps.flags & HNS_ROCE_CAP_FLAG_QP_RECORD_DB) {
 		INIT_LIST_HEAD(&hr_dev->pgdir_list);
@@ -1132,9 +1135,6 @@ int hns_roce_init(struct hns_roce_dev *hr_dev)
 		}
 	}
 
-	INIT_LIST_HEAD(&hr_dev->qp_list);
-	spin_lock_init(&hr_dev->qp_list_lock);
-
 	ret = hns_roce_register_device(hr_dev);
 	if (ret)
 		goto error_failed_register_device;
-- 
2.39.5



