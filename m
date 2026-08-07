Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 092EF38D011;
	Fri,  7 Aug 2026 15:12:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115550; cv=none; b=LmHhvPXRAJ/TfmjYKV8jvYbSHeXeJ/XFKMtXO8ygU9vLDhScm+eGhHTPsm1NbG4+jGbtAQ65AxRrHA+s9lhtOkJWeIBlfoJhUOXqGvzTL0kxfNkz0ZXnXIT0gFDNSX0jrOGtnj2Sq0VJ0iqhH+pyDubKdNDKT6rPw7saYLfS43I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115550; c=relaxed/simple;
	bh=P56euHFBY/RB6OS4Wa5qzMc8woxRSJiHcKAL2dJ5x6U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KenjHPjHkGUpNXH3C19eu6dGz7Ugxped51JwX3OlNz0qxfNg8CfwSaeWk94M4S3a1Xh92EdORCr1H85UTG2+iSeMYGe+fFfFHjzrJ/WlZIGtdA6v+crnRESOnvMDdzspY6TKE11SUFsDgYsByrCSMjWraZHoCqVbJwwVkimMbt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gv/khMhj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gv/khMhj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47F341F00A3D;
	Fri,  7 Aug 2026 15:12:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115542;
	bh=WCwstHwJRcdNCoJ/FLCABhJ/GNgetTYHbEgZFPW4rFk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Gv/khMhj0fGKeWTWibZhipOvmhLmXebmvqPspKr3DvYIqCLr329B3jAit1UMFSJGV
	 vESVtN/+r+xpE6q7G7YqdSozsWj3fkU6U8KsOquTJQ//xwt3j9pL8jOLxEZLQPh/TU
	 lVln2VyJ3mwZ5KHn/Onjrkxz/mXN6voJCvk/SsoM=
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
Subject: [PATCH 6.18 312/396] drm/dp: Read the PCON max FRL bandwidth only for HDMI DFPs
Date: Fri,  7 Aug 2026 16:37:52 +0200
Message-ID: <20260807143430.996625925@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3457,6 +3457,18 @@ int drm_dp_get_pcon_max_frl_bw(const u8
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
 


