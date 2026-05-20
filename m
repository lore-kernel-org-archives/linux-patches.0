Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12D18347512;
	Wed, 20 May 2026 17:15:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297337; cv=none; b=AhnqBGqqu5fItU4rE0UTcPLpVLGzHk85cm5BOEXAWWYRjDozuhF0jpDFCN3YyOYO5DbELfpgYocD8iQl/GCFl63hIJrqx0Pk/Li9CUV6wWR3hvg8CqCmuCOnFTnsL+HilEOTuEhlET/k2PEkOMoJcNEPn54smpFkZJaLMTxBZCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297337; c=relaxed/simple;
	bh=X4/WeDS7VSO7ZvjK0M0/b24Ud0ISeBJHCf3zKevNdXU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=a9rPkCYOD5bP6oJFp+NITU1Iwmg4iAwsYTwS2AIWnzNQKT5eQeDEDr2g5GQinCvyqIS0uXhQ9+m/LnbIpvT/qI/YpC1gF1Bgx9B4kAn+rDShsrm9cbN+JA8738ly/q+jqkuQ70ITCsFDnhDfqOvVS6ma+eY5XGtuL5ypk9xseFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NgnUC/Ld; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NgnUC/Ld"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E08E1F00893;
	Wed, 20 May 2026 17:15:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297336;
	bh=2gjZmZCviHuawBNnpoS7CFujlo9II6+xEUM9DY+wGyU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NgnUC/LdPEnfJFiYR/SEI+bTM10IRj7f90WoNexvXMJmtAWbFJP3YL+V8D+ga69wq
	 +7MhyghpWi8Clunff1QW5kwus27RLn50c877UhytR+2Q1FMPQqAqS0vRN7g1gRGRF5
	 oUwN8mKiONEAVAhmipHvAWT+KwJpA3+T3QfPR3K0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Friedrich Vock <friedrich.vock@gmx.de>,
	Maarten Lankhorst <dev@lankhorst.se>,
	Tejun Heo <tj@kernel.org>,
	Maxime Ripard <mripard@kernel.org>,
	Christian Koenig <christian.koenig@amd.com>,
	dri-devel@lists.freedesktop.org,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Maarten Lankhorst <dev@lankhrost.se>
Subject: [PATCH 7.0 1133/1146] drm/ttm: Convert -EAGAIN from dmem_cgroup_try_charge to -ENOSPC
Date: Wed, 20 May 2026 18:23:03 +0200
Message-ID: <20260520162213.891807759@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

From: Thomas Hellström <thomas.hellstrom@linux.intel.com>

commit 591711b32681a04b57d00c2a404658f8419a081c upstream.

dmem_cgroup_try_charge() returns -EAGAIN when the cgroup limit is
hit and the charge fails. TTM has no concept of -EAGAIN from resource
allocation; -ENOSPC is the canonical error meaning "no space, try
eviction". Convert at the source in ttm_resource_alloc() so no caller
needs to handle an unexpected error code, and clean up the now-redundant
-EAGAIN check in ttm_bo_alloc_resource().

Without this, -EAGAIN escaping ttm_resource_alloc() during an eviction
walk causes the walk to terminate early instead of continuing to the
next candidate.

Cc: Friedrich Vock <friedrich.vock@gmx.de>
Cc: Maarten Lankhorst <dev@lankhorst.se>
Cc: Tejun Heo <tj@kernel.org>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Christian Koenig <christian.koenig@amd.com>
Cc: dri-devel@lists.freedesktop.org
Cc: <stable@vger.kernel.org> # v6.14+
Fixes: 2b624a2c1865 ("drm/ttm: Handle cgroup based eviction in TTM")
Assisted-by: GitHub_Copilot:claude-sonnet-4.6
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Reviewed-by: Maarten Lankhorst <dev@lankhrost.se>
Link: https://patch.msgid.link/20260508160920.230339-1-thomas.hellstrom@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/ttm/ttm_bo.c       |    2 +-
 drivers/gpu/drm/ttm/ttm_resource.c |    5 ++++-
 2 files changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/ttm/ttm_bo.c
+++ b/drivers/gpu/drm/ttm/ttm_bo.c
@@ -740,7 +740,7 @@ static int ttm_bo_alloc_resource(struct
 		may_evict = (force_space && place->mem_type != TTM_PL_SYSTEM);
 		ret = ttm_resource_alloc(bo, place, res, force_space ? &limit_pool : NULL);
 		if (ret) {
-			if (ret != -ENOSPC && ret != -EAGAIN) {
+			if (ret != -ENOSPC) {
 				dmem_cgroup_pool_state_put(limit_pool);
 				return ret;
 			}
--- a/drivers/gpu/drm/ttm/ttm_resource.c
+++ b/drivers/gpu/drm/ttm/ttm_resource.c
@@ -398,8 +398,11 @@ int ttm_resource_alloc(struct ttm_buffer
 
 	if (man->cg) {
 		ret = dmem_cgroup_try_charge(man->cg, bo->base.size, &pool, ret_limit_pool);
-		if (ret)
+		if (ret) {
+			if (ret == -EAGAIN)
+				ret = -ENOSPC;
 			return ret;
+		}
 	}
 
 	ret = man->func->alloc(man, bo, place, res_ptr);


