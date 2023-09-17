Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21D3A7461
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 19:49:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88E74C433C8;
	Sun, 17 Sep 2023 19:49:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694980185;
	bh=NIJXgV6Lh/xo5etx9KL1kPX2rC34vNnt7e7MVbU6r7s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zqHef7qDO8DUP4VO0y5MGZpfDfh4WfRetTOb8cJK/EzfEFcd4BExyHq/QgT1qBzEK
	 tnNNC3HBzwrPBG/iU9/Ets45Lg1LVhX2b5uDN2o6prCnm1R/uurHMVnb7sXXMUNQvt
	 9mW9SAXCqmHnd0ilenceOyptToGF9Nl494MH5QhI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harry Wentland <harry.wentland@amd.com>,
	Rodrigo Siqueira <rodrigo.siqueira@amd.com>,
	Hamza Mahfooz <hamza.mahfooz@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 117/285] drm/amd/display: fix mode scaling (RMX_.*)
Date: Sun, 17 Sep 2023 21:11:57 +0200
Message-ID: <20230917191055.718933403@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191051.639202302@linuxfoundation.org>
References: <20230917191051.639202302@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hamza Mahfooz <hamza.mahfooz@amd.com>

[ Upstream commit ea7971af7a911a7a388b4c47db2a231a6b8dcc29 ]

As made mention of in commit 4a2df0d1f28e ("drm/amd/display: Fixed
non-native modes not lighting up"), we shouldn't call
drm_mode_set_crtcinfo() once the crtc timings have been decided. Since,
it can cause settings to be unintentionally overwritten. So, since
dm_state is never NULL now, we can use old_stream to determine if we
should call drm_mode_set_crtcinfo() because we only need to set the crtc
timing parameters for entirely new streams.

Cc: Harry Wentland <harry.wentland@amd.com>
Cc: Rodrigo Siqueira <rodrigo.siqueira@amd.com>
Fixes: bd49f19039c1 ("drm/amd/display: Always set crtcinfo from create_stream_for_sink")
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Hamza Mahfooz <hamza.mahfooz@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 3a7e7d2ce847b..e8e238865b021 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -5990,7 +5990,7 @@ create_stream_for_sink(struct amdgpu_dm_connector *aconnector,
 
 	if (recalculate_timing)
 		drm_mode_set_crtcinfo(&saved_mode, 0);
-	else
+	else if (!old_stream)
 		drm_mode_set_crtcinfo(&mode, 0);
 
 	/*
-- 
2.40.1



