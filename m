Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB6331A704B;
	Sun,  7 Sep 2025 20:35:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277359; cv=none; b=FfILoANyJlvujPlPy81Sdhny1R9howIbPeFCLWGoi2pMIdBG4m49QyRioCmLepQtXuzYSFGzsXp48bJzRRyapFnJ/5Y8H1nNxbvjVPgP6j7/uMSrCn6Ux0Fjit/Qq3QpNxf0AtwiOHt6qO03gYUF3L9nEPrmzTtFpgw8GiNLOAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277359; c=relaxed/simple;
	bh=Twl84jYpuoElkZmJ/HY4ms1Hoqkj+aOsq2SmsXH9hew=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GA52S+qo/OvDSTqUFRpjOqhS0BQbMaHLmUG4bDLWeSta7zpJ+9n3kwDBa6PqTcR2zdUJy3ISW6+MZPff6fHAQe/Rsq4jAGB0R2AHcytHjrlRGq/TufqGdiiCTMIYDz7xl+QYyCWv6GJi0Res/MXRQ+9CjhflE72/1DyRdUNAefM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JFuh0P/c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JFuh0P/c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D3C7C4CEF0;
	Sun,  7 Sep 2025 20:35:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277359;
	bh=Twl84jYpuoElkZmJ/HY4ms1Hoqkj+aOsq2SmsXH9hew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JFuh0P/c+JsI+C9iLL2RbBmzo+bosSvjXEDAQbDLezPcI3BW5m5wYfPrE2UNkAZBV
	 r5UGR7tgc4uzR/PmAC4cBpubqYPQPdRcWHf2bVx3VT+sJqiX/7AFj7W5h+LPDoW/vx
	 ep6wQVX9t8hSiIbtgDuS22njcMXPK+EdL2X4Z4TQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Colin Ian King <colin.i.king@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 165/175] drm/amd/amdgpu: Fix missing error return on kzalloc failure
Date: Sun,  7 Sep 2025 21:59:20 +0200
Message-ID: <20250907195618.761705559@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195614.892725141@linuxfoundation.org>
References: <20250907195614.892725141@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Colin Ian King <colin.i.king@gmail.com>

[ Upstream commit 467e00b30dfe75c4cfc2197ceef1fddca06adc25 ]

Currently the kzalloc failure check just sets reports the failure
and sets the variable ret to -ENOMEM, which is not checked later
for this specific error. Fix this by just returning -ENOMEM rather
than setting ret.

Fixes: 4fb930715468 ("drm/amd/amdgpu: remove redundant host to psp cmd buf allocations")
Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 1ee9d1a0962c13ba5ab7e47d33a80e3b8dc4b52e)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
index 3d42f6c3308ed..8553ac4c0ad3f 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
@@ -433,7 +433,7 @@ static int psp_sw_init(void *handle)
 	psp->cmd = kzalloc(sizeof(struct psp_gfx_cmd_resp), GFP_KERNEL);
 	if (!psp->cmd) {
 		dev_err(adev->dev, "Failed to allocate memory to command buffer!\n");
-		ret = -ENOMEM;
+		return -ENOMEM;
 	}
 
 	adev->psp.xgmi_context.supports_extended_data =
-- 
2.51.0



