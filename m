Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 746C11DE4EF;
	Sat, 12 Sep 2026 14:08:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789222112; cv=none; b=aXn1sBUWEMNeN+iHCQdiLfXrsIHgc7Zz+BcaWCOlRmyeBMk9KPJjofjGJEV3arW3PIs/Lw8WmmfnW97L8v7MGLLVYs36rTIgUPPDtfLb7Wa4fud7S41IQnfvcFa/tlzOyo8DI/EjWYIulPBRVCxM3iCmeqJw/nL+jKagKE+UKRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789222112; c=relaxed/simple;
	bh=H3VPmE9Od5IAXMxFnr69GFtQPBMmcdwuhjQPifXvSzQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ecO7SWYH7MNGYie/4zbQuVnvqnqWYKCdl+k38UHXxDBNtofXD3vINKezGj2bEc0EKRG2/7/MlwjB1zWxp/uUSs05Ktrqd9n9uFd7Wof8uETi9VZC5prhvDXe71SQJmFpuvXzrONzoXkxm6tp0BoGgwkZ5QlVWurTLIiANNwjMrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AIkLi7JB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AIkLi7JB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0345D1F000FF;
	Sat, 12 Sep 2026 14:08:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789222111;
	bh=FY/2FwJIhddhSXOuuGW1OiXBq/sVCHghJ1hLmmEXHS4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AIkLi7JBEvM0TbBGUaaFEJI5YTTkle6HxbgMCqSD4GMtZ4GaGLqILb+E1mgMVyIJe
	 XX3bXuK57pFxH9+4msp69i0IoQ1btX7gvBcOhrul6Gm6c/MHCjGzczbfN/n9La0B7W
	 MAtN8esS0VpSTGS5Mc7dNeFlCRCL5M3hJ3oZcfGc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Wang <kevinyang.wang@amd.com>,
	Kenneth Feng <kenneth.feng@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 0521/1424] drm/amdgpu: check thunderbolt before switcheroo registration
Date: Sat, 12 Sep 2026 08:49:13 +0200
Message-ID: <20260912065618.960124106@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Yang Wang <kevinyang.wang@amd.com>

commit 8587d48d694da5aca580f92461658ec14470592b upstream.

Introduce a helper to consolidate the vga_switcheroo registration condition
used by the init and fini paths.

Keep the explicit pci_is_thunderbolt_attached() check, as dev_is_removable()
does not provide equivalent coverage for Thunderbolt-attached GPUs.
This ensures such devices remain excluded from switcheroo registration while
preserving the existing PX and Apple gmux handling.

Cc: stable@vger.kernel.org
Signed-off-by: Yang Wang <kevinyang.wang@amd.com>
Reviewed-by: Kenneth Feng <kenneth.feng@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -3586,6 +3586,14 @@ static void amdgpu_device_set_mcbp(struc
 		DRM_INFO("MCBP is enabled\n");
 }
 
+static bool
+amdgpu_device_should_register_switcheroo(struct amdgpu_device *adev, bool px)
+{
+	return !pci_is_thunderbolt_attached(adev->pdev) &&
+	       (px || (!dev_is_removable(&adev->pdev->dev) &&
+		       apple_gmux_detect(NULL, NULL)));
+}
+
 /**
  * amdgpu_device_init - initialize the driver
  *
@@ -4002,8 +4010,7 @@ fence_driver_init:
 
 	px = amdgpu_device_supports_px(ddev);
 
-	if (px || (!dev_is_removable(&adev->pdev->dev) &&
-				apple_gmux_detect(NULL, NULL)))
+	if (amdgpu_device_should_register_switcheroo(adev, px))
 		vga_switcheroo_register_client(adev->pdev,
 					       &amdgpu_switcheroo_ops, px);
 
@@ -4162,8 +4169,7 @@ void amdgpu_device_fini_sw(struct amdgpu
 
 	px = amdgpu_device_supports_px(adev_to_drm(adev));
 
-	if (px || (!dev_is_removable(&adev->pdev->dev) &&
-				apple_gmux_detect(NULL, NULL)))
+	if (amdgpu_device_should_register_switcheroo(adev, px))
 		vga_switcheroo_unregister_client(adev->pdev);
 
 	if (px)


