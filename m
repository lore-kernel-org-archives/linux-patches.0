Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F409A1E25E1;
	Wed, 30 Jul 2025 09:52:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753869141; cv=none; b=X3AxOHKZiOM7C58zQLovjfZJ7QsVpXbxPERu4QsZmipdL68GNyLNExmS30WEjiIHl4F3KrUmyk60vb/PEPVNMyMOuV388hzjJglNEi/iS0BsQXtkg2ZtSTLiW99TJPuEig0yUphm0nGB9R2RK5eT83Br51IAfEiePpTS7OomSP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753869141; c=relaxed/simple;
	bh=LJhAdgqr3OsZ5Tqcrk+ox91gkhpBUiQSO49GiDIuMHU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=P14zbbLx9Ma+7XRSZ1XUOWeMeZhj0IItgbvCE4JesI2NATrNf/qHTT4fJRZMicNFEyvbMisDDWUWfZW6GIKrRHam8qQ5UBadcjYpRjj1clLrcZYDXBAUcFRFBm0aHICVQVSuK9/DVRMBHbuu4l9P+7L9KRbLlQ5cr+xoV2g38sI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fHkKTyHK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fHkKTyHK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF499C4CEF5;
	Wed, 30 Jul 2025 09:52:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753869139;
	bh=LJhAdgqr3OsZ5Tqcrk+ox91gkhpBUiQSO49GiDIuMHU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fHkKTyHKbr25Ate+H7Y5tGmSg/1jqgepTFvh6ULs/s0wGf8JSLbmL7XJF1e7jw34n
	 nR+wajeugK6XB51CJLwy/62VG1f5Eq9YO/5VtQRj1zMoIhgkLhMBxkZqbtyIlDvQRy
	 zR82frWfd432zlkvhsVHiaC8ZpcYN4zlGm2sKIoE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Imre Deak <imre.deak@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 6.15 46/92] drm/i915/dp: Fix 2.7 Gbps DP_LINK_BW value on g4x
Date: Wed, 30 Jul 2025 11:35:54 +0200
Message-ID: <20250730093232.539469022@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093230.629234025@linuxfoundation.org>
References: <20250730093230.629234025@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

commit 9e0c433d0c05fde284025264b89eaa4ad59f0a3e upstream.

On g4x we currently use the 96MHz non-SSC refclk, which can't actually
generate an exact 2.7 Gbps link rate. In practice we end up with 2.688
Gbps which seems to be close enough to actually work, but link training
is currently failing due to miscalculating the DP_LINK_BW value (we
calcualte it directly from port_clock which reflects the actual PLL
outpout frequency).

Ideas how to fix this:
- nudge port_clock back up to 270000 during PLL computation/readout
- track port_clock and the nominal link rate separately so they might
  differ a bit
- switch to the 100MHz refclk, but that one should be SSC so perhaps
  not something we want

While we ponder about a better solution apply some band aid to the
immediate issue of miscalculated DP_LINK_BW value. With this
I can again use 2.7 Gbps link rate on g4x.

Cc: stable@vger.kernel.org
Fixes: 665a7b04092c ("drm/i915: Feed the DPLL output freq back into crtc_state")
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250710201718.25310-2-ville.syrjala@linux.intel.com
Reviewed-by: Imre Deak <imre.deak@intel.com>
(cherry picked from commit a8b874694db5cae7baaf522756f87acd956e6e66)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_dp.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/gpu/drm/i915/display/intel_dp.c
+++ b/drivers/gpu/drm/i915/display/intel_dp.c
@@ -1603,6 +1603,12 @@ int intel_dp_rate_select(struct intel_dp
 void intel_dp_compute_rate(struct intel_dp *intel_dp, int port_clock,
 			   u8 *link_bw, u8 *rate_select)
 {
+	struct intel_display *display = to_intel_display(intel_dp);
+
+	/* FIXME g4x can't generate an exact 2.7GHz with the 96MHz non-SSC refclk */
+	if (display->platform.g4x && port_clock == 268800)
+		port_clock = 270000;
+
 	/* eDP 1.4 rate select method. */
 	if (intel_dp->use_rate_select) {
 		*link_bw = 0;


