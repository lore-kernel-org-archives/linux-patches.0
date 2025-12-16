Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D41E355029;
	Tue, 16 Dec 2025 11:50:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885837; cv=none; b=YMIgjwiYAXK1Pl6eyeSZ1SmIuWfFTSu+J6v5TVb8z6qDZu0Jdw37viQLQ9t10AvxIVRTQ/2dbxLb0MF597YkDa3zr81k5YnwVbtjqwfb1HA6rEGQEad57RcFTMIAF1EUpOymzlIWN9cqHkaHqnTYYQCzNA+5zBvZZF4EPej3Mcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885837; c=relaxed/simple;
	bh=VmyFyjD9lrbuDlYD8A99+8O4b0FCNYalAEXOGWdnxV8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CeiR5EJxZ3JVCOt0gqAS8zMqV8uiw3C+Eg+v7UNfXIu/tHtDbIClxEmFd7tiLcN6W+N/YR6pc1zLkFdvvLBfUgVy0/m3FVLdL9bWo9uVocvrrSMq3nH19lhFN2lgl59BYdYVUdvDe7wYMJKJpQVy/ui6r5xpTP98BdkKp3wW4H4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iHNGUvB/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iHNGUvB/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB055C4CEF1;
	Tue, 16 Dec 2025 11:50:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885837;
	bh=VmyFyjD9lrbuDlYD8A99+8O4b0FCNYalAEXOGWdnxV8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iHNGUvB/beVc1xn72g/j+qWc5tlUJMmtyouf5zKsUO/KxfjCKwFdZB/WbUEG4Jg4w
	 /8fNuXVzqywCrqsdd6BwdrQ6+IPUEQipiU0OWA6iX2B4hIBZYfQugJ/DmAfcaj0g7W
	 Zat33atM1LtTHlpNI4tby9nxJl/UFwJ2rxYNvyrk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huiwen He <hehuiwen@kylinos.cn>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 260/507] drm/msm: fix missing NULL check after kcalloc in crashstate_get_bos()
Date: Tue, 16 Dec 2025 12:11:41 +0100
Message-ID: <20251216111354.908699523@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 8f933c1fe4bfa..d5f8df3110cef 100644
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



