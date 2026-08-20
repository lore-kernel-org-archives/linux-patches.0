Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2AA646C82A;
	Thu, 20 Aug 2026 17:53:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787248438; cv=none; b=lxlSevF2G2lZ+zMf7HPl/zpzeT4Y6uIdYC14E4vwMYnJXRff3Zsu+qeBhSE6pcs9uquBmeTjtyw4V2DeCPNjuPmF8jx2P4yP84mDRO6ub6RfLahbeu+v5U9ZgjfW/xLwjiGAzBUzFgUW539Zi7d++Yej903aK/ZENdGahlaMal8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787248438; c=relaxed/simple;
	bh=916kGB5watRSV37VoCsneqYwwapq0Hx8N3N6XYsungg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VRkN66fugq0Hv8paLPDfBHekgUc1gQ5Jq40KDwUSIaDML33HHF4Zk1RfbPdpmRtq18k3oJ6KS2WWNM4+lwLmsdF8i7QPuJ5zeqy1PgP84uaY2ny5+iSo4VROrOgbPAGD3OeRdJWfaIBCARz24XGuNnDls/WCqTMsSeXQ3P/r6Wc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q0BQxaKA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q0BQxaKA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D2551F000E9;
	Thu, 20 Aug 2026 17:53:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787248436;
	bh=DOtXA+84++5MUb+CbRqVMOeH83TgrAbk0tcTNc9cHMY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q0BQxaKAM7N/hOGoW+e4fN928uyyVLw6E2m5mQlZqsNIZdJLbABeGV4u0FTOjslcy
	 FxHmHCDzEipMXrr4RTKU3CiQqddy/i6MyR5L2b+iaG9CPFRf2bv49q0Ik0CW0YDXZB
	 QLM2DRFa9NNZlroqhzgveAQhpGbo1X/yb85Tx3LU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Ankit Nautiyal <ankit.k.nautiyal@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 190/303] drm/i915/vrr: Check HAS_VRR() first in intel_vrr_is_capable()
Date: Thu, 20 Aug 2026 16:55:26 +0200
Message-ID: <20260820145259.023780970@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145253.200766705@linuxfoundation.org>
References: <20260820145253.200766705@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -15,6 +15,9 @@ bool intel_vrr_is_capable(struct intel_c
 	struct drm_i915_private *i915 = to_i915(connector->base.dev);
 	struct intel_dp *intel_dp;
 
+	if (!HAS_VRR(i915))
+		return false;
+
 	/*
 	 * DP Sink is capable of VRR video timings if
 	 * Ignore MSA bit is set in DPCD.
@@ -37,8 +40,7 @@ bool intel_vrr_is_capable(struct intel_c
 		return false;
 	}
 
-	return HAS_VRR(i915) &&
-		info->monitor_range.max_vfreq - info->monitor_range.min_vfreq > 10;
+	return info->monitor_range.max_vfreq - info->monitor_range.min_vfreq > 10;
 }
 
 void


