Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 428C81EB5E1;
	Wed, 25 Feb 2026 01:28:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771982909; cv=none; b=XeJ9iNqy60oYAjGWlmPWEVha+bG9NmJXOwkxcMwqRZpBLXhYxXpwU+j2g5VfE1INqwDaXr/dA1MLgNwh0MfR5LY6iAF5vYt66Qwpy5KGIGbBrua/BR/oSI2ekywC06tTuZNgts3pecagRbfP7ouGudFHNarPn7OS3mOSp9qPqKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771982909; c=relaxed/simple;
	bh=MBUTYzHRLKnyHpq+by1XmDQykR/rdsFcWq8TKywYseQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VtOpzvxUClIgxX1t5wszRiumd5gy+yHmOdMjF8lDE67ejIZVij8ZMks78jdKoG3qD2RWSFvv+J/m8nzn81lvvtXCRSAS5BW2QN5CkNguutngWaUxTPXpTtfdg88kv8B270WL/OOb6FP5iO8YOmWSWKXZdbTlBI3193MXGb/vR9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TOETT7Hj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TOETT7Hj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01BD4C116D0;
	Wed, 25 Feb 2026 01:28:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771982909;
	bh=MBUTYzHRLKnyHpq+by1XmDQykR/rdsFcWq8TKywYseQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TOETT7HjRli2Y3BN/z80rbKGoFHqyHoQgPBGN810nIPU2kbPc/eRnhhSUAwO4t5qh
	 BWgwYcbTB7ER1bpqSWf0Mna8zh67kW+O1i2q5nxyuaV7PNxfcVN3MP69xtTTB/7eyN
	 RciI9qzqG0ljzKU5CFnbaqLQKibKhWRjEm+fzrpU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenghai Huang <huangchenghai2@huawei.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 091/781] crypto: hisilicon/sgl - fix inconsistent map/unmap direction issue
Date: Tue, 24 Feb 2026 17:13:20 -0800
Message-ID: <20260225012401.925215993@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
index 24c7b6ab285ba..d41b34405c21c 100644
--- a/drivers/crypto/hisilicon/sgl.c
+++ b/drivers/crypto/hisilicon/sgl.c
@@ -260,7 +260,7 @@ hisi_acc_sg_buf_map_to_hw_sgl(struct device *dev, struct scatterlist *sgl,
 	return curr_hw_sgl;
 
 err_unmap:
-	dma_unmap_sg(dev, sgl, sg_n, DMA_BIDIRECTIONAL);
+	dma_unmap_sg(dev, sgl, sg_n, dir);
 
 	return ERR_PTR(ret);
 }
-- 
2.51.0



