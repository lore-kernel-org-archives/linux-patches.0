Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 733F415CAC
	for <patches@lists.linux.dev>; Tue,  8 Nov 2022 13:54:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7271C433C1;
	Tue,  8 Nov 2022 13:54:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667915649;
	bh=2tc5AU13tcn22TcprDkJX5PCUt9xCGz4hXo5uIKWqbo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k6I5vpg7M5v7FJKPQe6Bu+OG865hWRSIcvS56YkERhAxxUK8Tw6oi69oYVEMdNUcw
	 2VMu9Yn4bZDJA7nAQhmrQ3bI55O2eERoSIiG+wbv3KNEj0CeGvLKA0S0EAkYi7AXca
	 kcmx9eNuvJdBX7IyG6nSzJh57UzmZu2rB6xama5Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@oracle.com>,
	Leon Romanovsky <leon@kernel.org>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 021/118] RDMA/qedr: clean up work queue on failure in qedr_alloc_resources()
Date: Tue,  8 Nov 2022 14:38:19 +0100
Message-Id: <20221108133341.585200864@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133340.718216105@linuxfoundation.org>
References: <20221108133340.718216105@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 7a47e077e503feb73d56e491ce89aa73b67a3972 ]

Add a check for if create_singlethread_workqueue() fails and also destroy
the work queue on failure paths.

Fixes: e411e0587e0d ("RDMA/qedr: Add iWARP connection management functions")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Link: https://lore.kernel.org/r/Y1gBkDucQhhWj5YM@kili
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/qedr/main.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/qedr/main.c b/drivers/infiniband/hw/qedr/main.c
index 967641662b24..d0bb61b7e419 100644
--- a/drivers/infiniband/hw/qedr/main.c
+++ b/drivers/infiniband/hw/qedr/main.c
@@ -374,6 +374,10 @@ static int qedr_alloc_resources(struct qedr_dev *dev)
 	if (IS_IWARP(dev)) {
 		xa_init(&dev->qps);
 		dev->iwarp_wq = create_singlethread_workqueue("qedr_iwarpq");
+		if (!dev->iwarp_wq) {
+			rc = -ENOMEM;
+			goto err1;
+		}
 	}
 
 	/* Allocate Status blocks for CNQ */
@@ -381,7 +385,7 @@ static int qedr_alloc_resources(struct qedr_dev *dev)
 				GFP_KERNEL);
 	if (!dev->sb_array) {
 		rc = -ENOMEM;
-		goto err1;
+		goto err_destroy_wq;
 	}
 
 	dev->cnq_array = kcalloc(dev->num_cnq,
@@ -432,6 +436,9 @@ static int qedr_alloc_resources(struct qedr_dev *dev)
 	kfree(dev->cnq_array);
 err2:
 	kfree(dev->sb_array);
+err_destroy_wq:
+	if (IS_IWARP(dev))
+		destroy_workqueue(dev->iwarp_wq);
 err1:
 	kfree(dev->sgid_tbl);
 	return rc;
-- 
2.35.1



