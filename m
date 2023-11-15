Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07CF13DB8F
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:57:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LBREdt4+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0F09C433C9;
	Wed, 15 Nov 2023 19:57:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700078240;
	bh=3/6HZx9Oa4h8fLOJc4ojH+tqrhFBFz8Lb6/XU7DMdsY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LBREdt4+e1Be8lD6HYiy+O3Bie+wes47jn50HLb2sKyqbdNfEpUBhxgghpQVT+wqO
	 m/1t/ecVDDdkn9U6nBmyXVyfS6w7QH4rybfC35SayKiIoaVsS+LX9J0XBb9MKOU5p8
	 bx/Nn/VhNM3lfD+Sr8agRN+Ei4Xmmc8OM+AyVs+A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Wojciech Ziemba <wojciech.ziemba@intel.com>,
	Adam Guerin <adam.guerin@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 199/379] crypto: qat - generalize crypto request buffers
Date: Wed, 15 Nov 2023 14:24:34 -0500
Message-ID: <20231115192656.878357558@linuxfoundation.org>
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

[ Upstream commit 36ebc7472afeb58f1eb1d4c1f0546b9e98acea46 ]

The structure qat_crypto_request_buffs which contains the source and
destination buffer lists and correspondent sizes and dma addresses is
also required for the compression service.
Rename it as qat_request_buffs and move it to qat_bl.h.

Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Wojciech Ziemba <wojciech.ziemba@intel.com>
Reviewed-by: Adam Guerin <adam.guerin@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Stable-dep-of: 9b2f33a1bfcd ("crypto: qat - fix unregistration of crypto algorithms")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/qat/qat_common/qat_bl.c     |  4 +--
 drivers/crypto/qat/qat_common/qat_bl.h     | 38 ++++++++++++++++++++--
 drivers/crypto/qat/qat_common/qat_crypto.h | 36 ++------------------
 3 files changed, 39 insertions(+), 39 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/qat_bl.c b/drivers/crypto/qat/qat_common/qat_bl.c
index 5e319887f8d69..c32b12d386f0a 100644
--- a/drivers/crypto/qat/qat_common/qat_bl.c
+++ b/drivers/crypto/qat/qat_common/qat_bl.c
@@ -11,7 +11,7 @@
 #include "qat_crypto.h"
 
 void qat_bl_free_bufl(struct adf_accel_dev *accel_dev,
-		      struct qat_crypto_request_buffs *buf)
+		      struct qat_request_buffs *buf)
 {
 	struct device *dev = &GET_DEV(accel_dev);
 	struct qat_alg_buf_list *bl = buf->bl;
@@ -53,7 +53,7 @@ void qat_bl_free_bufl(struct adf_accel_dev *accel_dev,
 int qat_bl_sgl_to_bufl(struct adf_accel_dev *accel_dev,
 		       struct scatterlist *sgl,
 		       struct scatterlist *sglout,
-		       struct qat_crypto_request_buffs *buf,
+		       struct qat_request_buffs *buf,
 		       gfp_t flags)
 {
 	struct device *dev = &GET_DEV(accel_dev);
diff --git a/drivers/crypto/qat/qat_common/qat_bl.h b/drivers/crypto/qat/qat_common/qat_bl.h
index 241299c219dd5..1c534c57a36bc 100644
--- a/drivers/crypto/qat/qat_common/qat_bl.h
+++ b/drivers/crypto/qat/qat_common/qat_bl.h
@@ -4,14 +4,46 @@
 #define QAT_BL_H
 #include <linux/scatterlist.h>
 #include <linux/types.h>
-#include "qat_crypto.h"
+
+#define QAT_MAX_BUFF_DESC	4
+
+struct qat_alg_buf {
+	u32 len;
+	u32 resrvd;
+	u64 addr;
+} __packed;
+
+struct qat_alg_buf_list {
+	u64 resrvd;
+	u32 num_bufs;
+	u32 num_mapped_bufs;
+	struct qat_alg_buf bufers[];
+} __packed;
+
+struct qat_alg_fixed_buf_list {
+	struct qat_alg_buf_list sgl_hdr;
+	struct qat_alg_buf descriptors[QAT_MAX_BUFF_DESC];
+} __packed __aligned(64);
+
+struct qat_request_buffs {
+	struct qat_alg_buf_list *bl;
+	dma_addr_t blp;
+	struct qat_alg_buf_list *blout;
+	dma_addr_t bloutp;
+	size_t sz;
+	size_t sz_out;
+	bool sgl_src_valid;
+	bool sgl_dst_valid;
+	struct qat_alg_fixed_buf_list sgl_src;
+	struct qat_alg_fixed_buf_list sgl_dst;
+};
 
 void qat_bl_free_bufl(struct adf_accel_dev *accel_dev,
-		      struct qat_crypto_request_buffs *buf);
+		      struct qat_request_buffs *buf);
 int qat_bl_sgl_to_bufl(struct adf_accel_dev *accel_dev,
 		       struct scatterlist *sgl,
 		       struct scatterlist *sglout,
-		       struct qat_crypto_request_buffs *buf,
+		       struct qat_request_buffs *buf,
 		       gfp_t flags);
 
 #endif
diff --git a/drivers/crypto/qat/qat_common/qat_crypto.h b/drivers/crypto/qat/qat_common/qat_crypto.h
index df3c738ce323a..bb116357a5684 100644
--- a/drivers/crypto/qat/qat_common/qat_crypto.h
+++ b/drivers/crypto/qat/qat_common/qat_crypto.h
@@ -8,6 +8,7 @@
 #include <linux/slab.h>
 #include "adf_accel_devices.h"
 #include "icp_qat_fw_la.h"
+#include "qat_bl.h"
 
 struct qat_instance_backlog {
 	struct list_head list;
@@ -35,39 +36,6 @@ struct qat_crypto_instance {
 	struct qat_instance_backlog backlog;
 };
 
-#define QAT_MAX_BUFF_DESC	4
-
-struct qat_alg_buf {
-	u32 len;
-	u32 resrvd;
-	u64 addr;
-} __packed;
-
-struct qat_alg_buf_list {
-	u64 resrvd;
-	u32 num_bufs;
-	u32 num_mapped_bufs;
-	struct qat_alg_buf bufers[];
-} __packed;
-
-struct qat_alg_fixed_buf_list {
-	struct qat_alg_buf_list sgl_hdr;
-	struct qat_alg_buf descriptors[QAT_MAX_BUFF_DESC];
-} __packed __aligned(64);
-
-struct qat_crypto_request_buffs {
-	struct qat_alg_buf_list *bl;
-	dma_addr_t blp;
-	struct qat_alg_buf_list *blout;
-	dma_addr_t bloutp;
-	size_t sz;
-	size_t sz_out;
-	bool sgl_src_valid;
-	bool sgl_dst_valid;
-	struct qat_alg_fixed_buf_list sgl_src;
-	struct qat_alg_fixed_buf_list sgl_dst;
-};
-
 struct qat_crypto_request;
 
 struct qat_crypto_request {
@@ -80,7 +48,7 @@ struct qat_crypto_request {
 		struct aead_request *aead_req;
 		struct skcipher_request *skcipher_req;
 	};
-	struct qat_crypto_request_buffs buf;
+	struct qat_request_buffs buf;
 	void (*cb)(struct icp_qat_fw_la_resp *resp,
 		   struct qat_crypto_request *req);
 	union {
-- 
2.42.0



