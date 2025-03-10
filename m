Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B347374EA;
	Mon, 10 Mar 2025 18:19:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741630775; cv=none; b=ZDXEvMGbZWbSxBWxrv5GQIi9wJzqKOqo125Vn0BnS4y/6sfAaUfgpfi265z4g8muOzC+6rdqlqGw7YFE02QPtODSslgbIiu8xWBd5jS0Z4VJ8Y26FoPqq1RgE3u3eTqJdAZnLz7H0vvJsALaJfN66wWil34mFW1ZE0euWjsSL6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741630775; c=relaxed/simple;
	bh=X4uqBeeFslA0P5jDTSJ8/ePEGJFU3GAJhqz8uOR/Sdg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XQxYrlcMM++oGshAGsXwU8HZsX3zNqnbEEFZIYiqij7K9eBH7MfYqPCj+51NKUpZq66skDwFXydaP+NwkuwA+tcMPfStwg1jKF6nt9wEHsErJRDSfuLRScv8GZccKBbDxxLBtdBlZbxoAzn4sxHPnr+2ZbfJ2MTNhZILtq2A4ok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nGEI980i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nGEI980i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD66CC4CEE5;
	Mon, 10 Mar 2025 18:19:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741630775;
	bh=X4uqBeeFslA0P5jDTSJ8/ePEGJFU3GAJhqz8uOR/Sdg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nGEI980iRUkLHz/n2OwxamkyDUN/cRxHsVsF6FN1kGNcLu4yoTU1Y9i7iiVrW1HGC
	 t6mCvpb2jHNMNsUHzdPJ7h+WBR/hkg0lLDjwBFFOeXCkVlTHrllxcF5lTh26ScXHWx
	 FVlPSpPqaiWauuwtNrAVji2F6Z3At1jlfQsgfRBU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Jun <Jun.Ma2@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 531/620] drm/amdgpu: Check extended configuration space register when system uses large bar
Date: Mon, 10 Mar 2025 18:06:17 +0100
Message-ID: <20250310170606.505830585@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 4be8d2ca50f3a..387538f0ca54b 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -1202,6 +1202,10 @@ int amdgpu_device_resize_fb_bar(struct amdgpu_device *adev)
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



