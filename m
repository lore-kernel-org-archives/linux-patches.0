Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A36A3DB8F
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:57:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TiWt1Vjb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46AEFC433CD;
	Wed, 15 Nov 2023 19:57:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700078242;
	bh=HOmqCIKMH0TJ4IB/07nAf1lmX6CNDX4+EF6O3Fp7Yc0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TiWt1VjbldukTAhN/1/p3pqWlOFL1LqqWugMS/Sb5jpF94CNTTvXFeAxJBZUxWxik
	 wUJfrLRbm0cowxQaKUvXP7KNlZ9hWQx6510aaZ0j5Cy6DMve6bZvw09twfzgCWYHX5
	 DmHUWO6HJSix/CWFbFb9blJrlHj/Rmd9qngf4/Vs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Wojciech Ziemba <wojciech.ziemba@intel.com>,
	Adam Guerin <adam.guerin@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 200/379] crypto: qat - extend buffer list interface
Date: Wed, 15 Nov 2023 14:24:35 -0500
Message-ID: <20231115192656.938810426@linuxfoundation.org>
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

From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>

[ Upstream commit cf692906bd61af2eec06a32a83d2a8ec3acf3548 ]

The compression service requires an additional pre-allocated buffer for
each destination scatter list.
Extend the function qat_alg_sgl_to_bufl() to take an additional
structure that contains the dma address and the size of the extra
buffer which will be appended in the destination FW SGL.

The logic that unmaps buffers in qat_alg_free_bufl() has been changed to
start unmapping from buffer 0 instead of skipping the initial buffers
num_buff - num_mapped_bufs as that functionality was not used in the
code.

Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Wojciech Ziemba <wojciech.ziemba@intel.com>
Reviewed-by: Adam Guerin <adam.guerin@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Stable-dep-of: 9b2f33a1bfcd ("crypto: qat - fix unregistration of crypto algorithms")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/qat/qat_common/qat_algs.c |  8 ++--
 drivers/crypto/qat/qat_common/qat_bl.c   | 58 ++++++++++++++++++------
 drivers/crypto/qat/qat_common/qat_bl.h   |  6 +++
 3 files changed, 54 insertions(+), 18 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/qat_algs.c b/drivers/crypto/qat/qat_common/qat_algs.c
index 0e24e30acb040..b61ada5591586 100644
--- a/drivers/crypto/qat/qat_common/qat_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_algs.c
@@ -800,7 +800,7 @@ static int qat_alg_aead_dec(struct aead_request *areq)
 		return -EINVAL;
 
 	ret = qat_bl_sgl_to_bufl(ctx->inst->accel_dev, areq->src, areq->dst,
-				 &qat_req->buf, f);
+				 &qat_req->buf, NULL, f);
 	if (unlikely(ret))
 		return ret;
 
@@ -844,7 +844,7 @@ static int qat_alg_aead_enc(struct aead_request *areq)
 		return -EINVAL;
 
 	ret = qat_bl_sgl_to_bufl(ctx->inst->accel_dev, areq->src, areq->dst,
-				 &qat_req->buf, f);
+				 &qat_req->buf, NULL, f);
 	if (unlikely(ret))
 		return ret;
 
@@ -1030,7 +1030,7 @@ static int qat_alg_skcipher_encrypt(struct skcipher_request *req)
 		return 0;
 
 	ret = qat_bl_sgl_to_bufl(ctx->inst->accel_dev, req->src, req->dst,
-				 &qat_req->buf, f);
+				 &qat_req->buf, NULL, f);
 	if (unlikely(ret))
 		return ret;
 
@@ -1097,7 +1097,7 @@ static int qat_alg_skcipher_decrypt(struct skcipher_request *req)
 		return 0;
 
 	ret = qat_bl_sgl_to_bufl(ctx->inst->accel_dev, req->src, req->dst,
-				 &qat_req->buf, f);
+				 &qat_req->buf, NULL, f);
 	if (unlikely(ret))
 		return ret;
 
