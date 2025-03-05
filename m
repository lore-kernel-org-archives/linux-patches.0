Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EC7C2528F1;
	Wed,  5 Mar 2025 18:14:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198487; cv=none; b=dvsbVkp6f2qhTJG0pQkM4xqq7KFEuQ7KlyxOXV/uhzgxebcpT0hZT0bYZMylc5CC0My2GRL68NJ2f1yYHkX3IQGsu9j+sFjWU3DAAnEZhfWZiYkk/mtfb/S0alhsc/C9u+ydlkgjgxdR8xId/UjAgZ5NrdrK7grtCxWQPEZ5Kzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198487; c=relaxed/simple;
	bh=4aBC5Fa1u4Cosb1uKBqdxC9mpM7Dx2eiPmd2ptUVDMs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B3Oz/ojhBpei3rZz8AJCCmKoYcUz3QAC/kSHZoMrezrG6tuqxIiCsuWDhG0wWdvnnsiP2rP/Kvp/tGwxtuO235cy8hv1E/8rN0V+I+rzDOD5dttmOijHf1NKQ2CfetGfUsCRXlO6ENqN1uEPGUPmhmnA5MTLJ+klST30s0xBg7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZbedGE1w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZbedGE1w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50773C4CED1;
	Wed,  5 Mar 2025 18:14:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198486;
	bh=4aBC5Fa1u4Cosb1uKBqdxC9mpM7Dx2eiPmd2ptUVDMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZbedGE1wOxhq0AyWYJmrU8Obr+2wWTFWiMZZzucz80UZIqdhuLOFMynm0Tj7DnOnl
	 +1nc0YYBIyKWKERPrXR0tpX2CXigpt38L+RvcOe+lKglnRqAB5BV5pQ8MCBnVn/g4J
	 sCTVyG6MwqsHkI7whARMhR0YSAYjLLaNDE4ekRys=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Shaoyun Liu <shaoyun.liu@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 044/157] drm/amdgpu/gfx: only call mes for enforce isolation if supported
Date: Wed,  5 Mar 2025 18:48:00 +0100
Message-ID: <20250305174507.074543518@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.268725418@linuxfoundation.org>
References: <20250305174505.268725418@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit e7ea88207cef513514e706aacc534527ac88b9b8 ]

This should not be called on chips without MES so check if
MES is enabled and if the cleaner shader is supported.

Fixes: 8521e3c5f058 ("drm/amd/amdgpu: limit single process inside MES")
Reviewed-by: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: Shaoyun Liu <shaoyun.liu@amd.com>
Cc: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
(cherry picked from commit 80513e389765c8f9543b26d8fa4bbdf0e59ff8bc)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c
index 9a4dad3e41529..11aa55bd16d28 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c
@@ -1598,11 +1598,13 @@ static ssize_t amdgpu_gfx_set_enforce_isolation(struct device *dev,
 		if (adev->enforce_isolation[i] && !partition_values[i]) {
 			/* Going from enabled to disabled */
 			amdgpu_vmid_free_reserved(adev, AMDGPU_GFXHUB(i));
-			amdgpu_mes_set_enforce_isolation(adev, i, false);
+			if (adev->enable_mes && adev->gfx.enable_cleaner_shader)
+				amdgpu_mes_set_enforce_isolation(adev, i, false);
 		} else if (!adev->enforce_isolation[i] && partition_values[i]) {
 			/* Going from disabled to enabled */
 			amdgpu_vmid_alloc_reserved(adev, AMDGPU_GFXHUB(i));
-			amdgpu_mes_set_enforce_isolation(adev, i, true);
+			if (adev->enable_mes && adev->gfx.enable_cleaner_shader)
+				amdgpu_mes_set_enforce_isolation(adev, i, true);
 		}
 		adev->enforce_isolation[i] = partition_values[i];
 	}
-- 
2.39.5



