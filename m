Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0703A1DE2CF;
	Tue,  8 Oct 2024 12:46:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391582; cv=none; b=CQ35JFUvjLohfxbfZGA6ftljd8zSZfuWArJG8wDYGsQC/wduNK5nLaI/s0eVLk+89wtOmgdNjxoZs0Pr6BwlHTYIpNDEsFNGYx99PL346osU5ZA1/INSmVGVQ8Om+Nu7zbXSPsGfGtzgERlJzRG2xYE4rzuhNUPOj1zc9iCvLEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391582; c=relaxed/simple;
	bh=sahE01RuJPa54Uic5RkBrF0JU4D4uDH4bwcXT/CGhE0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zchse91GvOk44c9l8QXrQuUuBYn2q+TiPszIfm/3YjnEJDsOXD8gIRNNCJyXA+LeePUYqsCwJTkf9d6XdTFTqrsJLCO3QpDRCFnSTKIbrLT6cI3wVTNrfTc8tkJn7p/aBt4zJ8SDNreoQ4f9mwfpb7fRm8OTPJa/cJkkJDgUiXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wVuzRmx7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wVuzRmx7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 762D9C4CEC7;
	Tue,  8 Oct 2024 12:46:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391581;
	bh=sahE01RuJPa54Uic5RkBrF0JU4D4uDH4bwcXT/CGhE0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wVuzRmx7faw/QwsoFqmh7ahnUFQfNkpxTeuO5JNyBk2GXm2U44YNl+xXAkGbod62A
	 wHvof9wRd795KlDuil9mhu31w8IZPlqJ/V4Wp7hK0IZ0gQqtY4qNT8N6xjCn0rcE+0
	 N3zuZNQQa9G4tLv3MB2gOhd4mci0ICGW/1KAivgs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Shen <shenyang39@huawei.com>,
	Chenghai Huang <huangchenghai2@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 159/558] crypto: hisilicon - fix missed error branch
Date: Tue,  8 Oct 2024 14:03:09 +0200
Message-ID: <20241008115708.617673332@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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



