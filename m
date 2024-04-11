Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8ADD64CC0;
	Thu, 11 Apr 2024 10:49:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712832560; cv=none; b=i2bivIWf6I9Gbsno0TFlBC1xvlxOymbGIqH0trdVw3BS5HUx35PfDNLJ1ddokUAkRKQKVuvKGfI9cQKSTp9WS4WMMpn8mRRMj/L93aNDk5hvoWZu2M0f+lzraK2W/vfHylN6oXqJgPQ2/V1iQnHsQoL3JnfRSO/ZjXpcXXvniJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712832560; c=relaxed/simple;
	bh=L0QbgUthqT7Ogv259kdxngin8i8d4SZMDSfaWE4tD3o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aFyOHDjaaA+JBIHY7H6bahrNXPFqd4kFgPNXkn9BN0/UqTUvFjH3SuofU48x/Isic8bEpteJgqfRG9njMvYzFMhEx2/Pd+NcSIP0SGYxnuorsTh7csEEG65J5TS2KGoWOFEHUvUJH51l6+DyoNHrddAWfrAetY46p7FTz2e30hs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MCKXOkHn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MCKXOkHn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BA05C433F1;
	Thu, 11 Apr 2024 10:49:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712832560;
	bh=L0QbgUthqT7Ogv259kdxngin8i8d4SZMDSfaWE4tD3o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MCKXOkHn+6eXJ63SaRX88mQQ8zPNT1p76ni8Y4Xw99Z8f+0xt5s7ePnYt3r557Sq2
	 /B+Q3UpWRrlfloStap73MTvF9vqF8w7H6J65dbycRryUE+kSPSReK74nRlwwSdhEAy
	 gywnN0MoMXjhogeXItxp1iqjLr/rUvmyHHal1h2c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Jun <Jun.Ma2@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 83/83] Revert "drm/amd/amdgpu: Fix potential ioremap() memory leaks in amdgpu_device_init()"
Date: Thu, 11 Apr 2024 11:57:55 +0200
Message-ID: <20240411095415.186692656@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095412.671665933@linuxfoundation.org>
References: <20240411095412.671665933@linuxfoundation.org>
User-Agent: quilt/0.67
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

commit 03c6284df179de3a4a6e0684764b1c71d2a405e2 upstream.

This patch causes the following iounmap erorr and calltrace
iounmap: bad address 00000000d0b3631f

The original patch was unjustified because amdgpu_device_fini_sw() will
always cleanup the rmmio mapping.

This reverts commit eb4f139888f636614dab3bcce97ff61cefc4b3a7.

Signed-off-by: Ma Jun <Jun.Ma2@amd.com>
Suggested-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c |   16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -3713,10 +3713,8 @@ int amdgpu_device_init(struct amdgpu_dev
 	 * early on during init and before calling to RREG32.
 	 */
 	adev->reset_domain = amdgpu_reset_create_reset_domain(SINGLE_DEVICE, "amdgpu-reset-dev");
-	if (!adev->reset_domain) {
-		r = -ENOMEM;
-		goto unmap_memory;
-	}
+	if (!adev->reset_domain)
+		return -ENOMEM;
 
 	/* detect hw virtualization here */
 	amdgpu_detect_virtualization(adev);
@@ -3724,18 +3722,18 @@ int amdgpu_device_init(struct amdgpu_dev
 	r = amdgpu_device_get_job_timeout_settings(adev);
 	if (r) {
 		dev_err(adev->dev, "invalid lockup_timeout parameter syntax\n");
-		goto unmap_memory;
+		return r;
 	}
 
 	/* early init functions */
 	r = amdgpu_device_ip_early_init(adev);
 	if (r)
-		goto unmap_memory;
+		return r;
 
 	/* Get rid of things like offb */
 	r = drm_aperture_remove_conflicting_pci_framebuffers(adev->pdev, &amdgpu_kms_driver);
 	if (r)
-		goto unmap_memory;
+		return r;
 
 	/* Enable TMZ based on IP_VERSION */
 	amdgpu_gmc_tmz_set(adev);
@@ -3745,7 +3743,7 @@ int amdgpu_device_init(struct amdgpu_dev
 	if (adev->gmc.xgmi.supported) {
 		r = adev->gfxhub.funcs->get_xgmi_info(adev);
 		if (r)
-			goto unmap_memory;
+			return r;
 	}
 
 	/* enable PCIE atomic ops */
@@ -4001,8 +3999,6 @@ release_ras_con:
 failed:
 	amdgpu_vf_error_trans_all(adev);
 
-unmap_memory:
-	iounmap(adev->rmmio);
 	return r;
 }
 


