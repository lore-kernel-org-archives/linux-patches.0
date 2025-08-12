Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2BE761FFE;
	Tue, 12 Aug 2025 18:17:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022659; cv=none; b=KxwRpvMvverjLoOZ5gwUS1+EVjcwiD+YZpAixHbw70b0Z/9XNdex0SL17/P+R6xF6a7UK5QTF2v+K7eldGa+udwuNwleQAtUFKs6IzD41nU/OsKuFuUR+//NAeXzUj1JxBauJuZfaQmAZQIuzl8snbrKkFAVwLVtg9BHP8E8Aqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022659; c=relaxed/simple;
	bh=S65DDvSeHUP7lj/5D30DZJSSGefNPNGGmHCH7mM0sRs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hS4MBLA157wfz3xg2CQ3YuJu2bHkOf9ZLsEMvupNQ5yy/PD/SdevzDrzT8ZveOzdDLF29LNQEi0vLcNSuShXWk9HZHz6TPtn0YLcoWnc17LULRRmF+lQDBqFVVT5qemAm99h+IH8GuGhGFoRXt5kglzXZgr19IuUKPi9e6psQBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wLzCr4HN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wLzCr4HN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABD99C4CEF0;
	Tue, 12 Aug 2025 18:17:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022658;
	bh=S65DDvSeHUP7lj/5D30DZJSSGefNPNGGmHCH7mM0sRs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wLzCr4HN9ATlXtmaLjWDyqbOU2geFEGpXuhESoCkGdw/erXv/WMC7jyk1RhHSBtel
	 mPUb6cxPh84D/YLDdwefQTDTaIPDjtMj6pEUubdlkESK0Ivx8AC+eBSx7FEcPZrUiz
	 DngZbD44F2eghGzQ7FxF71SF37fhe/3VrJZ84KMk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Ahsan Atta <ahsan.atta@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 221/369] crypto: qat - fix DMA direction for compression on GEN2 devices
Date: Tue, 12 Aug 2025 19:28:38 +0200
Message-ID: <20250812173023.071236756@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>

[ Upstream commit d41d75fe1b751ee6b347bf1cb1cfe9accc4fcb12 ]

QAT devices perform an additional integrity check during compression by
decompressing the output. Starting from QAT GEN4, this verification is
done in-line by the hardware. However, on GEN2 devices, the hardware
reads back the compressed output from the destination buffer and performs
a decompression operation using it as the source.

In the current QAT driver, destination buffers are always marked as
write-only. This is incorrect for QAT GEN2 compression, where the buffer
is also read during verification. Since commit 6f5dc7658094
("iommu/vt-d: Restore WO permissions on second-level paging entries"),
merged in v6.16-rc1, write-only permissions are strictly enforced, leading
to DMAR errors when using QAT GEN2 devices for compression, if VT-d is
enabled.

Mark the destination buffers as DMA_BIDIRECTIONAL. This ensures
compatibility with GEN2 devices, even though it is not required for
QAT GEN4 and later.

Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Fixes: cf5bb835b7c8 ("crypto: qat - fix DMA transfer direction")
Reviewed-by: Ahsan Atta <ahsan.atta@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/intel/qat/qat_common/qat_bl.c          | 6 +++---
 drivers/crypto/intel/qat/qat_common/qat_compression.c | 4 ++--
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_common/qat_bl.c b/drivers/crypto/intel/qat/qat_common/qat_bl.c
index 338acf29c487..5a7b43f9150d 100644
--- a/drivers/crypto/intel/qat/qat_common/qat_bl.c
+++ b/drivers/crypto/intel/qat/qat_common/qat_bl.c
@@ -38,7 +38,7 @@ void qat_bl_free_bufl(struct adf_accel_dev *accel_dev,
 		for (i = 0; i < blout->num_mapped_bufs; i++) {
 			dma_unmap_single(dev, blout->buffers[i].addr,
 					 blout->buffers[i].len,
-					 DMA_FROM_DEVICE);
+					 DMA_BIDIRECTIONAL);
 		}
 		dma_unmap_single(dev, blpout, sz_out, DMA_TO_DEVICE);
 
@@ -162,7 +162,7 @@ static int __qat_bl_sgl_to_bufl(struct adf_accel_dev *accel_dev,
 			}
 			buffers[y].addr = dma_map_single(dev, sg_virt(sg) + left,
 							 sg->length - left,
-							 DMA_FROM_DEVICE);
+							 DMA_BIDIRECTIONAL);
 			if (unlikely(dma_mapping_error(dev, buffers[y].addr)))
 				goto err_out;
 			buffers[y].len = sg->length;
@@ -204,7 +204,7 @@ static int __qat_bl_sgl_to_bufl(struct adf_accel_dev *accel_dev,
 		if (!dma_mapping_error(dev, buflout->buffers[i].addr))
 			dma_unmap_single(dev, buflout->buffers[i].addr,
 					 buflout->buffers[i].len,
-					 DMA_FROM_DEVICE);
+					 DMA_BIDIRECTIONAL);
 	}
 
 	if (!buf->sgl_dst_valid)
diff --git a/drivers/crypto/intel/qat/qat_common/qat_compression.c b/drivers/crypto/intel/qat/qat_common/qat_compression.c
index 2c3aa89b316a..cf94ba3011d5 100644
--- a/drivers/crypto/intel/qat/qat_common/qat_compression.c
+++ b/drivers/crypto/intel/qat/qat_common/qat_compression.c
@@ -205,7 +205,7 @@ static int qat_compression_alloc_dc_data(struct adf_accel_dev *accel_dev)
 	if (!obuff)
 		goto err;
 
-	obuff_p = dma_map_single(dev, obuff, ovf_buff_sz, DMA_FROM_DEVICE);
+	obuff_p = dma_map_single(dev, obuff, ovf_buff_sz, DMA_BIDIRECTIONAL);
 	if (unlikely(dma_mapping_error(dev, obuff_p)))
 		goto err;
 
@@ -233,7 +233,7 @@ static void qat_free_dc_data(struct adf_accel_dev *accel_dev)
 		return;
 
 	dma_unmap_single(dev, dc_data->ovf_buff_p, dc_data->ovf_buff_sz,
-			 DMA_FROM_DEVICE);
+			 DMA_BIDIRECTIONAL);
 	kfree_sensitive(dc_data->ovf_buff);
 	kfree(dc_data);
 	accel_dev->dc_data = NULL;
-- 
2.39.5



