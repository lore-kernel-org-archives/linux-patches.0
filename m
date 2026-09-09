Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DAC15867D3;
	Wed,  9 Sep 2026 14:32:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964348; cv=none; b=GVvqmXWL9FnF+LKNplPIq5ibNuTK1kFynOiFB5hcDv5FnSgse1kK6aGNUhc0pAd4faOX15Zq/Rcb10WX20NP/5131xjEKmOnYN1bA9yjW6WVLoG4skxgJ7Ex4zPwSKcYO6u00UNL5zZWSfQ+xxFPwxBPLm5ax2l7K1Um0h3RKrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964348; c=relaxed/simple;
	bh=5udAUevWk7qHRobETCzEhGVUn64rrvvcqiu4tHXPdWs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dby6hTqdghpPaPZiXSfTGR2V6GrXxLHJ4DJcHuXNONLrgBhw46x+CDlfaPhQQr7KWeaM6lnTEItvZpOV0GKUSEoxL7f4BaKwJqDhbuPz+U9EgtbuZvJaFsTW0WQ01daA4A4/Kmz7ycOrZtt4tCTdzXt259GuzLhq1d9ml3GpgO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HnzdcVTs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HnzdcVTs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D26AB1F00A3A;
	Wed,  9 Sep 2026 14:32:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964347;
	bh=2APXnBcP47l08Ym/3wu7gNdAa1IfHKCWyLilEczBPfE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HnzdcVTst1ObT2Ff7Z3v4F75voquIA/7uqDLOO21pqVf6B9c2061zaVbFjMTr8hFI
	 szkVX8Yjm01v3Pm3bpgjlPH/yQDER9pv9eQgkWE2Hwoz2WylZzQFPbuv+rMnVQDc0F
	 qTgClHjLObae/4E/7IV5wy2RARV+8L3gnHYaOPKg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Wang <kevinyang.wang@amd.com>,
	Kenneth Feng <kenneth.feng@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 391/583] drm/amdgpu: check thunderbolt before switcheroo registration
Date: Wed,  9 Sep 2026 15:41:16 +0200
Message-ID: <20260909134251.533353524@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4463,6 +4463,14 @@ static void amdgpu_device_set_mcbp(struc
 		dev_info(adev->dev, "MCBP is enabled\n");
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
@@ -4940,8 +4948,7 @@ fence_driver_init:
 
 	px = amdgpu_device_supports_px(adev);
 
-	if (px || (!dev_is_removable(&adev->pdev->dev) &&
-				apple_gmux_detect(NULL, NULL)))
+	if (amdgpu_device_should_register_switcheroo(adev, px))
 		vga_switcheroo_register_client(adev->pdev,
 					       &amdgpu_switcheroo_ops, px);
 
@@ -5117,8 +5124,7 @@ void amdgpu_device_fini_sw(struct amdgpu
 
 	px = amdgpu_device_supports_px(adev);
 
-	if (px || (!dev_is_removable(&adev->pdev->dev) &&
-				apple_gmux_detect(NULL, NULL)))
+	if (amdgpu_device_should_register_switcheroo(adev, px))
 		vga_switcheroo_unregister_client(adev->pdev);
 
 	if (px)


