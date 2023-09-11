Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22E1E1170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:04:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97C9EC433C8;
	Mon, 11 Sep 2023 14:04:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694441055;
	bh=wRFbGldoI7dEyyx7ufemGmTDgiPpEb9wP6h+BjaSwD8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lO+ztU/SCSbqAUTr0Qn5xuk7zHWnMj1ddC9vWev7nX4w7uWnzauhhhyM/E+1CC6ak
	 xNtPaCpWmaM6NPV1xRU6FYnR8Aprsr9sGrrK3jP/fN18YAo5vcT6L5BUkBhXY91TWc
	 6INi7H4PX/YJCp1OkKpaucDml0H0uroBVDcOCaX4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 279/739] drm/amdgpu: Update min() to min_t() in amdgpu_info_ioctl
Date: Mon, 11 Sep 2023 15:41:18 +0200
Message-ID: <20230911134658.917298191@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>

[ Upstream commit a0cc8e1512ad72c9f97cdcb76d42715730adaf62 ]

Fixes the following:

WARNING: min() should probably be min_t(size_t, size, sizeof(ip))
+               ret = copy_to_user(out, &ip, min((size_t)size, sizeof(ip)));

And other style fixes:

WARNING: Prefer 'unsigned int' to bare use of 'unsigned'
WARNING: Missing a blank line after declarations

Cc: Christian König <christian.koenig@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c
index 12414a7132564..d4ca19ba5a289 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c
@@ -557,6 +557,7 @@ int amdgpu_info_ioctl(struct drm_device *dev, void *data, struct drm_file *filp)
 			crtc = (struct drm_crtc *)minfo->crtcs[i];
 			if (crtc && crtc->base.id == info->mode_crtc.id) {
 				struct amdgpu_crtc *amdgpu_crtc = to_amdgpu_crtc(crtc);
+
 				ui32 = amdgpu_crtc->crtc_id;
 				found = 1;
 				break;
@@ -575,7 +576,7 @@ int amdgpu_info_ioctl(struct drm_device *dev, void *data, struct drm_file *filp)
 		if (ret)
 			return ret;
 
-		ret = copy_to_user(out, &ip, min((size_t)size, sizeof(ip)));
+		ret = copy_to_user(out, &ip, min_t(size_t, size, sizeof(ip)));
 		return ret ? -EFAULT : 0;
 	}
 	case AMDGPU_INFO_HW_IP_COUNT: {
@@ -721,17 +722,18 @@ int amdgpu_info_ioctl(struct drm_device *dev, void *data, struct drm_file *filp)
 				    ? -EFAULT : 0;
 	}
 	case AMDGPU_INFO_READ_MMR_REG: {
-		unsigned n, alloc_size;
+		unsigned int n, alloc_size;
 		uint32_t *regs;
-		unsigned se_num = (info->read_mmr_reg.instance >>
+		unsigned int se_num = (info->read_mmr_reg.instance >>
 				   AMDGPU_INFO_MMR_SE_INDEX_SHIFT) &
 				  AMDGPU_INFO_MMR_SE_INDEX_MASK;
-		unsigned sh_num = (info->read_mmr_reg.instance >>
+		unsigned int sh_num = (info->read_mmr_reg.instance >>
 				   AMDGPU_INFO_MMR_SH_INDEX_SHIFT) &
 				  AMDGPU_INFO_MMR_SH_INDEX_MASK;
 
 		/* set full masks if the userspace set all bits
-		 * in the bitfields */
+		 * in the bitfields
+		 */
 		if (se_num == AMDGPU_INFO_MMR_SE_INDEX_MASK)
 			se_num = 0xffffffff;
 		else if (se_num >= AMDGPU_GFX_MAX_SE)
@@ -896,7 +898,7 @@ int amdgpu_info_ioctl(struct drm_device *dev, void *data, struct drm_file *filp)
 		return ret;
 	}
 	case AMDGPU_INFO_VCE_CLOCK_TABLE: {
-		unsigned i;
+		unsigned int i;
 		struct drm_amdgpu_info_vce_clock_table vce_clk_table = {};
 		struct amd_vce_state *vce_state;
 
-- 
2.40.1



