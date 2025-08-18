Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA3F732144E;
	Mon, 18 Aug 2025 13:40:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524429; cv=none; b=lceSn/Yozys7byvkX9ptKbDE7WCHFtGCfsaRSxH4hNhzCrVg13JvBRGt4PM0AVUUkVo6LExidjzc2gmQR3soS4lRt/5TXzYAh/ZOqUKKiKQlQ6wa9Hgo6cdXNh72XLajYAen/O+IlrmOeH5Glnz/9/kR1csg1P7croeXUAm/Fjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524429; c=relaxed/simple;
	bh=fX/UWJTcNPy5Oo685zOgQ3bL78WkK1wAtRN3XniAHwc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LGjNZc19Wkw2DOfma0Jba1f6OKOGvAXvEn5zlZ4JPSvMIPcyPHo9KxvwnZARUfu+P/+hNUYt123lT6YaGdPENIvR/wdq0uwradr+kDxsqtY4J2ctab/zaPdlbYq7qI7vEwMkBnVWQ5sI910Mzx+ZwM+sezdGfs3EiQhHxmeBzU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xYCGP1Ue; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xYCGP1Ue"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E3A1C4CEF1;
	Mon, 18 Aug 2025 13:40:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524429;
	bh=fX/UWJTcNPy5Oo685zOgQ3bL78WkK1wAtRN3XniAHwc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xYCGP1UeE/KtkGRRRW4Rj/ZMh0cJzPY33Up3jNdix7tVsDM9DOevlTMTdVI09yue6
	 AytFuRZoZQskG0kH6FSp8uDWgNXZPFh/+FQ/eS8l414lRV5fSpAFcEn2KnPX9fh9m+
	 xy8xFsgNHVzqt+YfICSieMjDThEHh3eT9NiEMnaM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	YiPeng Chai <YiPeng.Chai@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 437/515] drm/amdgpu: fix vram reservation issue
Date: Mon, 18 Aug 2025 14:47:03 +0200
Message-ID: <20250818124515.249837963@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: YiPeng Chai <YiPeng.Chai@amd.com>

[ Upstream commit 10ef476aad1c848449934e7bec2ab2374333c7b6 ]

The vram block allocation flag must be cleared
before making vram reservation, otherwise reserving
addresses within the currently freed memory range
will always fail.

Fixes: c9cad937c0c5 ("drm/amdgpu: add drm buddy support to amdgpu")
Signed-off-by: YiPeng Chai <YiPeng.Chai@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit d38eaf27de1b8584f42d6fb3f717b7ec44b3a7a1)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c
index 07c936e90d8e..78f9e86ccc09 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c
@@ -648,9 +648,8 @@ static void amdgpu_vram_mgr_del(struct ttm_resource_manager *man,
 	list_for_each_entry(block, &vres->blocks, link)
 		vis_usage += amdgpu_vram_mgr_vis_size(adev, block);
 
-	amdgpu_vram_mgr_do_reserve(man);
-
 	drm_buddy_free_list(mm, &vres->blocks, vres->flags);
+	amdgpu_vram_mgr_do_reserve(man);
 	mutex_unlock(&mgr->lock);
 
 	atomic64_sub(vis_usage, &mgr->vis_usage);
-- 
2.50.1



