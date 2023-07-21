Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FB7B200A6
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 19:02:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2211CC433C9;
	Fri, 21 Jul 2023 19:02:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689966134;
	bh=XMuA7nh0BQwZUUMeFkOezyFXWyBpxIiuq4Q67HyTXfU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jhnOQo6UB84MnHSN0v3XaA9kGz4ME79oUmFXaf7IiTB9KsGxzHCQHQXJ8+DA27L4g
	 ezhMLh7XiG1H/mfmCisbBy2LCfIuLn0oxz3hS+H7OTtHsTfwt2MwW5cM5ty2JIH1kk
	 8QLPgkXuRJh6Qzesgp2pIkI+Zzq3SYH7ghwazXpU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hareshx Sankar Raj <hareshx.sankar.raj@intel.com>,
	Bolemx Sivanagaleela <bolemx.sivanagaleela@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 237/532] crypto: qat - unmap buffers before free for RSA
Date: Fri, 21 Jul 2023 18:02:21 +0200
Message-ID: <20230721160627.220553516@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160614.695323302@linuxfoundation.org>
References: <20230721160614.695323302@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Hareshx Sankar Raj <hareshx.sankar.raj@intel.com>

[ Upstream commit d776b25495f2c71b9dbf1f5e53b642215ba72f3c ]

The callback function for RSA frees the memory allocated for the source
and destination buffers before unmapping them.
This sequence is wrong.

Change the cleanup sequence to unmap the buffers before freeing them.

Fixes: 3dfaf0071ed7 ("crypto: qat - remove dma_free_coherent() for RSA")
Signed-off-by: Hareshx Sankar Raj <hareshx.sankar.raj@intel.com>
Co-developed-by: Bolemx Sivanagaleela <bolemx.sivanagaleela@intel.com>
Signed-off-by: Bolemx Sivanagaleela <bolemx.sivanagaleela@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/qat/qat_common/qat_asym_algs.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/qat_asym_algs.c b/drivers/crypto/qat/qat_common/qat_asym_algs.c
index 8806242469a06..4128200a90329 100644
--- a/drivers/crypto/qat/qat_common/qat_asym_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_asym_algs.c
@@ -520,12 +520,14 @@ static void qat_rsa_cb(struct icp_qat_fw_pke_resp *resp)
 
 	err = (err == ICP_QAT_FW_COMN_STATUS_FLAG_OK) ? 0 : -EINVAL;
 
-	kfree_sensitive(req->src_align);
-
 	dma_unmap_single(dev, req->in.rsa.enc.m, req->ctx.rsa->key_sz,
 			 DMA_TO_DEVICE);
 
+	kfree_sensitive(req->src_align);
+
 	areq->dst_len = req->ctx.rsa->key_sz;
+	dma_unmap_single(dev, req->out.rsa.enc.c, req->ctx.rsa->key_sz,
+			 DMA_FROM_DEVICE);
 	if (req->dst_align) {
 		scatterwalk_map_and_copy(req->dst_align, areq->dst, 0,
 					 areq->dst_len, 1);
@@ -533,9 +535,6 @@ static void qat_rsa_cb(struct icp_qat_fw_pke_resp *resp)
 		kfree_sensitive(req->dst_align);
 	}
 
-	dma_unmap_single(dev, req->out.rsa.enc.c, req->ctx.rsa->key_sz,
-			 DMA_FROM_DEVICE);
-
 	dma_unmap_single(dev, req->phy_in, sizeof(struct qat_rsa_input_params),
 			 DMA_TO_DEVICE);
 	dma_unmap_single(dev, req->phy_out,
-- 
2.39.2



