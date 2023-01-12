Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63043749D
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:16:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 660F3C433D2;
	Thu, 12 Jan 2023 14:16:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673533014;
	bh=FkL/gRwtYHPM20wQyKws5rG7peWoGXoe9EQZ10OhwgA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h/fSi3HlSw3VmA1vKqhXmooJDF/p4LZDunswetc5z7IAJgOgsaAtDjfRlD1gQA8q4
	 IdTlzA4pQs1w367HftpzYyra8Pk5W+mMDKPdo6G2uZNIWSzLZZfubDyTQsCF1IVnrV
	 r6d2itKGOeEfvsQpTZqRTuSVni3wTARPaXW/0M04=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhengchao Shao <shaozhengchao@huawei.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 310/783] RDMA/hns: fix memory leak in hns_roce_alloc_mr()
Date: Thu, 12 Jan 2023 14:50:26 +0100
Message-Id: <20230112135538.704790792@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zhengchao Shao <shaozhengchao@huawei.com>

[ Upstream commit a115aa00b18f7b8982b8f458149632caf64a862a ]

When hns_roce_mr_enable() failed in hns_roce_alloc_mr(), mr_key is not
released. Compiled test only.

Fixes: 9b2cf76c9f05 ("RDMA/hns: Optimize PBL buffer allocation process")
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
Link: https://lore.kernel.org/r/20221119070834.48502-1-shaozhengchao@huawei.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_mr.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_mr.c b/drivers/infiniband/hw/hns/hns_roce_mr.c
index 6d7cc724862f..1c342a7bd7df 100644
--- a/drivers/infiniband/hw/hns/hns_roce_mr.c
+++ b/drivers/infiniband/hw/hns/hns_roce_mr.c
@@ -456,10 +456,10 @@ struct ib_mr *hns_roce_alloc_mr(struct ib_pd *pd, enum ib_mr_type mr_type,
 
 	return &mr->ibmr;
 
-err_key:
-	free_mr_key(hr_dev, mr);
 err_pbl:
 	free_mr_pbl(hr_dev, mr);
+err_key:
+	free_mr_key(hr_dev, mr);
 err_free:
 	kfree(mr);
 	return ERR_PTR(ret);
-- 
2.35.1



