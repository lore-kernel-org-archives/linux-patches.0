Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 588F615218A;
	Tue,  2 Jul 2024 17:23:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719941022; cv=none; b=bQfBMpi7QH2Wbf68dFfDHso/uXqA50AAlc6zmWouhz685fRr1fy10Cee+D2p761W44oQ984JAxCyABM9aa8T/KQ6Y+ZdnmzksW/lRvH7TZnnV+rn7hGMuZMuTVB04GbSQEbqbq9Ch7gPgCYpmws7JX8X3gfRVYSN6xNp4GGslQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719941022; c=relaxed/simple;
	bh=+Difje/KzXJo++48N5HmxkrYA4G1vkjfIaOQgGi4P68=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b6nhg9fbr3k42Y9ItIKj3O6ucfqsbs4+EGjj8iImoB/IpTnCg1y8V/2Jl1u9/utyU4wEK2scyoyk/jI/8NtAY5ufG9YeOrffBmZf/DIIDoPnVG8NIWdEYsTxsHy1nLVquv2wQKOAzlU8TX3pTXKEFhey5uw7bnOXpZlDBakEDOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d+jHksKW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d+jHksKW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD4FDC116B1;
	Tue,  2 Jul 2024 17:23:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719941022;
	bh=+Difje/KzXJo++48N5HmxkrYA4G1vkjfIaOQgGi4P68=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d+jHksKWZSivhDTCW7AuW1uO17hOXB02g7Y+ar/2jtvtbltO4oVDV7q48gtyG2zZY
	 W7mxfC/c/vHIVNl9G68SLWDbTqke817tnJx7AfH09yNJ36X0Oo19tX68CerCcPVuCg
	 aDx1lRK+93j1nNtVOPgr3Br3t+IgbkSU7mQ6mqzU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Feifei Xu <Feifei.Xu@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 074/163] drm/amdgpu: Fix pci state save during mode-1 reset
Date: Tue,  2 Jul 2024 19:03:08 +0200
Message-ID: <20240702170235.866474777@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170233.048122282@linuxfoundation.org>
References: <20240702170233.048122282@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 062d78818da16..e1227b7c71b16 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -4685,11 +4685,14 @@ int amdgpu_device_mode1_reset(struct amdgpu_device *adev)
 
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



