Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C7861DED48;
	Tue,  8 Oct 2024 12:18:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728389904; cv=none; b=RizBzz0nWwiVWOzhHPuYAGIfPPSQ/dH8e22RVFycSr/Aqskdkcn1n6g+qN6ziwvSiORdJNm6qN1YeeB0zNQtHWZsySOvAUzpe7Wz4xExs2kG7ox0UmdZc6j15PfGCk0UO6Bg7Aikd9knZ0Dk1F6xINg5Ngt2aFxA/Vxv3rLDbGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728389904; c=relaxed/simple;
	bh=ANRiti7PHLze5O9jQ9LVDdiK7voIf3UHCzdHJO/j+8c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gXODUB/cnasKEeYiq7yx/kPvx7qteqtcvlk3MBhgDFnCMAL/C5ACzX1AM9/Ht+GfwRxr5LlkqlsnxBiokFXQ9OROYl+IzexV1WSmAiO0eShWNlWbuc7LfXXbMIrpY+CariLYYxogvj1dc2+M8nc1RlGm7oqyW5QqrIvQ75hyG04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1AYRKsw9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1AYRKsw9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFDF2C4CEC7;
	Tue,  8 Oct 2024 12:18:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728389904;
	bh=ANRiti7PHLze5O9jQ9LVDdiK7voIf3UHCzdHJO/j+8c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1AYRKsw9Y5BetNkA4cIJrPTNITeeSQ/98eJoLbGeaJnDfxcSGVU7kNj0g0g5A1MLU
	 CJuTxJSFki5qjZJ6Knt8lk684fh/h/JeFi3Pcd77l0FKR1HD09np4PafHmVL+18j0T
	 AoBY/0Cxq54J7zYxU9+IzlvmdGJPinxVAldbhGhk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Shen <shenyang39@huawei.com>,
	Chenghai Huang <huangchenghai2@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 132/482] crypto: hisilicon - fix missed error branch
Date: Tue,  8 Oct 2024 14:03:15 +0200
Message-ID: <20241008115653.499181163@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Shen <shenyang39@huawei.com>

[ Upstream commit f386dc64e1a5d3dcb84579119ec350ab026fea88 ]

If an error occurs in the process after the SGL is mapped
successfully, it need to unmap the SGL.

Otherwise, memory problems may occur.

Signed-off-by: Yang Shen <shenyang39@huawei.com>
Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/hisilicon/sgl.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/hisilicon/sgl.c b/drivers/crypto/hisilicon/sgl.c
index 568acd0aee3fa..c974f95cd126f 100644
--- a/drivers/crypto/hisilicon/sgl.c
+++ b/drivers/crypto/hisilicon/sgl.c
@@ -225,7 +225,7 @@ hisi_acc_sg_buf_map_to_hw_sgl(struct device *dev,
 	dma_addr_t curr_sgl_dma = 0;
 	struct acc_hw_sge *curr_hw_sge;
 	struct scatterlist *sg;
-	int sg_n;
+	int sg_n, ret;
 
 	if (!dev || !sgl || !pool || !hw_sgl_dma || index >= pool->count)
 		return ERR_PTR(-EINVAL);
@@ -240,14 +240,15 @@ hisi_acc_sg_buf_map_to_hw_sgl(struct device *dev,
 
 	if (sg_n_mapped > pool->sge_nr) {
 		dev_err(dev, "the number of entries in input scatterlist is bigger than SGL pool setting.\n");
-		return ERR_PTR(-EINVAL);
+		ret = -EINVAL;
+		goto err_unmap;
 	}
 
 	curr_hw_sgl = acc_get_sgl(pool, index, &curr_sgl_dma);
 	if (IS_ERR(curr_hw_sgl)) {
 		dev_err(dev, "Get SGL error!\n");
-		dma_unmap_sg(dev, sgl, sg_n, DMA_BIDIRECTIONAL);
-		return ERR_PTR(-ENOMEM);
+		ret = -ENOMEM;
+		goto err_unmap;
 	}
 	curr_hw_sgl->entry_length_in_sgl = cpu_to_le16(pool->sge_nr);
 	curr_hw_sge = curr_hw_sgl->sge_entries;
@@ -262,6 +263,11 @@ hisi_acc_sg_buf_map_to_hw_sgl(struct device *dev,
 	*hw_sgl_dma = curr_sgl_dma;
 
 	return curr_hw_sgl;
+
+err_unmap:
+	dma_unmap_sg(dev, sgl, sg_n, DMA_BIDIRECTIONAL);
+
+	return ERR_PTR(ret);
 }
 EXPORT_SYMBOL_GPL(hisi_acc_sg_buf_map_to_hw_sgl);
 
-- 
2.43.0



