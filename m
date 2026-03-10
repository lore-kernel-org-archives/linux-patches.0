Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EFD8387368;
	Tue, 10 Mar 2026 11:26:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773142001; cv=none; b=ppe2oIRe6r8Y+mD7lu80pRBdUknCinyKFx9KcfWwKXPmjpF7A7iFM9eDTskhS8Q8laGSgvohC1gpEbG0ahPFq8KKGUxI4JrCKejIH9hUfeTDKL/ZBcl2P8CP38tyUAokVwcnDeX2ggXY1FiCUIVjzSeEIE5zmAL0KYmI5Ew79Xo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773142001; c=relaxed/simple;
	bh=ymJxRDQbWwoytOrQpg0jtX1abNUf+YMZ53aXbADlIbo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hK1HeI0RyzMfOcXz0F+paGlquQ2VBYdnmeIYyUcGuHzvkS5f8SLZ3aclyb1opMq9msB2s6ypanKscjuj3Ir50zoV8KywhzS0EvQvq3B6I1sDtKyPxVMA7HYmsuHMQQPA1fWhGi6eJaFYkvTyp1tHWm5nUtlm1g5qoXF8YZxN1C8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BTep+XLC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BTep+XLC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B350CC2BC86;
	Tue, 10 Mar 2026 11:26:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773142001;
	bh=ymJxRDQbWwoytOrQpg0jtX1abNUf+YMZ53aXbADlIbo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BTep+XLCvGmYCh/ENAHCw8t6UOp2MUrFQvMTAqw7FhDGN/ppd0GHJw51AZmYJY8WN
	 2IyonC440Qe4n5kSHFvMTH8fkvJHEa2/0+9D2lt8RXggJEckqHFGr5d8b8NfVIY+f4
	 UsGuAKErCdYHtoqRFMtrryR7suSFvZhDCZ1VgJZr5q/0BI7P6EbxliwXoD70mWFCMF
	 BMfrhgb/jw3zEF/bAoZMZlnfbFzp+8M83cwiQAhFhM8TcN0WrDPuTQ5sAmNmmsI5Xb
	 kGsd3cbKyRezsQylScOjlYOvSgdhqnUf+bxbbT7X8IjhJBp3bdNwJ0Pgp4ZBHsjEtP
	 lp7AcLECP+xLQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Imre Deak <imre.deak@intel.com>,
	Vinod Govindapillai <vinod.govindapillai@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 127/314] drm/i915/dp: Fail state computation for invalid DSC source input BPP values
Date: Tue, 10 Mar 2026 07:16:26 -0400
Message-ID: <c291d6acc338791cb89e2d3e9f85738ab2dd8229.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Imre Deak <imre.deak@intel.com>

[ Upstream commit 338465490cf7bd4a700ecd33e4855fee4622fa5f ]

There is no reason to accept an invalid minimum/maximum DSC source input
BPP value (i.e a minimum DSC input BPP value above the maximum pipe BPP
or a maximum DSC input BPP value below the minimum pipe BPP value), fail
the state computation in these cases.

Reviewed-by: Vinod Govindapillai <vinod.govindapillai@intel.com>
Signed-off-by: Imre Deak <imre.deak@intel.com>
Link: https://patch.msgid.link/20251215192357.172201-17-imre.deak@intel.com
Stable-dep-of: fe26ae6ac8b8 ("drm/i915/dp: Fix pipe BPP clamping due to HDR")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_dp.c | 28 ++++++++++++++++++-------
 1 file changed, 21 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_dp.c b/drivers/gpu/drm/i915/display/intel_dp.c
index 2eab591a8ef56..057b366c5ae29 100644
--- a/drivers/gpu/drm/i915/display/intel_dp.c
+++ b/drivers/gpu/drm/i915/display/intel_dp.c
@@ -2523,16 +2523,30 @@ intel_dp_compute_config_link_bpp_limits(struct intel_dp *intel_dp,
 	return true;
 }
 
-static void
-intel_dp_dsc_compute_pipe_bpp_limits(struct intel_dp *intel_dp,
+static bool
+intel_dp_dsc_compute_pipe_bpp_limits(struct intel_connector *connector,
 				     struct link_config_limits *limits)
 {
-	struct intel_display *display = to_intel_display(intel_dp);
+	struct intel_display *display = to_intel_display(connector);
+	const struct link_config_limits orig_limits = *limits;
 	int dsc_min_bpc = intel_dp_dsc_min_src_input_bpc();
 	int dsc_max_bpc = intel_dp_dsc_max_src_input_bpc(display);
 
-	limits->pipe.max_bpp = clamp(limits->pipe.max_bpp, dsc_min_bpc * 3, dsc_max_bpc * 3);
-	limits->pipe.min_bpp = clamp(limits->pipe.min_bpp, dsc_min_bpc * 3, dsc_max_bpc * 3);
+	limits->pipe.min_bpp = max(limits->pipe.min_bpp, dsc_min_bpc * 3);
+	limits->pipe.max_bpp = min(limits->pipe.max_bpp, dsc_max_bpc * 3);
+
+	if (limits->pipe.min_bpp <= 0 ||
+	    limits->pipe.min_bpp > limits->pipe.max_bpp) {
+		drm_dbg_kms(display->drm,
+			    "[CONNECTOR:%d:%s] Invalid DSC src/sink input BPP (src:%d-%d pipe:%d-%d)\n",
+			    connector->base.base.id, connector->base.name,
+			    dsc_min_bpc * 3, dsc_max_bpc * 3,
+			    orig_limits.pipe.min_bpp, orig_limits.pipe.max_bpp);
+
+		return false;
+	}
+
+	return true;
 }
 
 bool
@@ -2572,8 +2586,8 @@ intel_dp_compute_config_limits(struct intel_dp *intel_dp,
 							respect_downstream_limits);
 	}
 
-	if (dsc)
-		intel_dp_dsc_compute_pipe_bpp_limits(intel_dp, limits);
+	if (dsc && !intel_dp_dsc_compute_pipe_bpp_limits(connector, limits))
+		return false;
 
 	if (is_mst || intel_dp->use_max_params) {
 		/*
-- 
2.51.0

