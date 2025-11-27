Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DE8832AAC4;
	Thu, 27 Nov 2025 15:05:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255929; cv=none; b=tDhYsuaq9e8Nnv5Tf3+COFvGix0XqhsnTiUqcg79GOrwQWflf8WUMHXwgjFoetcnbWfP7ejL8h9zI5xTQGnaziRhLlNDMyseeD3a7QBb1MapO4bcvxLmFJ/fFMEiqYjmv8oqt1xJjdjXrXEfKcwOSGZSrBZyI5wdxdLAnsGIn34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255929; c=relaxed/simple;
	bh=DGHk1PtIax2fgR9Rz3oFPcd/Ykf+ktkz4Hjk9+GWDxA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ccmrPOyEGxQ2p/hzrtUG32VHqMQZYCX/CZtrC3OgnIcfyP5o8dXsk8ypGct97TnowyJ3ofq4dEEWHfjIoH0OKiKRGYVACNnyevn2RBEYplI4T310mKLCdWWsp+lJa+H05kADGRPOTscgebwCouxEI4N+4kw0cNS9Vcf8v/tvBHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r1D6KCCV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r1D6KCCV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E690C4CEF8;
	Thu, 27 Nov 2025 15:05:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255928;
	bh=DGHk1PtIax2fgR9Rz3oFPcd/Ykf+ktkz4Hjk9+GWDxA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r1D6KCCVhdhHcNqw+kWv+mPbq3dZOLTK5EZJS/+tJy1PPDjYVyQEi47cY5UPP5zhA
	 7aBvQqgDCJCON84cVPnGwe0NWGA8MKJMILvqw156+Hd/LtXUerPDjBxEIYJk0lkjSv
	 hLOXUWTbRtVGTalTjkyyFPwsomWe/RJXpCDqEmSI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jouni=20H=C3=B6gander?= <jouni.hogander@intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 162/175] drm/i915/psr: Check drm_dp_dpcd_read return value on PSR dpcd init
Date: Thu, 27 Nov 2025 15:46:55 +0100
Message-ID: <20251127144048.867836090@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144042.945669935@linuxfoundation.org>
References: <20251127144042.945669935@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jouni Högander <jouni.hogander@intel.com>

[ Upstream commit 9cc10041e9fe7f32c4817e3cdd806ff1986d266c ]

Currently we are ignoriong drm_dp_dpcd_read return values when reading PSR
and Panel Replay capability DPCD register. Rework intel_psr_dpcd a bit to
take care of checking the return value.

v2: use drm_dp_dpcd_read_data

Signed-off-by: Jouni Högander <jouni.hogander@intel.com>
Reviewed-by: Jani Nikula <jani.nikula@intel.com>
Link: https://lore.kernel.org/r/20250821045918.17757-1-jouni.hogander@intel.com
Stable-dep-of: f2687d3cc9f9 ("drm/i915/dp_mst: Disable Panel Replay")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_psr.c |   32 ++++++++++++++++++++-----------
 1 file changed, 21 insertions(+), 11 deletions(-)

--- a/drivers/gpu/drm/i915/display/intel_psr.c
+++ b/drivers/gpu/drm/i915/display/intel_psr.c
@@ -600,6 +600,16 @@ exit:
 static void _panel_replay_init_dpcd(struct intel_dp *intel_dp)
 {
 	struct intel_display *display = to_intel_display(intel_dp);
+	int ret;
+
+	ret = drm_dp_dpcd_read_data(&intel_dp->aux, DP_PANEL_REPLAY_CAP_SUPPORT,
+				    &intel_dp->pr_dpcd, sizeof(intel_dp->pr_dpcd));
+	if (ret < 0)
+		return;
+
+	if (!(intel_dp->pr_dpcd[INTEL_PR_DPCD_INDEX(DP_PANEL_REPLAY_CAP_SUPPORT)] &
+	      DP_PANEL_REPLAY_SUPPORT))
+		return;
 
 	if (intel_dp_is_edp(intel_dp)) {
 		if (!intel_alpm_aux_less_wake_supported(intel_dp)) {
@@ -631,6 +641,15 @@ static void _panel_replay_init_dpcd(stru
 static void _psr_init_dpcd(struct intel_dp *intel_dp)
 {
 	struct intel_display *display = to_intel_display(intel_dp);
+	int ret;
+
+	ret = drm_dp_dpcd_read_data(&intel_dp->aux, DP_PSR_SUPPORT, intel_dp->psr_dpcd,
+				    sizeof(intel_dp->psr_dpcd));
+	if (ret < 0)
+		return;
+
+	if (!intel_dp->psr_dpcd[0])
+		return;
 
 	drm_dbg_kms(display->drm, "eDP panel supports PSR version %x\n",
 		    intel_dp->psr_dpcd[0]);
@@ -676,18 +695,9 @@ static void _psr_init_dpcd(struct intel_
 
 void intel_psr_init_dpcd(struct intel_dp *intel_dp)
 {
-	drm_dp_dpcd_read(&intel_dp->aux, DP_PSR_SUPPORT, intel_dp->psr_dpcd,
-			 sizeof(intel_dp->psr_dpcd));
-
-	drm_dp_dpcd_read(&intel_dp->aux, DP_PANEL_REPLAY_CAP_SUPPORT,
-			 &intel_dp->pr_dpcd, sizeof(intel_dp->pr_dpcd));
-
-	if (intel_dp->pr_dpcd[INTEL_PR_DPCD_INDEX(DP_PANEL_REPLAY_CAP_SUPPORT)] &
-	    DP_PANEL_REPLAY_SUPPORT)
-		_panel_replay_init_dpcd(intel_dp);
+	_psr_init_dpcd(intel_dp);
 
-	if (intel_dp->psr_dpcd[0])
-		_psr_init_dpcd(intel_dp);
+	_panel_replay_init_dpcd(intel_dp);
 
 	if (intel_dp->psr.sink_psr2_support ||
 	    intel_dp->psr.sink_panel_replay_su_support)


