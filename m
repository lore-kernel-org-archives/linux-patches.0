Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D0EF2F5A;
	Tue,  2 Jul 2024 17:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719941421; cv=none; b=pWFLM0zB++yCL3NX8+uJ7FPtu6fcRrIpyOvKPftChU7GG7RbhIwPLRlQsItxmhn18osKnNNKeod0Dy8PJjSnS6swWdBFwSQ1WSk1UJFtlC5x+IP418zND6VJfT8uF3w+TBdpnt6ofMeZ5sDnFddnfeeLmCOCKxCJJNyo2UB/Ipw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719941421; c=relaxed/simple;
	bh=lCXm9fmBqjzRs7rQ+DoY6FvNU3WJ4OrQ5sopKJpbXpU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mtFPtmBUws314W0wgVOu+1r5uhxHvaLZJ8EJocTbtRz1hnbAEEz3J+8qu0rYX2bNWkky6L1r6/tNvsCJrImo/iN2M6IvYR16c7AJ2n0WKOrBn+TpOGGiLNRmhM1TECDBaT+YNdB9a3M+pTohzjaWYatPpe2bHOzatum1QIUKqbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QRSlKnfa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QRSlKnfa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67F5DC116B1;
	Tue,  2 Jul 2024 17:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719941420;
	bh=lCXm9fmBqjzRs7rQ+DoY6FvNU3WJ4OrQ5sopKJpbXpU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QRSlKnfaN3kOw0Q5990RyfDBE85uUEQC9lSKkk7kSerAtckS3otn6UVK4Lg05dBIa
	 0Xawdg2jXZ1Rtg7UabkZGDrU2AywrZR8NxD7xdR9VTjjuHp4fyazF/XybRJtpjfsoA
	 HdcxcuvRhe/l3Sq4ziaEEXpAhZ4qiUZsAUJ8eT/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Feifei Xu <Feifei.Xu@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 057/128] drm/amdgpu: Fix pci state save during mode-1 reset
Date: Tue,  2 Jul 2024 19:04:18 +0200
Message-ID: <20240702170228.388650440@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170226.231899085@linuxfoundation.org>
References: <20240702170226.231899085@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 985688696202a..157441dd07041 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -4763,11 +4763,14 @@ int amdgpu_device_mode1_reset(struct amdgpu_device *adev)
 
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



