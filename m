Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61EC3340290
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:53:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301216; cv=none; b=RQ8bAtCg4T9qB/xDlRKuGjM4KGVUsMp92B3OzJfoOT6kc6bfro2zs4fepW2o5tnkoHX0wg6Osb2UPDhehpZac1SAXHyOhwdQkx7KdvqV6tXqmVssXwuBzwqlhZPVf0tTzy0tDj09zMpLrfK699F0rRgQkwjKNRg9AT3IuzIvBl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301216; c=relaxed/simple;
	bh=nGfWN/RyvxmqAuCr2FHXkxLg68q650iTb5z6WbxzE9w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aH5M0FngtLZ13thjfJhE4Nh1hPdfoTayCax38XlAe9T/hdDhjI5/U7OqAu/qatmT2MiWDil06ycWN2XyV+ptjlCOStYFZhGvJh4n9eq/JFEYN+7YXDaCSGnPofKRcCOYMgFuwxnbCZngQHQANbniVh+WuUlIBvFQ9SSzGRZMR4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oMKPaf8A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oMKPaf8A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C54E4C19423;
	Sat, 28 Feb 2026 17:53:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301216;
	bh=nGfWN/RyvxmqAuCr2FHXkxLg68q650iTb5z6WbxzE9w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oMKPaf8AjBxf3SifitmJuUIODW1CM+CRS+WBij8zh+0FZjWOeN+mmLeIbBoWbyaur
	 4In5kzPs4o0WeSXoy1Cxe6TXZdFRlCC0FT6UTP9N3vrYHlUog/wjp8EkR89hHVfykQ
	 LS3w/yFfhjumN6mX4zNhV/H/U2m0nZd2zPkD+3Jbcr+X2iOOzzorurLFgX4BU/Ay6d
	 5UPSgE9P7YpRr3JV5KGudcpW3A/JC+ILT1JPd0NypCqpaeb3vC4m0kymtY7MdJoHTL
	 HJqp7QmZqBIdCBmlYmcsJURnuI+gzm4Yox1xirYRZlv3nkuLpgQIS+9PU7YAvuDYH8
	 j962qulKCk5Yg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Victor Zhao <Victor.Zhao@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 392/752] drm/amdgpu: avoid sdma ring reset in sriov
Date: Sat, 28 Feb 2026 12:41:43 -0500
Message-ID: <20260228174750.1542406-392-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Victor Zhao <Victor.Zhao@amd.com>

[ Upstream commit 5cc7bbd9f1b74d9fe2f7ac08d6ba0477e8d2d65f ]

sdma ring reset is not supported in SRIOV. kfd driver does not check
reset mask, and could queue sdma ring reset during unmap_queues_cpsch.

Avoid the ring reset for sriov.

Signed-off-by: Victor Zhao <Victor.Zhao@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_sdma.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_sdma.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_sdma.c
index 8b8a04138711c..321310ba2c08e 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_sdma.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_sdma.c
@@ -558,6 +558,9 @@ int amdgpu_sdma_reset_engine(struct amdgpu_device *adev, uint32_t instance_id,
 	struct amdgpu_ring *gfx_ring = &sdma_instance->ring;
 	struct amdgpu_ring *page_ring = &sdma_instance->page;
 
+	if (amdgpu_sriov_vf(adev))
+		return -EOPNOTSUPP;
+
 	mutex_lock(&sdma_instance->engine_reset_mutex);
 
 	if (!caller_handles_kernel_queues) {
-- 
2.51.0

