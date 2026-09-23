Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5BCD53C3D1;
	Wed, 23 Sep 2026 14:56:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790175372; cv=none; b=dRFOdP8Nf3GhPE5ZveodtJAgbR4DPhCUTGFNhjEwelS6mBY6ormKr2p7+vcUtc04NjmmUOI72hb3xYZkZsaNrudAArNn9cVH7YvrT5zpF3kSM85Uv13t+haMILjCCF9rlwAyy0Cjdcfr31S+cy5/2IGUo50UQairEMwck4js8CQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790175372; c=relaxed/simple;
	bh=zDYWT2bjFvf7X5bldzQkw+mG6gxxLLNlAv0lApOREa0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kvyRrYFgZJtjM3xH7B0FooOqfsDRaM4wgUUz8mFGYk9fleLxvIMQ9S2z+rqsNGXMA8ayY0+h1E6vlbvSNWLffALa1x+zeI0feU0IdyYgapliLg8V9mivEfZhsn+sGCXha58WFkg/NCe2RS1snCiXyjW2fZw890wTSHQ+3uTG2is=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V8AeNJoL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V8AeNJoL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4286A1F000FF;
	Wed, 23 Sep 2026 14:56:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790175370;
	bh=f9OydEosjMgXD0uTFPertdyxIM+NrRMjT8/vAwUgBXk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V8AeNJoLSBlRjZpQpAMir85IkHkVXYixd92AmfilM0yT+svq775e0VRU3yQc1QU4p
	 yEXq1uPesVAbUak4SJNbdfFHJMSeODLGIeyEML/eRikBDQ05a1xvfLoF7R+uCSyFQq
	 +Hstu5nTpvlpAy41jUkDZMJC8eIAx25aNeww/GcQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre-Eric Pelloux-Prayer <pierre-eric.pelloux-prayer@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 385/398] drm/amdgpu: lock bo before calling amdgpu_vm_bo_update_shared
Date: Wed, 23 Sep 2026 16:07:39 +0200
Message-ID: <20260923140653.444239628@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pierre-Eric Pelloux-Prayer <pierre-eric.pelloux-prayer@amd.com>

[ Upstream commit 36ffc58b8a8704e690a0ce679db26baa5759256f ]

BO's reservation object must be locked before using
amdgpu_vm_bo_update_shared otherwise dma_resv_assert_held will
complain in amdgpu_vm_update_shared.

Signed-off-by: Pierre-Eric Pelloux-Prayer <pierre-eric.pelloux-prayer@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: 636139603b99 ("drm/amdgpu: hold a runtime PM reference for P2P dma-buf attachments")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_dma_buf.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_dma_buf.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_dma_buf.c
@@ -81,6 +81,7 @@ static int amdgpu_dma_buf_attach(struct
 	struct drm_gem_object *obj = dmabuf->priv;
 	struct amdgpu_bo *bo = gem_to_amdgpu_bo(obj);
 	struct amdgpu_device *adev = amdgpu_ttm_adev(bo->tbo.bdev);
+	int r;
 
 	/*
 	 * Disable peer-to-peer access for DCC-enabled VRAM surfaces on GFX12+.
@@ -98,8 +99,14 @@ static int amdgpu_dma_buf_attach(struct
 	    pci_p2pdma_distance(adev->pdev, attach->dev, false) < 0)
 		attach->peer2peer = false;
 
+	r = dma_resv_lock(bo->tbo.base.resv, NULL);
+	if (r)
+		return r;
+
 	amdgpu_vm_bo_update_shared(bo);
 
+	dma_resv_unlock(bo->tbo.base.resv);
+
 	return 0;
 }
 


