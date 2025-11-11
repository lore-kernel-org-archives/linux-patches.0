Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49A1434217C;
	Tue, 11 Nov 2025 01:11:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823517; cv=none; b=h4lHY17iafEcWCai0FDmp608KTHr/IF53JCzAHN/iDJr1a9A0TUdE3C2lcP8eyqYsEHVBdXLp+fPn+6ePXuOwso3tWhyVFRTI8rO9IzzsMCaUpfNJ9lTwvPITLo0FjWGVYG8gl0Jcl41uO5AMJEIjrIRoXgKTYWvTpICDlO+46U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823517; c=relaxed/simple;
	bh=rY2jHruyjCtkD5AERRixs/Dgg/BI+xtbdGkUXFgY8zs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fZJ7YFwKGKJKOW2Xz+pEbD89CHLA795bvwMme2OS3fZ3G24Md/saDj4JublwwcZ1todjOhdqt08PDaThwzjQ1nPpEV5yYqCtW2f+jCJqRirEx5HjxKTQJneWSemCJM+JRpWt381PR3uiXe+tTxgb7Bud0qE4Fh+fkJqSBHcL+ok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nfl65UEO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nfl65UEO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D68ABC2BC86;
	Tue, 11 Nov 2025 01:11:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823517;
	bh=rY2jHruyjCtkD5AERRixs/Dgg/BI+xtbdGkUXFgY8zs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nfl65UEOqnODcItukYO9RX0STMfLURkcIvpNI41S2PrIIeec7EqtLV07dPrT67FZy
	 TBoOeDn+lCoJGpQsm8RSIIv4+JyqKw6tbjJfd7VUj+AGwsqr7cOhUssvC1nMyQF9OT
	 V4kU1ZksCLFg37eLpKLqIUkR/sBbx9BC+/1GNQJA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heng Zhou <Heng.Zhou@amd.com>,
	"Kasiviswanathan, Harish" <Harish.Kasiviswanathan@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 315/849] drm/amdgpu: fix nullptr err of vm_handle_moved
Date: Tue, 11 Nov 2025 09:38:05 +0900
Message-ID: <20251111004544.032321033@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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
index 902eac2c685f3..30d4a47535882 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
@@ -2993,9 +2993,22 @@ int amdgpu_amdkfd_gpuvm_restore_process_bos(void *info, struct dma_fence __rcu *
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



