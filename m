Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30B251F1302;
	Tue, 30 Sep 2025 15:11:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759245077; cv=none; b=FUrXtNXmkFZXcPJTIERlYxIVvfvND1XLsVcLzxeelh84WvE4nYkGIE9VSpAGDQR9p9JDGDSh4VwqVehX0U845NSR3NZMDTtEeDId8w++SFDmbEFIVZTngDxjwCNv67VrquOmnCubnodjVddNGTHUHSLh4PISAoD+WWg9AbKzhqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759245077; c=relaxed/simple;
	bh=LPodH74C+F8Ptoic6q14VTfitzk7lq6cj9U8bNTTeGk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CeJyFAVF13KQ1NtMt+9LMfMUqNNUeakgdwEgiuQkqP+u+bUcU2P+MR+SX7Vg7yDCGhgzXrChSJxN9INfoyfS3ofslUNiPcSwVW6CtXA1JEeoiglylKeE0wKlyqanOX3B1jGVV51p5JwUic9Y6c0rg5fOtn6cF9tMuq6pqGPhoE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ypan8qFt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ypan8qFt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD66CC4CEF0;
	Tue, 30 Sep 2025 15:11:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759245077;
	bh=LPodH74C+F8Ptoic6q14VTfitzk7lq6cj9U8bNTTeGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ypan8qFtOLPHxcdR/DuicU2y/mFQgkhs0Ei/Q+VZqC7sfoGLo7nC/6eaqduwH7S1M
	 3RMhxGiWXKjbN4UPZ6mdXHCVCcE2rHF1W9+gvzFPj+JT+J4gk786M5dXl7WWAqcmWT
	 yDe2z+oD7BOK2ZzyuwIEhsE2+Z344YBt5XmKvQho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Lin.Cao" <lincao12@amd.com>,
	Vitaly Prosyak <vitaly.prosyak@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 061/151] drm/amdgpu: fix a memory leak in fence cleanup when unloading
Date: Tue, 30 Sep 2025 16:46:31 +0200
Message-ID: <20250930143830.031349401@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143827.587035735@linuxfoundation.org>
References: <20250930143827.587035735@linuxfoundation.org>
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

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit 7838fb5f119191403560eca2e23613380c0e425e ]

Commit b61badd20b44 ("drm/amdgpu: fix usage slab after free")
reordered when amdgpu_fence_driver_sw_fini() was called after
that patch, amdgpu_fence_driver_sw_fini() effectively became
a no-op as the sched entities we never freed because the
ring pointers were already set to NULL.  Remove the NULL
setting.

Reported-by: Lin.Cao <lincao12@amd.com>
Cc: Vitaly Prosyak <vitaly.prosyak@amd.com>
Cc: Christian König <christian.koenig@amd.com>
Fixes: b61badd20b44 ("drm/amdgpu: fix usage slab after free")
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit a525fa37aac36c4591cc8b07ae8957862415fbd5)
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ring.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ring.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ring.c
@@ -302,8 +302,6 @@ void amdgpu_ring_fini(struct amdgpu_ring
 	dma_fence_put(ring->vmid_wait);
 	ring->vmid_wait = NULL;
 	ring->me = 0;
-
-	ring->adev->rings[ring->idx] = NULL;
 }
 
 /**


