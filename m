Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A55D1863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:15:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ADE5C433EF;
	Wed, 28 Dec 2022 15:15:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672240507;
	bh=pUFWZ5MW5W9wyBN/ICba+Rofm1EMP5FUmDntusvg0yE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AC07xze9EYxD3XaFwzb0aTC3B1jqzHzZVWRhE0QfuuVRrgmKWhxvYMkk1zbiINKVF
	 JSaz6Q7YlFzmHqH7W1lc90Q7w9x7LHqmIE3w56TWLGMD1oNF6QuE6qr8IMSe4xuSxt
	 E95AC12VwQGg7z/eKB/GoHpGnk8lQDX/SkvVhtIA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weili Qian <qianweili@huawei.com>,
	Yang Shen <shenyang39@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 361/731] crypto: hisilicon/qm - fix missing destroy qp_idr
Date: Wed, 28 Dec 2022 15:37:48 +0100
Message-Id: <20221228144307.025779269@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Weili Qian <qianweili@huawei.com>

[ Upstream commit 116be08f6e4e385733d42360a33c3d883d2dd702 ]

In the function hisi_qm_memory_init(), if resource alloc fails after
idr_init, the initialized qp_idr needs to be destroyed.

Signed-off-by: Weili Qian <qianweili@huawei.com>
Signed-off-by: Yang Shen <shenyang39@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/hisilicon/qm.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index b8900a5dbf6e..fd89918abd19 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -5727,8 +5727,8 @@ static int hisi_qm_memory_init(struct hisi_qm *qm)
 					 GFP_ATOMIC);
 	dev_dbg(dev, "allocate qm dma buf size=%zx)\n", qm->qdma.size);
 	if (!qm->qdma.va) {
-		ret =  -ENOMEM;
-		goto err_alloc_qdma;
+		ret = -ENOMEM;
+		goto err_destroy_idr;
 	}
 
 	QM_INIT_BUF(qm, eqe, QM_EQ_DEPTH);
@@ -5744,7 +5744,8 @@ static int hisi_qm_memory_init(struct hisi_qm *qm)
 
 err_alloc_qp_array:
 	dma_free_coherent(dev, qm->qdma.size, qm->qdma.va, qm->qdma.dma);
-err_alloc_qdma:
+err_destroy_idr:
+	idr_destroy(&qm->qp_idr);
 	kfree(qm->factor);
 
 	return ret;
-- 
2.35.1



