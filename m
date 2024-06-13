Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B38EA13CFA3;
	Thu, 13 Jun 2024 12:29:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281780; cv=none; b=pRadcXj2sZHe8bTiaYWz69i1gx1kjU/mr3SXOoI2rlq0MFg7aTiQqI3md1I1LrrZNW0kwZzbHjPxnDcmZK8R6/uS3kgmtLa4iwsXK4UbnmQG+yK4TyK0n74O1YBbJ8ioGX7p1ZZ5jb/4z9EisCwxRdQZzOHqDoNJjKNXl7grKRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281780; c=relaxed/simple;
	bh=zMtbZTbOYVvfqJ0ZkEZeWcST3U5iMnvIogsCviIcjM0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sXjd4t5XJghWDnXgpS/Q1uqzMEECJAduAZruQkzKt5oPmyLy9ChtDjC7uTCOcje2mRnAb8TmCfo2oaX1wn/39ifUsARIvPgkfzx6lEeF1d8m2HK9INKzNoiqyOook8iPidKiWLhCEDW/24X3OhswfiiMTA9yuhY43wVX5C5fuek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GTaactUQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GTaactUQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39572C32786;
	Thu, 13 Jun 2024 12:29:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281780;
	bh=zMtbZTbOYVvfqJ0ZkEZeWcST3U5iMnvIogsCviIcjM0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GTaactUQHH1II6zZsczrvN2jhllL8xY2TVejf3pDqgWwoEgzVDqW/dD+Bp4+FEDNr
	 zQVI0NAiERg/XAsfXVTu/Os+K4LVqa0YYS84IwvAXKogRt2u7QWAXdpv5uWMCkBna8
	 U8aUSr3KKXZL9d4fTRACxJFNqcqtvJ2AG38ghsj0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joshua Ashton <joshua@froggi.es>,
	Harry Wentland <harry.wentland@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 022/402] drm/amd/display: Set color_mgmt_changed to true on unsuspend
Date: Thu, 13 Jun 2024 13:29:39 +0200
Message-ID: <20240613113303.004529638@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index b7b8a2d77da67..b821abb56ac3b 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -2772,6 +2772,7 @@ static int dm_resume(void *handle)
 			dc_stream_release(dm_new_crtc_state->stream);
 			dm_new_crtc_state->stream = NULL;
 		}
+		dm_new_crtc_state->base.color_mgmt_changed = true;
 	}
 
 	for_each_new_plane_in_state(dm->cached_state, plane, new_plane_state, i) {
-- 
2.43.0



