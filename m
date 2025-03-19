Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A6811DE2C0;
	Wed, 19 Mar 2025 14:35:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742394950; cv=none; b=NM52LSHpQgl2Bk3sfqQ9QQKFjH223nXkO7YVN+8k/++yzgoZT6b5DaF3Uxj+sWhJ7QOTbn5qbwm/9m8HHD+fixtN7T+TJ7JWJvcaGecSRevXOJ9pmaE+83hhy63+rejJ6SUqmfUzvKJgm53nMVhq6GtcXIExr4PBkpoaRraX7+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742394950; c=relaxed/simple;
	bh=E5jy3MdPfikrXz+cBesaNwG+sPGl9J8BH2HaeuA7jro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=vGt4ZM+u6vBtWPdgUgQMeeDlHuHpe284LV0Fk5W2rFk3G4hodgVczEs0xBf2wTHwnrmwc2PrbXja+lD9lHIDB3UFsaTleh0UZpOhas5G9MNDsXk2U8mr/hPuudH5/20nFMfh+M8C1uauwWdQ9bomWSxYlztoy13jp8NTbWl9+QE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0+9Po3eQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0+9Po3eQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2CD7C4CEE4;
	Wed, 19 Mar 2025 14:35:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742394950;
	bh=E5jy3MdPfikrXz+cBesaNwG+sPGl9J8BH2HaeuA7jro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0+9Po3eQbrVhW/8T9EnGkcOW1uJ3cA58y+9sFm7fz8xgOTNR3/kqJqM/wXX2hmOB/
	 pF3BM521Iie/ni/bStElCrEYShcCrIHGB6ov54Dk161lnZQwoZXp0BVG3j5zxKeJv+
	 EDIVmpq81eh2vLzKWKg+JrMtbwT0cf9tjuNhNdNA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Vinod Govindapillai <vinod.govindapillai@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 6.13 174/241] drm/i915/cdclk: Do cdclk post plane programming later
Date: Wed, 19 Mar 2025 07:30:44 -0700
Message-ID: <20250319143032.038738784@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143027.685727358@linuxfoundation.org>
References: <20250319143027.685727358@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

commit 6266f4a78131c795631440ea9c7b66cdfd399484 upstream.

We currently call intel_set_cdclk_post_plane_update() far
too early. When pipes are active during the reprogramming
the current spot only works for the cd2x divider update
case, as that is synchronize to the pipe's vblank. Squashing
and crawling are not synchronized in any way, so doing the
programming while the pipes/planes are potentially still using
the old hardware state could lead to underruns.

Move the post plane reprgramming to a spot where we know
that the pipes/planes have switched over the new hardware
state.

Cc: stable@vger.kernel.org
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250218211913.27867-2-ville.syrjala@linux.intel.com
Reviewed-by: Vinod Govindapillai <vinod.govindapillai@intel.com>
(cherry picked from commit fb64f5568c0e0b5730733d70a012ae26b1a55815)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_display.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/i915/display/intel_display.c
+++ b/drivers/gpu/drm/i915/display/intel_display.c
@@ -7840,9 +7840,6 @@ static void intel_atomic_commit_tail(str
 	/* Now enable the clocks, plane, pipe, and connectors that we set up. */
 	dev_priv->display.funcs.display->commit_modeset_enables(state);
 
-	if (state->modeset)
-		intel_set_cdclk_post_plane_update(state);
-
 	intel_wait_for_vblank_workers(state);
 
 	/* FIXME: We should call drm_atomic_helper_commit_hw_done() here
@@ -7916,6 +7913,8 @@ static void intel_atomic_commit_tail(str
 		intel_verify_planes(state);
 
 	intel_sagv_post_plane_update(state);
+	if (state->modeset)
+		intel_set_cdclk_post_plane_update(state);
 	intel_pmdemand_post_plane_update(state);
 
 	drm_atomic_helper_commit_hw_done(&state->base);


