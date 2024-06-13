Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5D3844C6F;
	Thu, 13 Jun 2024 12:12:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280721; cv=none; b=Hmn0PDuJdOXN4U6OjmHNLsBGE+hoDpe0KSMkvsrgtnNQAmr5qnFR+Vlcjcp/OCkFcV2b4IoYSRuYvt95Y28xP5os4l5ADHNXIzDlMGYSQG+1K9UNKKXhfVsbl98RwDMcMWBtL3/+eKFHSfgYJ0UYoP7GcZnTwOsZEVypHppGIl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280721; c=relaxed/simple;
	bh=jzc2x7rpDQ40CsIFJlgvxyK/9oGW+ityi1qITiAcJhw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mboYzy1CjgElTzRNuMon7Vo11LNHslJAzO26HUEWcB0w7k9Lo7UGpmU4HXM2e4i+M1iB/oOQWQ07lUFl2XxU8FBfRV65Bs2PtEzcDZWyXlZLlAaJUmDC2znRU0R+xFqz6cOBxMeSkNf5r4NG5KHSgoxqssw4LcqqCLoYbsHEVEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CUGAmsjA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CUGAmsjA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F379C2BBFC;
	Thu, 13 Jun 2024 12:12:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280720;
	bh=jzc2x7rpDQ40CsIFJlgvxyK/9oGW+ityi1qITiAcJhw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CUGAmsjA1/7fmWaxuCz98jGXb54KSaOxfgZmpJBXMBmo8wDbaocKjk8jaCKpUuzo8
	 BEaNSK3KkiytaDGYEoBCAwBU3zORIn5xLX6ZtRc7hqmqfQd9Dsd8T7EpFakcTLmucl
	 ni+Ode/zOma//hM3VRUTZuTPjgvre6sRSp2Krdgs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joshua Ashton <joshua@froggi.es>,
	Harry Wentland <harry.wentland@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 012/317] drm/amd/display: Set color_mgmt_changed to true on unsuspend
Date: Thu, 13 Jun 2024 13:30:30 +0200
Message-ID: <20240613113248.014571605@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 3578e3b3536e3..29ef0ed44d5f4 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -2099,6 +2099,7 @@ static int dm_resume(void *handle)
 			dc_stream_release(dm_new_crtc_state->stream);
 			dm_new_crtc_state->stream = NULL;
 		}
+		dm_new_crtc_state->base.color_mgmt_changed = true;
 	}
 
 	for_each_new_plane_in_state(dm->cached_state, plane, new_plane_state, i) {
-- 
2.43.0



