Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50EE9197523;
	Thu,  6 Jun 2024 14:12:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683134; cv=none; b=K5R9CRBiYu9IjVKzj2tYWBQLSzW9+HCl+Y9Nx2aUTQjsiJuVl79+OJG4FbykCXjlgrrtcNRwB3gsSF8rDodw8GfchRzFsNZI6sgZLM00nEhUSuO9P21a4OxfLtoUc3sm7h5KhQetNiK295nAjfQe0zAxZKS7IsOpse3Gb2wnCbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683134; c=relaxed/simple;
	bh=Qx9ad0HVlpejWbJuDDRkJpEz/CKRKoJcdl3e1srHL20=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZvSB9tqo0axBw0XPv4cGpkWj5uUR3yRecCYcrzYudR6Y4OFfF9ZwP+Ji+ccIbhypmifaAWUXc9sbi4yh4ckMbVolRuphK4QhqIYLiIsCGMwvm11I0GdGIrYwl1nZFsbQsjEQweETzlrzx52DV01xXIJfgAOmBK/UDwe2T3zWJzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NDXqEJHC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NDXqEJHC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31268C2BD10;
	Thu,  6 Jun 2024 14:12:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683134;
	bh=Qx9ad0HVlpejWbJuDDRkJpEz/CKRKoJcdl3e1srHL20=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NDXqEJHCH4TS7NlnRqHcDYIWicywzk84qxveINNg/E9jAUajBF7awy/CTC05MVrmJ
	 Z6PEuc7ediModIKZG93MuWU3eplHp7/unayB1YCZcy8WWdVYtEbafBjfnnz1rZ3DJs
	 6ufAd8I82vBN3uBRzUSg8FzlINPLBKtOnb8lbXcw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Kuehling <felix.kuehling@amd.com>,
	Mukul Joshi <mukul.joshi@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 041/744] drm/amdgpu: Update BO eviction priorities
Date: Thu,  6 Jun 2024 15:55:13 +0200
Message-ID: <20240606131733.767369444@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Kuehling <felix.kuehling@amd.com>

[ Upstream commit b0b13d532105e0e682d95214933bb8483a063184 ]

Make SVM BOs more likely to get evicted than other BOs. These BOs
opportunistically use available VRAM, but can fall back relatively
seamlessly to system memory. It also avoids SVM migrations evicting
other, more important BOs as they will evict other SVM allocations
first.

Signed-off-by: Felix Kuehling <felix.kuehling@amd.com>
Acked-by: Mukul Joshi <mukul.joshi@amd.com>
Tested-by: Mukul Joshi <mukul.joshi@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_object.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c
index a348d320575e0..4e9ae52ef9fdb 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c
@@ -613,6 +613,8 @@ int amdgpu_bo_create(struct amdgpu_device *adev,
 	else
 		amdgpu_bo_placement_from_domain(bo, bp->domain);
 	if (bp->type == ttm_bo_type_kernel)
+		bo->tbo.priority = 2;
+	else if (!(bp->flags & AMDGPU_GEM_CREATE_DISCARDABLE))
 		bo->tbo.priority = 1;
 
 	if (!bp->destroy)
-- 
2.43.0



