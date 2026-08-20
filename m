Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47B0E47AF75;
	Thu, 20 Aug 2026 16:34:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787243675; cv=none; b=ijrZgWHp40UB28GkBLRKJaND+T6lI2BzzoVNYwPAvgLYWvt7We7tlZdot84EOsHUD9A2qo9bpvCI7cUA4kfBuPkgDXThVXOgtwg2mvmykzVXs2s1kbb3lHgzacwOowW5MxnctwFY3G7sueJE+WoOnWYKhEHONV8IK3JlUmFqMSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787243675; c=relaxed/simple;
	bh=5Ea03bX7zIuFM7Tz/44qQ4CoCdzj1IY81N81YL+Paig=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AEDoUoEivmrR973ulbySEwEYHjn4v6C9kBGoRrudHSf3LcQGJurAqqxge7Arv/IO9/7S6TZSJE7/Vk0PN/4jNYHvP/8mm7fWuhZcRpkg3lkq5KaF2BOihOzGXE8+pyMHRK7z11rEQP/dAtiDc/1Bd/+i0YQ9Y9VC9bzBntMsSXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2RJvhtJh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2RJvhtJh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72A711F00A3A;
	Thu, 20 Aug 2026 16:34:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787243673;
	bh=RC1dj4zUnB/bSZuBT7SgSzSZrqqiv9PtR2AN3g3WC+4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2RJvhtJhwp0qG4yz/D5/q9a5aE/cV+9sIS8webKsHiibLKe4oABsw9yOiURT/xcqg
	 TWeIk48B4qdoOo5pDH3QCAeXbQML5MLeX8KGIWMTxVuRRE5pXfaattAXpeASOTOHvr
	 AVR51Bk1MiPu9Q93sk8U7rg95Rt30qT52ICGhpdg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 176/272] drm/amdgpu: Fix amdgpu_bo_move() when old_mem and new_mem are both GTT
Date: Thu, 20 Aug 2026 16:56:00 +0200
Message-ID: <20260820145236.740742508@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145231.229664293@linuxfoundation.org>
References: <20260820145231.229664293@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Timur Kristóf <timur.kristof@gmail.com>

[ Upstream commit ee94a65f192c05c543b4d3ad7137cd696b5c18fc ]

The UVD code relies on GTT to GTT moves in order to ensure
that its BOs don't cross 256M segments.

Fixes: bfe5e585b44f ("drm/ttm: move last binding into the drivers.")
Signed-off-by: Timur Kristóf <timur.kristof@gmail.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 21fd45e5e2628d00b478590bcc3d14d3de5d45b6)
Cc: stable@vger.kernel.org
[ dropped the third `new_mem` argument from `amdgpu_bo_move_notify()` and changed `return 0` to `goto out` to match 5.15's 2-arg prototype and shared epilogue ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
@@ -472,6 +472,15 @@ static int amdgpu_bo_move(struct ttm_buf
 
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
@@ -505,6 +514,14 @@ static int amdgpu_bo_move(struct ttm_buf
 		ttm_resource_free(bo, &bo->resource);
 		ttm_bo_assign_mem(bo, new_mem);
 		goto out;
+	}
+	if ((old_mem->mem_type == TTM_PL_TT ||
+	     old_mem->mem_type == AMDGPU_PL_PREEMPT) &&
+	    (new_mem->mem_type == TTM_PL_TT ||
+	     new_mem->mem_type == AMDGPU_PL_PREEMPT)) {
+		ttm_resource_free(bo, &bo->resource);
+		ttm_bo_assign_mem(bo, new_mem);
+		goto out;
 	}
 
 	if (old_mem->mem_type == AMDGPU_PL_GDS ||


