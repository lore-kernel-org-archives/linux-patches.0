Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A6918287E;
	Wed,  7 Aug 2024 15:05:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043116; cv=none; b=Z5RclEU1E+k1L/jqHRWSSeWjLbcHSF8B6ETjrsa/ogZypDK9uTmXAs7TcZK6cH3il+nhldADjMaCMZLNP6zpa2B8uPdjvY9tXnpBI0GIAXLzLjvtnWlB/4ZmUOLjxG4qouYcSR52Xqc1/jWu+w1oRIZuArPl9XNDhDvaVE/htbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043116; c=relaxed/simple;
	bh=6Wfut4nqNQHfSQnSLE8jJNrQhjSKJ9gpGhuUfDBhqYc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=poxPjrO1nbek+aZ8P8RGR038D90Skt7GHWAkcD4sgQQERhO5uZaoQRDAOKPZtwop9KrqF2n1trk2GlSjL0MCc1xGyDfnmZFWAAo/+QnFFN3tLy7Uq/19Ue20RzgJW1Hl5u5Ky6ZpG8K9vNq8G0eagiN2vTZPgEvmdet26wY0O2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qMlER4nA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qMlER4nA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D02E7C4AF0E;
	Wed,  7 Aug 2024 15:05:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043116;
	bh=6Wfut4nqNQHfSQnSLE8jJNrQhjSKJ9gpGhuUfDBhqYc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qMlER4nA9C4APKCrkNepRAQoC3FofhIU9GRg6+6VcpKw0pIv2CXxnfzNrfQDcVbGF
	 9JlNBBq7Zy6iHD3K2i96bdW5/w43knFgr4C4+yBQUfFJtmDpK51vy7+Fs9NZzkNkbh
	 iSo2fMqBd7nZ1e81J5dEdkh41voFo0ktm9huEsks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Dave Airlie <airlied@redhat.com>
Subject: [PATCH 6.10 095/123] drm/amdgpu: fix contiguous handling for IB parsing v2
Date: Wed,  7 Aug 2024 17:00:14 +0200
Message-ID: <20240807150023.902606845@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150020.790615758@linuxfoundation.org>
References: <20240807150020.790615758@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian König <christian.koenig@amd.com>

commit f3572db3c049b4d32bb5ba77ad5305616c44c7c1 upstream.

Otherwise we won't get correct access to the IB.

v2: keep setting AMDGPU_GEM_CREATE_VRAM_CONTIGUOUS to avoid problems in
    the VRAM backend.

Signed-off-by: Christian König <christian.koenig@amd.com>
Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/3501
Fixes: e362b7c8f8c7 ("drm/amdgpu: Modify the contiguous flags behaviour")
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Tested-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit fbfb5f0342253d92c4e446588c428a9d90c3f610)
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
@@ -1763,7 +1763,7 @@ int amdgpu_cs_find_mapping(struct amdgpu
 	struct ttm_operation_ctx ctx = { false, false };
 	struct amdgpu_vm *vm = &fpriv->vm;
 	struct amdgpu_bo_va_mapping *mapping;
-	int r;
+	int i, r;
 
 	addr /= AMDGPU_GPU_PAGE_SIZE;
 
@@ -1778,13 +1778,13 @@ int amdgpu_cs_find_mapping(struct amdgpu
 	if (dma_resv_locking_ctx((*bo)->tbo.base.resv) != &parser->exec.ticket)
 		return -EINVAL;
 
-	if (!((*bo)->flags & AMDGPU_GEM_CREATE_VRAM_CONTIGUOUS)) {
-		(*bo)->flags |= AMDGPU_GEM_CREATE_VRAM_CONTIGUOUS;
-		amdgpu_bo_placement_from_domain(*bo, (*bo)->allowed_domains);
-		r = ttm_bo_validate(&(*bo)->tbo, &(*bo)->placement, &ctx);
-		if (r)
-			return r;
-	}
+	(*bo)->flags |= AMDGPU_GEM_CREATE_VRAM_CONTIGUOUS;
+	amdgpu_bo_placement_from_domain(*bo, (*bo)->allowed_domains);
+	for (i = 0; i < (*bo)->placement.num_placement; i++)
+		(*bo)->placements[i].flags |= TTM_PL_FLAG_CONTIGUOUS;
+	r = ttm_bo_validate(&(*bo)->tbo, &(*bo)->placement, &ctx);
+	if (r)
+		return r;
 
 	return amdgpu_ttm_alloc_gart(&(*bo)->tbo);
 }


