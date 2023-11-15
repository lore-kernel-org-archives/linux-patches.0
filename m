Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F4F73BB29
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:50:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rp9NX1GL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F7E6C433CA;
	Wed, 15 Nov 2023 19:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077814;
	bh=Fw8nhmhsS15F14HxawWmXMPn/56DiMaExwlToyiG/ek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rp9NX1GLxvt8fDfLmB2CYslH6wc1AyVBUPIxkmSQwC+zUIVn8Z9YM8q209BAGIIz5
	 XojjYh+UJg2NC0eMxiUL3moAfZLdcUwVuhTXsFfuC8n1AOcBbZkPsDygwuVTSDgLi8
	 es/M0gjp1LyaLp5GU6x4VYq7JwML2LelSE/Y+OeU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	alexey.klimov@linaro.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 535/603] drm/amdgpu: dont put MQDs in VRAM on ARM | ARM64
Date: Wed, 15 Nov 2023 14:18:00 -0500
Message-ID: <20231115191648.890222807@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
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

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit ba0fb4b48c19a2d2380fc16ca4af236a0871d279 ]

Issues were reported with commit 1cfb4d612127
("drm/amdgpu: put MQDs in VRAM") on an ADLINK Ampere
Altra Developer Platform (AVA developer platform).

Various ARM systems seem to have problems related
to PCIe and MMIO access.  In this case, I'm not sure
if this is specific to the ADLINK platform or ARM
in general.  Seems to be some coherency issue with
VRAM.  For now, just don't put MQDs in VRAM on ARM.

Link: https://lists.freedesktop.org/archives/amd-gfx/2023-October/100453.html
Fixes: 1cfb4d612127 ("drm/amdgpu: put MQDs in VRAM")
Acked-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: alexey.klimov@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c
index 2382921710ece..ef4cb921781d7 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c
@@ -384,9 +384,11 @@ int amdgpu_gfx_mqd_sw_init(struct amdgpu_device *adev,
 	struct amdgpu_ring *ring = &kiq->ring;
 	u32 domain = AMDGPU_GEM_DOMAIN_GTT;
 
+#if !defined(CONFIG_ARM) && !defined(CONFIG_ARM64)
 	/* Only enable on gfx10 and 11 for now to avoid changing behavior on older chips */
 	if (adev->ip_versions[GC_HWIP][0] >= IP_VERSION(10, 0, 0))
 		domain |= AMDGPU_GEM_DOMAIN_VRAM;
+#endif
 
 	/* create MQD for KIQ */
 	if (!adev->enable_mes_kiq && !ring->mqd_obj) {
-- 
2.42.0



