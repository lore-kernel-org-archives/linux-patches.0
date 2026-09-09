Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 896F957D22A;
	Wed,  9 Sep 2026 14:10:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963047; cv=none; b=Bnu95mSrfU5DQE+UyRKdVhkDKVKw7oXX8jwoLdhDR3Pv2KXtL1txns+TaM0FGSmgWW9Q7vyYROanRPeCZihyrhGV7DvNNuExL1Q4ZgpAD3QdV+PR0AvfwPzCJxBn4eF00TMIyDLo+rrzX2tVA+iN40CSnpurJnhcSjtJwL3NoM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963047; c=relaxed/simple;
	bh=8sFVcTXi3ByRL+YA9GCrlCbF5RcNDiZ15nCeHnKWfZI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CZBfTi0x3WeQ/CovC3+k0Jc3EiGusxw6199Q4tIvoAOFwXKLxB1w+WhWFDjMn8SL0nsYQ9O/HNgYNSc/8KzGENmu9evNmBYQiIo9ZEQ6soyNlc8Jcsx0Qj2+qp9QFlFGCTQ2zDMHmrPrb+SZtgyKle9tjmlbLtayHjyzOSxYBgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uSXuEZOY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uSXuEZOY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E093F1F00A3A;
	Wed,  9 Sep 2026 14:10:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963046;
	bh=+0enUyR56MV6LntttF3JYe/g39ugaR3zqWHT4sHC8XQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uSXuEZOYgCXfaTY9+DGWnxdvxLqbzeMt8wtVsQXZyC/f8CSK1xlgM4x0kGwQmaeh0
	 +vtO0MELQVKkZ9rfyaf1SLXYfG18G+Y4fDDili9HgQSrswBvkPAkIKT5yM0xGOO75k
	 BAue7rIzl56X7YDjXPq1I5sZYhJNKknGtYGplmx4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Wang <kevinyang.wang@amd.com>,
	Kenneth Feng <kenneth.feng@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.2 501/556] drm/amdgpu: check thunderbolt before switcheroo registration
Date: Wed,  9 Sep 2026 15:43:01 +0200
Message-ID: <20260909134248.097398123@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3745,6 +3745,14 @@ static void amdgpu_device_sys_interface_
 	amdgpu_ptl_sysfs_fini(adev);
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
@@ -4194,8 +4202,7 @@ fence_driver_init:
 
 	px = amdgpu_device_supports_px(adev);
 
-	if (px || (!dev_is_removable(&adev->pdev->dev) &&
-				apple_gmux_detect(NULL, NULL)))
+	if (amdgpu_device_should_register_switcheroo(adev, px))
 		vga_switcheroo_register_client(adev->pdev,
 					       &amdgpu_switcheroo_ops, px);
 
@@ -4359,8 +4366,7 @@ void amdgpu_device_fini_sw(struct amdgpu
 
 	px = amdgpu_device_supports_px(adev);
 
-	if (px || (!dev_is_removable(&adev->pdev->dev) &&
-				apple_gmux_detect(NULL, NULL)))
+	if (amdgpu_device_should_register_switcheroo(adev, px))
 		vga_switcheroo_unregister_client(adev->pdev);
 
 	if (px)


