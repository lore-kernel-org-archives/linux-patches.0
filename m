Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3F6B43DA3C;
	Thu, 30 Jul 2026 14:37:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422251; cv=none; b=WxLL/Vp3Hma6FuoUPE2cr1FEwBLp8yhHfn8q+gj9VRtyVPA1Mo5X1hQCFNnFH0KE2KhLceqaDWZiAR/Cg8JONxh//jMgiDe4hiI5grXpkSDJq3+3M90GYA9L9sO9L2EG2heGhQOrEIYZCZL9uo65SizAz6Xie1UJ7senr6rjnc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422251; c=relaxed/simple;
	bh=EI/GDENuvlMubXZt6QXYARUFm2DPBZux3ywGuDX0BLc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mPD76ezflanTDsDJHEAmjygGfxGH/gpokYe++tioHitMFnUda/e6k1JqcgcVMBsgUx6KDwlmS1FcVMF3ts/XlNDuzNJH2N1ziB7VrlWdU+mJFM1W1fR3FsTrjtFfIDRciABPP9k/lKUX+sruYjQcQxe8O1yhfh/TyAMtQSY8OMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oXttNagg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oXttNagg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BC0B1F000E9;
	Thu, 30 Jul 2026 14:37:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422250;
	bh=UwAK5+P35P7t3Qywv6VmwbWHPSP6JLg0o/UKTmMhvqs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oXttNaggaRnSIsp2riHCnswj17Es7j/H7ZE+xAy1UfnIVpxDNzDCbayDzr+xVa9i/
	 ZCqX616DTHhDi3ppNSvp7oedNsR07VKt+GimfMPLMnnHWaWpf5Z5CEaPuKeyUOIGjc
	 YzbSzG+nDXNxywjOWQPYDpjwjk7JubXGpwqozcGQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.1 376/744] drm/amdgpu/uvd: Place VCPU BO only in VRAM for UVD 4.x and older
Date: Thu, 30 Jul 2026 16:10:49 +0200
Message-ID: <20260730141452.278363580@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
User-Agent: quilt/0.69
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Timur Kristóf <timur.kristof@gmail.com>

commit 8002b744ad70055ef11ff7d0a7d685bfe8ffe6e4 upstream.

These UVD versions don't fully support GPUVM and are only
validated to work when their VCPU BO is placed in VRAM.

Signed-off-by: Timur Kristóf <timur.kristof@gmail.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 01b8dfc0660db5d6cdd62c22dc20f774a26ce853)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_uvd.c |   17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_uvd.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_uvd.c
@@ -188,6 +188,7 @@ int amdgpu_uvd_sw_init(struct amdgpu_dev
 	const struct common_firmware_header *hdr;
 	unsigned int family_id;
 	int i, j, r;
+	u32 vcpu_bo_domain;
 
 	INIT_DELAYED_WORK(&adev->uvd.idle_work, amdgpu_uvd_idle_work_handler);
 
@@ -319,12 +320,20 @@ int amdgpu_uvd_sw_init(struct amdgpu_dev
 	if (adev->firmware.load_type != AMDGPU_FW_LOAD_PSP)
 		bo_size += AMDGPU_GPU_PAGE_ALIGN(le32_to_cpu(hdr->ucode_size_bytes) + 8);
 
+	/* UVD 5.0 and newer HW can use 64 bit addressing. */
+	adev->uvd.address_64_bit =
+		!amdgpu_device_ip_block_version_cmp(adev, AMD_IP_BLOCK_TYPE_UVD, 5, 0);
+
+	vcpu_bo_domain = AMDGPU_GEM_DOMAIN_VRAM;
+	if (adev->uvd.address_64_bit)
+		vcpu_bo_domain |= AMDGPU_GEM_DOMAIN_GTT;
+
 	for (j = 0; j < adev->uvd.num_uvd_inst; j++) {
 		if (adev->uvd.harvest_config & (1 << j))
 			continue;
+
 		r = amdgpu_bo_create_kernel(adev, bo_size, PAGE_SIZE,
-					    AMDGPU_GEM_DOMAIN_VRAM |
-					    AMDGPU_GEM_DOMAIN_GTT,
+					    vcpu_bo_domain,
 					    &adev->uvd.inst[j].vcpu_bo,
 					    &adev->uvd.inst[j].gpu_addr,
 					    &adev->uvd.inst[j].cpu_addr);
@@ -339,10 +348,6 @@ int amdgpu_uvd_sw_init(struct amdgpu_dev
 		adev->uvd.filp[i] = NULL;
 	}
 
-	/* from uvd v5.0 HW addressing capacity increased to 64 bits */
-	if (!amdgpu_device_ip_block_version_cmp(adev, AMD_IP_BLOCK_TYPE_UVD, 5, 0))
-		adev->uvd.address_64_bit = true;
-
 	r = amdgpu_uvd_create_msg_bo_helper(adev, 128 << 10, &adev->uvd.ib_bo);
 	if (r)
 		return r;


