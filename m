Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 064B18F57
	for <patches@lists.linux.dev>; Mon, 13 Feb 2023 14:54:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80D30C433D2;
	Mon, 13 Feb 2023 14:54:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676300041;
	bh=yNhaBNpkBy+X/0ebLwxQL2wxf2clS3WJ8h+jXXyC/3g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V+gZpgAopJewcf9DPAiL7P+mS93CD12RptNklxJXzyEKGSp7ImBQCgE7hHZcmzmUS
	 jt/PY9OWH6hXubKJIibu6r9qKs1faIV0Rpm/pSrh8owifwzvj8lAsrQCKnfQ95sAO+
	 7Cw1kjQriBEv0CGiHYkl5K7S8aFmJ90DT4uFOKmI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Stanislav Lisovskiy <stanislav.lisovskiy@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 036/114] drm/i915: Dont do the WM0->WM1 copy w/a if WM1 is already enabled
Date: Mon, 13 Feb 2023 15:47:51 +0100
Message-Id: <20230213144744.016345273@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144742.219399167@linuxfoundation.org>
References: <20230213144742.219399167@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

[ Upstream commit 90d5e8301ac24550be80d193aa5582cab56c29fc ]

Due to a workaround we have to make sure the WM1 watermarks block/lines
values are sensible even when WM1 is disabled. To that end we copy those
values from WM0.

However since we now keep each wm level enabled on a per-plane basis
it doesn't seem necessary to do that copy when we already have an
enabled WM1 on the current plane. That is, we might be in a situation
where another plane can only do WM0 (and thus needs the copy) but
the current plane's WM1 is still perfectly valid (ie. fits into the
current DDB allocation).

Skipping the copy could avoid reprogramming the plane's registers
needlessly in some cases.

Fixes: a301cb0fca2d ("drm/i915: Keep plane watermarks enabled more aggressively")
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230131002127.29305-1-ville.syrjala@linux.intel.com
Reviewed-by: Stanislav Lisovskiy <stanislav.lisovskiy@intel.com>
(cherry picked from commit c580c2d27ac8754cc6f01da1d715b7272f5f9cbb)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/skl_watermark.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/display/skl_watermark.c b/drivers/gpu/drm/i915/display/skl_watermark.c
index 18178b01375e4..a7adf02476f6a 100644
--- a/drivers/gpu/drm/i915/display/skl_watermark.c
+++ b/drivers/gpu/drm/i915/display/skl_watermark.c
@@ -1587,7 +1587,8 @@ skl_crtc_allocate_plane_ddb(struct intel_atomic_state *state,
 				skl_check_wm_level(&wm->wm[level], ddb);
 
 			if (icl_need_wm1_wa(i915, plane_id) &&
-			    level == 1 && wm->wm[0].enable) {
+			    level == 1 && !wm->wm[level].enable &&
+			    wm->wm[0].enable) {
 				wm->wm[level].blocks = wm->wm[0].blocks;
 				wm->wm[level].lines = wm->wm[0].lines;
 				wm->wm[level].ignore_lines = wm->wm[0].ignore_lines;
-- 
2.39.0



