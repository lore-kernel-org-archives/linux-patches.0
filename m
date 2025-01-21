Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AFC51F0E36;
	Tue, 21 Jan 2025 18:02:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482554; cv=none; b=KtIM2gbruqdSKEhYd4dMKTBwFegZis7Xan3wxpHPDZSNA6V7TbdW09obfw9duBWYrXdA7Fn9j7alGgSqYqPMYh0nyb6qe2/VI6QW6Cc7VkFRwbFkMoSRlJ1pGnTbElpoXpK4HXKh8uNiRi3oQObIAMuJB4SPj+cvpOERcgi8sAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482554; c=relaxed/simple;
	bh=EHlVmuw7tqYC+zPv5GroqenWuzEnW+rd9xwhDCgZ9v8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ibb1fcIyeejz7Dppiyb8mS78M8jIzCqHhGs+THv5hHZuwJJp+dWQ/zl+dgkMlXBycv3nivNcMfnf4vcsiO00s2KCTUTVvQFrc2Tw5nlAPnF7m3+mS59I5CTJdgmoPbxSEMt305xBXQuVIZulzcBgGAb0mYPA9QakYeMd25Lj4ys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DrTjYyEo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DrTjYyEo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CA84C4CEE1;
	Tue, 21 Jan 2025 18:02:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482553;
	bh=EHlVmuw7tqYC+zPv5GroqenWuzEnW+rd9xwhDCgZ9v8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DrTjYyEow6l2jI4xjWNo3BvBHBFu2uWOHO7iAr4EQWDS3zVAe9iODUra5fodq9POA
	 1efX9WKBfGeCcyafHaXRW/+7lLpEMLz9ItFSJR1XVzfrtumrd74MjGS8OFN4d8SPB9
	 BuuXEzJlnBEZCxPiL9KUfwVBHxBLkPZg4eroVS7k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 116/122] drm/amdgpu: always sync the GFX pipe on ctx switch
Date: Tue, 21 Jan 2025 18:52:44 +0100
Message-ID: <20250121174537.527783583@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174532.991109301@linuxfoundation.org>
References: <20250121174532.991109301@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian König <christian.koenig@amd.com>

commit af04b320c71c4b59971f021615876808a36e5038 upstream.

That is needed to enforce isolation between contexts.

Signed-off-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit def59436fb0d3ca0f211d14873d0273d69ebb405)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ib.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ib.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ib.c
@@ -193,8 +193,8 @@ int amdgpu_ib_schedule(struct amdgpu_rin
 	need_ctx_switch = ring->current_ctx != fence_ctx;
 	if (ring->funcs->emit_pipeline_sync && job &&
 	    ((tmp = amdgpu_sync_get_fence(&job->explicit_sync)) ||
-	     (amdgpu_sriov_vf(adev) && need_ctx_switch) ||
-	     amdgpu_vm_need_pipeline_sync(ring, job))) {
+	     need_ctx_switch || amdgpu_vm_need_pipeline_sync(ring, job))) {
+
 		need_pipe_sync = true;
 
 		if (tmp)


