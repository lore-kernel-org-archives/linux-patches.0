Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EBBA3D25A6;
	Fri, 15 May 2026 16:31:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862671; cv=none; b=Y25FLYMLvKRNeTGEGrGKk8wGSTXz0agRJ+lGnaUz4RLyAqIYmZ5C8tx6LCOXbFZ2PggbwgUKxlrvuTU2ybKsNKfK+BpeflMigLp+yJdK2IWPsDGimAb9mOz1kqgkZjvMnU+Q4O5fKiFKo43NY34Itt9uAgAPqjeDLnn7VmgAPOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862671; c=relaxed/simple;
	bh=tiqwway9sjmrulCefsO9yxZZBJRsAI6OcWC8dbsdsfM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cOM6uxl+Rlc5ISfHkcnOLcexXowYqqIs11Gj51RjBVfPbfVKMNa4/00pLlKqF6SpM7WbBkVdkz/vjKDDu0FOx6doct91MUcOxCFX0Vpmn2xeU4w4N4LImF+rblm3Gt9MywS57fbgSqw2/2sb+/xVmSE125qzmgig7Ci6cOQFacA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cI/DdbvT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cI/DdbvT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 245A9C2BCB3;
	Fri, 15 May 2026 16:31:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862671;
	bh=tiqwway9sjmrulCefsO9yxZZBJRsAI6OcWC8dbsdsfM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cI/DdbvTi/VSt68uyKhPSQ6DNvLBAvGhdaOtfNAY2TcltxRrCqlTbwU+i6MCWgedR
	 LukPNjJoN0B9SZtCm16tcvy5qDHjxjolCTxwfMCkKNRrlN7EHiktC8JjR+UH6PlsES
	 046aa2TA+l9WWgZ0M2flF9JB87LUlIKtdhN/agyI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Cheng <benjamin.cheng@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Ruijing Dong <ruijing.dong@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.0 139/201] drm/amdgpu/vcn4: Prevent OOB reads when parsing IB
Date: Fri, 15 May 2026 17:49:17 +0200
Message-ID: <20260515154701.579278513@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154658.538039039@linuxfoundation.org>
References: <20260515154658.538039039@linuxfoundation.org>
User-Agent: quilt/0.69
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Cheng <benjamin.cheng@amd.com>

commit 2444eb0ec8283f4a3845eb7febad378476e1ba3c upstream.

Rewrite the IB parsing to use amdgpu_ib_get_value() which handles the
bounds checks.

Signed-off-by: Benjamin Cheng <benjamin.cheng@amd.com>
Acked-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Ruijing Dong <ruijing.dong@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/vcn_v4_0.c |   23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/vcn_v4_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v4_0.c
@@ -1913,9 +1913,10 @@ out:
 static int vcn_v4_0_enc_find_ib_param(struct amdgpu_ib *ib, uint32_t id, int start)
 {
 	int i;
+	uint32_t len;
 
-	for (i = start; i < ib->length_dw && ib->ptr[i] >= 8; i += ib->ptr[i] / 4) {
-		if (ib->ptr[i + 1] == id)
+	for (i = start; (len = amdgpu_ib_get_value(ib, i)) >= 8; i += len / 4) {
+		if (amdgpu_ib_get_value(ib, i + 1) == id)
 			return i;
 	}
 	return -1;
@@ -1926,8 +1927,6 @@ static int vcn_v4_0_ring_patch_cs_in_pla
 					   struct amdgpu_ib *ib)
 {
 	struct amdgpu_ring *ring = amdgpu_job_ring(job);
-	struct amdgpu_vcn_decode_buffer *decode_buffer;
-	uint64_t addr;
 	uint32_t val;
 	int idx = 0, sidx;
 
@@ -1938,20 +1937,22 @@ static int vcn_v4_0_ring_patch_cs_in_pla
 	while ((idx = vcn_v4_0_enc_find_ib_param(ib, RADEON_VCN_ENGINE_INFO, idx)) >= 0) {
 		val = amdgpu_ib_get_value(ib, idx + 2); /* RADEON_VCN_ENGINE_TYPE */
 		if (val == RADEON_VCN_ENGINE_TYPE_DECODE) {
-			decode_buffer = (struct amdgpu_vcn_decode_buffer *)&ib->ptr[idx + 6];
+			uint32_t valid_buf_flag = amdgpu_ib_get_value(ib, idx + 6);
+			uint64_t msg_buffer_addr;
 
-			if (!(decode_buffer->valid_buf_flag & 0x1))
+			if (!(valid_buf_flag & 0x1))
 				return 0;
 
-			addr = ((u64)decode_buffer->msg_buffer_address_hi) << 32 |
-				decode_buffer->msg_buffer_address_lo;
-			return vcn_v4_0_dec_msg(p, job, addr);
+			msg_buffer_addr = ((u64)amdgpu_ib_get_value(ib, idx + 7)) << 32 |
+				amdgpu_ib_get_value(ib, idx + 8);
+			return vcn_v4_0_dec_msg(p, job, msg_buffer_addr);
 		} else if (val == RADEON_VCN_ENGINE_TYPE_ENCODE) {
 			sidx = vcn_v4_0_enc_find_ib_param(ib, RENCODE_IB_PARAM_SESSION_INIT, idx);
-			if (sidx >= 0 && ib->ptr[sidx + 2] == RENCODE_ENCODE_STANDARD_AV1)
+			if (sidx >= 0 &&
+			    amdgpu_ib_get_value(ib, sidx + 2) == RENCODE_ENCODE_STANDARD_AV1)
 				return vcn_v4_0_limit_sched(p, job);
 		}
-		idx += ib->ptr[idx] / 4;
+		idx += amdgpu_ib_get_value(ib, idx) / 4;
 	}
 	return 0;
 }


