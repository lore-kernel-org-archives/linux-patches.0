Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4EA636D;
	Wed, 17 Sep 2025 12:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758112827; cv=none; b=L3tn13PeSTbb5V0ZJnxoiU0J1K0ZZI5/48t8Pjw5z1DOMkpXCgqL+UPULHMDd6XKFhXVX32DgKQBq9GATo892eOzeXYVyMsZPmRZBFvPwz5qQwjZ7BxqlET9regttr4NZQbnyfZ0bZep9prpLDKgyQC2SJ3zWka5uiGeEEyt7S0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758112827; c=relaxed/simple;
	bh=lv9jOMi1PGs6a+HUmo/EmwilE56ZIFvNZciCMbliB10=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UIctM4lKivVBKkSkknUhksuMbP6ENyIawcZuReZQ2X+/JVGgAjWVfGdMn4R5FJdne24tclv4iyVO0zoJhFg/Cfnmi3/TuWOgwJL71R2sEx4RNPA0KMKWpURzoJHmn6NbJO26A0JSRupFFQS/ytoUM2qb8deXEZe9HDrAVMAM9j0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PhTxDRju; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PhTxDRju"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CCBDC4CEF5;
	Wed, 17 Sep 2025 12:40:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758112827;
	bh=lv9jOMi1PGs6a+HUmo/EmwilE56ZIFvNZciCMbliB10=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PhTxDRju1MChUn/+UieAYQauR6mwOwDCh8b21qidRnDANShl+CT6Zw/RtgmLQl+MH
	 EGEhkXetU/lgwLoZIBF1jQ4Yx4UUqQpsiTFWl1ZKDkO2TKkbqnthyDybsasYiY+BRa
	 oolLQlzpN5J4qOznZRiZAeZ+Yl/lTrMedDC5UL5s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Lin.Cao" <lincao12@amd.com>,
	Vitaly Prosyak <vitaly.prosyak@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.16 088/189] drm/amdgpu: fix a memory leak in fence cleanup when unloading
Date: Wed, 17 Sep 2025 14:33:18 +0200
Message-ID: <20250917123354.005855617@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123351.839989757@linuxfoundation.org>
References: <20250917123351.839989757@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 7838fb5f119191403560eca2e23613380c0e425e upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ring.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ring.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ring.c
@@ -389,8 +389,6 @@ void amdgpu_ring_fini(struct amdgpu_ring
 	dma_fence_put(ring->vmid_wait);
 	ring->vmid_wait = NULL;
 	ring->me = 0;
-
-	ring->adev->rings[ring->idx] = NULL;
 }
 
 /**


