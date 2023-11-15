Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0563D3DBB8
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:58:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JMI1fS1R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAFEEC433C8;
	Wed, 15 Nov 2023 19:58:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700078309;
	bh=bwnvWftxlIbnUs81YLrFahmfJMPhdiyYrWuaxqnFQrg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JMI1fS1RtAou5F1+CLv2yB+mMsh5AcfbmLL7i2b5Cq5tFik+aRLb3fx6jck1muiGC
	 9PlloYin/bQ1+uiv++oIDRyI5xhneHkKZ7umYIGqAl4epQ40n6qYvTT8C9G0VMPQ+Q
	 7UE2kMjC/jlKPgqYw2g8KEc+aAsTcKR7/Y09qxSE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengchang Tang <tangchengchang@huawei.com>,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 219/379] RDMA/hns: Fix uninitialized ucmd in hns_roce_create_qp_common()
Date: Wed, 15 Nov 2023 14:24:54 -0500
Message-ID: <20231115192658.075980176@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115192645.143643130@linuxfoundation.org>
References: <20231115192645.143643130@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chengchang Tang <tangchengchang@huawei.com>

[ Upstream commit c64e9710f9241e38a1c761ed1c1a30854784da66 ]

ucmd in hns_roce_create_qp_common() are not initialized. But it works fine
until new member sdb_addr is added to struct hns_roce_ib_create_qp.

If the user-mode driver uses an old version ABI, then the value of the new
member will be undefined after ib_copy_from_udata().

This patch fixes it by initialize this variable to 0. And the default value
of the new member sdb_addr will be 0 which is invalid.

Fixes: 0425e3e6e0c7 ("RDMA/hns: Support flush cqe for hip08 in kernel space")
Signed-off-by: Chengchang Tang <tangchengchang@huawei.com>
Signed-off-by: Junxian Huang <huangjunxian6@hisilicon.com>
Link: https://lore.kernel.org/r/20231017125239.164455-3-huangjunxian6@hisilicon.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_qp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_qp.c b/drivers/infiniband/hw/hns/hns_roce_qp.c
index 7a95f8677a02c..7b79e6b3f3baa 100644
--- a/drivers/infiniband/hw/hns/hns_roce_qp.c
+++ b/drivers/infiniband/hw/hns/hns_roce_qp.c
@@ -1128,7 +1128,7 @@ static int hns_roce_create_qp_common(struct hns_roce_dev *hr_dev,
 {
 	struct hns_roce_ib_create_qp_resp resp = {};
 	struct ib_device *ibdev = &hr_dev->ib_dev;
-	struct hns_roce_ib_create_qp ucmd;
+	struct hns_roce_ib_create_qp ucmd = {};
 	int ret;
 
 	mutex_init(&hr_qp->mutex);
-- 
2.42.0



