Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75062197538;
	Thu,  6 Jun 2024 14:12:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683161; cv=none; b=a1z6C1AVGqJCMwvsbn5SELGxMd4iWuM/w+15mI2E8pTd0qmTuWTq8sC/s0WNJZvSuFZNATKgZRdBwM0NIazIRWI+P6PkuEKXWxgkmy2eVq1t3/2nuDe83scwe3oWTxvyCgVsTuhra+AWL2scyVLSpGyTmu4ILkqJWYkPLkTuSJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683161; c=relaxed/simple;
	bh=AYvZIzyQ++ggfuHP8WVHSGwXjeuNxmdTHzVUpL+g1t0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V6E8r1jPmuacehAaxeim4vaDz8mb0rZlzQLW1BKkwvzOy44VaBpln6U2lsBdQa8Au4mtFq7frE4Ddx4ofCmski7BEWhJZs3DmqqdMBWPb9ByP1qq3R+pc/pDCSouAWxANq+Fc4csb0lgXnz7xKw2/Mqj7PBs0vG3fEWt/M37w0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aGeay8A8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aGeay8A8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BA50C32782;
	Thu,  6 Jun 2024 14:12:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683161;
	bh=AYvZIzyQ++ggfuHP8WVHSGwXjeuNxmdTHzVUpL+g1t0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aGeay8A8wkbonZ5Fx+gVmiLWcqycnJrnUGt46khc6uK2zmDoVWDcO3CxbAiJNLEDu
	 BLXIiMommF79dNFeZZRHr+e8SqPAnzVSXvWGmMAwEYjDrG5MP4ZzLPb5J99WEGxgFJ
	 04givJ3P0iyYEPySldVX6MqYMpm8QRY0Gc/deoEY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joshua Ashton <joshua@froggi.es>,
	Harry Wentland <harry.wentland@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 032/473] drm/amd/display: Set color_mgmt_changed to true on unsuspend
Date: Thu,  6 Jun 2024 15:59:21 +0200
Message-ID: <20240606131700.950195296@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joshua Ashton <joshua@froggi.es>

[ Upstream commit 2eb9dd497a698dc384c0dd3e0311d541eb2e13dd ]

Otherwise we can end up with a frame on unsuspend where color management
is not applied when userspace has not committed themselves.

Fixes re-applying color management on Steam Deck/Gamescope on S3 resume.

Signed-off-by: Joshua Ashton <joshua@froggi.es>
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index ff460c9802eb2..31bae620aeffc 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -2964,6 +2964,7 @@ static int dm_resume(void *handle)
 			dc_stream_release(dm_new_crtc_state->stream);
 			dm_new_crtc_state->stream = NULL;
 		}
+		dm_new_crtc_state->base.color_mgmt_changed = true;
 	}
 
 	for_each_new_plane_in_state(dm->cached_state, plane, new_plane_state, i) {
-- 
2.43.0



