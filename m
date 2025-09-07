Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A72D1D88D0;
	Sun,  7 Sep 2025 20:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276407; cv=none; b=AYm77aRDufqiTuvQffTQK2qmk5kER5zCdeYbzUfBKgpWZChsqrS+136HpsNfFiUtzqd9o6+8ehqFDshWDPN2RU9e+9Rfk3W0eThI8juRNT1hgcuMG6Spor289XzgOXwVuSvMOQS9gjv4FvthOwHu1ra2VlD+7L8kzlEb+WzSEZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276407; c=relaxed/simple;
	bh=FlkPpJ2pG4+0W6TwLolt/7hGy7zuz4UtKRQwUdwsdrQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RjSF9ZF1efarDUp71wrLK5LmvGFdGi4zLXQ2170Bo10ODHcPOgmi1bzYGbiYz96MVneV24LVAw/jqQEOAwQajRHUtaCTdtVGwd4mesdh3MO3y8QhJ7f0SVLx8lNaTTPa60rmau3Qa5SB4GgCmVAkmevCXKaoUbwxBXhC17tW510=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PhGZ9b3l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PhGZ9b3l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D99B9C4CEF0;
	Sun,  7 Sep 2025 20:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276407;
	bh=FlkPpJ2pG4+0W6TwLolt/7hGy7zuz4UtKRQwUdwsdrQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PhGZ9b3lK40DKadOOhFHunVQ3nazSCPcosHrnY1dyJ4gGMx7wLVlrLM3eXuIYgolU
	 34on4DZvMu+z5lzUvcgEacit3lll+gZaVkccAzFuC+o7cTrHffSlN18G/ngk4T1XBx
	 4wmKuhSr30rEPa7GeCW094tce0nNmVXkxjb76bJ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Colin Ian King <colin.i.king@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 094/104] drm/amd/amdgpu: Fix missing error return on kzalloc failure
Date: Sun,  7 Sep 2025 21:58:51 +0200
Message-ID: <20250907195610.103602452@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195607.664912704@linuxfoundation.org>
References: <20250907195607.664912704@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index df38eb9604ec3..0bc21106d9e87 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
@@ -373,7 +373,7 @@ static int psp_sw_init(void *handle)
 	psp->cmd = kzalloc(sizeof(struct psp_gfx_cmd_resp), GFP_KERNEL);
 	if (!psp->cmd) {
 		dev_err(adev->dev, "Failed to allocate memory to command buffer!\n");
-		ret = -ENOMEM;
+		return -ENOMEM;
 	}
 
 	if (amdgpu_sriov_vf(adev))
-- 
2.51.0



