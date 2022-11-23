Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6A741C31
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:52:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46EACC433D6;
	Wed, 23 Nov 2022 09:52:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669197162;
	bh=WO33uot3OR3TvqZxOp92NKrN7EgmYPBU7TzJwPjhVyk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h8wE1mMDLABN9rXm7A8aC3yrqZcOnNWmvyo+rNsiMnOKl8wnEheh2TcfKyJ07A+zg
	 fLRW7f21lWNWaASg+joa94RPHPhfHukqkRmRu8QNhy7JULlIGRMGXLMzxlRJRxYWk+
	 7btc5yv+d5XMfa9FQ/8TNgPrfZFcMC0lE2cRj+bU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wayne Lin <Wayne.Lin@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Stylon Wang <stylon.wang@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.0 216/314] drm/amd/display: Fix access timeout to DPIA AUX at boot time
Date: Wed, 23 Nov 2022 09:51:01 +0100
Message-Id: <20221123084635.331988949@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Stylon Wang <stylon.wang@amd.com>

commit 0d502ef8898b3983eef9e40f50dfe100a0de5d93 upstream.

[Why]
Since introduction of patch "Query DPIA HPD status.", link detection at
boot could be accessing DPIA AUX, which will not succeed until
DMUB outbox messaging is enabled and results in below dmesg logs:

[  160.840227] [drm:amdgpu_dm_process_dmub_aux_transfer_sync [amdgpu]] *ERROR* wait_for_completion_timeout timeout!

[How]
Enable DMUB outbox messaging before link detection at boot time.

Reviewed-by: Wayne Lin <Wayne.Lin@amd.com>
Acked-by: Tom Chung <chiahsuan.chung@amd.com>
Signed-off-by: Stylon Wang <stylon.wang@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.0.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -1645,12 +1645,6 @@ static int amdgpu_dm_init(struct amdgpu_
 		}
 	}
 
-	if (amdgpu_dm_initialize_drm_device(adev)) {
-		DRM_ERROR(
-		"amdgpu: failed to initialize sw for display support.\n");
-		goto error;
-	}
-
 	/* Enable outbox notification only after IRQ handlers are registered and DMUB is alive.
 	 * It is expected that DMUB will resend any pending notifications at this point, for
 	 * example HPD from DPIA.
@@ -1658,6 +1652,12 @@ static int amdgpu_dm_init(struct amdgpu_
 	if (dc_is_dmub_outbox_supported(adev->dm.dc))
 		dc_enable_dmub_outbox(adev->dm.dc);
 
+	if (amdgpu_dm_initialize_drm_device(adev)) {
+		DRM_ERROR(
+		"amdgpu: failed to initialize sw for display support.\n");
+		goto error;
+	}
+
 	/* create fake encoders for MST */
 	dm_dp_create_fake_mst_encoders(adev);
 


