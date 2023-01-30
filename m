Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B03BA28EB
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 14:03:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 357A1C433EF;
	Mon, 30 Jan 2023 14:03:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675087415;
	bh=CqcJOYrmMwrHvHr1l/AqBsW2JJ1N7PeAWS74POW7m1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xX8NvFIkKowq4O+vumQkLt8j6jX/800oDijoq0d0sQUqbUA8tTXpGG7DAoMraR49R
	 /99Rg6+izGlA4MX9yJ8i2eampwqcVGFEEh62CwAm5TH/tJ2qEx/DLhY3nPmbPXTaAk
	 ycNQVXHV3bG0MHE311J0E8gBcF2eiKf+1j1BlbPI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 199/313] drm/i915: Allow alternate fixed modes always for eDP
Date: Mon, 30 Jan 2023 14:50:34 +0100
Message-Id: <20230130134345.976764621@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
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

[ Upstream commit 55cfeecc2197de68e9cc30f77c711dcbcdf27510 ]

Stop considering VBT's static DRRS support when deciding whether
to use alternate fixed modes or not. It looks like Windows more
or less just uses that to decide whether to automagically switch
refresh rates on AC<->battery changes, or perhaps whether to
even expose a control for that in some UI thing. Either way it
seems happy to always use all EDID modes, and I guess the
DRRS/VRR stuff more or less adjusts how said modes get
actually used.

Let's do the same and just accept all the suitable looking
modes from EDID, whether we have DRRS or VRR.

Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/6323
Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/6484
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220927180615.25476-3-ville.syrjala@linux.intel.com
Reviewed-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_dp.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_dp.c b/drivers/gpu/drm/i915/display/intel_dp.c
index 78b3427471bd..b94bcceeff70 100644
--- a/drivers/gpu/drm/i915/display/intel_dp.c
+++ b/drivers/gpu/drm/i915/display/intel_dp.c
@@ -5216,9 +5216,7 @@ static bool intel_edp_init_connector(struct intel_dp *intel_dp,
 	intel_bios_init_panel(dev_priv, &intel_connector->panel,
 			      encoder->devdata, IS_ERR(edid) ? NULL : edid);
 
-	intel_panel_add_edid_fixed_modes(intel_connector,
-					 intel_connector->panel.vbt.drrs_type != DRRS_TYPE_NONE ||
-					 intel_vrr_is_capable(intel_connector));
+	intel_panel_add_edid_fixed_modes(intel_connector, true);
 
 	/* MSO requires information from the EDID */
 	intel_edp_mso_init(intel_dp);
-- 
2.39.0



