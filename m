Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31CB7335BC;
	Thu, 11 Apr 2024 10:30:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831410; cv=none; b=i+p0RuixH/mg6Bfdq/Vo88IzXE7iaHoZky8p8/KDfhTPF0pF+IIsjSANkVO759lX18SqS2jTdkpdB8BBfYWEWPOdbvqx5QIQqItiuxDMWwoKGBn9s5oO4uW2joLSWyQ18J8aA2z/AOAZ3dpbfisP5BrbteULeK06afaO8DhJHWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831410; c=relaxed/simple;
	bh=C3etJO/RO/CnZhm5nSiexI7FjQ//G0JwmXr3BDOJAeE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=as58fV7SdTbvf/DP2W0BhivZPwKBa6dCIwHS4RjOixLZxmLpd76aXeVp8ExjD6frSfaAQDbfZxS28Oaka1FR2/G1ebdLQ5qSLS+JqrUD+OfnMP48Aqc+XT/AmAzIqU+QnAaHi22fA3jnNDXGOxJVa4/Ft4NdOdcdGgnPMA0QMRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xt/xFi9Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xt/xFi9Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A9F1C433F1;
	Thu, 11 Apr 2024 10:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831409;
	bh=C3etJO/RO/CnZhm5nSiexI7FjQ//G0JwmXr3BDOJAeE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xt/xFi9Zlip2QceiuwfRVqjTzUKD86iAIYl/72Msc5jpA+TfxyJVInzXlc3WjQVH1
	 KhT8lpeXRDfKbVfKdesNIZUqNa1MBEofLo00dFilzLDRxPvxFF7p1mZeCHPSVpFMnT
	 6rxkTYXOOTpKMajLLjOChBlh7NK8AUr+fz2FhpFA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Jun <Jun.Ma2@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 114/114] Revert "drm/amd/amdgpu: Fix potential ioremap() memory leaks in amdgpu_device_init()"
Date: Thu, 11 Apr 2024 11:57:21 +0200
Message-ID: <20240411095420.332814157@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095416.853744210@linuxfoundation.org>
References: <20240411095416.853744210@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3639,10 +3639,8 @@ int amdgpu_device_init(struct amdgpu_dev
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
@@ -3652,20 +3650,20 @@ int amdgpu_device_init(struct amdgpu_dev
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
 
 	amdgpu_device_set_mcbp(adev);
 
 	/* Get rid of things like offb */
 	r = drm_aperture_remove_conflicting_pci_framebuffers(adev->pdev, &amdgpu_kms_driver);
 	if (r)
-		goto unmap_memory;
+		return r;
 
 	/* Enable TMZ based on IP_VERSION */
 	amdgpu_gmc_tmz_set(adev);
@@ -3675,7 +3673,7 @@ int amdgpu_device_init(struct amdgpu_dev
 	if (adev->gmc.xgmi.supported) {
 		r = adev->gfxhub.funcs->get_xgmi_info(adev);
 		if (r)
-			goto unmap_memory;
+			return r;
 	}
 
 	/* enable PCIE atomic ops */
@@ -3932,8 +3930,6 @@ release_ras_con:
 failed:
 	amdgpu_vf_error_trans_all(adev);
 
-unmap_memory:
-	iounmap(adev->rmmio);
 	return r;
 }
 


