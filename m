Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 997B815B0FE;
	Tue,  2 Jul 2024 17:11:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940266; cv=none; b=o6AuKJ4JvzTLTJOklhVL9JZrwGSAYYQQBXygcefz0TQ/UceEm6T7mDl6B2Vev5CFytjdSzwq9vQ95VAkIVL9znXbIrKkr4tKYlZ+kz8waHDouNvvt7JYNNxeq/gOpxR9z3JiPXJxjcnfeXYy4O7jvFc97T8rt/RVgEkoHIbKn4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940266; c=relaxed/simple;
	bh=1ucRHKF5RqviqWN6kl0GKurFbkL9AKHCPPMEQnBHCGc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WrHtY3L70DkYYAprMCZ+h6fw7ZHvuITgw/Gb1LQg5Z1rvMw/66PmR0xEl8ueyoXLGP3L6rewKgqkhEzLpFH82r4dfJrD6FFFMVbrn2fp2DzfFsDwyrhaHtIuB9WgprB7iK/OXvpN1GnbFrqQx8GW3+E1tE+hyVkM4bFI72/h3wI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vI7oqORN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vI7oqORN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C95E5C116B1;
	Tue,  2 Jul 2024 17:11:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940266;
	bh=1ucRHKF5RqviqWN6kl0GKurFbkL9AKHCPPMEQnBHCGc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vI7oqORNamBWyI7ZhiXnmpz0YJvuzOY6rPjvwpoKm+2MuGpXkb+ZjI1StMomXlgLK
	 fWqbSU97zeI1ddNVObnjtGB0xDnqPoD26eNBedH4UgRTv3u+0K66iUDLg01Vi/UUW+
	 6rcX8+3FAJhURMhwL7dde14ymdg1WDoyzX8mYYQs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Feifei Xu <Feifei.Xu@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 102/222] drm/amdgpu: Fix pci state save during mode-1 reset
Date: Tue,  2 Jul 2024 19:02:20 +0200
Message-ID: <20240702170247.866363417@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170243.963426416@linuxfoundation.org>
References: <20240702170243.963426416@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lijo Lazar <lijo.lazar@amd.com>

[ Upstream commit 74fa02c4a5ea1ade5156a6ce494d3ea83881c2d8 ]

Cache the PCI state before bus master is disabled. The saved state is
later used for other cases like restoring config space after mode-2
reset.

Fixes: 5c03e5843e6b ("drm/amdgpu:add smu mode1/2 support for aldebaran")
Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
Reviewed-by: Feifei Xu <Feifei.Xu@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index 941d6e379b8a6..eb8af023326ab 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -5121,11 +5121,14 @@ int amdgpu_device_mode1_reset(struct amdgpu_device *adev)
 
 	dev_info(adev->dev, "GPU mode1 reset\n");
 
+	/* Cache the state before bus master disable. The saved config space
+	 * values are used in other cases like restore after mode-2 reset.
+	 */
+	amdgpu_device_cache_pci_state(adev->pdev);
+
 	/* disable BM */
 	pci_clear_master(adev->pdev);
 
-	amdgpu_device_cache_pci_state(adev->pdev);
-
 	if (amdgpu_dpm_is_mode1_reset_supported(adev)) {
 		dev_info(adev->dev, "GPU smu mode1 reset\n");
 		ret = amdgpu_dpm_mode1_reset(adev);
-- 
2.43.0



