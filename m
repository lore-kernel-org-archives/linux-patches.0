Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C2192798F8;
	Tue, 27 May 2025 17:17:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366271; cv=none; b=kOlIcIL9pVX9PCzxY0cF3zC7JWqQXEPEvzby+qbArZLjzmWf6y+ceBU4AJdLqyioLseNxpgpDfUabzXNgg0WV6bX2veh5lS1gYb8VPBdiZQKJga8V/gh/IWRbR/b7NWpNFC/vtn05M01H7Nw5X5nTUT/v+7/9LAVS1NmIPEBvX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366271; c=relaxed/simple;
	bh=vibBpcsx24yk43GCzKywQW2bS1TvW7pMmTnxVNYh140=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vETdf5v6uuC2r1MuPn8REqtJnQOAD6rrK+ijyBYUcz5SgFlCBaeOQKzQaRoJfhcsZ70fGDveJAqDMyH0XH0vpd7VdMVlyGiKO2U0lFdJ3MuriXiB0oHuz3Go8tCvIR7/TfvMffU6Y49wu3IPJquzbK8CTzlZQsyVB0V0EDJKzn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AJnHy0kN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AJnHy0kN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 255D4C4CEE9;
	Tue, 27 May 2025 17:17:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366270;
	bh=vibBpcsx24yk43GCzKywQW2bS1TvW7pMmTnxVNYh140=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AJnHy0kN02XcS4dTIJrv2k4paREd+W+eCajxLWOmobcBYyzlk7RPs15Rj8zSUtKmw
	 SJyyS+svtVBcfJ1ykxq18g9zaP9A5wJiwwoKKOAE7mm1Pj9ywM52yvuyQ1RSOWjZmk
	 7+Co5Oe/r4Y+BkhG8ymNPDamDY13qNMeOlKZYXGQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charlene Liu <charlene.liu@amd.com>,
	Zhongwei Zhang <Zhongwei.Zhang@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 002/783] drm/amd/display: Correct timing_adjust_pending flag setting.
Date: Tue, 27 May 2025 18:16:39 +0200
Message-ID: <20250527162513.146651269@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhongwei Zhang <Zhongwei.Zhang@amd.com>

[ Upstream commit 34935701b7ed1a1ef449310ba041f10964b23cf4 ]

[Why&How]
stream->adjust will be overwritten by update->crtc_timing_adjust.
We should set update->crtc_timing_adjust->timing_adjust_pending
and then overwrite stream->adjust.
Reset update->crtc_timing_adjust->timing_adjust_pending after
the assignment.

Reviewed-by: Charlene Liu <charlene.liu@amd.com>
Signed-off-by: Zhongwei Zhang <Zhongwei.Zhang@amd.com>
Signed-off-by: Tom Chung <chiahsuan.chung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: 874697e12793 ("drm/amd/display: Defer BW-optimization-blocked DRR adjustments")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc.c b/drivers/gpu/drm/amd/display/dc/core/dc.c
index a444fe1e0838a..e70b097cf478d 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -3131,8 +3131,9 @@ static void copy_stream_update_to_stream(struct dc *dc,
 	if (update->crtc_timing_adjust) {
 		if (stream->adjust.v_total_min != update->crtc_timing_adjust->v_total_min ||
 			stream->adjust.v_total_max != update->crtc_timing_adjust->v_total_max)
-			stream->adjust.timing_adjust_pending = true;
+			update->crtc_timing_adjust->timing_adjust_pending = true;
 		stream->adjust = *update->crtc_timing_adjust;
+		update->crtc_timing_adjust->timing_adjust_pending = false;
 	}
 
 	if (update->dpms_off)
-- 
2.39.5



