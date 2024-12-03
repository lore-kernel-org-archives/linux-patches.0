Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EE7B1F707A;
	Tue,  3 Dec 2024 15:13:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238823; cv=none; b=pP7bBT4yBEnIzWMwaCqKed2+cACMzWAaPlysb4FGzh1MwWOxmgTJx4Yy/JhpssD1nHNTUb+DazMe5w6mNMuIuKHQLQjfZsNr8VPPMoiu+eYbLPwdouqmE5yHd/aom5IqtRvzn/fixU49j1/qrPVAe69mvh+N81x5Tjoa90U0jRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238823; c=relaxed/simple;
	bh=MBsGfMpOpA1vRHrvvHDn69kByWC3zyEK/nnlAdTUd3o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E8kEvBRDw7GGlmNYBjPX5sq33VqWSGzNU1wiRCZwImrVCqqFDIv0xTcaP8/mCSyDDvb8fD1xg5SqPFX48aniCEOVbAtSoaDZO8Q5z2LeZOD+vJ1SG+72f/EOg8T2iAPlm4PGAWtvXeluQecZtV0Gd8mOVpD0qsThlmvmvRpolng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EuPKr05l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EuPKr05l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BC42C4CECF;
	Tue,  3 Dec 2024 15:13:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238822;
	bh=MBsGfMpOpA1vRHrvvHDn69kByWC3zyEK/nnlAdTUd3o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EuPKr05lCmLGUY4MYVSQxs7YL+53amLuEYMGnoCZx7kse/0qo9m0Zqysb9IRBQIdG
	 Bx6hpIBu6UROrN2SHOWHHlDP8VawEdrXK2v/8/lhgp44f7rmVzrqzmG9Dr9k8nEswr
	 tqnVYGFaGLu4/aPWARJNFS0jOaOqOSKg4Ml1aMCo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengchang Tang <tangchengchang@huawei.com>,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 377/817] RDMA/hns: Disassociate mmap pages for all uctx when HW is being reset
Date: Tue,  3 Dec 2024 15:39:09 +0100
Message-ID: <20241203144010.561245523@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chengchang Tang <tangchengchang@huawei.com>

[ Upstream commit 615b94746a54702af923b28bd8a629f4ac0ff0d8 ]

When HW is being reset, userspace should not ring doorbell otherwise
it may lead to abnormal consequence such as RAS.

Disassociate mmap pages for all uctx to prevent userspace from ringing
doorbell to HW. Since all resources will be destroyed during HW reset,
no new mmap is allowed after HW reset is completed.

Fixes: 9a4435375cd1 ("IB/hns: Add driver files for hns RoCE driver")
Signed-off-by: Chengchang Tang <tangchengchang@huawei.com>
Signed-off-by: Junxian Huang <huangjunxian6@hisilicon.com>
Link: https://patch.msgid.link/20240927103323.1897094-3-huangjunxian6@hisilicon.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 4 ++++
 drivers/infiniband/hw/hns/hns_roce_main.c  | 5 +++++
 2 files changed, 9 insertions(+)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index 24e906b9d3ae1..f1feaa79f78ee 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -7017,6 +7017,7 @@ static void hns_roce_hw_v2_uninit_instance(struct hnae3_handle *handle,
 
 	handle->rinfo.instance_state = HNS_ROCE_STATE_NON_INIT;
 }
+
 static int hns_roce_hw_v2_reset_notify_down(struct hnae3_handle *handle)
 {
 	struct hns_roce_dev *hr_dev;
@@ -7035,6 +7036,9 @@ static int hns_roce_hw_v2_reset_notify_down(struct hnae3_handle *handle)
 
 	hr_dev->active = false;
 	hr_dev->dis_db = true;
+
+	rdma_user_mmap_disassociate(&hr_dev->ib_dev);
+
 	hr_dev->state = HNS_ROCE_DEVICE_STATE_RST_DOWN;
 
 	return 0;
diff --git a/drivers/infiniband/hw/hns/hns_roce_main.c b/drivers/infiniband/hw/hns/hns_roce_main.c
index 4cb0af7335870..49315f39361de 100644
--- a/drivers/infiniband/hw/hns/hns_roce_main.c
+++ b/drivers/infiniband/hw/hns/hns_roce_main.c
@@ -466,6 +466,11 @@ static int hns_roce_mmap(struct ib_ucontext *uctx, struct vm_area_struct *vma)
 	pgprot_t prot;
 	int ret;
 
+	if (hr_dev->dis_db) {
+		atomic64_inc(&hr_dev->dfx_cnt[HNS_ROCE_DFX_MMAP_ERR_CNT]);
+		return -EPERM;
+	}
+
 	rdma_entry = rdma_user_mmap_entry_get_pgoff(uctx, vma->vm_pgoff);
 	if (!rdma_entry) {
 		atomic64_inc(&hr_dev->dfx_cnt[HNS_ROCE_DFX_MMAP_ERR_CNT]);
-- 
2.43.0



