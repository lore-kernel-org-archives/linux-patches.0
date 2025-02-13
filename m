Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF34E214A69;
	Thu, 13 Feb 2025 14:40:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739457632; cv=none; b=hyFLfABiEliyeYXLE4OJ+3k+czNZirN8ZAjB9OGJvHEwGW+s4xBMhOWgQMmS1qqPoJlSjr1L2gQrmQJVS5GmISi5FcqlNB9DgtDiGxKsB+EDG9aDEAfw2sP3Pds8GAFb4jrETCjh7vvf1lWUGc1Az3a/Juuff31cJknIlFgXFyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739457632; c=relaxed/simple;
	bh=TjYMXCDlchaSuZWCh53LnS+5yR4NhFMUzoPXKAaPd6I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oIWGgDarfJBnx9BFxki85pSjYsysZQlD+hTP48t1ehO/63QOztgN3LEfqZjfZAphpEAMxa57oh5Nvp+C4eSTMg1gkvT+d0I5/p6adn818XezNLfja93H862THCeFVJUGaTskRS1i5fmnCzLv0M2W+hoOLoYZOpwyD7Ubry1aILI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rSaTfADi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rSaTfADi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 646BAC4CED1;
	Thu, 13 Feb 2025 14:40:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739457631;
	bh=TjYMXCDlchaSuZWCh53LnS+5yR4NhFMUzoPXKAaPd6I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rSaTfADi1nBlSURdpZE08Gxw3so/xQj5opVh7MvZorCUrsCydngo+Mfy6jSOx68lb
	 UXV5fVs54+o4wayY0h29uyhKee/TCqKh2SDrMo/I1tY8cpMoWYrOLdwfPx4eyYHX6P
	 pRhlDujoVxWMTyls0E6pPQfXrab5pKbGC3Zp1Ylg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Marek=20Ol=C5=A1=C3=A1k?= <marek.olsak@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 168/422] drm/amdgpu: add a BO metadata flag to disable write compression for Vulkan
Date: Thu, 13 Feb 2025 15:25:17 +0100
Message-ID: <20250213142443.027258295@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Olšák <marek.olsak@amd.com>

commit 2255b40cacc2e5ef1b127770fc1808c60de4a2fc upstream.

Vulkan can't support DCC and Z/S compression on GFX12 without
WRITE_COMPRESS_DISABLE in this commit or a completely different DCC
interface.

AMDGPU_TILING_GFX12_SCANOUT is added because it's already used by userspace.

Cc: stable@vger.kernel.org # 6.12.x
Signed-off-by: Marek Olšák <marek.olsak@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c |    3 ++-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c |    8 ++++++--
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.h |    2 ++
 drivers/gpu/drm/amd/amdgpu/sdma_v7_0.c  |    5 +++--
 include/uapi/drm/amdgpu_drm.h           |    9 ++++++++-
 5 files changed, 21 insertions(+), 6 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
@@ -118,9 +118,10 @@
  * - 3.57.0 - Compute tunneling on GFX10+
  * - 3.58.0 - Add GFX12 DCC support
  * - 3.59.0 - Cleared VRAM
+ * - 3.60.0 - Add AMDGPU_TILING_GFX12_DCC_WRITE_COMPRESS_DISABLE (Vulkan requirement)
  */
 #define KMS_DRIVER_MAJOR	3
-#define KMS_DRIVER_MINOR	59
+#define KMS_DRIVER_MINOR	60
 #define KMS_DRIVER_PATCHLEVEL	0
 
 /*
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
@@ -309,7 +309,7 @@ int amdgpu_ttm_copy_mem_to_mem(struct am
 	mutex_lock(&adev->mman.gtt_window_lock);
 	while (src_mm.remaining) {
 		uint64_t from, to, cur_size, tiling_flags;
-		uint32_t num_type, data_format, max_com;
+		uint32_t num_type, data_format, max_com, write_compress_disable;
 		struct dma_fence *next;
 
 		/* Never copy more than 256MiB at once to avoid a timeout */
