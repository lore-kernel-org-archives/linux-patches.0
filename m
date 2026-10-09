Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3557B39FCCD;
	Fri,  9 Oct 2026 14:26:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555970; cv=none; b=tj9xZ4eYuAaXshrZ60X4pGUXnqNvyJiAxvU4lWV/z6E1YpqY7kWiAGoH/6xZMTssZSurjxwHWmsnAwElImmSWbbWByHA6pPKdh+8XeRlRwvgEp/yQ1GClQpubb4KJGS0tPUi4yJ8fJ5rSzAFBBcsP5cDuLxTdfAwLkLzUDtu8gM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555970; c=relaxed/simple;
	bh=FkAvUFffaXZMd0QatHgTegGMHaCnPAsLtfwzQSJGI+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hZH2+OdyCJzAZCSeYyi8YJvVAzXnshckye7XlJZ6P1P3Nrbhp5DDk2eRN9Q+zTXNluerOr4BV3UZYG9Bqs5KPY0GnFDGhBMWKwDQoveGGqjjk5epNj+90xbQXfzWbCqqRE0GQsCwVf02sA9VIWBK2+mf4yMAjYrvBWN5/7Wc/hc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oqspUkJ7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oqspUkJ7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88A561F000FF;
	Fri,  9 Oct 2026 14:26:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555969;
	bh=olurqszRDd5x4XBJ2MQB8qs2mU8HZHE9PUu/R/3IH2g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oqspUkJ7k33WI9AGGRMPFLsY3Hf4fgL3Rp7LbJCLX1Q+UUFYbXPZI3Dded/vGroN4
	 VE58bKTRetjEB1cntaMCcI0nQ1pXz2jLotbeT4DSmDeWFUzG/AGabhVZuYDzvgUrbW
	 ZdxlIkNXyRduXBLTWZwXAodOP31iKx+Rha5L7x/U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Theo Andersen Carton <andersen.theo@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 147/403] drm/amdgpu: skip the noirq suspend reset for a switcheroo-parked GPU
Date: Fri,  9 Oct 2026 16:08:28 +0200
Message-ID: <20261009140955.510231396@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

From: Theo Andersen Carton <andersen.theo@gmail.com>

commit eadb85cca111152bd334b861fb53747ab851d13a upstream.

amdgpu_pmops_suspend_noirq() resets the ASIC unconditionally. When the GPU
has been parked by vga_switcheroo it has neither power nor a PCIe link, so
the reset cannot reach it: pci_set_power_state() reports the device as
inaccessible and amdgpu_asic_reset() returns -EINVAL. A failure there
aborts the entire noirq suspend phase, and with it the system suspend, so
the machine cannot sleep at all while the GPU is switched off.

amdgpu_device_prepare(), amdgpu_device_suspend() and amdgpu_device_resume()
all bail out early on DRM_SWITCH_POWER_OFF. This callback was added later,
for an unrelated reason, and did not inherit the check. nouveau guards
every one of its PM callbacks the same way.

Bail out the same way here. On a single-GPU system switch_power_state is
never DRM_SWITCH_POWER_OFF, so this is a no-op there.

Found on a MacBookPro11,5, where the Radeon is powered down through
apple-gmux so that the internal panel can be driven by the iGPU instead.
Every suspend failed in amdgpu_pmops_suspend_noirq() while the card was
off; with this check a full S3 cycle completes.

Fixes: 9e051720f9d3 ("drm/amdgpu: Ensure HDA function is suspended before ASIC reset")
Signed-off-by: Theo Andersen Carton <andersen.theo@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 539d0558638a6dcc066f1cf592b6b9a52adc8ea4)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
@@ -2643,6 +2643,14 @@ static int amdgpu_pmops_suspend_noirq(st
 	struct amdgpu_device *adev = drm_to_adev(drm_dev);
 	int r;
 
+	/*
+	 * A GPU parked by vga_switcheroo has no power and no PCIe link, so the
+	 * ASIC reset below would fail and abort the whole noirq suspend phase.
+	 * Bail out like amdgpu_device_prepare/suspend/resume() already do.
+	 */
+	if (drm_dev->switch_power_state == DRM_SWITCH_POWER_OFF)
+		return 0;
+
 	if (amdgpu_acpi_should_gpu_reset(adev)) {
 		amdgpu_device_lock_reset_domain(adev->reset_domain);
 		r = amdgpu_asic_reset(adev);


