Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F423B3B19DE;
	Fri,  9 Oct 2026 14:34:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556487; cv=none; b=KDm1F6+jV4JudqEal1WxhJTF/CJDJxn0nHCqme8OIig662zJQ+nkWhR/9NjmBtm17BzXjD0pi0mAbZfHIwEt+TQFiXSHPJBu6IYzvliFEfEI2sM6tHvU1HYo3JMam4RC0OPAd5BsyPzKX1nZpntZ8tkeTR/Z6jZps0I2m7RsI/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556487; c=relaxed/simple;
	bh=Dn6OCAhOBnBXoxMjKh7y60Hb0mQ/WvjSLg2G3cUoCUg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cgoNIKAVy6vyYtLxqx4JISKoD0cUfW9snnHrxTfdJ36uJAafVE3fVLE/xPHWEmf8lqaSVcPtkRrIy+GNmMFUYlfG5wI/czBUp9EL1OA4FeeLihqcCP4RLcJB6tBBGk5XJRK5lr64g9rtOH0yN+cca/eKNOoD5ZD+T4NrrgL0x9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lO7SIMHj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lO7SIMHj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 174921F0089A;
	Fri,  9 Oct 2026 14:34:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556485;
	bh=XYqWCSPDSPoWO9phEFiMX49OSajHAORj2Mspmklb+nM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lO7SIMHj9iAyWPArx0aRmUFFK9zvkk+i7/obDZNKCacRD2utlVYfcNdkP61VVKHU5
	 mr7ywAzBMbfwZIVkm/BUjpov2ZIz5VjmAMmqZ/Kb4x+jQxKbYUtwyfomgWFP91rznt
	 nx6T6oz/8lu24lGUQEvg7O78j2Bnc1MTBH5BImQM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Theo Andersen Carton <andersen.theo@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.2 189/428] drm/amdgpu: skip the noirq suspend reset for a switcheroo-parked GPU
Date: Fri,  9 Oct 2026 16:08:46 +0200
Message-ID: <20261009140950.293033898@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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
@@ -2653,6 +2653,14 @@ static int amdgpu_pmops_suspend_noirq(st
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


