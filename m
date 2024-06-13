Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8DF7145359;
	Thu, 13 Jun 2024 11:55:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279708; cv=none; b=IloiL0b14drsqrtktLqs9vcYyuiR2TloFPZMbFIGPtf95pJbZgZnOVgFs3oy2605wETWYQlMI8MvAhEHXqPKUnRND8ypV8qdTOAkVmW0hNyOlqB0IE4fL9TDAP2OVVNynluSnx3swr/afEKFi5X2p77V67jXchBypewgrCYwt5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279708; c=relaxed/simple;
	bh=sNmGpln7qkG83UDdBf9Y9o7HjXWz/L927ce1663BWts=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MixNpW3WzuJkipErMk1lDyKzZ3fAZnOZRK0nbfDhuuD1h4prhDX5qu2N1rM24YApIwRlHtMfqbdZT7SrHwSzyFMT+GJmc897EN9fi7l9bO4KKAsseQruOtX1Sj3jskn6z0hH7WUrfd7cpxmmmkxiugDb6qzxovZYumyB3XDMD6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p89HWJBD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p89HWJBD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 505A4C32786;
	Thu, 13 Jun 2024 11:55:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279708;
	bh=sNmGpln7qkG83UDdBf9Y9o7HjXWz/L927ce1663BWts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p89HWJBD4JY513HszYZBCIYjuBfQhvqJ+QBW+N8sJNYpoSa1eDJwQfg8n4ENfyjFb
	 AtZBUtTJQF5/mC9npC3N6T9eE/9P/XO4MIJ6P3j6VugA9mrISPJH0Pbudi9iUOTf9u
	 uP58qy4Dlg7a73cl8IOFvA79JPD+B2BwtVXZZlsg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joshua Ashton <joshua@froggi.es>,
	Harry Wentland <harry.wentland@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 010/202] drm/amd/display: Set color_mgmt_changed to true on unsuspend
Date: Thu, 13 Jun 2024 13:31:48 +0200
Message-ID: <20240613113228.161627751@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.759341286@linuxfoundation.org>
References: <20240613113227.759341286@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 3f3242783e1c3..3bfc4aa328c6f 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -1251,6 +1251,7 @@ static int dm_resume(void *handle)
 			dc_stream_release(dm_new_crtc_state->stream);
 			dm_new_crtc_state->stream = NULL;
 		}
+		dm_new_crtc_state->base.color_mgmt_changed = true;
 	}
 
 	for_each_new_plane_in_state(dm->cached_state, plane, new_plane_state, i) {
-- 
2.43.0



