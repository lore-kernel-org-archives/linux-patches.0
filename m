Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 472141547F0;
	Thu, 12 Dec 2024 15:44:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734018278; cv=none; b=MLv9kf8+tqGCuEXpjjAmaycaqHn9/GxB7RICZss+B4GEytgD3VzH/k1v6+Yc6ofCbqaidEf78WyXV0/31SZxIX+OJc8ChEPrZJC42h3lTWhRgbvW3vsuHe5LyimrIEQeKyyho1pyKI9km/PSbMzj39AMFBbHHgGrbkJtBmio180=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734018278; c=relaxed/simple;
	bh=QMOkB67lsbq5zxA6O0+4PFXHYsrHWmdHodwfe05dRNo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VFnGbKuCIh10MXLY3GAykbWYFNrZVD9zQiM772yFHgKuxFFWyq3yMfKWsPtQQX/SHxGcE0/8tvsrN15svvbFSriOg67vt4hemT4ZpeB9Bw8XE+5zU0aSaOLgXNqGdy3agCl0w8sR1LViikw2eUFTXSzy/rbHhknQVR5iGiNHors=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pnQsO2Nr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pnQsO2Nr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A797EC4CECE;
	Thu, 12 Dec 2024 15:44:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734018278;
	bh=QMOkB67lsbq5zxA6O0+4PFXHYsrHWmdHodwfe05dRNo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pnQsO2NrJ0vzcHMU6j9W12W+mJZx7WcrPgpvjVH4qgyG4TNIUAabf7Pxcyxy+LhCt
	 mk9r0zju38b9QbdXvqBSSEhTB5YtNzT6TCJbOP1vLL3jtHiYT6d4Wlif3YTKxhvZdL
	 fmnk4/TJ08lxaondWI+cd6PiN7VhbyJVTBt6utgw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Victor Zhao <Victor.Zhao@amd.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 248/356] drm/amdgpu: skip amdgpu_device_cache_pci_state under sriov
Date: Thu, 12 Dec 2024 15:59:27 +0100
Message-ID: <20241212144254.404591506@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
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

From: Victor Zhao <Victor.Zhao@amd.com>

[ Upstream commit afe260df55ac280cd56306248cb6d8a6b0db095c ]

Under sriov, host driver will save and restore vf pci cfg space during
reset. And during device init, under sriov, pci_restore_state happens after
fullaccess released, and it can have race condition with mmio protection
enable from host side leading to missing interrupts.

So skip amdgpu_device_cache_pci_state for sriov.

Signed-off-by: Victor Zhao <Victor.Zhao@amd.com>
Acked-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index cd2d99e00b5d9..2e739b80cfccf 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -5841,6 +5841,9 @@ bool amdgpu_device_cache_pci_state(struct pci_dev *pdev)
 	struct amdgpu_device *adev = drm_to_adev(dev);
 	int r;
 
+	if (amdgpu_sriov_vf(adev))
+		return false;
+
 	r = pci_save_state(pdev);
 	if (!r) {
 		kfree(adev->pci_state);
-- 
2.43.0



