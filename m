Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10EFB1FB4F
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:47:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88113C433C7;
	Tue,  1 Aug 2023 09:47:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690883223;
	bh=OeVLk6mlwRD/ZLauaMFLG2EYUsi3afLuezd1XrFJVvs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g3D3PRy8Pfq0KtqvL1P+k589MVIn1gsPNTCdWhXfB2zDt388MiRN20zFR7DvsT9My
	 9T4nGwgp/dF7brZ82JtdJGifXRuOUK3WyEA8+P7JEFZ4MIhRT4O29ihdZu7Klwr0cV
	 HwOqPc/qH0RBtq+Tew67f0ExgvAKbQjLS4NcAgdQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 130/239] drm/amd/display: Unlock on error path in dm_handle_mst_sideband_msg_ready_event()
Date: Tue,  1 Aug 2023 11:19:54 +0200
Message-ID: <20230801091930.402791817@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091925.659598007@linuxfoundation.org>
References: <20230801091925.659598007@linuxfoundation.org>
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
index 888e80f498e97..9bc86deac9e8e 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
@@ -706,7 +706,7 @@ void dm_handle_mst_sideband_msg_ready_event(
 
 			if (retry == 3) {
 				DRM_ERROR("Failed to ack MST event.\n");
-				return;
+				break;
 			}
 
 			drm_dp_mst_hpd_irq_send_new_request(&aconnector->mst_mgr);
-- 
2.40.1



