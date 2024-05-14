Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD62913C685;
	Tue, 14 May 2024 11:39:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686774; cv=none; b=EHM963yhO9CZRblFPrsb5Kec2xpjK9hfUNAIc4krpl0lQmP5zUtltj6SnlvA1wp7v7Z9S8FEGI9P/8QxVbLuCRW0b2d8pnNrCfWq52P9MRC0/A86dwZx/4J4PzzjWh1C43BJPzqJee1EikgO3fxFrkIG1g3R+zz1xb1uKLFJfn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686774; c=relaxed/simple;
	bh=9jYqjQ9XZk3ch8O+ZfzvGkn38ELw8Q8NjYkHrQtb6K0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U1CNSIkUibcIzi2snbl06fSs8ifRJIhm1R+sQoZwQeNoC5u7ZuudMdjfG+GDmmG0pA1iCazcoV6HmTaALpzJn2vkScDZou8bnTWPo1U6xT6q9UN3OTdtWFkD+0R3Loi3ztqsnGX7d5c+0S2GaYnS7Sv+qyBhVflas+qdGTsI34w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mZbz3Umk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mZbz3Umk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46342C2BD10;
	Tue, 14 May 2024 11:39:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686774;
	bh=9jYqjQ9XZk3ch8O+ZfzvGkn38ELw8Q8NjYkHrQtb6K0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mZbz3UmkioUUJd1qoBXYraBvQk24ZnUwamJiOYwy/Da0pOU/elTa47N4g9mYdDW8z
	 JMbSyEuPai1YA1GGSj93Qh+0/4PeMFOdKU+5MPAJVT1j67GvvhBMUhVgm9XFBZW/03
	 MS7Hv5uY0IInxJHj7akvZJxr7q4kAOVqba4UgZQs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mukul Joshi <mukul.joshi@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 05/63] drm/amdgpu: Fix leak when GPU memory allocation fails
Date: Tue, 14 May 2024 12:19:26 +0200
Message-ID: <20240514100948.216527362@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514100948.010148088@linuxfoundation.org>
References: <20240514100948.010148088@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mukul Joshi <mukul.joshi@amd.com>

[ Upstream commit 25e9227c6afd200bed6774c866980b8e36d033af ]

Free the sync object if the memory allocation fails for any
reason.

Signed-off-by: Mukul Joshi <mukul.joshi@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
index 13a03f467688a..e15f9da25c7d1 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
@@ -1273,6 +1273,7 @@ int amdgpu_amdkfd_gpuvm_alloc_memory_of_gpu(
 err_bo_create:
 	unreserve_system_mem_limit(adev, size, alloc_domain, false);
 err_reserve_limit:
+	amdgpu_sync_free(&(*mem)->sync);
 	mutex_destroy(&(*mem)->lock);
 	kfree(*mem);
 	return ret;
-- 
2.43.0



