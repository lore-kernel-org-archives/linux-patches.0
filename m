Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7E6E3B9943;
	Mon, 17 Aug 2026 15:08:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979284; cv=none; b=n5ljq9kIgkyJFArcD+TsNSUkIG3A/aSjtzetIacvjrPAf2UcOtQ14CmlgWfPTa+/QxgGmX/DXt0DOCj4JD/XAhL9adJARiZJRCe8mG0kwSqcPA59qFKVHsNYBXGzQhg6ITIt+XmUvhWjMyEma+N/P+8OgLVszugxzPXGvXex5Pk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979284; c=relaxed/simple;
	bh=SGpMKEgvNizL9w9TSqmcgzojQCSvCSMLCcSKMfc5u10=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qef0DtTnY2OSkg1CxSsdqh9A8e2XlpoNMlt3evn7Gxagr4lFi7SEl0d5wkI+dyO/AUbUKmFVzqcpodGmGMWsl5+Ar6wSaJAW1FJQJFBLn2UwY++8yf9eC6JJKxNOpn7aX3Z2IOyyqra2VmfV2EUEagfY8y+b7oipZ3xXc3fqtQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AnWCuG7v; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AnWCuG7v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 071F61F000E9;
	Mon, 17 Aug 2026 15:08:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979283;
	bh=lOIJBqdjhtyisPANzRVqmYuZChUHMeoxDiTiMxmleko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AnWCuG7vF3P9IXcVDE6TI4WIgjPspum2w3zkPuJ+lOtSE+3/xO9YopnPrEHf8X7lw
	 58/741ZfC5/lben1yX3RvDnBBXh3kJx30o5k+7JOOANHiK3g/LQ/jtNrAZTmlYZe65
	 zMmitAGeTMvfw9iHo5cpavSD4+f8lhmSYqdi0XpY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 172/609] drm/amdgpu: Fix amdgpu_bo_move() when old_mem and new_mem are both GTT
Date: Mon, 17 Aug 2026 15:27:48 +0200
Message-ID: <20260817132549.807487240@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

From: Timur Kristóf <timur.kristof@gmail.com>

commit ee94a65f192c05c543b4d3ad7137cd696b5c18fc upstream.

The UVD code relies on GTT to GTT moves in order to ensure
that its BOs don't cross 256M segments.

Fixes: bfe5e585b44f ("drm/ttm: move last binding into the drivers.")
Signed-off-by: Timur Kristóf <timur.kristof@gmail.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 21fd45e5e2628d00b478590bcc3d14d3de5d45b6)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
@@ -463,6 +463,15 @@ static int amdgpu_bo_move(struct ttm_buf
 
 	if (new_mem->mem_type == TTM_PL_TT ||
 	    new_mem->mem_type == AMDGPU_PL_PREEMPT) {
+		if (old_mem && (old_mem->mem_type == TTM_PL_TT ||
+				old_mem->mem_type == AMDGPU_PL_PREEMPT)) {
+			r = ttm_bo_wait_ctx(bo, ctx);
+			if (r)
+				return r;
+
+			amdgpu_ttm_backend_unbind(bo->bdev, bo->ttm);
+		}
+
 		r = amdgpu_ttm_backend_bind(bo->bdev, bo->ttm, new_mem);
 		if (r)
 			return r;
@@ -499,6 +508,15 @@ static int amdgpu_bo_move(struct ttm_buf
 		amdgpu_bo_move_notify(bo, evict, new_mem);
 		ttm_resource_free(bo, &bo->resource);
 		ttm_bo_assign_mem(bo, new_mem);
+		return 0;
+	}
+	if ((old_mem->mem_type == TTM_PL_TT ||
+	     old_mem->mem_type == AMDGPU_PL_PREEMPT) &&
+	    (new_mem->mem_type == TTM_PL_TT ||
+	     new_mem->mem_type == AMDGPU_PL_PREEMPT)) {
+		amdgpu_bo_move_notify(bo, evict, new_mem);
+		ttm_resource_free(bo, &bo->resource);
+		ttm_bo_assign_mem(bo, new_mem);
 		return 0;
 	}
 


