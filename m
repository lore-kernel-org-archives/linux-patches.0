Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B850B34104B;
	Sat, 30 May 2026 17:06:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160780; cv=none; b=XUfc38CM0eu+EGc4z3hYXYqDUlm6oCHVX6KQpof9iaC47H56UgmGJ0XQa3mnhLesLQcww8hQv4wIpOgzBfRUQvNgUYMnRDT2FAxehtb3Xetxh79MTraO7iQuWRkfCuf/tka8XaM6tSHqdpoUTNNoinbmUSR6bMTUv7nqAEFhGa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160780; c=relaxed/simple;
	bh=UPNinUq1tKvxZHtv36aitQK603W1S+AuQoF6cT4SizQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BzEg6c2Qwg5NvtFCeAn8lnC1GSnF2WRoYlOUzsJIalNwUkKTRg91yvqj/QTFEaRMORycRnALiFSUPespaDcCTvFKNDgWzfJS9JZ1EJmUcYMzM8lJsY68DTXLiKoXExvquhvQclzotvjqumc3oN7pgZFIl0ggwANMDJZaTiBlcZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o8RbNVsU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o8RbNVsU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09E301F00893;
	Sat, 30 May 2026 17:06:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160779;
	bh=UlXHxyGd7OX2D61ARz4n2qsj5X+NSmmsoU0DtGECdoE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o8RbNVsUiZdn+zfdx6cn8toiTmBneVhorQ2Fe/C3o6PfhW2EFmCLysFVKPk2Envw4
	 71BHIYuSxNHD/9pe7AEyOAi00X/qAaSCT/d3h6gDROhlzN2rqjg+hXFOp/AcygMqJk
	 y6NNN8EYXuAT+ea76LfNy4zsWdWgqbdLgxs3Ghlk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Cheng <benjamin.cheng@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Ruijing Dong <ruijing.dong@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 405/969] drm/amdgpu/vcn4: Prevent OOB reads when parsing dec msg
Date: Sat, 30 May 2026 17:58:49 +0200
Message-ID: <20260530160311.468613908@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1612,7 +1612,7 @@ static int vcn_v4_0_dec_msg(struct amdgp
 {
 	struct ttm_operation_ctx ctx = { false, false };
 	struct amdgpu_bo_va_mapping *map;
-	uint32_t *msg, num_buffers;
+	uint32_t *msg, num_buffers, len_dw;
 	struct amdgpu_bo *bo;
 	uint64_t start, end;
 	unsigned int i;
@@ -1633,6 +1633,11 @@ static int vcn_v4_0_dec_msg(struct amdgp
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
@@ -1649,8 +1654,8 @@ static int vcn_v4_0_dec_msg(struct amdgp
 
 	msg = ptr + addr - start;
 
-	/* Check length */
 	if (msg[1] > end - addr) {
+		DRM_ERROR("VCN message header does not fit in BO!\n");
 		r = -EINVAL;
 		goto out;
 	}
@@ -1658,7 +1663,16 @@ static int vcn_v4_0_dec_msg(struct amdgp
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
 
@@ -1668,7 +1682,8 @@ static int vcn_v4_0_dec_msg(struct amdgp
 		offset = msg[1];
 		size = msg[2];
 
-		if (offset + size > end) {
+		if (size < 4 || offset + size > end - addr) {
+			DRM_ERROR("VCN message buffer exceeds BO bounds!\n");
 			r = -EINVAL;
 			goto out;
 		}


