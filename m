Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85D143176E4;
	Wed,  8 Apr 2026 18:58:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674713; cv=none; b=QR1ZrMrZRbt8pVfn974Uu2TYpoIfMTq7NWc40WnRfRVFk7+igzSc4TQ+MqpLdsbwngRrRrHppTMqlXS6o2VoIe1X00kYYO4AY5Nl9RIjrxsvwyxMJfBcpyQksX9i/HmkpwINsK6+u2UhRkqjB+OAxXtxvRODyxaLylPIrn1/HSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674713; c=relaxed/simple;
	bh=dGTm/AzTADo84Tn93kT4eXRD8xN90m7PZDU8RZHgEws=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n/VJmNKZCORaPSxOg0HvUBtwoToC5dYt4aKDLlpN6uooFQvmsmBLcTt21mVmPxDbk/ekS5X9uLk4+JkApkn2G+FmcWKq/+gBei1Ub8+4YwU9tx8qKW2aoFQ3RiL6JbnGrifeJSB0VVxT2VrvhYnsB+LskP/GwgG+dprjNULvD14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iZfeS+Ei; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iZfeS+Ei"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 197B2C19421;
	Wed,  8 Apr 2026 18:58:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674713;
	bh=dGTm/AzTADo84Tn93kT4eXRD8xN90m7PZDU8RZHgEws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iZfeS+EiHzy0KsaySN0EkJkVKe8fB0YvW4FtJe82BhqFzBm2p7ShQo5qVoo2+uQGw
	 D23yRgEyyh0X5VEZy2fmAWLVTO8De7H5sAXZrBnlbGjtZZDo1WewUmxuEb1jGQxHwI
	 VblZndGzfIbNsUB71MgJDXelcJ687uzKyzxDdVEU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.19 203/311] drm/amdgpu: Fix wait after reset sequence in S4
Date: Wed,  8 Apr 2026 20:03:23 +0200
Message-ID: <20260408175946.989919430@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175939.393281918@linuxfoundation.org>
References: <20260408175939.393281918@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lijo Lazar <lijo.lazar@amd.com>

commit daf470b8882b6f7f53cbfe9ec2b93a1b21528cdc upstream.

For a mode-1 reset done at the end of S4 on PSPv11 dGPUs, only check if
TOS is unloaded.

Fixes: 32f73741d6ee ("drm/amdgpu: Wait for bootloader after PSPv11 reset")
Closes: https://gitlab.freedesktop.org/drm/amd/-/work_items/4853
Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 2fb4883b884a437d760bd7bdf7695a7e5a60bba3)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c |    8 ++++++--
 drivers/gpu/drm/amd/amdgpu/psp_v11_0.c  |    3 ++-
 2 files changed, 8 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
@@ -2703,8 +2703,12 @@ static int amdgpu_pmops_freeze(struct de
 	if (r)
 		return r;
 
-	if (amdgpu_acpi_should_gpu_reset(adev))
-		return amdgpu_asic_reset(adev);
+	if (amdgpu_acpi_should_gpu_reset(adev)) {
+		amdgpu_device_lock_reset_domain(adev->reset_domain);
+		r = amdgpu_asic_reset(adev);
+		amdgpu_device_unlock_reset_domain(adev->reset_domain);
+		return r;
+	}
 	return 0;
 }
 
--- a/drivers/gpu/drm/amd/amdgpu/psp_v11_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/psp_v11_0.c
@@ -170,7 +170,8 @@ static int psp_v11_0_wait_for_bootloader
 	int retry_loop;
 
 	/* For a reset done at the end of S3, only wait for TOS to be unloaded */
-	if (adev->in_s3 && !(adev->flags & AMD_IS_APU) && amdgpu_in_reset(adev))
+	if ((adev->in_s4 || adev->in_s3) && !(adev->flags & AMD_IS_APU) &&
+	    amdgpu_in_reset(adev))
 		return psp_v11_wait_for_tos_unload(psp);
 
 	for (retry_loop = 0; retry_loop < 20; retry_loop++) {


