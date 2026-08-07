Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90DCC4756A6;
	Fri,  7 Aug 2026 15:04:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115061; cv=none; b=nBdfCOcHKFuUIsh1sF7OPwgN5tKYWbxxqZ5do1ePfW80t6FrDQ2yvtCz0FIgBtmfL8XKeRxcy/yv2LLjMvWP4hlzVbASNv6LpdpTGY05iNecJVoVfnLTLAOf/hziI4Bdp/ghRWesJF1mq3bqNJCd0ALDCaYzyYkecpJhx9I2u0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115061; c=relaxed/simple;
	bh=NdXj7gmagZgpRZrsZN0cZwyEa9+sKf/EUKHRnU7bD2Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qRK7ntyz9/HewbQVguT+3WpQNOckdnBjZNG68Rsq2Avr50JHXHEjI3vMG8l4tRJgl0agHv92zls+XxGnX0Q/j4khmG+MpXIXhAUbda73EDmIFxSJu2Dc27s89gyVRdSLMPHIb88OVQB7LEnk5000SRwRPaOuKfXzKhiVoty8RNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eav8DqaO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eav8DqaO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 798591F00A3A;
	Fri,  7 Aug 2026 15:04:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115048;
	bh=X2bYcZxMklD9Q06ufgES+elHsVF90macP4DQ1aKk8Pg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eav8DqaOHqzxt9uUSAjGEm8VxTiQgE2dkaQKgFe3PtYUFG4NSy1i0wTCs+KsWppbQ
	 ouQBKn1lmkEX2g4ioAPmbnTp5JJqW6OWrvzMhD6gYIIGt6tAH+AN4RxYLcWivhWI1f
	 jt4lNqcTSBoV/yYqNgcaNc0vv2GvvVk8n6K4vxb8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ankit Nautiyal <ankit.k.nautiyal@intel.com>,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Alexander Kaplan <alexander.kaplan@sms-medipool.de>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 137/396] drm/i915/dp: Ignore the sinks DSC max FRL rate without a PCON DSC encoder
Date: Fri,  7 Aug 2026 16:34:57 +0200
Message-ID: <20260807143427.264242706@linuxfoundation.org>
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

From: Alexander Kaplan <alexander.kaplan@sms-medipool.de>

[ Upstream commit 8891e39e89042e285fd82fdde325d1311ec750a1 ]

intel_dp_hdmi_sink_max_frl() limits the sink's max FRL rate by its
DSC max FRL rate whenever the sink supports DSC 1.2.
However, the DSC max FRL rate (HF-VSDB DSC_Max_FRL_Rate) only applies
to compressed video transport, which requires a DSC 1.2 encoder in
the PCON (configured via intel_dp_pcon_dsc_configure()).
Without such an encoder the HDMI link always carries uncompressed
video, for which the regular Max_FRL_Rate is the correct limit.

Applying the DSC limit unconditionally trains the FRL link at a lower
rate than both the PCON and the sink support.
E.g. an LG OLED G4 (Max_FRL_Rate 48 Gbps, DSC_Max_FRL_Rate 24 Gbps)
behind a Synaptics VMM7100 PCON (PCON max FRL bw 48 Gbps, no DSC
encoder):

  Sink max rate from EDID = 24 Gbps
  FRL trained with : 24 Gbps

while Windows/macOS train the same hardware at 40/48 Gbps.
The too low FRL rate needlessly constrains the formats available to
the sink.

Only apply the sink's DSC max FRL rate if the PCON has a DSC 1.2
encoder, matching the gate in intel_dp_pcon_dsc_configure().
PCONs with a DSC encoder keep the current conservative behavior,
since the link is trained once and compressed transport may be used
for any subsequent mode.
With this the setup above trains at 48 Gbps.

Tested on PTL (xe) with the above PCON/sink combo.

Fixes: 10fec80b48c5 ("drm/i915/display: Configure PCON for DSC1.1 to DSC1.2 encoding")
Cc: Ankit Nautiyal <ankit.k.nautiyal@intel.com>
Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
Reviewed-by: Ankit Nautiyal <ankit.k.nautiyal@intel.com>
Signed-off-by: Alexander Kaplan <alexander.kaplan@sms-medipool.de>
Signed-off-by: Ankit Nautiyal <ankit.k.nautiyal@intel.com>
Link: https://patch.msgid.link/20260718105207.5565-3-alexander.kaplan@sms-medipool.de
(cherry picked from commit 71b57dd92f94569dca4bdf883fbd8ca5d4ed4bae)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_dp.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/display/intel_dp.c b/drivers/gpu/drm/i915/display/intel_dp.c
index 2a0750acf2053..84fca860c93ee 100644
--- a/drivers/gpu/drm/i915/display/intel_dp.c
+++ b/drivers/gpu/drm/i915/display/intel_dp.c
@@ -3859,7 +3859,14 @@ static int intel_dp_hdmi_sink_max_frl(struct intel_dp *intel_dp)
 	rate_per_lane = info->hdmi.max_frl_rate_per_lane;
 	max_frl_rate = max_lanes * rate_per_lane;
 
-	if (info->hdmi.dsc_cap.v_1p2) {
+	/*
+	 * The sink's DSC max FRL rate only applies to compressed video
+	 * transport, which requires a DSC 1.2 encoder in the PCON. Without
+	 * one the HDMI link always carries uncompressed video, for which
+	 * the regular max FRL rate is the limit.
+	 */
+	if (drm_dp_pcon_enc_is_dsc_1_2(intel_dp->pcon_dsc_dpcd) &&
+	    info->hdmi.dsc_cap.v_1p2) {
 		max_dsc_lanes = info->hdmi.dsc_cap.max_lanes;
 		dsc_rate_per_lane = info->hdmi.dsc_cap.max_frl_rate_per_lane;
 		if (max_dsc_lanes && dsc_rate_per_lane)
-- 
2.53.0



