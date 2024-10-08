Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A783D190663;
	Tue,  8 Oct 2024 12:38:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391129; cv=none; b=dtVt5xZ3eX4bGdnGKry4UTBRaNf0oTiHT1aHfk1LGG/nS7+npLiuAjgjhlXsVQixCGwzHf9T3BokU7XjsAtUOBnLAxhm+VfkfbP/7FY1eremmqzLaJsDf0ho8uHGCvGF5WGUmrbHsdW2U9JE4k+wm/SrSUaCZjYXcdoaOLCB/eE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391129; c=relaxed/simple;
	bh=TV4btvcQvEIQt/dxh1IMzlIQ/umdVix5MO3+4fKT/+Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JQ6AUHSjKHXaGdgKn3QjQfI4ge71OpMs7DJPzY7RHCQCHSqBAH1SHRqR87dJ8DVT1qVqlekJ+p1bVbkvKYnWW8b9O6vshuFQdUHneLW4pvwYqMpCtQ6Qt02LNWhnUAdVoGzW2IGX2mgRyFx7Ow9h9OhAZ5qYpr2Qh/GSkRdzDGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gju/YQ3V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gju/YQ3V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C0B0C4CEC7;
	Tue,  8 Oct 2024 12:38:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391129;
	bh=TV4btvcQvEIQt/dxh1IMzlIQ/umdVix5MO3+4fKT/+Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gju/YQ3VLxLA+C1A17JIvaTulLKmzm5Q6/l2Fe4EGDI7bBc5iKeXVx15EHToloujq
	 yHkljwEXcGtp5iFCbc0PBnglFle2yi5epPmj09hu9gPeSisZeUjIp8TqE3Do1m0NXX
	 X/MFNcz1jKt/t1yY2VslxfrspxGVBKBmT0S7LOVA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jouni=20H=C3=B6gander?= <jouni.hogander@intel.com>,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 017/558] drm/i915/dp: Fix colorimetry detection
Date: Tue,  8 Oct 2024 14:00:47 +0200
Message-ID: <20241008115702.901769446@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

[ Upstream commit e860513f56d8428fcb2bd0282ac8ab691a53fc6c ]

intel_dp_init_connector() is no place for detecting stuff via
DPCD (except perhaps for eDP). Move the colorimetry stuff into
a more appropriate place.

Cc: Jouni Högander <jouni.hogander@intel.com>
Fixes: 00076671a648 ("drm/i915/display: Move colorimetry_support from intel_psr to intel_dp")
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240918190441.29071-1-ville.syrjala@linux.intel.com
Reviewed-by: Jouni Högander <jouni.hogander@intel.com>
(cherry picked from commit 35dba4834bded843d5416e8caadfe82bd0ce1904)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_dp.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_dp.c b/drivers/gpu/drm/i915/display/intel_dp.c
index 2a7deac73b2eb..ffc0d1b140455 100644
--- a/drivers/gpu/drm/i915/display/intel_dp.c
+++ b/drivers/gpu/drm/i915/display/intel_dp.c
@@ -3964,6 +3964,9 @@ intel_edp_init_dpcd(struct intel_dp *intel_dp, struct intel_connector *connector
 			 drm_dp_is_branch(intel_dp->dpcd));
 	intel_init_dpcd_quirks(intel_dp, &intel_dp->desc.ident);
 
+	intel_dp->colorimetry_support =
+		intel_dp_get_colorimetry_status(intel_dp);
+
 	/*
 	 * Read the eDP display control registers.
 	 *
@@ -4077,6 +4080,9 @@ intel_dp_get_dpcd(struct intel_dp *intel_dp)
 
 		intel_init_dpcd_quirks(intel_dp, &intel_dp->desc.ident);
 
+		intel_dp->colorimetry_support =
+			intel_dp_get_colorimetry_status(intel_dp);
+
 		intel_dp_update_sink_caps(intel_dp);
 	}
 
@@ -6861,9 +6867,6 @@ intel_dp_init_connector(struct intel_digital_port *dig_port,
 				    "HDCP init failed, skipping.\n");
 	}
 
-	intel_dp->colorimetry_support =
-		intel_dp_get_colorimetry_status(intel_dp);
-
 	intel_dp->frl.is_trained = false;
 	intel_dp->frl.trained_rate_gbps = 0;
 
-- 
2.43.0



