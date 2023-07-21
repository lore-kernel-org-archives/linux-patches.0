Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E9441F942
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 16:22:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93308C433C7;
	Fri, 21 Jul 2023 16:22:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689956547;
	bh=LwRs8AFU2Xx/hkiVI4zf6py5TkAkmN94tUS8xHPXBJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vf8jn+iK49wLFCtlH17OFKfTLo3qWk0JSjJvOTsVlTqu9Mh8ikP2tPV03BWD3rFKE
	 Q6Xmg/I7bEajHJc3tIav0ElKHmgwYj5E2dSUBl4KAQbBw/0T86dM8emVs5fMvBteoJ
	 7xBMDIqlCXN36JlJ/VOhEstUR5XuoiSNtt1kbEpw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Wayne Lin <Wayne.Lin@amd.com>,
	Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
	Alan Liu <HaoPing.Liu@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.4 198/292] drm/amd/display: Fix in secure display context creation
Date: Fri, 21 Jul 2023 18:05:07 +0200
Message-ID: <20230721160537.393333494@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160528.800311148@linuxfoundation.org>
References: <20230721160528.800311148@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alan Liu <HaoPing.Liu@amd.com>

commit f477c7b5ec3e4ef87606671b340abf3bdb0cccff upstream.

[Why & How]
We need to store CRTC information in secure_display_ctx, so postpone
the call to amdgpu_dm_crtc_secure_display_create_contexts() until we
initialize all CRTCs.

Cc: stable@vger.kernel.org
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Reviewed-by: Wayne Lin <Wayne.Lin@amd.com>
Acked-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Alan Liu <HaoPing.Liu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c     |   11 +++++------
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crc.h |    2 +-
 2 files changed, 6 insertions(+), 7 deletions(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -1776,12 +1776,6 @@ static int amdgpu_dm_init(struct amdgpu_
 
 		dc_init_callbacks(adev->dm.dc, &init_params);
 	}
-#if defined(CONFIG_DRM_AMD_SECURE_DISPLAY)
-	adev->dm.secure_display_ctxs = amdgpu_dm_crtc_secure_display_create_contexts(adev);
-	if (!adev->dm.secure_display_ctxs) {
-		DRM_ERROR("amdgpu: failed to initialize secure_display_ctxs.\n");
-	}
-#endif
 	if (dc_is_dmub_outbox_supported(adev->dm.dc)) {
 		init_completion(&adev->dm.dmub_aux_transfer_done);
 		adev->dm.dmub_notify = kzalloc(sizeof(struct dmub_notification), GFP_KERNEL);
@@ -1840,6 +1834,11 @@ static int amdgpu_dm_init(struct amdgpu_
 		goto error;
 	}
 
+#if defined(CONFIG_DRM_AMD_SECURE_DISPLAY)
+	adev->dm.secure_display_ctxs = amdgpu_dm_crtc_secure_display_create_contexts(adev);
+	if (!adev->dm.secure_display_ctxs)
+		DRM_ERROR("amdgpu: failed to initialize secure display contexts.\n");
+#endif
 
 	DRM_DEBUG_DRIVER("KMS initialized.\n");
 
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crc.h
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crc.h
@@ -100,7 +100,7 @@ struct secure_display_context *amdgpu_dm
 #else
 #define amdgpu_dm_crc_window_is_activated(x)
 #define amdgpu_dm_crtc_handle_crc_window_irq(x)
-#define amdgpu_dm_crtc_secure_display_create_contexts()
+#define amdgpu_dm_crtc_secure_display_create_contexts(x)
 #endif
 
 #endif /* AMD_DAL_DEV_AMDGPU_DM_AMDGPU_DM_CRC_H_ */


