Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEA94248881;
	Wed, 25 Feb 2026 01:40:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983612; cv=none; b=juPSGM9KRmQEFCYxHlivHTZAXIyarx3ENK1JYcw+G8v+Mp8RbOX2mHClMZGM0ERgPDTQ0SER++Wct5X1cuMlKweOrFWfBMZ9QvyFq+dcwawhz5v398YDDnsnnl77XNPpgNiCkrG/DwnA33a4rS6fTnMPnrRPjuqeT8udwhvPQ8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983612; c=relaxed/simple;
	bh=J2ehVbepg5LEX5cQU7Ogl/1oaszUstxFdKLb0Ew0Q3I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gkTzNOPtXL4v8MZOXV/ciGDT780L7vqfsVnEGPZ+oJ8ySQlyrQSRcYvdYnvgT8EjHZn/voKhckHDKNZZ+70JEGoHxaRrPlWuyuJo8MDztnyd0fDmSxxlBeV+IYn7wSVT9ng2LgEelhMcAxYln8ggMxu45t0NOnN20zVirlVXXWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bj0WiEWI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bj0WiEWI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 894E2C19423;
	Wed, 25 Feb 2026 01:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983612;
	bh=J2ehVbepg5LEX5cQU7Ogl/1oaszUstxFdKLb0Ew0Q3I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bj0WiEWIFKsVfOUhlDZAVJCv49JKgwApwYhpLiAJ9EeqaCELg4/39IohOmtn4P8NH
	 f8r+rJaJRNjhBXX5QBb5z9leVUVT/EjnOf4NLgOdDKxFbgrC2JBUUzsP/8B89bZVhB
	 gvh9+vlikNqSm0L+ZEDULLvGV+8bhXcNudYbAuHQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Zilin Guan <zilin@seu.edu.cn>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 707/781] drm/amdgpu: Use kvfree instead of kfree in amdgpu_gmc_get_nps_memranges()
Date: Tue, 24 Feb 2026 17:23:36 -0800
Message-ID: <20260225012417.090844891@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zilin Guan <zilin@seu.edu.cn>

[ Upstream commit 0c44d61945c4a80775292d96460aa2f22e62f86c ]

amdgpu_discovery_get_nps_info() internally allocates memory for ranges
using kvcalloc(), which may use vmalloc() for large allocation. Using
kfree() to release vmalloc memory will lead to a memory corruption.

Use kvfree() to safely handle both kmalloc and vmalloc allocations.

Compile tested only. Issue found using a prototype static analysis tool
and code review.

Fixes: b194d21b9bcc ("drm/amdgpu: Use NPS ranges from discovery table")
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Zilin Guan <zilin@seu.edu.cn>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c
index d9c7ad297293b..2b37398337afc 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c
@@ -1387,7 +1387,7 @@ int amdgpu_gmc_get_nps_memranges(struct amdgpu_device *adev,
 	if (!*exp_ranges)
 		*exp_ranges = range_cnt;
 err:
-	kfree(ranges);
+	kvfree(ranges);
 
 	return ret;
 }
-- 
2.51.0



