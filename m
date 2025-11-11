Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8F27328602;
	Tue, 11 Nov 2025 01:09:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823352; cv=none; b=FgVzd8JTK/PtwLVgUko7cm2e6Vu5kO2NwlbJUANpuuVJwaM7BN8zlQKsNiaLHfRR1hCSsv5JhiJFBA6mQqY6XOp34qTjZ8BEB4YePe2QSNGO3uyofa2drl51IjOy/5Fw7L4DCjxB3VGdL8K2Gpkput1rzQZNOMz7jPSKC4lT/Tc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823352; c=relaxed/simple;
	bh=kiZ3a6xPgXBhPRsl90CbqyANvpMT9HkqtNw+05FC2I8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H+VdSG1Ln8JzbiooHHM+/gPgpTRD5WPGAZRdnfWmke8QXiSSPjpOmHYTfiZdfg9zgEFlY6JV2XIkYM9oT38LirJPlebmaBCJVRdOKnl9BqMSUCLTUSyNqWEYJnanaT4EwPtVNdTnQPOpq3qWwApNMIXhXRUozGJmSIiMWHDAKbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F/LnFE1E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F/LnFE1E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57EE9C4CEFB;
	Tue, 11 Nov 2025 01:09:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823352;
	bh=kiZ3a6xPgXBhPRsl90CbqyANvpMT9HkqtNw+05FC2I8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F/LnFE1EsQDXt3/Bpg/dZVhMkatgFj/zc33zY8OtCsMbqYHzvAk/cyq3l4c/OyUa4
	 vf0/Q7w24+k9oSltWuGwRDgPPt2+6FM3/LzuTWV9kWTXzqzHfN1aRYAhlD0Ff7uyba
	 cV9zdAHBUZHJhwRELgb01tyNnLHOyitCpJRNrMYw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heng Zhou <Heng.Zhou@amd.com>,
	"Kasiviswanathan, Harish" <Harish.Kasiviswanathan@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 225/565] drm/amdgpu: fix nullptr err of vm_handle_moved
Date: Tue, 11 Nov 2025 09:41:21 +0900
Message-ID: <20251111004531.980649410@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heng Zhou <Heng.Zhou@amd.com>

[ Upstream commit 859958a7faefe5b7742b7b8cdbc170713d4bf158 ]

If a amdgpu_bo_va is fpriv->prt_va, the bo of this one is always NULL.
So, such kind of amdgpu_bo_va should be updated separately before
amdgpu_vm_handle_moved.

Signed-off-by: Heng Zhou <Heng.Zhou@amd.com>
Reviewed-by: Kasiviswanathan, Harish <Harish.Kasiviswanathan@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
index d349a4816e537..fff89288e2f4b 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
@@ -3001,9 +3001,22 @@ int amdgpu_amdkfd_gpuvm_restore_process_bos(void *info, struct dma_fence __rcu *
 		struct amdgpu_device *adev = amdgpu_ttm_adev(
 			peer_vm->root.bo->tbo.bdev);
 
+		struct amdgpu_fpriv *fpriv =
+			container_of(peer_vm, struct amdgpu_fpriv, vm);
+
+		ret = amdgpu_vm_bo_update(adev, fpriv->prt_va, false);
+		if (ret) {
+			dev_dbg(adev->dev,
+				"Memory eviction: handle PRT moved failed, pid %8d. Try again.\n",
+				pid_nr(process_info->pid));
+			goto validate_map_fail;
+		}
+
 		ret = amdgpu_vm_handle_moved(adev, peer_vm, &exec.ticket);
 		if (ret) {
-			pr_debug("Memory eviction: handle moved failed. Try again\n");
+			dev_dbg(adev->dev,
+				"Memory eviction: handle moved failed, pid %8d. Try again.\n",
+				pid_nr(process_info->pid));
 			goto validate_map_fail;
 		}
 	}
-- 
2.51.0



