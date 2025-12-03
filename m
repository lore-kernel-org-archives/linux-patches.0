Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E18E34C9AD;
	Wed,  3 Dec 2025 16:55:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780958; cv=none; b=ktUWNi0PdgJqV4wQdgHfKjyhQWnosoEBKytHBz/CZ8GUYKmPd5GIVezb+c/nIRfdrCgcm9Tpv2eHcZBljoZkLEm0792WTjx1to4Zomrk8/H3zevgl16pyTv9tjZbneDvqV9z12tn6yRW+Ta5yxbmJYtG5Z0b0OyiTROSS1ZwBno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780958; c=relaxed/simple;
	bh=7t1XKad4hU28wLDFuXc96PezO8msIg8rrozf/nXyXes=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CP+IRXaBVm2STAAjhNWq7ufOD3dsR5BqMR5R8uHx9qGg41yF7PSbGdK4XD0N2hQJlOAMrX60+bbo7CxlelaBCnNc+UfgdlqRsG4dPdJXAkQecXb3QK/EWSxtzCyN1DJkHK1c8njTGqawowce/Bc6FUizSEwURmrjHhcWq9vh3Us=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nQKAkWWf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nQKAkWWf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 877DEC4CEF5;
	Wed,  3 Dec 2025 16:55:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780958;
	bh=7t1XKad4hU28wLDFuXc96PezO8msIg8rrozf/nXyXes=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nQKAkWWfNdxJtMe9d6w9R/vNW2qRnJ1TkqkC+45EHFcUTPda66SsRF4mrVNON1Oyf
	 Wx+J/X3zFhAlguktkl2LInfCb/IWP2gTqH5HSalvBGtTiG5k4qHj2kK8wDDPvCCXx7
	 e47Y/fitoUB/LijkH2roztaqYyAvsHobMYkoyg6M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Imre Deak <imre.deak@intel.com>,
	"H. Nikolaus Schaller" <hns@goldelico.com>
Subject: [PATCH 6.12 131/132] drm/i915/dp: Initialize the source OUI write timestamp always
Date: Wed,  3 Dec 2025 16:30:10 +0100
Message-ID: <20251203152348.167446045@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152343.285859633@linuxfoundation.org>
References: <20251203152343.285859633@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Imre Deak <imre.deak@intel.com>

commit 5861258c4e6a829a10200b41ba3fb4d7d1a4054f upstream.

If the source OUI DPCD register value matches the expected Intel OUI
value, the write timestamp doesn't get updated leaving it at the 0
initial value if the OUI wasn't written before. This can lead to an
incorrect wait duration in intel_dp_wait_source_oui(), since jiffies is
not inited to 0 in general (on a 32 bit system INITIAL_JIFFIES is set to
5 minutes ahead of wrap-around). Fix this by intializing the write
timestamp in the above case as well.

Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Signed-off-by: Imre Deak <imre.deak@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241025160259.3088727-4-imre.deak@intel.com
Cc: "H. Nikolaus Schaller" <hns@goldelico.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_dp.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/display/intel_dp.c
+++ b/drivers/gpu/drm/i915/display/intel_dp.c
@@ -3383,8 +3383,11 @@ intel_edp_init_source_oui(struct intel_d
 		if (drm_dp_dpcd_read(&intel_dp->aux, DP_SOURCE_OUI, buf, sizeof(buf)) < 0)
 			drm_err(&i915->drm, "Failed to read source OUI\n");
 
-		if (memcmp(oui, buf, sizeof(oui)) == 0)
+		if (memcmp(oui, buf, sizeof(oui)) == 0) {
+			/* Assume the OUI was written now. */
+			intel_dp->last_oui_write = jiffies;
 			return;
+		}
 	}
 
 	if (drm_dp_dpcd_write(&intel_dp->aux, DP_SOURCE_OUI, oui, sizeof(oui)) < 0)


