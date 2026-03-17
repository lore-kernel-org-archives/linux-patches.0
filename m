Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C6771ACEDE;
	Tue, 17 Mar 2026 17:01:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773766892; cv=none; b=i/SJ1NaBBH5XIiQ0iqArun7v2cWT64NFwMQv1pL+JxB9eSYwaYQ3AF0K/ySQNf9B9vbSGTlkKN1hjir/VlQz9k7jwCFfdvo/6C/wu7t8cm77BCtgVmORuT0GoEykALnCQ2nQlBW58/q0jEykT/Up/KB0Fd/Im6r4j8O/MHdL//k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773766892; c=relaxed/simple;
	bh=EB7vgOdQqGjyTvw+cvVeAuNRCumZE9g+7AzJAUTPBGU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NOCTK62MgaDiGslw+AX1uSc+2hyKwwe3DvvPk5aRBdnECwjFZuwGq5vFNM/mivkR/4u5vEBjXwr3MvMSH/Wny1b5yZdgtquyjNAoRipWc/8tEiMbMnYWdSBvWcMaxUj4kGkG7jO+vk6yMzePsJ0n1qRvy/vdohQvv0gHiGBK0+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nAV5VESB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nAV5VESB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7BDAC4CEF7;
	Tue, 17 Mar 2026 17:01:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773766892;
	bh=EB7vgOdQqGjyTvw+cvVeAuNRCumZE9g+7AzJAUTPBGU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nAV5VESBHCyoL3veDiLcFuCbOrK2Buk/WPmt2/lQxKUMXKiebPkCLV6hOD5PYyx8p
	 +gFPmxAabBeTWbiWwXttdDx8/hnwq+hqDHcYBicWWSB8GDP3SqdlAszWhpx/yk2RMz
	 gqdUbmycl+HFAD/B1XLZCZAa96FhWV9q4PtY2b8Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ankit Nautiyal <ankit.k.nautiyal@intel.com>,
	Benjamin Tissoires <bentiss@kernel.org>,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>
Subject: [PATCH 6.19 311/378] drm/i915/vrr: Configure VRR timings after enabling TRANS_DDI_FUNC_CTL
Date: Tue, 17 Mar 2026 17:34:28 +0100
Message-ID: <20260317163018.439314505@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

commit 237aab549676288d9255bb8dcc284738e56eaa31 upstream.

Apparently ICL may hang with an MCE if we write TRANS_VRR_VMAX/FLIPLINE
before enabling TRANS_DDI_FUNC_CTL.

Personally I was only able to reproduce a hang (on an Dell XPS 7390
2-in-1) with an external display connected via a dock using a dodgy
type-C cable that made the link training fail. After the failed
link training the machine would hang. TGL seemed immune to the
problem for whatever reason.

BSpec does tell us to configure VRR after enabling TRANS_DDI_FUNC_CTL
as well. The DMC firmware also does the VRR restore in two stages:
- first stage seems to be unconditional and includes TRANS_VRR_CTL
  and a few other VRR registers, among other things
- second stage is conditional on the DDI being enabled,
  and includes TRANS_DDI_FUNC_CTL and TRANS_VRR_VMAX/VMIN/FLIPLINE,
  among other things

So let's reorder the steps to match to avoid the hang, and
toss in an extra WARN to make sure we don't screw this up later.

BSpec: 22243
Cc: stable@vger.kernel.org
Cc: Ankit Nautiyal <ankit.k.nautiyal@intel.com>
Reported-by: Benjamin Tissoires <bentiss@kernel.org>
Closes: https://gitlab.freedesktop.org/drm/i915/kernel/-/issues/15777
Tested-by: Benjamin Tissoires <bentiss@kernel.org>
Fixes: dda7dcd9da73 ("drm/i915/vrr: Use fixed timings for platforms that support VRR")
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patch.msgid.link/20260303095414.4331-1-ville.syrjala@linux.intel.com
Reviewed-by: Ankit Nautiyal <ankit.k.nautiyal@intel.com>
(cherry picked from commit 93f3a267c3dd4d811b224bb9e179a10d81456a74)
Signed-off-by: Tvrtko Ursulin <tursulin@ursulin.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_display.c |    1 -
 drivers/gpu/drm/i915/display/intel_vrr.c     |   14 ++++++++++++++
 2 files changed, 14 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/display/intel_display.c
+++ b/drivers/gpu/drm/i915/display/intel_display.c
@@ -1614,7 +1614,6 @@ static void hsw_configure_cpu_transcoder
 	}
 
 	intel_set_transcoder_timings(crtc_state);
-	intel_vrr_set_transcoder_timings(crtc_state);
 
 	if (cpu_transcoder != TRANSCODER_EDP)
 		intel_de_write(display, TRANS_MULT(display, cpu_transcoder),
--- a/drivers/gpu/drm/i915/display/intel_vrr.c
+++ b/drivers/gpu/drm/i915/display/intel_vrr.c
@@ -529,6 +529,18 @@ void intel_vrr_set_transcoder_timings(co
 		return;
 
 	/*
+	 * Bspec says:
+	 * "(note: VRR needs to be programmed after
+	 *  TRANS_DDI_FUNC_CTL and before TRANS_CONF)."
+	 *
+	 * In practice it turns out that ICL can hang if
+	 * TRANS_VRR_VMAX/FLIPLINE are written before
+	 * enabling TRANS_DDI_FUNC_CTL.
+	 */
+	drm_WARN_ON(display->drm,
+		    !(intel_de_read(display, TRANS_DDI_FUNC_CTL(display, cpu_transcoder)) & TRANS_DDI_FUNC_ENABLE));
+
+	/*
 	 * This bit seems to have two meanings depending on the platform:
 	 * TGL: generate VRR "safe window" for DSB vblank waits
 	 * ADL/DG2: make TRANS_SET_CONTEXT_LATENCY effective with VRR
@@ -754,6 +766,8 @@ void intel_vrr_transcoder_enable(const s
 {
 	struct intel_display *display = to_intel_display(crtc_state);
 
+	intel_vrr_set_transcoder_timings(crtc_state);
+
 	if (!intel_vrr_possible(crtc_state))
 		return;
 


