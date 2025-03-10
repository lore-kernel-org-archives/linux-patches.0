Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D57C1B3927;
	Mon, 10 Mar 2025 17:38:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628317; cv=none; b=JiIzUL17TqSZRP3umHiys8Orf3swo/fCepoEnxhaChz6nsNQ3my76DwrJyhZTCBx+Qn+UVBAjqC5j50THfMVFh/psGHUn72AsCmYgbQTFRq9yiqHoqPxeMcf1M09Jg/6Js3ufZKZu6SH4BpY6aeIPtAW9i3WVnbjMom8N0P5IOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628317; c=relaxed/simple;
	bh=292D5bxM4dYf/7fL69dRibgxpv2naEV+lBLn7E96a4Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fvdsh8wzmK3Sbxoc6v6OsF77pMg5HYZxSixQEUQKY+cqk0oXeswVc/w1nft69WC9ptW0qtUWymuzh/lXGCgQQPNZ0su5fM8J4iREehNY3LlEva9Z/3X2Fpsd3qyQZOkm+cfo7+hE6PCqqCXYXa8vaMd22ypbtd2AoeJafFpZ0hs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wZI2U5eq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wZI2U5eq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1149FC4CEED;
	Mon, 10 Mar 2025 17:38:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628317;
	bh=292D5bxM4dYf/7fL69dRibgxpv2naEV+lBLn7E96a4Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wZI2U5eqleTVpuNF8NhgdO3myw8jm/Gj17tcs61kRY3jm745JkfPYmF8N2qywKHm3
	 BBWl35HBYYkWsqY5ykDf73oZ7uSmJ93Jp7nCdVtW1c86mlBNRl6TPpr8ZS3GZEGBra
	 qa/lZei4PcrRDAvT0htnZtA87w1P0XyiO3SmTcqQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Jun <Jun.Ma2@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 003/109] drm/amdgpu: Check extended configuration space register when system uses large bar
Date: Mon, 10 Mar 2025 18:05:47 +0100
Message-ID: <20250310170427.677348713@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170427.529761261@linuxfoundation.org>
References: <20250310170427.529761261@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ma Jun <Jun.Ma2@amd.com>

[ Upstream commit e372baeb3d336b20fd9463784c577fd8824497cd ]

Some customer platforms do not enable mmconfig for various reasons,
such as bios bug, and therefore cannot access the GPU extend configuration
space through mmio.

When the system enters the d3cold state and resumes, the amdgpu driver
fails to resume because the extend configuration space registers of
GPU can't be restored. At this point, Usually we only see some failure
dmesg log printed by amdgpu driver, it is difficult to find the root
cause.

Therefor print a warnning message if the system can't access the
extended configuration space register when using large bar.

Signed-off-by: Ma Jun <Jun.Ma2@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: 099bffc7cadf ("drm/amdgpu: disable BAR resize on Dell G5 SE")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index c4e548d32504d..a28f7e0a27aaa 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -1220,6 +1220,10 @@ int amdgpu_device_resize_fb_bar(struct amdgpu_device *adev)
 	if (amdgpu_sriov_vf(adev))
 		return 0;
 
+	/* PCI_EXT_CAP_ID_VNDR extended capability is located at 0x100 */
+	if (!pci_find_ext_capability(adev->pdev, PCI_EXT_CAP_ID_VNDR))
+		DRM_WARN("System can't access extended configuration space,please check!!\n");
+
 	/* skip if the bios has already enabled large BAR */
 	if (adev->gmc.real_vram_size &&
 	    (pci_resource_len(adev->pdev, 0) >= adev->gmc.real_vram_size))
-- 
2.39.5