@@ -340,9 +340,13 @@ int amdgpu_ttm_copy_mem_to_mem(struct am
 			max_com = AMDGPU_TILING_GET(tiling_flags, GFX12_DCC_MAX_COMPRESSED_BLOCK);
 			num_type = AMDGPU_TILING_GET(tiling_flags, GFX12_DCC_NUMBER_TYPE);
 			data_format = AMDGPU_TILING_GET(tiling_flags, GFX12_DCC_DATA_FORMAT);
+			write_compress_disable =
+				AMDGPU_TILING_GET(tiling_flags, GFX12_DCC_WRITE_COMPRESS_DISABLE);
 			copy_flags |= (AMDGPU_COPY_FLAGS_SET(MAX_COMPRESSED, max_com) |
 				       AMDGPU_COPY_FLAGS_SET(NUMBER_TYPE, num_type) |
-				       AMDGPU_COPY_FLAGS_SET(DATA_FORMAT, data_format));
+				       AMDGPU_COPY_FLAGS_SET(DATA_FORMAT, data_format) |
+				       AMDGPU_COPY_FLAGS_SET(WRITE_COMPRESS_DISABLE,
+							     write_compress_disable));
 		}
 
 		r = amdgpu_copy_buffer(ring, from, to, cur_size, resv,
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.h
@@ -118,6 +118,8 @@ struct amdgpu_copy_mem {
 #define AMDGPU_COPY_FLAGS_NUMBER_TYPE_MASK		0x07
 #define AMDGPU_COPY_FLAGS_DATA_FORMAT_SHIFT		8
 #define AMDGPU_COPY_FLAGS_DATA_FORMAT_MASK		0x3f
+#define AMDGPU_COPY_FLAGS_WRITE_COMPRESS_DISABLE_SHIFT	14
+#define AMDGPU_COPY_FLAGS_WRITE_COMPRESS_DISABLE_MASK	0x1
 
 #define AMDGPU_COPY_FLAGS_SET(field, value) \
 	(((__u32)(value) & AMDGPU_COPY_FLAGS_##field##_MASK) << AMDGPU_COPY_FLAGS_##field##_SHIFT)
--- a/drivers/gpu/drm/amd/amdgpu/sdma_v7_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/sdma_v7_0.c
@@ -1688,11 +1688,12 @@ static void sdma_v7_0_emit_copy_buffer(s
 				       uint32_t byte_count,
 				       uint32_t copy_flags)
 {
-	uint32_t num_type, data_format, max_com;
+	uint32_t num_type, data_format, max_com, write_cm;
 
 	max_com = AMDGPU_COPY_FLAGS_GET(copy_flags, MAX_COMPRESSED);
 	data_format = AMDGPU_COPY_FLAGS_GET(copy_flags, DATA_FORMAT);
 	num_type = AMDGPU_COPY_FLAGS_GET(copy_flags, NUMBER_TYPE);
+	write_cm = AMDGPU_COPY_FLAGS_GET(copy_flags, WRITE_COMPRESS_DISABLE) ? 2 : 1;
 
 	ib->ptr[ib->length_dw++] = SDMA_PKT_COPY_LINEAR_HEADER_OP(SDMA_OP_COPY) |
 		SDMA_PKT_COPY_LINEAR_HEADER_SUB_OP(SDMA_SUBOP_COPY_LINEAR) |
@@ -1709,7 +1710,7 @@ static void sdma_v7_0_emit_copy_buffer(s
 	if ((copy_flags & (AMDGPU_COPY_FLAGS_READ_DECOMPRESSED | AMDGPU_COPY_FLAGS_WRITE_COMPRESSED)))
 		ib->ptr[ib->length_dw++] = SDMA_DCC_DATA_FORMAT(data_format) | SDMA_DCC_NUM_TYPE(num_type) |
 			((copy_flags & AMDGPU_COPY_FLAGS_READ_DECOMPRESSED) ? SDMA_DCC_READ_CM(2) : 0) |
-			((copy_flags & AMDGPU_COPY_FLAGS_WRITE_COMPRESSED) ? SDMA_DCC_WRITE_CM(1) : 0) |
+			((copy_flags & AMDGPU_COPY_FLAGS_WRITE_COMPRESSED) ? SDMA_DCC_WRITE_CM(write_cm) : 0) |
 			SDMA_DCC_MAX_COM(max_com) | SDMA_DCC_MAX_UCOM(1);
 	else
 		ib->ptr[ib->length_dw++] = 0;
--- a/include/uapi/drm/amdgpu_drm.h
+++ b/include/uapi/drm/amdgpu_drm.h
@@ -411,13 +411,20 @@ struct drm_amdgpu_gem_userptr {
 /* GFX12 and later: */
 #define AMDGPU_TILING_GFX12_SWIZZLE_MODE_SHIFT			0
 #define AMDGPU_TILING_GFX12_SWIZZLE_MODE_MASK			0x7
-/* These are DCC recompression setting for memory management: */
+/* These are DCC recompression settings for memory management: */
 #define AMDGPU_TILING_GFX12_DCC_MAX_COMPRESSED_BLOCK_SHIFT	3
 #define AMDGPU_TILING_GFX12_DCC_MAX_COMPRESSED_BLOCK_MASK	0x3 /* 0:64B, 1:128B, 2:256B */
 #define AMDGPU_TILING_GFX12_DCC_NUMBER_TYPE_SHIFT		5
 #define AMDGPU_TILING_GFX12_DCC_NUMBER_TYPE_MASK		0x7 /* CB_COLOR0_INFO.NUMBER_TYPE */
 #define AMDGPU_TILING_GFX12_DCC_DATA_FORMAT_SHIFT		8
 #define AMDGPU_TILING_GFX12_DCC_DATA_FORMAT_MASK		0x3f /* [0:4]:CB_COLOR0_INFO.FORMAT, [5]:MM */
+/* When clearing the buffer or moving it from VRAM to GTT, don't compress and set DCC metadata
+ * to uncompressed. Set when parts of an allocation bypass DCC and read raw data. */
+#define AMDGPU_TILING_GFX12_DCC_WRITE_COMPRESS_DISABLE_SHIFT	14
+#define AMDGPU_TILING_GFX12_DCC_WRITE_COMPRESS_DISABLE_MASK	0x1
+/* bit gap */
+#define AMDGPU_TILING_GFX12_SCANOUT_SHIFT			63
+#define AMDGPU_TILING_GFX12_SCANOUT_MASK			0x1
 
 /* Set/Get helpers for tiling flags. */
 #define AMDGPU_TILING_SET(field, value) \


