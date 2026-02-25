Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E8F42FB08C;
	Wed, 25 Feb 2026 06:59:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002753; cv=none; b=NlTAwbjDfAeLHBuz6xzft0wlBEE5vDaBpOCbwlYuPZ6dEQUAOicX+QRspKkDzp7RiDdBSzrOCmckSth+NDqIwAc9IH6W6nvAV2BnkA/8IM80AYDKADqlF8oUF1FmYTXQ3nyx8b5/Guybj/1hYxUEmTuT3GltIHrNWxixpBXvEuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002753; c=relaxed/simple;
	bh=X7elIupXQot2VhbU1uwjMzA0wvqB5glwDOHlnO4G1v4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=svaAU5zYgqZmUSl+291vefur4NRk6e7qhDtG7q/x+7PQmTznChHEruJZDdiWFlzcViGMEBwE4/Gru5v7PejJrSVsZxqZ0blcd8VYC1Po25zpE5aY+vBoey0IUrlRnJfmpayOjwMXwKccTOCUCl8SD0ljGMsyXRqzPelg02oljLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lD7n4pVS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lD7n4pVS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34828C116D0;
	Wed, 25 Feb 2026 06:59:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002753;
	bh=X7elIupXQot2VhbU1uwjMzA0wvqB5glwDOHlnO4G1v4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lD7n4pVSPpacX8MJBvEFPCMsCgEqd6p4y5Cp/R6q8XMsOm/ko2ei7abNhaO1c8S3c
	 /L8/bopmt1QoN2hfwXUR3+h11ZlP1xE3oRfzvxVpTHrbMlN18GncRhxxRaOzd8KrVt
	 YwdZEhaMb7T23XH0neP+ArFdI+dSpgwYbEseAi0E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Zilin Guan <zilin@seu.edu.cn>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 579/641] drm/amdgpu: Use kvfree instead of kfree in amdgpu_gmc_get_nps_memranges()
Date: Tue, 24 Feb 2026 17:25:05 -0800
Message-ID: <20260225012402.543562010@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index aef1ba1bdca9e..01ad5cc008a96 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c
@@ -1381,7 +1381,7 @@ int amdgpu_gmc_get_nps_memranges(struct amdgpu_device *adev,
 	if (!*exp_ranges)
 		*exp_ranges = range_cnt;
 err:
-	kfree(ranges);
+	kvfree(ranges);
 
 	return ret;
 }
-- 
2.51.0



