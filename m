Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E93FF31E833;
	Thu, 30 Jul 2026 14:41:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422509; cv=none; b=cqkqHLxF+I2nc1ZL+8n1VWTbPOGFZx97T+NhipYEN+gEeUJp763OKNIzjiwQ17blf5zQD9dgWC3Gpsf2HDfMOEISpZFKqOn9IfsoPgeD9sgzbZL/hoUk4GpgG+iuYV2HvK++snRkMtk8noKcvTapubU9eUkpQLB1qruXeWG6iac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422509; c=relaxed/simple;
	bh=gZ4tJhdsZpTn/VXMpixEikj8GPhiLxO57+IL69y/32Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cmRtaO6+DM9nbsfpgZRRxNHcelYFqEmK6AqYs+JVqzD5qJhf6LbTiYTzPdkCDJZe+2zXiGbs9bRKPkf8UgH9L/0l31rRttteM8jWOrIKEx8HcxzYKBlhX6xTGQhkT9w0hwx2m7/7y6M3lgBWTxCf4TBJqL1PPyOT0kPk58Rzfvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X+aHarjh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X+aHarjh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F9B71F000E9;
	Thu, 30 Jul 2026 14:41:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422507;
	bh=F1QjuglObOJunsm1h5tjkC4vxsdXG/7nKvgDXfQisH0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X+aHarjheRbAa2M5KRWWRFS3Sa3jN5kCeqzTk6ZMXNhgzgJWcaxht+uhpTl8cZ1L4
	 kSL+zEVb1OjCkEYdk82Zr5gYiFqVL3OwaXXjNsnGFwTX6auYe7eVxzS+MQNzGqs1A2
	 PdzTZZj7Y55Z3ex77fWd1HGKR5rgDiDb0OsbmKi4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leorize <leorize+oss@disroot.org>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.1 418/744] drm/amd/display: set MSA MISC1 bit 6 when using VSC SDP for DCE 11.x
Date: Thu, 30 Jul 2026 16:11:31 +0200
Message-ID: <20260730141453.181971619@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leorize <leorize+oss@disroot.org>

commit da353a6b30086674c77bdbbfd86e9e0c7416ba99 upstream.

When BT.2020 colorimetry is selected, the driver sends information using
VSC SDP but does not set "ignore MSA colorimetry" bit on older GPUs with
DCE-based IPs. This causes certain sinks to prefer colorimetry
information in DP MSA, resulting in terrible color rendering ("dull"
colors) when HDR is enabled.

This commit wires up the MISC1 bit 6 for GPUs with DCE 11.x based IPs to
correctly configure sinks to ignore colorimetry information in MSA,
resolving the color rendering issue.

Closes: https://gitlab.freedesktop.org/drm/amd/-/work_items/4849
Assisted-by: oh-my-pi:GPT-5.5
Signed-off-by: Leorize <leorize+oss@disroot.org>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 323a09e56c1d549ce47d4f110de77b0051b4a8bf)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dce/dce_stream_encoder.c |   15 ++++++++++++++-
 drivers/gpu/drm/amd/display/dc/dce/dce_stream_encoder.h |    3 ++-
 2 files changed, 16 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/dce/dce_stream_encoder.c
+++ b/drivers/gpu/drm/amd/display/dc/dce/dce_stream_encoder.c
@@ -271,7 +271,6 @@ static void dce110_stream_encoder_dp_set
 	bool use_vsc_sdp_for_colorimetry,
 	uint32_t enable_sdp_splitting)
 {
-	(void)use_vsc_sdp_for_colorimetry;
 	(void)enable_sdp_splitting;
 	uint32_t h_active_start;
 	uint32_t v_active_start;
@@ -334,6 +333,16 @@ static void dce110_stream_encoder_dp_set
 	if (REG(DP_MSA_MISC))
 		misc1 = REG_READ(DP_MSA_MISC);
 
+	/* For YCbCr420 and BT2020 Colorimetry Formats, VSC SDP shall be used.
+	 * When MISC1, bit 6, is Set to 1, a Source device uses a VSC SDP to indicate the
+	 * Pixel Encoding/Colorimetry Format and that a Sink device shall ignore MISC1, bit 7,
+	 * and MISC0, bits 7:1 (MISC1, bit 7, and MISC0, bits 7:1, become "don't care").
+	 */
+	if (use_vsc_sdp_for_colorimetry)
+		misc1 = misc1 | 0x40;
+	else
+		misc1 = misc1 & ~0x40;
+
 	/* set color depth */
 
 	switch (hw_crtc_timing.display_color_depth) {
@@ -499,6 +508,10 @@ static void dce110_stream_encoder_dp_set
 				hw_crtc_timing.h_addressable + hw_crtc_timing.h_border_right,
 				DP_MSA_VHEIGHT, hw_crtc_timing.v_border_top +
 				hw_crtc_timing.v_addressable + hw_crtc_timing.v_border_bottom);
+	} else {
+		/* DCE-only path */
+		if (REG(DP_MSA_MISC))
+			REG_WRITE(DP_MSA_MISC, misc1);   /* MSA_MISC1 */
 	}
 }
 
--- a/drivers/gpu/drm/amd/display/dc/dce/dce_stream_encoder.h
+++ b/drivers/gpu/drm/amd/display/dc/dce/dce_stream_encoder.h
@@ -96,7 +96,8 @@
 
 #define SE_COMMON_REG_LIST(id)\
 	SE_COMMON_REG_LIST_DCE_BASE(id), \
-	SRI(AFMT_CNTL, DIG, id)
+	SRI(AFMT_CNTL, DIG, id), \
+	SRI(DP_MSA_MISC, DP, id)
 
 #define SE_DCN_REG_LIST(id)\
 	SE_COMMON_REG_LIST_BASE(id),\


