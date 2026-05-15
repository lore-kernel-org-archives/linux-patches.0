Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F35D3E0094;
	Fri, 15 May 2026 16:31:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862679; cv=none; b=JZ8iwK15DVI6AqTbvT/tbOokZmN/KbwnSMreSU76U/0j2IPsxOXseZtMx0qOgJJwG+5h9RRFJqFNLjEL8jNKaVuJkWTQxR03OH39E5IqLl0pcbWG8PhjLQKO0xxDYlymGlK2S5shW6IuaRWXc0s4tTe0RtAUETSdmYEpwObFfxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862679; c=relaxed/simple;
	bh=jUboLAF9fmU6xZqcgo9NgGMIY1ZRvboP3qiHEabx63Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tDxkiRd61s3KEz0TZ52LnUbsUUqAN2rIMicBiZeeu/hHrD9rISN1sCSNjDXXut7U5hsRVsD5GoqRb+AgNO7k4N5RdNNvp/+1Dz7c7Nmxb/4skDH4ZfcvEX6TjAdsZuC0ThPFQbpZI7CNIn2WVmw8RoPqeUEGDcW0IWDplXk9m9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bqg7ks42; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bqg7ks42"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA881C2BCB0;
	Fri, 15 May 2026 16:31:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862679;
	bh=jUboLAF9fmU6xZqcgo9NgGMIY1ZRvboP3qiHEabx63Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bqg7ks42t44SjCFBPxvnWWjrvuKFG/hc8JUdkmSRow+5Lg/9iC/xxVHqD/tBx2AnQ
	 /J+3yAl3TRRc77s5Fw8pmDG48DVFNBJ0EMsO7NtG8COvKsENgzFP0gOUfGiwdRT4O0
	 UppHAusegQtVDbQvIOJDZu3x+JasLDsUw0nyXJf0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Cheng <benjamin.cheng@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Ruijing Dong <ruijing.dong@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.0 142/201] drm/amdgpu/vcn3: Prevent OOB reads when parsing dec msg
Date: Fri, 15 May 2026 17:49:20 +0200
Message-ID: <20260515154701.643983672@linuxfoundation.org>
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

commit b193019860d61e92da395eae2011f2f6716b182f upstream.

Check bounds against the end of the BO whenever we access the msg.

Signed-off-by: Benjamin Cheng <benjamin.cheng@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Ruijing Dong <ruijing.dong@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c |   23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c
@@ -1909,7 +1909,7 @@ static int vcn_v3_0_dec_msg(struct amdgp
 	struct ttm_operation_ctx ctx = { false, false };
 	struct amdgpu_device *adev = p->adev;
 	struct amdgpu_bo_va_mapping *map;
-	uint32_t *msg, num_buffers;
+	uint32_t *msg, num_buffers, len_dw;
 	struct amdgpu_bo *bo;
 	uint64_t start, end;
 	unsigned int i;
@@ -1930,6 +1930,11 @@ static int vcn_v3_0_dec_msg(struct amdgp
 		return -EINVAL;
 	}
 
+	if (end - addr < 16) {
+		DRM_ERROR("VCN messages must be at least 4 DWORDs!\n");
+		return -EINVAL;
+	}
+
 	bo->flags |= AMDGPU_GEM_CREATE_CPU_ACCESS_REQUIRED;
 	amdgpu_bo_placement_from_domain(bo, bo->allowed_domains);
 	r = ttm_bo_validate(&bo->tbo, &bo->placement, &ctx);
@@ -1946,8 +1951,8 @@ static int vcn_v3_0_dec_msg(struct amdgp
 
 	msg = ptr + addr - start;
 
-	/* Check length */
 	if (msg[1] > end - addr) {
+		DRM_ERROR("VCN message header does not fit in BO!\n");
 		r = -EINVAL;
 		goto out;
 	}
@@ -1955,7 +1960,16 @@ static int vcn_v3_0_dec_msg(struct amdgp
 	if (msg[3] != RDECODE_MSG_CREATE)
 		goto out;
 
+	len_dw = msg[1] / 4;
 	num_buffers = msg[2];
+
+	/* Verify that all indices fit within the claimed length. Each index is 4 DWORDs */
+	if (num_buffers > len_dw || 6 + num_buffers * 4 > len_dw) {
+		DRM_ERROR("VCN message has too many buffers!\n");
+		r = -EINVAL;
+		goto out;
+	}
+
 	for (i = 0, msg = &msg[6]; i < num_buffers; ++i, msg += 4) {
 		uint32_t offset, size, *create;
 
@@ -1965,14 +1979,15 @@ static int vcn_v3_0_dec_msg(struct amdgp
 		offset = msg[1];
 		size = msg[2];
 
-		if (offset + size > end) {
+		if (size < 4 || offset + size > end - addr) {
+			DRM_ERROR("VCN message buffer exceeds BO bounds!\n");
 			r = -EINVAL;
 			goto out;
 		}
 
 		create = ptr + addr + offset - start;
 
-		/* H246, HEVC and VP9 can run on any instance */
+		/* H264, HEVC and VP9 can run on any instance */
 		if (create[0] == 0x7 || create[0] == 0x10 || create[0] == 0x11)
 			continue;
 


