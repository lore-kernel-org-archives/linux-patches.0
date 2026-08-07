Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C0E333C1AD;
	Fri,  7 Aug 2026 15:26:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116417; cv=none; b=IFixBmXZB7wU6E073jQeEVBEmwojMc1rxnwA63HOVtM9/c51SFfnPB4YleFWTu5S3nNIU3t556xpVAg9Lk8fit6cq4Hw53u75NCgzjxt3sShdzMQGhvRKm83TAb5f+svWLeNEkOn9DnpTdOVHo63StbiFr9xW2X5gQLFnE6rz6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116417; c=relaxed/simple;
	bh=siuPMOV7MfQjZD4AF0NIi698KMm5myOfw/VPuY+oERw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=r/fIP7xgqrNxSezXDFEP1i7T/GmDw8UEBa+rWd3e2mj3I4S19y820YH4xR+9hkH7jAMt9jvlBJA/K8UuFnFWtsTAAEcavFIpOLorT4TsgcyMbOmIfDvCdj9xFZ4rWi2DVs3csrpyCUDP1afq9AdiAE5kAu0HgesbENnnrrqq/bs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a3B80+es; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a3B80+es"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A80C41F000E9;
	Fri,  7 Aug 2026 15:26:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116416;
	bh=ZSjSY1duyAcS5WmV3vW07H9Tm9y/uxxLtF6JY9zEiEQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a3B80+esZ6CW1s/F1cb0Yyn8w4+vDisQiOBTIEvxmG6mXLc/wHDlVNiZ9rTH5jLBL
	 5B/1zgw6cw62TPLSLTF8RCq6Wms98phQIQcsrJyVi95QrRG8oOPBe/VUvkSE8ypptC
	 o5Rb2F0FQ2TsXa+qSBQuWmI3izBmr009l3zucNSE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Ankit Nautiyal <ankit.k.nautiyal@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 225/261] drm/i915/vrr: Check HAS_VRR() first in intel_vrr_is_capable()
Date: Fri,  7 Aug 2026 16:39:42 +0200
Message-ID: <20260807143420.225101393@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143415.358597922@linuxfoundation.org>
References: <20260807143415.358597922@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -16,6 +16,9 @@ bool intel_vrr_is_capable(struct intel_c
 	struct drm_i915_private *i915 = to_i915(connector->base.dev);
 	struct intel_dp *intel_dp;
 
+	if (!HAS_VRR(i915))
+		return false;
+
 	/*
 	 * DP Sink is capable of VRR video timings if
 	 * Ignore MSA bit is set in DPCD.
@@ -38,8 +41,7 @@ bool intel_vrr_is_capable(struct intel_c
 		return false;
 	}
 
-	return HAS_VRR(i915) &&
-		info->monitor_range.max_vfreq - info->monitor_range.min_vfreq > 10;
+	return info->monitor_range.max_vfreq - info->monitor_range.min_vfreq > 10;
 }
 
 void


