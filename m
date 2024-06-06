Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0A021990D7;
	Thu,  6 Jun 2024 14:12:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683133; cv=none; b=bXoid1rWQ4yEDzjqqBy0c6Wmon72KgVuK2hyMiziORdAUvkoePymAGSXvvuZmr1yy+Snic6UEXpTYAHJrdyj6LlRuaAL7fKyQn20G/wPh5KMvJhLFeVTmmO8zq7NVm+equaPgbwfY5H0qYTXznZV4cUpElZ0Ju5C4/FzZ9pK5/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683133; c=relaxed/simple;
	bh=EtiIVtNvXYMOtsTfm/I+3VC9/rTYOUGNft7t4/WSdoA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AjuOkw2+AMyAoBznaxvHhOAmykQM+lzuNmA918ZFS2PyUQVUJY3XBOW9j5OgrUJmVSKSTerz/vGKonWUz9ulR6cMpTYCcwHkSm2mnFEmxReO3qbUQUtFwgoyLw60lWC5/UQany9pxK1VLEHuJ3pcUpWSPlA1Q6PFela+7VF0Gdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C6WzFxVM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C6WzFxVM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B078AC2BD10;
	Thu,  6 Jun 2024 14:12:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683133;
	bh=EtiIVtNvXYMOtsTfm/I+3VC9/rTYOUGNft7t4/WSdoA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C6WzFxVMQK/6kzKvQNuV9etpJLRMo2Ox08wCW0o1CWdPjUEST4vfTVz4OIAExjEvS
	 STv4y3AIC3fKRp/CABI7GiFL2WXfTMM3rhF/LGJS+aNCN6Ioa1JmGeU0b7H05oQORm
	 9aRFQ/94qmRAuy3QCv8NebMn3xBa27ScBbD4hIuo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joshua Ashton <joshua@froggi.es>,
	Harry Wentland <harry.wentland@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 040/744] drm/amd/display: Set color_mgmt_changed to true on unsuspend
Date: Thu,  6 Jun 2024 15:55:12 +0200
Message-ID: <20240606131733.734350574@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 98dd07e3726af..7ed6bb61fe0ad 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -2956,6 +2956,7 @@ static int dm_resume(void *handle)
 			dc_stream_release(dm_new_crtc_state->stream);
 			dm_new_crtc_state->stream = NULL;
 		}
+		dm_new_crtc_state->base.color_mgmt_changed = true;
 	}
 
 	for_each_new_plane_in_state(dm->cached_state, plane, new_plane_state, i) {
-- 
2.43.0



