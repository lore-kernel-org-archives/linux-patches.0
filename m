Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20EB585274;
	Tue, 23 Apr 2024 21:42:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908570; cv=none; b=Bq6+L6GEh/SnNyeJStw5lChPbDB5+q7AOedUVVPeb/+g+A81sasK9MHAffcLBa/hRdlqlSuWIJR+hjw156wyX0VlALDLeG7hHROLUyulza98snH9CDLODBJZ+kuKfrNOcRG/36XN1UyM4T3VHD3pDVFFXH+8/t1R3N3y+Nv8ZL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908570; c=relaxed/simple;
	bh=a4rz/nh8vC1WcKa9/lazYPyI8ifx23oY1o3mfgozs4w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VViqVfdk12RHk1PJ2a8Bj9s0UiD1FJQ146KgL+/QKqM5j1lEK2jtA7fPxi/wMem94iQ9SVQvAlSBPUCN/ixRR5iFQJnuuYFvx1geix3GcZBoHigYXwo7gU6K5Ny3eL9MwCOKLuzIaHkEQVSKi+kQse0zr5jBl67dOUs6uDrN0SM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ergBarCX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ergBarCX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E331CC116B1;
	Tue, 23 Apr 2024 21:42:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908570;
	bh=a4rz/nh8vC1WcKa9/lazYPyI8ifx23oY1o3mfgozs4w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ergBarCXi7Q1h1ZLpHB1CcIOy9SQzIjvSaFw35rtkSVnaknmiA7CzTnw1FOuRyUC6
	 cDrCa4h8nv11INpriMy7wb1ba291h0D40ZuWXWKgWyrwnULlJ8aMPxtxTZjiuC0lg9
	 X8z6HNjHQBUaa9FPoosnn8fr3I7T0mDi2o6J+NRQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Luca Coelho <luciano.coelho@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 006/158] drm/i915: Fix FEC pipe A vs. DDI A mixup
Date: Tue, 23 Apr 2024 14:37:23 -0700
Message-ID: <20240423213855.899756664@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.696477232@linuxfoundation.org>
References: <20240423213855.696477232@linuxfoundation.org>
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

[ Upstream commit 126f94e87e7960ef7ae58180e39c19cc9dcbbf7f ]

On pre-TGL FEC is a port level feature, not a transcoder
level feature, and it's DDI A which doesn't have it, not
trancoder A. Check for the correct thing when determining
whether FEC is supported or not.

Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230502143906.2401-5-ville.syrjala@linux.intel.com
Reviewed-by: Luca Coelho <luciano.coelho@intel.com>
Stable-dep-of: 99f855082f22 ("drm/i915/mst: Reject FEC+MST on ICL")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_dp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_dp.c b/drivers/gpu/drm/i915/display/intel_dp.c
index 18ee4f2a87f9e..fff008955cb2c 100644
--- a/drivers/gpu/drm/i915/display/intel_dp.c
+++ b/drivers/gpu/drm/i915/display/intel_dp.c
@@ -1310,13 +1310,13 @@ bool intel_dp_has_hdmi_sink(struct intel_dp *intel_dp)
 static bool intel_dp_source_supports_fec(struct intel_dp *intel_dp,
 					 const struct intel_crtc_state *pipe_config)
 {
+	struct intel_encoder *encoder = &dp_to_dig_port(intel_dp)->base;
 	struct drm_i915_private *dev_priv = dp_to_i915(intel_dp);
 
-	/* On TGL, FEC is supported on all Pipes */
 	if (DISPLAY_VER(dev_priv) >= 12)
 		return true;
 
-	if (DISPLAY_VER(dev_priv) == 11 && pipe_config->cpu_transcoder != TRANSCODER_A)
+	if (DISPLAY_VER(dev_priv) == 11 && encoder->port != PORT_A)
 		return true;
 
 	return false;
-- 
2.43.0



