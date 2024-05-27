Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9914168C4;
	Mon, 27 May 2024 19:20:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837640; cv=none; b=mJSlUWzRePA4brAdyREemCuZS5Ws8s8GhrSldyTvRlTPSU9vcP2u3g4nnwB5uoBKvq7spGT7JCSxnce8p1UCw/W2sV8drv4CGmI3qEPKhr5V/RBDRzvlfAGdUT+TOYLUXxDAfhYTrFBwYV0opHf22mYWmXBKedY/JSC+3amKjHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837640; c=relaxed/simple;
	bh=GdbZTlE+UlecxzjEn4DXs9UK1mOABY3i7vi48p6r+6g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PFm7jO0wZCJ1399TElxj3FELxCYCyD+enFlD3+C8KMojelLZQRCFNQsXSgxrlHpDz84LX929/0TOZ0VMkXlwl2WSpzqfztjAfg2p15AqBY85P49A4eGIqGTdi10mWZgAPJAhdCKlG45/nwS+egStiub6RjhI5jY8TiDfwpnhrk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ppod9vrV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ppod9vrV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E27BC2BBFC;
	Mon, 27 May 2024 19:20:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837640;
	bh=GdbZTlE+UlecxzjEn4DXs9UK1mOABY3i7vi48p6r+6g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ppod9vrV9iqikc+jonCOkRPJIzXYJNFLO7Y5TsNY7vFk20+g89hrLuuTLl9ufKHJH
	 GacWRioiL6yN3PzQEaKD1+t6ypcsLDh3IJo7IV1Buz/9WPSLHgv8FQdqhIYGs/a+lf
	 UtvY//3mlialRdeBkB9/oIWwBl5qg6mPe9LiyqWc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joshua Ashton <joshua@froggi.es>,
	Harry Wentland <harry.wentland@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 047/493] drm/amd/display: Set color_mgmt_changed to true on unsuspend
Date: Mon, 27 May 2024 20:50:49 +0200
Message-ID: <20240527185630.569701194@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index 9044214dfdbdf..c4ba397f8cef5 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -3010,6 +3010,7 @@ static int dm_resume(void *handle)
 			dc_stream_release(dm_new_crtc_state->stream);
 			dm_new_crtc_state->stream = NULL;
 		}
+		dm_new_crtc_state->base.color_mgmt_changed = true;
 	}
 
 	for_each_new_plane_in_state(dm->cached_state, plane, new_plane_state, i) {
-- 
2.43.0



