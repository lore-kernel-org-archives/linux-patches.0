Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F061F1487CD;
	Thu, 12 Dec 2024 15:23:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017025; cv=none; b=KnQHDjrse5zLrX+uiM0RNXXLsiT5FwCfg+qkD/jodK9H54xpNKQ2wUHQxTPXbEPTOgy5hfpSnzSnvm9QWOtppdPCCQ/Qm/BMo+4JaN3z5d8p1RQjeXKIwev3evNKrCzrEKHq7uykbqJwPOsDiK1dKvfzUE4CuERWRpFbTwvKQv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017025; c=relaxed/simple;
	bh=raxPzSrD7nan+hwRnbRQjS16W7Z5UnAZEpA4qFlpcqM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ln/qSYsZSzQXR0lSmO7umq+MSgW69Osb4TAeooRFIc+UKNKaIZ11yQqitRkVVWyoDnkAiMeegHY+uzgjIZ+gM38EydQ3zMSasvCPT7i098Kn9vflmc1POWmIbxFwUB7G12HgDOK0j3dKKoPPBcMWTrGos6X7oaj4k+c3GkoxC0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ud4qHIH2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ud4qHIH2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D340C4CECE;
	Thu, 12 Dec 2024 15:23:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017024;
	bh=raxPzSrD7nan+hwRnbRQjS16W7Z5UnAZEpA4qFlpcqM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ud4qHIH2RmszFyfyL8WDuDvwPUpgfAS65a8/Ms3GWAresf5lKIC1H0ytdQYK2fU4Z
	 k4yY5sV0bSp35o5su8MM3W0BghXKoLTyOLdPJRrfHXchJo8zEeRKNK0cWyOijNouqP
	 9M9wkTrsBvFmvSeAXOjjcYDmC5HH585FpbfdsxyU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Victor Zhao <Victor.Zhao@amd.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 329/466] drm/amdgpu: skip amdgpu_device_cache_pci_state under sriov
Date: Thu, 12 Dec 2024 15:58:18 +0100
Message-ID: <20241212144319.784754757@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 1f08cb88d51be..07f93f77de7dc 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -6344,6 +6344,9 @@ bool amdgpu_device_cache_pci_state(struct pci_dev *pdev)
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



