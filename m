Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 665AA374722;
	Fri, 15 May 2026 16:11:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861478; cv=none; b=Xhc4/4PDDo2lp/S0Y5rfMpEb2Q2Iu86CIZbNoQafKu3PsySzrdYBh+0eKFEepNbyaWkIxXcTosty8pwVynl8364xSdmoD4V61sAE2y4xI1JcAbI7kCuE0CfcSfsfDnZZLgIIyqysJfzhdYseL/l6N40j4vpXCIYHgQhhjlh2aLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861478; c=relaxed/simple;
	bh=yMgJmYYdkfrlzNmXtGUu2N5aWml6gkIIAp5cka6r1tk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Xt8x/0mhZwi4uK/Ee7FzIEvGhd6x6YRN0LNEvUaMqUoYBl5zdEkwZgwX/UplyDuxuyPlPsALad9zsSzHab3fDRrCaOF0t+dygobtsi8iPxV41kJMiTm0/ACYzbE1adkmrT6r4cleyPBZtTnkvTGLOz87tiD02tqGCEJHnQode5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J8DPKlYJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J8DPKlYJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEBE9C2BCB0;
	Fri, 15 May 2026 16:11:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861478;
	bh=yMgJmYYdkfrlzNmXtGUu2N5aWml6gkIIAp5cka6r1tk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J8DPKlYJ27nqhPUzyY0RK1/+qF+dssfDvI2JH7Rl3Dgjja9S4V1TXDkU8muLS+evJ
	 lvfYbg9sTvfH+ERhHc8eCd0fv60LRqFK6Ra4Uuy0kUItZ7EUzXakXvDpS8v+CLbubZ
	 5nDlb4DR5+mql8PBSB7ovFGRaFMVsWfn+CO42Ytk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Cheng <benjamin.cheng@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Ruijing Dong <ruijing.dong@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 345/474] drm/amdgpu/vcn4: Prevent OOB reads when parsing dec msg
Date: Fri, 15 May 2026 17:47:34 +0200
Message-ID: <20260515154722.480419791@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1668,7 +1668,7 @@ static int vcn_v4_0_dec_msg(struct amdgp
 {
 	struct ttm_operation_ctx ctx = { false, false };
 	struct amdgpu_bo_va_mapping *map;
-	uint32_t *msg, num_buffers;
+	uint32_t *msg, num_buffers, len_dw;
 	struct amdgpu_bo *bo;
 	uint64_t start, end;
 	unsigned int i;
@@ -1689,6 +1689,11 @@ static int vcn_v4_0_dec_msg(struct amdgp
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
@@ -1705,8 +1710,8 @@ static int vcn_v4_0_dec_msg(struct amdgp
 
 	msg = ptr + addr - start;
 
-	/* Check length */
 	if (msg[1] > end - addr) {
+		DRM_ERROR("VCN message header does not fit in BO!\n");
 		r = -EINVAL;
 		goto out;
 	}
@@ -1714,7 +1719,16 @@ static int vcn_v4_0_dec_msg(struct amdgp
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
 
@@ -1724,7 +1738,8 @@ static int vcn_v4_0_dec_msg(struct amdgp
 		offset = msg[1];
 		size = msg[2];
 
-		if (offset + size > end) {
+		if (size < 4 || offset + size > end - addr) {
+			DRM_ERROR("VCN message buffer exceeds BO bounds!\n");
 			r = -EINVAL;
 			goto out;
 		}


