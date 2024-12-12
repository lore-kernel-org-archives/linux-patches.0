Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0146722330D;
	Thu, 12 Dec 2024 17:09:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023344; cv=none; b=KtQECusg4K9inFo9W6Lm/d0MsmBUhRKnXYL1DnhAc5AX2AT7rLJ6p0SXRdpVgLyMZMe1VIzC6QO6MLf+C1F80sS4zwbF/5MY/9wkt0we/yJ1u1o213QFVQo5HbOkpC9nZ8F45sF/4l4N0VPKnFR6CHYMX/y6VpBdqHvDNphW9L0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023344; c=relaxed/simple;
	bh=xtaoOQPygjRaBte3GrmT1da+qzifchKK1P6r25azNEs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oK3TyjUx3GuZck7+1WjxnVuO0CdPynb2j23+8mbPlNiNNEz/RYXPFQZ4BB6FH5Fdxopuo57/4VRSoBpRxeHZmYUmoYjp4pmTA52SWdX66ywFFSajKl9HwjDd2EA2QauFUFz6VFWP7P+/JNav4wjmci7w2THwMoRGKoShjcDNZf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JdRczyNm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JdRczyNm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70C3FC4CECE;
	Thu, 12 Dec 2024 17:09:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023343;
	bh=xtaoOQPygjRaBte3GrmT1da+qzifchKK1P6r25azNEs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JdRczyNmHFtmkG63pp14JHjGfmungzNISgwFLrJwbSCL6uaPUSLCRfi7cRkmArb0e
	 hADQ4beLNyl23RVP8XGJXj6SyO27msRroI824PLUzpHCZhPtY0dfKYFOgLAKoOb/XX
	 V55LMsvNN4htWPD6m0aA61hsgoRK/ldFxQclgfhE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Victor Zhao <Victor.Zhao@amd.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 503/565] drm/amdgpu: skip amdgpu_device_cache_pci_state under sriov
Date: Thu, 12 Dec 2024 16:01:38 +0100
Message-ID: <20241212144331.645985064@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 042f27af6856c..4be8d2ca50f3a 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -5743,6 +5743,9 @@ bool amdgpu_device_cache_pci_state(struct pci_dev *pdev)
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



