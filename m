Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2E8218E12;
	Sat,  3 Feb 2024 04:14:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933665; cv=none; b=nBVBsv2xeQUBs0iXYYInY5jYRhFqFZbP1OfnXCP6CeFG5Pd/EZTNdU2c2kuU6IRqbi8HIGvXt6C3aalqsjJfFc/K9tRM3b2od/77uulPCWr0v5sna7jN720foppux6zDCC2ydidBFoAXkpxiBJdbAVYImZ8jxomwXoxXdPoLOZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933665; c=relaxed/simple;
	bh=wQ7XUa0T03IEsU+lxVe7eYZZzD9lwZw92gbM+oFRuN0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KiEel55tMPLALL33h97m0NPjaG97IDY7sBGx3VWx2RbCtGMmRD/fcyhdfXsBxTV4XtWHI/a3vfqO9LcABH2A4rh1DLVqoUXwLMH1I9qKw9kCdqKqYwZYsWqWvtO4XNSk5BwTu/4QxMZO6yDHGoji8nOrcgnje2HpmpM9YbMgTkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZR/agnyO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZR/agnyO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAEB2C43394;
	Sat,  3 Feb 2024 04:14:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933664;
	bh=wQ7XUa0T03IEsU+lxVe7eYZZzD9lwZw92gbM+oFRuN0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZR/agnyONSXM0yodGNhQjx/OxZbPBLAcg/Uc9sTDumWz1BjhLbFGNaIqvjRyliPVJ
	 tBmnY9nK3KQR8Ffo0PqC9eQHrf7wVuadD3ve08NJet2y78I+QlXXPB/ytTqgQReFqi
	 iMjNtaxywX/FmHaOAihSQrJeI/rWEyBd75JghJQY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Wang <kevinyang.wang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 253/322] drm/amdgpu: fix avg vs input power reporting on smu7
Date: Fri,  2 Feb 2024 20:05:50 -0800
Message-ID: <20240203035407.330409672@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035359.041730947@linuxfoundation.org>
References: <20240203035359.041730947@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit 25852d4b97572ff62ffee574cb8bb4bc551af23a ]

Hawaii, Bonaire, Fiji, and Tonga support average power, the others
support current power.

Reviewed-by: Yang Wang <kevinyang.wang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/pm/powerplay/hwmgr/smu7_hwmgr.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu7_hwmgr.c b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu7_hwmgr.c
index b1a8799e2dee..aa91730e4eaf 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu7_hwmgr.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu7_hwmgr.c
@@ -3999,6 +3999,7 @@ static int smu7_read_sensor(struct pp_hwmgr *hwmgr, int idx,
 	uint32_t sclk, mclk, activity_percent;
 	uint32_t offset, val_vid;
 	struct smu7_hwmgr *data = (struct smu7_hwmgr *)(hwmgr->backend);
+	struct amdgpu_device *adev = hwmgr->adev;
 
 	/* size must be at least 4 bytes for all sensors */
 	if (*size < 4)
@@ -4042,7 +4043,21 @@ static int smu7_read_sensor(struct pp_hwmgr *hwmgr, int idx,
 		*size = 4;
 		return 0;
 	case AMDGPU_PP_SENSOR_GPU_INPUT_POWER:
-		return smu7_get_gpu_power(hwmgr, (uint32_t *)value);
+		if ((adev->asic_type != CHIP_HAWAII) &&
+		    (adev->asic_type != CHIP_BONAIRE) &&
+		    (adev->asic_type != CHIP_FIJI) &&
+		    (adev->asic_type != CHIP_TONGA))
+			return smu7_get_gpu_power(hwmgr, (uint32_t *)value);
+		else
+			return -EOPNOTSUPP;
+	case AMDGPU_PP_SENSOR_GPU_AVG_POWER:
+		if ((adev->asic_type != CHIP_HAWAII) &&
+		    (adev->asic_type != CHIP_BONAIRE) &&
+		    (adev->asic_type != CHIP_FIJI) &&
+		    (adev->asic_type != CHIP_TONGA))
+			return -EOPNOTSUPP;
+		else
+			return smu7_get_gpu_power(hwmgr, (uint32_t *)value);
 	case AMDGPU_PP_SENSOR_VDDGFX:
 		if ((data->vr_config & VRCONF_VDDGFX_MASK) ==
 		    (VR_SVI2_PLANE_2 << VRCONF_VDDGFX_SHIFT))
-- 
2.43.0



