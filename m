Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5A6E19753B;
	Thu,  6 Jun 2024 14:12:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683164; cv=none; b=e41KUN/j2JQaEy7SZrP3Nv5Y6BpziDm8hpFgJGP0WmK4rMJgFaAe3l2d7OUBWzJk7Gkh1j05WWoiX+cbfuiKpX5AHEXrHQzXt+dJjOuqjyd09ZHreg1vylNM4zPht6cvYLbLT+lt+izsODtRwSqN6Qv6e51Je2SYZx6+bCMrf1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683164; c=relaxed/simple;
	bh=BkE2L/PqWHgnbJMFsEOzhzkjsfnthhTYQlS0lbqGOpQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bhzrEFdsn6x+3bP8JiRi3TBgCveR807FmkirKH3qNEcX/3hYnqE4NvUxGGvaJIEaunSQ6uoPZV55FvGdr8nIYEAJ6o8iElHPXEaqzYuxb/RbsPRLlJ1dhBcba3pVi/w7WIAXG67s4G3uQ14LDCYScuXe3wbHHNOVnRKuU3qseRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mXe8ZJrv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mXe8ZJrv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2CA4C32781;
	Thu,  6 Jun 2024 14:12:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683164;
	bh=BkE2L/PqWHgnbJMFsEOzhzkjsfnthhTYQlS0lbqGOpQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mXe8ZJrv9eonhExQrXq8NIlcwDVdEOLsiadRd3xNHlDEzQXJ0Xa8ewBzBdT0QCKIk
	 sV9DNgXcoFNnQkTqc/YUGrG3XovT3IpINaG0bgC6n0QYG30oxrXuY0gkCVafqt3If4
	 a98sU/ztHCXuCD+IJd3o9/qgZSbmLX5SyZxkbNd4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jack Xiao <Jack.Xiao@amd.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 035/473] drm/amdgpu/mes: fix use-after-free issue
Date: Thu,  6 Jun 2024 15:59:24 +0200
Message-ID: <20240606131701.048212739@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jack Xiao <Jack.Xiao@amd.com>

[ Upstream commit 948255282074d9367e01908b3f5dcf8c10fc9c3d ]

Delete fence fallback timer to fix the ramdom
use-after-free issue.

v2: move to amdgpu_mes.c

Signed-off-by: Jack Xiao <Jack.Xiao@amd.com>
Acked-by: Lijo Lazar <lijo.lazar@amd.com>
Acked-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_mes.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_mes.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_mes.c
index bebd136ed5444..9a4cbfbd5d9e5 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_mes.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_mes.c
@@ -1083,6 +1083,7 @@ void amdgpu_mes_remove_ring(struct amdgpu_device *adev,
 		return;
 
 	amdgpu_mes_remove_hw_queue(adev, ring->hw_queue_id);
+	del_timer_sync(&ring->fence_drv.fallback_timer);
 	amdgpu_ring_fini(ring);
 	kfree(ring);
 }
-- 
2.43.0



