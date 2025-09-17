Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C45E1E25EF;
	Wed, 17 Sep 2025 12:40:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758112834; cv=none; b=bpmRHiDiy2ILUecR+dTYxLHpfG/Sd4r0gBh9wNFdDpNzOgodQr/rH7GLY2yIZoIURdjdpADuWui7IYigXW85K1iEW3yj4ZFLWDq35OjE1bCaz2nyQTv4O99SjT8mPnhuaoEx+TJKt4SUm9l7yyb9m3LeebLvEdPNtnI3MrKXLbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758112834; c=relaxed/simple;
	bh=pOGOqfnTzxm34IHtdPtiQnBJjrMsokurYnRSiZCTEC0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rJhiL+QJQmH1UmtbrW3XmMuiIIWZTrUNIS5/j4HyowVm2VgrCTnkNkUwLL1jmhdB4J1QKgVSJ/7OHwgNJN/N7LJ3E/og98/th8uZfJ/+UfiEdN/G0rcB7P29ccXv0Dftf3lywdqePnWSQPr5tCPwVJZ0z+vUB+s6iPalJvo7MG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gx9UaAo9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gx9UaAo9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB7C1C4CEF0;
	Wed, 17 Sep 2025 12:40:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758112834;
	bh=pOGOqfnTzxm34IHtdPtiQnBJjrMsokurYnRSiZCTEC0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gx9UaAo9iVgDX7xIDrzeZHc71tTVEslY0at/C553e6QtoRTGzD0ms+sIJAD/Tt7JK
	 9cLlKuJEKw/FCD6JWVOnj80fmo7gwicRDS8wYz4K3gObeDD+PXnW/jjKcrTkWzJmAe
	 2Uk2SfvQrDkY68pLBh3nlFhJ+Lw1HrUYmHxRmQfw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Rosca <david.rosca@amd.com>,
	Leo Liu <leo.liu@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.16 090/189] drm/amdgpu/vcn4: Fix IB parsing with multiple engine info packages
Date: Wed, 17 Sep 2025 14:33:20 +0200
Message-ID: <20250917123354.054528040@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123351.839989757@linuxfoundation.org>
References: <20250917123351.839989757@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Rosca <david.rosca@amd.com>

commit 2b10cb58d7a3fd621ec9b2ba765a092e562ef998 upstream.

There can be multiple engine info packages in one IB and the first one
may be common engine, not decode/encode.
We need to parse the entire IB instead of stopping after finding first
engine info.

Signed-off-by: David Rosca <david.rosca@amd.com>
Reviewed-by: Leo Liu <leo.liu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit dc8f9f0f45166a6b37864e7a031c726981d6e5fc)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/vcn_v4_0.c |   52 +++++++++++++---------------------
 1 file changed, 21 insertions(+), 31 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/vcn_v4_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v4_0.c
@@ -1910,22 +1910,16 @@ out:
 
 #define RADEON_VCN_ENGINE_TYPE_ENCODE			(0x00000002)
 #define RADEON_VCN_ENGINE_TYPE_DECODE			(0x00000003)
-
 #define RADEON_VCN_ENGINE_INFO				(0x30000001)
-#define RADEON_VCN_ENGINE_INFO_MAX_OFFSET		16
-
 #define RENCODE_ENCODE_STANDARD_AV1			2
 #define RENCODE_IB_PARAM_SESSION_INIT			0x00000003
-#define RENCODE_IB_PARAM_SESSION_INIT_MAX_OFFSET	64
 
-/* return the offset in ib if id is found, -1 otherwise
- * to speed up the searching we only search upto max_offset
- */
-static int vcn_v4_0_enc_find_ib_param(struct amdgpu_ib *ib, uint32_t id, int max_offset)
+/* return the offset in ib if id is found, -1 otherwise */
+static int vcn_v4_0_enc_find_ib_param(struct amdgpu_ib *ib, uint32_t id, int start)
 {
 	int i;
 
-	for (i = 0; i < ib->length_dw && i < max_offset && ib->ptr[i] >= 8; i += ib->ptr[i]/4) {
+	for (i = start; i < ib->length_dw && ib->ptr[i] >= 8; i += ib->ptr[i] / 4) {
 		if (ib->ptr[i + 1] == id)
 			return i;
 	}
@@ -1940,33 +1934,29 @@ static int vcn_v4_0_ring_patch_cs_in_pla
 	struct amdgpu_vcn_decode_buffer *decode_buffer;
 	uint64_t addr;
 	uint32_t val;
-	int idx;
+	int idx = 0, sidx;
 
 	/* The first instance can decode anything */
 	if (!ring->me)
 		return 0;
 
-	/* RADEON_VCN_ENGINE_INFO is at the top of ib block */
-	idx = vcn_v4_0_enc_find_ib_param(ib, RADEON_VCN_ENGINE_INFO,
-			RADEON_VCN_ENGINE_INFO_MAX_OFFSET);
-	if (idx < 0) /* engine info is missing */
-		return 0;
-
-	val = amdgpu_ib_get_value(ib, idx + 2); /* RADEON_VCN_ENGINE_TYPE */
-	if (val == RADEON_VCN_ENGINE_TYPE_DECODE) {
-		decode_buffer = (struct amdgpu_vcn_decode_buffer *)&ib->ptr[idx + 6];
-
-		if (!(decode_buffer->valid_buf_flag  & 0x1))
-			return 0;
-
-		addr = ((u64)decode_buffer->msg_buffer_address_hi) << 32 |
-			decode_buffer->msg_buffer_address_lo;
-		return vcn_v4_0_dec_msg(p, job, addr);
-	} else if (val == RADEON_VCN_ENGINE_TYPE_ENCODE) {
-		idx = vcn_v4_0_enc_find_ib_param(ib, RENCODE_IB_PARAM_SESSION_INIT,
-			RENCODE_IB_PARAM_SESSION_INIT_MAX_OFFSET);
-		if (idx >= 0 && ib->ptr[idx + 2] == RENCODE_ENCODE_STANDARD_AV1)
-			return vcn_v4_0_limit_sched(p, job);
+	while ((idx = vcn_v4_0_enc_find_ib_param(ib, RADEON_VCN_ENGINE_INFO, idx)) >= 0) {
+		val = amdgpu_ib_get_value(ib, idx + 2); /* RADEON_VCN_ENGINE_TYPE */
+		if (val == RADEON_VCN_ENGINE_TYPE_DECODE) {
+			decode_buffer = (struct amdgpu_vcn_decode_buffer *)&ib->ptr[idx + 6];
+
+			if (!(decode_buffer->valid_buf_flag & 0x1))
+				return 0;
+
+			addr = ((u64)decode_buffer->msg_buffer_address_hi) << 32 |
+				decode_buffer->msg_buffer_address_lo;
+			return vcn_v4_0_dec_msg(p, job, addr);
+		} else if (val == RADEON_VCN_ENGINE_TYPE_ENCODE) {
+			sidx = vcn_v4_0_enc_find_ib_param(ib, RENCODE_IB_PARAM_SESSION_INIT, idx);
+			if (sidx >= 0 && ib->ptr[sidx + 2] == RENCODE_ENCODE_STANDARD_AV1)
+				return vcn_v4_0_limit_sched(p, job);
+		}
+		idx += ib->ptr[idx] / 4;
 	}
 	return 0;
 }


