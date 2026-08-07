Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAB7535F184;
	Fri,  7 Aug 2026 15:16:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115770; cv=none; b=E6QXcKgZw4Q4Djqec43X9jsFfEk3/fmF4akuzs2ascvRwXP4kjsFZeVpQzonbpuyI8mdnRtR646qoCzbIPimZfmAzs3M0MkGaLB4KxaapAz0p90GxMOBxVtqFC2YpJm4OmafopyNNi+fT/SXoyjtYeLdmZNq9IzKQC//1Egxeik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115770; c=relaxed/simple;
	bh=VDDjDATAjgywKf+OhzwvXwRkF6d6lTNrbIQbztfC3M4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FXOw1njvR1uGpIWIAeTFcvlyJumzKIXnIZNEYQ8phozCwVhDDBGrg5I/7fmZcYQVX0IfeVeLRB/b5fLMkPL+pQqGnZ6hZlip/TmBTNHDDZxADYQv2UJ0IoeQBgZfYgJYgwyyHRxDyy7lVC3CAgKRRnf0p2mhvJPeH6MfYBQL81o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LxGkuh81; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LxGkuh81"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BC141F000E9;
	Fri,  7 Aug 2026 15:16:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115769;
	bh=VOhiP8P88gnr4GE3Pw7DgtYhCltUgedtW1yJeghn7J4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LxGkuh811g7U30aQKBikXnx+MVdy+juRnxUn6x+t9IUrbXyWBmI5Ld9ShxtwnayGs
	 r1r4rRoLahnPnc02sDOVnDcXNC2XoGvE6wZjo/rAmVA7zBRHY+1ACnPhWtRdcC2Qfo
	 LHkYCeL7Om/MU15ipMkppO6ldmFaJnmSaBvIbVsg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Ankit Nautiyal <ankit.k.nautiyal@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 386/396] drm/i915/vrr: Check HAS_VRR() first in intel_vrr_is_capable()
Date: Fri,  7 Aug 2026 16:39:06 +0200
Message-ID: <20260807143432.603360065@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

[ Upstream commit 4b274b0b61ab2a529e5c22e9aa033f3028e639fc ]

There's no point in doing all the other checks in
intel_vrr_is_capable() if the platform doesn't support VRR at all
Check HAS_VRR() before wasting time on the other checks.

Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20251020185038.4272-23-ville.syrjala@linux.intel.com
Reviewed-by: Ankit Nautiyal <ankit.k.nautiyal@intel.com>
Stable-dep-of: f8a9262c7a6f ("drm/i915/vrr: require valid min/max vfreq for VRR")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_vrr.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/i915/display/intel_vrr.c
+++ b/drivers/gpu/drm/i915/display/intel_vrr.c
@@ -22,6 +22,9 @@ bool intel_vrr_is_capable(struct intel_c
 	const struct drm_display_info *info = &connector->base.display_info;
 	struct intel_dp *intel_dp;
 
+	if (!HAS_VRR(display))
+		return false;
+
 	/*
 	 * DP Sink is capable of VRR video timings if
 	 * Ignore MSA bit is set in DPCD.
@@ -46,8 +49,7 @@ bool intel_vrr_is_capable(struct intel_c
 		return false;
 	}
 
-	return HAS_VRR(display) &&
-		info->monitor_range.max_vfreq - info->monitor_range.min_vfreq > 10;
+	return info->monitor_range.max_vfreq - info->monitor_range.min_vfreq > 10;
 }
 
 bool intel_vrr_is_in_range(struct intel_connector *connector, int vrefresh)


