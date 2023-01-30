Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF6B928EB
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 14:13:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C5D2C433D2;
	Mon, 30 Jan 2023 14:13:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675087989;
	bh=rk0jz7qaU8yzDod79Bcnm5n/Qf72E3j6ztNf1smrrsQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TRtBPiFt7298Fj+8G7S8c0zDJMaqDyzXtnEFsOLkL++M9+8CS3nlJlUAXab3Synq9
	 Khuv/06yttvDppebfXJ9/ZMpvisqPBtEvYrIGyjvtakQpY6ewNEhMo6dGocGriXJJW
	 o30+l4c4w3awKji6i9IIxJIqeTplu0cp0uRoCWCc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Hamza Mahfooz <hamza.mahfooz@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 078/204] drm/amd/display: fix issues with driver unload
Date: Mon, 30 Jan 2023 14:50:43 +0100
Message-Id: <20230130134319.759028119@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134316.327556078@linuxfoundation.org>
References: <20230130134316.327556078@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Hamza Mahfooz <hamza.mahfooz@amd.com>

[ Upstream commit e433adc60f7f847e734c56246b09291532f29b6d ]

Currently, we run into a number of WARN()s when attempting to unload the
amdgpu driver (e.g. using "modprobe -r amdgpu"). These all stem from
calling drm_encoder_cleanup() too early. So, to fix this we can stop
calling drm_encoder_cleanup() from amdgpu_dm_fini() and instead have it
be called from amdgpu_dm_encoder_destroy(). Also, we don't need to free
in amdgpu_dm_encoder_destroy() since mst_encoders[] isn't explicitly
allocated by the slab allocator.

Fixes: f74367e492ba ("drm/amdgpu/display: create fake mst encoders ahead of time (v4)")
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Hamza Mahfooz <hamza.mahfooz@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c           | 4 ----
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c | 1 -
 2 files changed, 5 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 409739ee5ba0..a2d9e0af0654 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -1688,10 +1688,6 @@ static void amdgpu_dm_fini(struct amdgpu_device *adev)
 	}
 #endif
 
-	for (i = 0; i < adev->dm.display_indexes_num; i++) {
-		drm_encoder_cleanup(&adev->dm.mst_encoders[i].base);
-	}
-
 	amdgpu_dm_destroy_drm_device(&adev->dm);
 
 #if defined(CONFIG_DRM_AMD_SECURE_DISPLAY)
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
index 652cf108b3c2..bc02e3e0d17d 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
@@ -385,7 +385,6 @@ static const struct drm_connector_helper_funcs dm_dp_mst_connector_helper_funcs
 static void amdgpu_dm_encoder_destroy(struct drm_encoder *encoder)
 {
 	drm_encoder_cleanup(encoder);
-	kfree(encoder);
 }
 
 static const struct drm_encoder_funcs amdgpu_dm_encoder_funcs = {
-- 
2.39.0



