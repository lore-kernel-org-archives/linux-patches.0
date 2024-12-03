Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24190153800;
	Tue,  3 Dec 2024 15:47:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240863; cv=none; b=RzoWIzCgtrsRMk3EdNHTp1SWe+WunMu9TGeC68LO83JWIPS+tE9UbL+S6mA7Pfs+BakKNV2mvxAuUKJyvMsgWW4eQrp+Cv3/c7VyrfjkMau0n5bdjL/zghmBqPs8qtFCPdJg7yz9Lt69xTZGDOoUIpzs38bUcclGXu4EGGdCZXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240863; c=relaxed/simple;
	bh=er6LL2V7XC1JYZX0TWp8k1T2FP4c5aJjLnge+OC7954=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=m8+U90nIUNx/1ERjU3CPgO70YTTab2WjAc1osG+Cy5678XUis91BJk9vdDYys67W3iewpr4yMbuyepSyV74IVMCY3an0LVAXN/5lZn9t5zA1yTKISZI2FakwiosQqFD7oWDDkBDpHRwkuCUjCNGFtqbuG0iGOk6ZVmZgb0QD8ZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oTuCju5Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oTuCju5Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A080EC4CECF;
	Tue,  3 Dec 2024 15:47:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240863;
	bh=er6LL2V7XC1JYZX0TWp8k1T2FP4c5aJjLnge+OC7954=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oTuCju5ZURpMkUa0Q5u+mN3V6wUbW+uZe0hO3zv0y6MIi86hjmCxom+x+Of1c/ZOC
	 dBmN5FHQZJBB1H9fbGvaLyc+Y/B1LHi08kb5tESk8144VNnlugN1dzjoQlw1Xc8rWf
	 7oPCAHShAzp4anqK/PuGcTsHIRDSsL9oLjadiZmE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Dave Stevenson <dave.stevenson@raspberrypi.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 240/826] drm/vc4: Match drm_dev_enter and exit calls in vc4_hvs_atomic_flush
Date: Tue,  3 Dec 2024 15:39:27 +0100
Message-ID: <20241203144753.128140055@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Stevenson <dave.stevenson@raspberrypi.com>

[ Upstream commit 6b0bd1b02ea24b10522c92b2503981970b26d1a2 ]

Commit 92c17d16476c ("drm/vc4: hvs: Ignore atomic_flush if we're disabled")
added a path which returned early without having called drm_dev_exit.

Ensure all paths call drm_dev_exit.

Fixes: 92c17d16476c ("drm/vc4: hvs: Ignore atomic_flush if we're disabled")
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
Reviewed-by: Maíra Canal <mcanal@igalia.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241008-drm-vc4-fixes-v1-2-9d0396ca9f42@raspberrypi.com
Signed-off-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_hvs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/vc4/vc4_hvs.c b/drivers/gpu/drm/vc4/vc4_hvs.c
index 15e4c888c4afd..f30022a360a8a 100644
--- a/drivers/gpu/drm/vc4/vc4_hvs.c
+++ b/drivers/gpu/drm/vc4/vc4_hvs.c
@@ -584,7 +584,7 @@ void vc4_hvs_atomic_flush(struct drm_crtc *crtc,
 	}
 
 	if (vc4_state->assigned_channel == VC4_HVS_CHANNEL_DISABLED)
-		return;
+		goto exit;
 
 	if (debug_dump_regs) {
 		DRM_INFO("CRTC %d HVS before:\n", drm_crtc_index(crtc));
@@ -667,6 +667,7 @@ void vc4_hvs_atomic_flush(struct drm_crtc *crtc,
 		vc4_hvs_dump_state(hvs);
 	}
 
+exit:
 	drm_dev_exit(idx);
 }
 
-- 
2.43.0



