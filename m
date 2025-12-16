Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68E6B2C0276;
	Tue, 16 Dec 2025 12:21:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887693; cv=none; b=K5wiujL9HcmjlsKbQ5jFde0viFRVwTfakObicVK2df9LQeXiMmKnCH7L8+v/1pWmpmsWfjRdU0jsDV1TzaQXaINaGc3YqQ9Hvsfsjowy2wdMEJ+tXLm092QnAAnMzAf4K1nJ4QRChAI0KKM0cE6Usz4zY+DKAeOrDxe+1nvT/jE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887693; c=relaxed/simple;
	bh=7EB1C25MCv9fI3qx4eWvw9UBAs96xJRF63I3Hv0Lbfc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EsLfU4K9eKEgqco7QcEJEUi3pxHJt6LOFKEcnWTyszQWZ9dDvarU8Sfj4Bm/73BN/RYwFpqy7+bA9PS23jXxCdCP+2AqpQdrVaSGdd3Svsuc2mwvM0nzeF3Ds4ePuzHupv7TKSLZ1pnP321IhyAfNvDVxR9mm7RBswtzhip5ok8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FBjL8ZL2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FBjL8ZL2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76E0DC4CEF5;
	Tue, 16 Dec 2025 12:21:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887693;
	bh=7EB1C25MCv9fI3qx4eWvw9UBAs96xJRF63I3Hv0Lbfc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FBjL8ZL2aC/ORUDBaKDJMUpPBeOAclf0/V/qKvO11yAaMW/vsHjmS9WF0Qy6Ah/rr
	 98KTEWGqIh0LUWSyBg0o/Ufb275ugMSpTEJAeT2kg4sJCdsITj4MzK1z7xWOntLIf1
	 TJ+yDwLO+nndzj7ca1KGpWBuXCGFOgp720h0HpNU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huiwen He <hehuiwen@kylinos.cn>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 308/614] drm/msm: fix missing NULL check after kcalloc in crashstate_get_bos()
Date: Tue, 16 Dec 2025 12:11:15 +0100
Message-ID: <20251216111412.527738206@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Huiwen He <hehuiwen@kylinos.cn>

[ Upstream commit 3065e6a4d3594b42dae6176b3e2c0c3563cf94b8 ]

The crashstate_get_bos() function allocates memory for `state->bos`
using kcalloc(), but the vmbind path does not check for allocation
failure before dereferencing it in the following drm_gpuvm_for_each_va()
loop. This could lead to a NULL pointer dereference if memory allocation
fails.

Fix this by wrapping the drm_gpuvm_for_each_va() loop with a NULL check
on state->bos, similar to the safety check in the non-vmbind path.

Fixes: af9aa6f316b3d ("drm/msm: Crashdump support for sparse")
Signed-off-by: Huiwen He <hehuiwen@kylinos.cn>
Patchwork: https://patchwork.freedesktop.org/patch/687556/
Signed-off-by: Rob Clark <robin.clark@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/msm_gpu.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/msm/msm_gpu.c b/drivers/gpu/drm/msm/msm_gpu.c
index e23f70fbc8cb2..dd0605fe1243d 100644
--- a/drivers/gpu/drm/msm/msm_gpu.c
+++ b/drivers/gpu/drm/msm/msm_gpu.c
@@ -287,16 +287,17 @@ static void crashstate_get_bos(struct msm_gpu_state *state, struct msm_gem_submi
 
 		state->bos = kcalloc(cnt, sizeof(struct msm_gpu_state_bo), GFP_KERNEL);
 
-		drm_gpuvm_for_each_va (vma, submit->vm) {
-			bool dump = rd_full || (vma->flags & MSM_VMA_DUMP);
+		if (state->bos)
+			drm_gpuvm_for_each_va(vma, submit->vm) {
+				bool dump = rd_full || (vma->flags & MSM_VMA_DUMP);
 
-			/* Skip MAP_NULL/PRR VMAs: */
-			if (!vma->gem.obj)
-				continue;
+				/* Skip MAP_NULL/PRR VMAs: */
+				if (!vma->gem.obj)
+					continue;
 
-			msm_gpu_crashstate_get_bo(state, vma->gem.obj, vma->va.addr,
-						  dump, vma->gem.offset, vma->va.range);
-		}
+				msm_gpu_crashstate_get_bo(state, vma->gem.obj, vma->va.addr,
+							  dump, vma->gem.offset, vma->va.range);
+			}
 
 		drm_exec_fini(&exec);
 	} else {
-- 
2.51.0