diff --git a/drivers/crypto/qat/qat_common/qat_bl.c b/drivers/crypto/qat/qat_common/qat_bl.c
index c32b12d386f0a..221a4eb610a38 100644
--- a/drivers/crypto/qat/qat_common/qat_bl.c
+++ b/drivers/crypto/qat/qat_common/qat_bl.c
@@ -35,10 +35,7 @@ void qat_bl_free_bufl(struct adf_accel_dev *accel_dev,
 		kfree(bl);
 
 	if (blp != blpout) {
-		/* If out of place operation dma unmap only data */
-		int bufless = blout->num_bufs - blout->num_mapped_bufs;
-
-		for (i = bufless; i < blout->num_bufs; i++) {
+		for (i = 0; i < blout->num_mapped_bufs; i++) {
 			dma_unmap_single(dev, blout->bufers[i].addr,
 					 blout->bufers[i].len,
 					 DMA_FROM_DEVICE);
@@ -50,11 +47,13 @@ void qat_bl_free_bufl(struct adf_accel_dev *accel_dev,
 	}
 }
 
-int qat_bl_sgl_to_bufl(struct adf_accel_dev *accel_dev,
-		       struct scatterlist *sgl,
-		       struct scatterlist *sglout,
-		       struct qat_request_buffs *buf,
-		       gfp_t flags)
+static int __qat_bl_sgl_to_bufl(struct adf_accel_dev *accel_dev,
+				struct scatterlist *sgl,
+				struct scatterlist *sglout,
+				struct qat_request_buffs *buf,
+				dma_addr_t extra_dst_buff,
+				size_t sz_extra_dst_buff,
+				gfp_t flags)
 {
 	struct device *dev = &GET_DEV(accel_dev);
 	int i, sg_nctr = 0;
@@ -86,7 +85,7 @@ int qat_bl_sgl_to_bufl(struct adf_accel_dev *accel_dev,
 
 	bufl_dma_dir = sgl != sglout ? DMA_TO_DEVICE : DMA_BIDIRECTIONAL;
 
-	for_each_sg(sgl, sg, n, i)
+	for (i = 0; i < n; i++)
 		bufl->bufers[i].addr = DMA_MAPPING_ERROR;
 
 	for_each_sg(sgl, sg, n, i) {
@@ -113,8 +112,10 @@ int qat_bl_sgl_to_bufl(struct adf_accel_dev *accel_dev,
 	/* Handle out of place operation */
 	if (sgl != sglout) {
 		struct qat_alg_buf *bufers;
+		int extra_buff = extra_dst_buff ? 1 : 0;
+		int n_sglout = sg_nents(sglout);
 
-		n = sg_nents(sglout);
+		n = n_sglout + extra_buff;
 		sz_out = struct_size(buflout, bufers, n);
 		sg_nctr = 0;
 
@@ -129,10 +130,10 @@ int qat_bl_sgl_to_bufl(struct adf_accel_dev *accel_dev,
 		}
 
 		bufers = buflout->bufers;
-		for_each_sg(sglout, sg, n, i)
+		for (i = 0; i < n; i++)
 			bufers[i].addr = DMA_MAPPING_ERROR;
 
-		for_each_sg(sglout, sg, n, i) {
+		for_each_sg(sglout, sg, n_sglout, i) {
 			int y = sg_nctr;
 
 			if (!sg->length)
@@ -146,7 +147,13 @@ int qat_bl_sgl_to_bufl(struct adf_accel_dev *accel_dev,
 			bufers[y].len = sg->length;
 			sg_nctr++;
 		}
+		if (extra_buff) {
+			bufers[sg_nctr].addr = extra_dst_buff;
+			bufers[sg_nctr].len = sz_extra_dst_buff;
+		}
+
 		buflout->num_bufs = sg_nctr;
+		buflout->num_bufs += extra_buff;
 		buflout->num_mapped_bufs = sg_nctr;
 		bloutp = dma_map_single(dev, buflout, sz_out, DMA_TO_DEVICE);
 		if (unlikely(dma_mapping_error(dev, bloutp)))
@@ -166,11 +173,14 @@ int qat_bl_sgl_to_bufl(struct adf_accel_dev *accel_dev,
 		dma_unmap_single(dev, bloutp, sz_out, DMA_TO_DEVICE);
 
 	n = sg_nents(sglout);
-	for (i = 0; i < n; i++)
+	for (i = 0; i < n; i++) {
+		if (buflout->bufers[i].addr == extra_dst_buff)
+			break;
 		if (!dma_mapping_error(dev, buflout->bufers[i].addr))
 			dma_unmap_single(dev, buflout->bufers[i].addr,
 					 buflout->bufers[i].len,
 					 DMA_FROM_DEVICE);
+	}
 
 	if (!buf->sgl_dst_valid)
 		kfree(buflout);
@@ -192,3 +202,23 @@ int qat_bl_sgl_to_bufl(struct adf_accel_dev *accel_dev,
 	dev_err(dev, "Failed to map buf for dma\n");
 	return -ENOMEM;
 }
+
+int qat_bl_sgl_to_bufl(struct adf_accel_dev *accel_dev,
+		       struct scatterlist *sgl,
+		       struct scatterlist *sglout,
+		       struct qat_request_buffs *buf,
+		       struct qat_sgl_to_bufl_params *params,
+		       gfp_t flags)
+{
+	dma_addr_t extra_dst_buff = 0;
+	size_t sz_extra_dst_buff = 0;
+
+	if (params) {
+		extra_dst_buff = params->extra_dst_buff;
+		sz_extra_dst_buff = params->sz_extra_dst_buff;
+	}
+
+	return __qat_bl_sgl_to_bufl(accel_dev, sgl, sglout, buf,
+				    extra_dst_buff, sz_extra_dst_buff,
+				    flags);
+}
diff --git a/drivers/crypto/qat/qat_common/qat_bl.h b/drivers/crypto/qat/qat_common/qat_bl.h
index 1c534c57a36bc..0c174fee9e645 100644
--- a/drivers/crypto/qat/qat_common/qat_bl.h
+++ b/drivers/crypto/qat/qat_common/qat_bl.h
@@ -38,12 +38,18 @@ struct qat_request_buffs {
 	struct qat_alg_fixed_buf_list sgl_dst;
 };
 
+struct qat_sgl_to_bufl_params {
+	dma_addr_t extra_dst_buff;
+	size_t sz_extra_dst_buff;
+};
+
 void qat_bl_free_bufl(struct adf_accel_dev *accel_dev,
 		      struct qat_request_buffs *buf);
 int qat_bl_sgl_to_bufl(struct adf_accel_dev *accel_dev,
 		       struct scatterlist *sgl,
 		       struct scatterlist *sglout,
 		       struct qat_request_buffs *buf,
+		       struct qat_sgl_to_bufl_params *params,
 		       gfp_t flags);
 
 #endif
-- 
2.42.0



