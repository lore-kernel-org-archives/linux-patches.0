Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C22DE545
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:35:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF03DC433C9;
	Tue,  1 Aug 2023 09:35:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690882522;
	bh=bIVgCnN2ioOxz3PnZ9XxKb9LWhnCFtuxxJ38EvxvTkI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AhwEGHILoljiuK2QOw047VvAEicaydy+nDjOfrv1qVYx7TtHiVJvQrWe+0TcewEtC
	 8IrUZo6WeFi1GsfcYw7gqlJVQAO4YQi+LJumEbGgJT90zVRYsHQtwQWjKPvwEFIddh
	 Ijo+h9eV6jBunqkRLIcvcgcOMDfYGU2N3Uw+zkLg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 135/228] drm/amd/display: Unlock on error path in dm_handle_mst_sideband_msg_ready_event()
Date: Tue,  1 Aug 2023 11:19:53 +0200
Message-ID: <20230801091927.725708873@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091922.799813980@linuxfoundation.org>
References: <20230801091922.799813980@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 38ac4e8385ffb275b1837986ca6c16f26ea028c5 ]

This error path needs to unlock the "aconnector->handle_mst_msg_ready"
mutex before returning.

Fixes: 4f6d9e38c4d2 ("drm/amd/display: Add polling method to handle MST reply packet")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
index 05708684c9f58..d07e1053b36b3 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
@@ -677,7 +677,7 @@ void dm_handle_mst_sideband_msg_ready_event(
 
 			if (retry == 3) {
 				DRM_ERROR("Failed to ack MST event.\n");
-				return;
+				break;
 			}
 
 			drm_dp_mst_hpd_irq_send_new_request(&aconnector->mst_mgr);
-- 
2.40.1



