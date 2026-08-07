Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 809AE371D1F;
	Fri,  7 Aug 2026 15:25:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116312; cv=none; b=cMoZuZaTH3Hsw5JLkAKPP3x7niK8cbj55EbRJZ3ld2BH98Z0FiH0uXq3hpOTvuFzmpVKTMWPzgpWQ36Z1/gxWuSQyvTyb71FfHy389hAE7SvJhOOo8Cylgzt+VFnrDIE7D9HpW/gb8qjS9mNoRWT9v6uvsy5Aj5xoEXntU6sjx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116312; c=relaxed/simple;
	bh=h/t+f8PpH9oZlH5SY9X+loT+IFNzb+Zbay2dowZqGRA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bzP9WmzOOepWTv7+Il0rc6C5hCbLdxBSsnSqHbsK6mXQovCbrLIT29G6jAdLAHVoLGwHkyHSq0/kI71m54Q3OgF6v2iNXHep9twghJ0TMY8w6DItcMJCSwLa+ME3P/tlaXCXAl9i3cgAcximl2k+Le32bb2qsaowKRHAOJQZN1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0LdUWPz5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0LdUWPz5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E60401F000E9;
	Fri,  7 Aug 2026 15:25:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116311;
	bh=z5IB6XTFKI35y5FdFqdbCMUdkuJsyMofSrKjy4C8jnw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0LdUWPz5DoHc2D7vg7CPFQoJTR2RsD4DH9/ld8rDW2jESTIpoIWC6cwCEzSB9Ef9k
	 w6aH0RJRr+XSdGbeuVzkAN9iXglblRFVVCXPS+WGnLebeCZdptfOWUUYzLtpQpNrsP
	 f3/ZW7oU0M6tg7ze0Jx3T81Yk1ohJB4stfLyfSyI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ankit Nautiyal <ankit.k.nautiyal@intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	dri-devel@lists.freedesktop.org,
	Alexander Kaplan <alexander.kaplan@sms-medipool.de>,
	Uma Shankar <uma.shankar@intel.com>
Subject: [PATCH 6.6 187/261] drm/dp: Read the PCON max FRL bandwidth only for HDMI DFPs
Date: Fri,  7 Aug 2026 16:39:04 +0200
Message-ID: <20260807143419.398710067@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Kaplan <alexander.kaplan@sms-medipool.de>

commit e40e20ac089e32f1d910636155dc82e61e61dcf3 upstream.

The PCON max FRL bandwidth field lives in byte 2 of the DFP Detailed
Capability Info (DPCD 0x82 for the first DFP).
The DP standard defines the meaning of descriptor bytes 1-3 strictly
per DFP type, and for a DisplayPort type DFP all of them are
reserved, with "read all 0s" semantics (DP v2.0, section 2.12.3,
Table 2-183).
The FRL bandwidth field is an HDMI DFP extension added by the VESA
DP-to-HDMI PCON specification.
drm_dp_get_pcon_max_frl_bw() however parses the byte without checking
the DFP type, the branch presence or DETAILED_CAP_INFO_AVAILABLE.
Without the latter the port descriptors are one byte wide and
port_cap[2] is not even the right register.

All neighbouring helpers parsing the same descriptor are scoped by
the DFP type already, see for instance drm_dp_downstream_max_bpc()
reading the same byte and returning 0 for a DP type DFP.
amdgpu's DC parses the field only for HDMI(/DP++) detailed types as
well.

This is not theoretical.
A Synaptics VMM7100 based USB-C to HDMI adapter with a macOS targeted
firmware advertises a DisplayPort type DFP with the type byte
replicated across the whole descriptor (08 08 08 08).
i915 decodes that as "PCON limited to 18 Gbps FRL" and prunes every
mode above ~750 MHz dotclock, including all the 4k@100/120 modes the
sink EDID offers, while macOS drives 4k@120 through the same adapter
just fine via DP DSC (and amdgpu's type-scoped parser would ignore
the bogus field as well).

Only parse the field for an HDMI DFP behind a DPCD 1.1+ branch
device that reports detailed cap info, matching the type-scoped
field layout of the spec and the rest of the helpers.

Fixes: ce32a6239de6 ("drm/dp_helper: Add Helpers for FRL Link Training support for DP-HDMI2.1 PCON")
Cc: Ankit Nautiyal <ankit.k.nautiyal@intel.com>
Cc: Uma Shankar <uma.shankar@intel.com> (v2)
Cc: Jani Nikula <jani.nikula@intel.com>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: dri-devel@lists.freedesktop.org
Cc: <stable@vger.kernel.org> # v5.12+
Signed-off-by: Alexander Kaplan <alexander.kaplan@sms-medipool.de>
Reviewed-by: Ankit Nautiyal <ankit.k.nautiyal@intel.com>
Signed-off-by: Ankit Nautiyal <ankit.k.nautiyal@intel.com>
Link: https://patch.msgid.link/20260610193825.2933-1-alexander.kaplan@sms-medipool.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/display/drm_dp_helper.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/drivers/gpu/drm/display/drm_dp_helper.c
+++ b/drivers/gpu/drm/display/drm_dp_helper.c
@@ -2930,6 +2930,18 @@ int drm_dp_get_pcon_max_frl_bw(const u8
 	int bw;
 	u8 buf;
 
+	if (!drm_dp_is_branch(dpcd))
+		return 0;
+
+	if (dpcd[DP_DPCD_REV] < 0x11)
+		return 0;
+
+	if ((dpcd[DP_DOWNSTREAMPORT_PRESENT] & DP_DETAILED_CAP_INFO_AVAILABLE) == 0)
+		return 0;
+
+	if ((port_cap[0] & DP_DS_PORT_TYPE_MASK) != DP_DS_PORT_TYPE_HDMI)
+		return 0;
+
 	buf = port_cap[2];
 	bw = buf & DP_PCON_MAX_FRL_BW;
 


