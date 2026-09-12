Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C98F33D9DC0;
	Sat, 12 Sep 2026 11:56:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789214187; cv=none; b=uxkK20f+cKQVLnXzIpjFOu+wRhqixBfX0QH9u+n6CZ/O1NRkVxykypmSDKhdWZR+6CgGIsLqm91h33J7plTtnJieY89KfaRm4falMRLRFggF2SPIttP72rbZU3ep1Evgpf5WsOQr5H8fLf0GQqzvGqrUb3n5zObkcEH74zWM6vI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789214187; c=relaxed/simple;
	bh=ctUWv0Ola0SwREQhgMKEpMrt2p/YhIQcM3KjL1lPn1Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hid74B7nNUGSITt6ZSkMnoaslI//tzqOOfPnZ2uIEJBeIw5Fpl01lA2qc2pnVNOWpx/ormhlmTAieMnZk5HoFIPOslcF2kyVKiOYcpatEVL9ISsRpVc+XnwVBUJDvTJao+rXH/ZX8wF8ooPVQuLjNh4Y/lbNXZKktZtuooSzlGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JJ/UFdHw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JJ/UFdHw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCA041F000FF;
	Sat, 12 Sep 2026 11:56:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789214186;
	bh=bKFpu/RqYP7g4y/s/3OGMuka1M00D5Ua14t6xQuaRkg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JJ/UFdHw+oZVrVrPCtgCZ2PJqVsAcFPV4mzxJtA04X9FSt074OB3zIAKU3YqVAvV6
	 ukqByIhbbmmF1nbGlXY1e/P9qst/pqGnCoyLNsr7MtGUrQJVcW5rhbD1dBcfkBOPVo
	 5c5eBZVQLIjaLqT9hzZuivhBjA4ngWD4hTb/7Dv4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Wang <kevinyang.wang@amd.com>,
	Kenneth Feng <kenneth.feng@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 0275/1376] drm/amdgpu: check thunderbolt before switcheroo registration
Date: Sat, 12 Sep 2026 08:45:01 +0200
Message-ID: <20260912065613.674815463@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4168,6 +4168,14 @@ static void amdgpu_device_set_mcbp(struc
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
@@ -4628,8 +4636,7 @@ fence_driver_init:
 
 	px = amdgpu_device_supports_px(ddev);
 
-	if (px || (!dev_is_removable(&adev->pdev->dev) &&
-				apple_gmux_detect(NULL, NULL)))
+	if (amdgpu_device_should_register_switcheroo(adev, px))
 		vga_switcheroo_register_client(adev->pdev,
 					       &amdgpu_switcheroo_ops, px);
 
@@ -4798,8 +4805,7 @@ void amdgpu_device_fini_sw(struct amdgpu
 
 	px = amdgpu_device_supports_px(adev_to_drm(adev));
 
-	if (px || (!dev_is_removable(&adev->pdev->dev) &&
-				apple_gmux_detect(NULL, NULL)))
+	if (amdgpu_device_should_register_switcheroo(adev, px))
 		vga_switcheroo_unregister_client(adev->pdev);
 
 	if (px)


