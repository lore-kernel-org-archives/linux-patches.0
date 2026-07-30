Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AFF6431488;
	Thu, 30 Jul 2026 14:38:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422312; cv=none; b=JeoZkys7CZgA+Jo1tNgfyTfGWqRtLmKSMt05UprGWMyTg2Kgo5GTq/QWOUDAJLVPbIJZ7y37Xu8uxmcFes0A4OAG09zUl3uWu/ZBFgbMbOTphtbBKQyQp8zuJFbg2vf/xtF1rbzosAdtcjfoCGqZF6mu4xa4gVpLZWxjb3wISwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422312; c=relaxed/simple;
	bh=YeL711Retqa9lXuFzZdR8KEDxGyg5AB0gI+KYRTp0vw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VrXawWEYBusclx6TdVfdYZSXMb1V1it5Bb9vRkHvBqAWpxAvku0+LcpflXB9NW+/YgcuX3FoMOaaJskgS1LMbVh7YqLsbwojQcOrpQYMpU6XLG1+g/vo3u27tgFTJ6FM2B2mQPLjhjfRtJq4VWQM7O34ZNcg06MFwKFyZqKbpCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jvalWYJv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jvalWYJv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE4291F000E9;
	Thu, 30 Jul 2026 14:38:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422311;
	bh=6ecE/5c1N3xaeKmhbkd+BoBORbCpku1W3Ecyy/+bIqQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jvalWYJvqHrK3ZVwTAZ3+3jve6HqZ2yI6vJfOBBhvxrq7cUbf2rO7shZ1/aiMFuWZ
	 Q8MjhrrhXCfw5FWyeyEfpRRqP8u9noL/HF0RC0ft/O5KLUWJ+ASpWZ0iyetntx+2iX
	 RUk4F/LZvMjrGAHCY08GW6dcqG4Ohc1YNsur9xxs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mika Kahola <mika.kahola@intel.com>,
	=?UTF-8?q?Jouni=20H=C3=B6gander?= <jouni.hogander@intel.com>,
	Marco Nenciarini <mnencia@kcore.it>,
	Suraj Kandpal <suraj.kandpal@intel.com>,
	Imre Deak <imre.deak@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 7.1 394/744] drm/i915/mtl+: Enable PPS before PLL
Date: Thu, 30 Jul 2026 16:11:07 +0200
Message-ID: <20260730141452.664248387@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
User-Agent: quilt/0.69
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Imre Deak <imre.deak@intel.com>

commit 062499cc4813b5a3cbed5dd4fbe0177265858450 upstream.

Enabling PPS after a display port's PLL is enabled leads to PLL / DDI
BUF timeouts during system resuming after a long (> 45 mins) suspended
state, at least on some ARL and MTL laptops, either all or some of them
also containing an Nvidia GPU. Enabling PPS first and then the PLL fixes
the problem for all the reporters.

A similar issue is seen when enabling an external DP output on PHY B
(vs. PHY A in the above eDP cases), where this change will not have any
effect (since no PPS is used in that case). There isn't any direct
connection between PPS and PLL, so the fix for eDP works by some
side-effect only. However Bspec does seem to require enabling PPS first,
so let's do that. Further investigation continues on the actual root
cause and a cure for external panels.

Fixes: 1a7fad2aea74 ("drm/i915/cx0: Enable dpll framework for MTL+")
Closes: https://gitlab.freedesktop.org/drm/i915/kernel/-/work_items/16098
Closes: https://gitlab.freedesktop.org/drm/i915/kernel/-/work_items/16064
Closes: https://gitlab.freedesktop.org/drm/i915/kernel/-/work_items/16042
Cc: Mika Kahola <mika.kahola@intel.com>
Cc: stable@vger.kernel.org # v7.0+
Tested-by: Jouni Högander <jouni.hogander@intel.com>
Tested-by: Marco Nenciarini <mnencia@kcore.it>
Reviewed-by: Suraj Kandpal <suraj.kandpal@intel.com>
Signed-off-by: Imre Deak <imre.deak@intel.com>
Link: https://patch.msgid.link/20260612172617.3427027-1-imre.deak@intel.com
(cherry picked from commit 28783a274e886dd6da61419be6020bd9d0384e9f)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_ddi.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/i915/display/intel_ddi.c
+++ b/drivers/gpu/drm/i915/display/intel_ddi.c
@@ -2652,9 +2652,6 @@ static void mtl_ddi_pre_enable_dp(struct
 	/* 3. Select Thunderbolt */
 	mtl_port_buf_ctl_io_selection(encoder);
 
-	/* 4. Enable Panel Power if PPS is required */
-	intel_pps_on(intel_dp);
-
 	/* 5. Enable the port PLL */
 	intel_ddi_enable_clock(encoder, crtc_state);
 
@@ -3710,6 +3707,14 @@ intel_ddi_pre_pll_enable(struct intel_at
 	else if (display->platform.geminilake || display->platform.broxton)
 		bxt_dpio_phy_set_lane_optim_mask(encoder,
 						 crtc_state->lane_lat_optim_mask);
+
+	/*
+	 * There is no direct connection between the PLL and PPS, however
+	 * enabling PPS before PLL is required to avoid PLL/DDI BUF timeouts
+	 * during system resume. Do that matching the Bspec order as well.
+	 */
+	if (DISPLAY_VER(display) >= 14)
+		intel_pps_on(&dig_port->dp);
 }
 
 static void adlp_tbt_to_dp_alt_switch_wa(struct intel_encoder *encoder)


