Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 983B026158C;
	Wed, 25 Feb 2026 01:43:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983799; cv=none; b=rm4+qJs5u7vDrSox0zmmW2zyB3n+nVvXaB0PTKnAjsEh7H3yawSxyDLPtFBqOGzNX7u7tpnZmeZP5TxfcdoyB4fpEVbWU4qHAwQokCUcLkpUsk5KocDoPRulHdF56Itzy3m+S5rspzfWXlSBuPABwNr2xdjxdp4LUwl/2FdRgkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983799; c=relaxed/simple;
	bh=Ykp9gsiTethrN6RcNJ/qsjPtT3JfwP4ZYpq1jE0/Ur8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=epAFLlSr058o+73YBhVsGhlczW0H4i9aNZemYz4I4HUBCZhHsJTsAaabdi/q8k2lf05z9RDEe5nulqx11INb9Aoi9/l1ROsxrGSd3eewP/O+9nS5t9VhmbhtcSrsFPWsLHtwZ+Hec9x/iJWaIx6mWncEg8nFd9BOmBY21M/Fp7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mb5DUsv9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mb5DUsv9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57612C116D0;
	Wed, 25 Feb 2026 01:43:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983799;
	bh=Ykp9gsiTethrN6RcNJ/qsjPtT3JfwP4ZYpq1jE0/Ur8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mb5DUsv9RNGzGozvX1twFBe09RlPxvSibrfvdn5lftVOQQiPAMDMbpNYK2sNmaFf6
	 8c3sPd0MOz5n9R4IHuAoug9+NFBSwTHL2xqhT3/O9RFAubSIxO4BBhafOXesFSKyNi
	 m0i9DsHU0nfJBwSwrPknJWsraFYZNsTmdt72h/Y8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenghai Huang <huangchenghai2@huawei.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 083/641] crypto: hisilicon/sgl - fix inconsistent map/unmap direction issue
Date: Tue, 24 Feb 2026 17:16:49 -0800
Message-ID: <20260225012351.099087937@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chenghai Huang <huangchenghai2@huawei.com>

[ Upstream commit 4154f7d3b1c133b909d20c44ecb8277e8482aa6b ]

Ensure that the direction for dma_map_sg and dma_unmap_sg is
consistent.

Fixes: 2566de3e06a3 ("crypto: hisilicon - Use fine grained DMA mapping direction")
Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/hisilicon/sgl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/hisilicon/sgl.c b/drivers/crypto/hisilicon/sgl.c
index 7a9ef2a9972a2..848ad7b101d93 100644
--- a/drivers/crypto/hisilicon/sgl.c
+++ b/drivers/crypto/hisilicon/sgl.c
@@ -265,7 +265,7 @@ hisi_acc_sg_buf_map_to_hw_sgl(struct device *dev, struct scatterlist *sgl,
 	return curr_hw_sgl;
 
 err_unmap:
-	dma_unmap_sg(dev, sgl, sg_n, DMA_BIDIRECTIONAL);
+	dma_unmap_sg(dev, sgl, sg_n, dir);
 
 	return ERR_PTR(ret);
 }
-- 
2.51.0



