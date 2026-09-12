Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FE113750C9;
	Sat, 12 Sep 2026 15:57:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789228639; cv=none; b=Q9ktwW1MStRnmhNazzPLDMxgIIw1O/382izZLUYZ6hY+xPZCleWkO2QZtMEoytgyr10Lu7AOyu/Tqm35IncXJtkFvxqLU6PsDltOYb0ksAyuKrUNxC71cAXybtU5EHzvx1NbJFF7pMEaZVgbkX494fwKkjjNY16HC5/Ke016lx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789228639; c=relaxed/simple;
	bh=SOC4d/2D1kha4YV13F3EWUmdAQNgkOc8yersi5wp/HA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bNmTX3mXqDpQNZ6fxOtW+G73ScHXW5xYRRKPd0trwQ3hxnkpHRIImnnQL9La1nYdHFGD+zVu/KBDmLpzizrrUwg0CdVeCcHXJltCaJ2fA7j2rPh0eux14GoX2ezbaLgEw65D5I8rs6RyTL6MeT2rgLCjW6cxEAsovvAN9fzm8f0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wpTOfI0k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wpTOfI0k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39BC91F000FF;
	Sat, 12 Sep 2026 15:57:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789228638;
	bh=bL/RTI6IwCpwE4gg3dc6jDsEBXIhDa2wK/lora1OLbw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wpTOfI0kivSKIW0RNnT2A0Bf+UrVd7u0Iyni6ApCxvC3uuBORcM+MZiYVPYqibWV3
	 QGeRkJjCqEdXRzLAcscpnNWhBuVVrDzZ3as9AySZBASjgThMxHScTLLzmzljFTUgWj
	 fSegz6KsUZnW8qdMVarobIADABH0SV7lIYQ5jawQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Wang <kevinyang.wang@amd.com>,
	Kenneth Feng <kenneth.feng@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 0427/1191] drm/amdgpu: check thunderbolt before switcheroo registration
Date: Sat, 12 Sep 2026 08:52:35 +0200
Message-ID: <20260912065557.827664020@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3628,6 +3628,14 @@ static const struct attribute *amdgpu_de
 	NULL
 };
 
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
@@ -4040,8 +4048,7 @@ fence_driver_init:
 
 	px = amdgpu_device_supports_px(ddev);
 
-	if (px || (!dev_is_removable(&adev->pdev->dev) &&
-				apple_gmux_detect(NULL, NULL)))
+	if (amdgpu_device_should_register_switcheroo(adev, px))
 		vga_switcheroo_register_client(adev->pdev,
 					       &amdgpu_switcheroo_ops, px);
 
@@ -4196,8 +4203,7 @@ void amdgpu_device_fini_sw(struct amdgpu
 
 	px = amdgpu_device_supports_px(adev_to_drm(adev));
 
-	if (px || (!dev_is_removable(&adev->pdev->dev) &&
-				apple_gmux_detect(NULL, NULL)))
+	if (amdgpu_device_should_register_switcheroo(adev, px))
 		vga_switcheroo_unregister_client(adev->pdev);
 
 	if (px)


