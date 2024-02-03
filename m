Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34AD653E27;
	Sat,  3 Feb 2024 04:19:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933948; cv=none; b=cqSwZswusjqxM8/uRUsarpOvED2MHmixK6TLvimRWHvMjhzSqcQu7nveVVvLOprIQoY4M2Or1Nf3g68srWrVQ/Puv3Hy97/cS1wCUokMMtKkJ3oong8C08v0tKP1ZId4BNdHZoKO0CzDtVTo9kVGixqe1r6JVaHC/D8ipjFLTd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933948; c=relaxed/simple;
	bh=vtRzVSc+VLyIlivhnpsvhXpTKsL4U7he4TxJxsWWQYQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LNTKfTWwGyODRXhfR7F5pb1nDEu2aP2dgl7mQiJ05ehlrDNq1BFTTYmd0ySfD8+LkeLSHQlPZkKR49BpNFsx9OZ39ipQIo71YN9sWdokHiWB1yVEIqTIlxh5srHl6Ui0hwjdeFhJP0yEXXgI1+29xsZOjb9XbKqqOa/wdgF08KQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M3/KBfB5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M3/KBfB5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F14BBC43390;
	Sat,  3 Feb 2024 04:19:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933948;
	bh=vtRzVSc+VLyIlivhnpsvhXpTKsL4U7he4TxJxsWWQYQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M3/KBfB5ApM055wmf5XlIwdi/AP97xjnHffsuuzaajX0XvlkZu4izN7zDMQtczWsX
	 +f/PKd0zpP7ENH8fA5XXwkOQTmUcpfjFscWEbDTE+ooW2FmofGdNq63/zU7dW9wIxF
	 VcpkUEPyHh32hLhBfMLKvbKrVqE+yIywo8MW9fSY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Wang <kevinyang.wang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 281/353] drm/amdgpu: fix avg vs input power reporting on smu7
Date: Fri,  2 Feb 2024 20:06:39 -0800
Message-ID: <20240203035412.659652819@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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



