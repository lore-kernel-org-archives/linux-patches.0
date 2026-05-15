Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5A4B305687;
	Fri, 15 May 2026 15:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860399; cv=none; b=Gzrd/23UfqMk+JVffkSFAEx7IquNIU3uJFJ57djDFK37+AH8KhD+21cbNdUtaHPWdHuHv/w8+5BV8x0FIHz9ZX/ztaMZ4zGAtxu36elU+iZHgbbWI2ipyFkQ5v4+ByjqxbwqMHSqr3VpggdkF3Un1YfSqV8LAa+4svUlXb60JO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860399; c=relaxed/simple;
	bh=SXH3r59hR8d91484dAgzdCr5gRw6TvVEIY5cuP6D1xA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uHutxshsA3q9Q0Cs6NvZn0xXgMjCqteFfCwJ7SqaOATRLIf+vJ9q3Dxhxtf9u9NPIknt7+roBn+DHczr+hU76v5NXQD2YDoZsq8sWbbVs19C4Ez1OmY9YgbHXozmP7PBtqkm/iOp1UhSN3xg4X56yijBdgPjn3vixWhGl20GVu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GMYdJgIq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GMYdJgIq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BCA4C2BCB3;
	Fri, 15 May 2026 15:53:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860399;
	bh=SXH3r59hR8d91484dAgzdCr5gRw6TvVEIY5cuP6D1xA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GMYdJgIqv7Dj8o2hjzjqceebDq+sTsnMYlXYHXWfTtOHmJYXGo4pTwdUBjjn7WoSM
	 uz75Fj/zrCgiLzSs8jG7njHfWBVeueQK8Udhr4JyGj+kVlYxqVBI6tmd4XRx4Sybmm
	 sjhMgaegDq3G9tVCZ6dC49rZBS4+SgwHVu20Sc8M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Cheng <benjamin.cheng@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Ruijing Dong <ruijing.dong@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 075/144] drm/amdgpu/vcn4: Prevent OOB reads when parsing dec msg
Date: Fri, 15 May 2026 17:48:21 +0200
Message-ID: <20260515154655.272204557@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154653.469907118@linuxfoundation.org>
References: <20260515154653.469907118@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Cheng <benjamin.cheng@amd.com>

commit 0a78f2bac1424deb7c9d5e09c6b8e849d8e8b648 upstream.

Check bounds against the end of the BO whenever we access the msg.

Signed-off-by: Benjamin Cheng <benjamin.cheng@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Ruijing Dong <ruijing.dong@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/vcn_v4_0.c |   21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/vcn_v4_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v4_0.c
@@ -1767,7 +1767,7 @@ static int vcn_v4_0_dec_msg(struct amdgp
 {
 	struct ttm_operation_ctx ctx = { false, false };
 	struct amdgpu_bo_va_mapping *map;
-	uint32_t *msg, num_buffers;
+	uint32_t *msg, num_buffers, len_dw;
 	struct amdgpu_bo *bo;
 	uint64_t start, end;
 	unsigned int i;
@@ -1788,6 +1788,11 @@ static int vcn_v4_0_dec_msg(struct amdgp
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
@@ -1804,8 +1809,8 @@ static int vcn_v4_0_dec_msg(struct amdgp
 
 	msg = ptr + addr - start;
 
-	/* Check length */
 	if (msg[1] > end - addr) {
+		DRM_ERROR("VCN message header does not fit in BO!\n");
 		r = -EINVAL;
 		goto out;
 	}
@@ -1813,7 +1818,16 @@ static int vcn_v4_0_dec_msg(struct amdgp
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
 
@@ -1823,7 +1837,8 @@ static int vcn_v4_0_dec_msg(struct amdgp
 		offset = msg[1];
 		size = msg[2];
 
-		if (offset + size > end) {
+		if (size < 4 || offset + size > end - addr) {
+			DRM_ERROR("VCN message buffer exceeds BO bounds!\n");
 			r = -EINVAL;
 			goto out;
 		}


