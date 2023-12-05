Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74A556AA0;
	Tue,  5 Dec 2023 03:20:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CI4sSAPj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0CDEC433C7;
	Tue,  5 Dec 2023 03:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701746417;
	bh=i0OKpz5a6PAB3hzCQJ3B2UK32k1Bxk0TD+OGebaFTmA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CI4sSAPjyqVuM8sOf6I1TD/Qc8eYXPgf5xqXLxfmAtgslOlK2CxTik+fDtJhtfYc0
	 saS//Wh3kgM9TM+c/PGO3dRkUO+lbCq7Hyak+RPAB1kOnBm8e0qCU0MtqHJ26RSpZc
	 A5aYSN1Wfj+azTuMnmvFL/mwBNnPb4zV3HrDb8rE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 6.6 017/134] drm/i915: Also check for VGA converter in eDP probe
Date: Tue,  5 Dec 2023 12:14:49 +0900
Message-ID: <20231205031536.421988824@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031535.163661217@linuxfoundation.org>
References: <20231205031535.163661217@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

commit f76f83a83c8fdbb62acbf8bd945f10821768145b upstream.

Unfortunately even the HPD based detection added in
commit cfe5bdfb27fa ("drm/i915: Check HPD live state during eDP probe")
fails to detect that the VBT's eDP/DDI-A is a ghost on
Asus B360M-A (CFL+CNP). On that board eDP/DDI-A has its HPD
asserted despite nothing being actually connected there :(
The straps/fuses also indicate that the eDP port is present.

So if one boots with a VGA monitor connected the eDP probe will
mistake the DP->VGA converter hooked to DDI-E for an eDP panel
on DDI-A.

As a last resort check what kind of DP device we've detected,
and if it looks like a DP->VGA converter then conclude that
the eDP port should be ignored.

Cc: stable@vger.kernel.org
Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/9636
Fixes: cfe5bdfb27fa ("drm/i915: Check HPD live state during eDP probe")
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20231114142333.15799-1-ville.syrjala@linux.intel.com
Reviewed-by: Jani Nikula <jani.nikula@intel.com>
(cherry picked from commit fcd479a79120bf0cd507d85f898297a3b868dda6)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_dp.c |   28 ++++++++++++++++++++++------
 1 file changed, 22 insertions(+), 6 deletions(-)

--- a/drivers/gpu/drm/i915/display/intel_dp.c
+++ b/drivers/gpu/drm/i915/display/intel_dp.c
@@ -5517,8 +5517,7 @@ static bool intel_edp_init_connector(str
 	 * (eg. Acer Chromebook C710), so we'll check it only if multiple
 	 * ports are attempting to use the same AUX CH, according to VBT.
 	 */
-	if (intel_bios_dp_has_shared_aux_ch(encoder->devdata) &&
-	    !intel_digital_port_connected(encoder)) {
+	if (intel_bios_dp_has_shared_aux_ch(encoder->devdata)) {
 		/*
 		 * If this fails, presume the DPCD answer came
 		 * from some other port using the same AUX CH.
@@ -5526,10 +5525,27 @@ static bool intel_edp_init_connector(str
 		 * FIXME maybe cleaner to check this before the
 		 * DPCD read? Would need sort out the VDD handling...
 		 */
-		drm_info(&dev_priv->drm,
-			 "[ENCODER:%d:%s] HPD is down, disabling eDP\n",
-			 encoder->base.base.id, encoder->base.name);
-		goto out_vdd_off;
+		if (!intel_digital_port_connected(encoder)) {
+			drm_info(&dev_priv->drm,
+				 "[ENCODER:%d:%s] HPD is down, disabling eDP\n",
+				 encoder->base.base.id, encoder->base.name);
+			goto out_vdd_off;
+		}
+
+		/*
+		 * Unfortunately even the HPD based detection fails on
+		 * eg. Asus B360M-A (CFL+CNP), so as a last resort fall
+		 * back to checking for a VGA branch device. Only do this
+		 * on known affected platforms to minimize false positives.
+		 */
+		if (DISPLAY_VER(dev_priv) == 9 && drm_dp_is_branch(intel_dp->dpcd) &&
+		    (intel_dp->dpcd[DP_DOWNSTREAMPORT_PRESENT] & DP_DWN_STRM_PORT_TYPE_MASK) ==
+		    DP_DWN_STRM_PORT_TYPE_ANALOG) {
+			drm_info(&dev_priv->drm,
+				 "[ENCODER:%d:%s] VGA converter detected, disabling eDP\n",
+				 encoder->base.base.id, encoder->base.name);
+			goto out_vdd_off;
+		}
 	}
 
 	mutex_lock(&dev_priv->drm.mode_config.mutex);


