Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 029D3C8EB;
	Wed, 23 Apr 2025 15:10:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421036; cv=none; b=C7e/L+WzBQFswde/CwaqLSDRCXMlNkH6HRAZmtCWSfTrUJMY7a/OGFudWCoDJ1e2s0hZ/2JLl/mgv4IR3oV0VlbmWiBsaMKvp5MbD/TqqkDoDI5FHHby7pyDyyjonLzy9abRDsZkgrbgqRDcP15QB3OfmMlGxSjUKV7ybu8JvjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421036; c=relaxed/simple;
	bh=SfXzHRhkN5HAuig8Rai5osMoEh9D8AB6cSj/jhFcq0Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=N/VXtxf3OLjrLhZay1ANnAN3Q9nhEFd38ia14p/R+K03OTpxRjLZUD86K/rU/TQQOGLtzWXiSSSHoGYqiJnRCfgOkYqdB5rGcPFCwInqTdGVDqL6ZrSL8SllrykcoDUUMehWUW1KuvK2VpxpJRj8rSyV4iHXIW9oaWEZEHf0zXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fcQd0bkt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fcQd0bkt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C86DC4CEE2;
	Wed, 23 Apr 2025 15:10:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421035;
	bh=SfXzHRhkN5HAuig8Rai5osMoEh9D8AB6cSj/jhFcq0Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fcQd0bktbNzSWiuxJWKP3GS52FaKXFAWwVIcFW+WPl7g1rWZTR7+laJAU8R+g1kaH
	 z4NJ4ByGVhWihS+NjRFBQoIlnc48RWBDxOQIrX+PfZP2N6RAcWfxb1wlxyNcgOmu5w
	 bZZws7RS3emvZPvR4yYnSktqQSi7ey8sRagZx+sk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	ZhenGuo Yin <zhenguo.yin@amd.com>
Subject: [PATCH 6.12 184/223] drm/amdgpu: fix warning of drm_mm_clean
Date: Wed, 23 Apr 2025 16:44:16 +0200
Message-ID: <20250423142624.665705050@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142617.120834124@linuxfoundation.org>
References: <20250423142617.120834124@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: ZhenGuo Yin <zhenguo.yin@amd.com>

commit e7afa85a0d0eba5bf2c0a446ff622ebdbc9812d6 upstream.

Kernel doorbell BOs needs to be freed before ttm_fini.

Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/4145
Fixes: 54c30d2a8def ("drm/amdgpu: create kernel doorbell pages")
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: ZhenGuo Yin <zhenguo.yin@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 39938a8ed979e398faa3791a47e282c82bcc6f04)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -3322,6 +3322,7 @@ static int amdgpu_device_ip_fini(struct
 			amdgpu_device_mem_scratch_fini(adev);
 			amdgpu_ib_pool_fini(adev);
 			amdgpu_seq64_fini(adev);
+			amdgpu_doorbell_fini(adev);
 		}
 
 		r = adev->ip_blocks[i].version->funcs->sw_fini((void *)adev);
@@ -4670,7 +4671,6 @@ void amdgpu_device_fini_sw(struct amdgpu
 
 		iounmap(adev->rmmio);
 		adev->rmmio = NULL;
-		amdgpu_doorbell_fini(adev);
 		drm_dev_exit(idx);
 	}
 


