Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC5F92918EE;
	Wed, 23 Apr 2025 15:19:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421563; cv=none; b=IXSY/sqH+RGcxg234LNnJFiXHpYNbn8ng0wALeK1YWs78E5tYHX4IvLdpewqLGGPDNbfK8zxQkMT7yyLySPQACNZEdb1VavJPjoTyeeyhRIEGN5XMcedABMJQVBZkDcjgYBjjEwmvt/KYtCZ3EbTLnt962c3RDShNv7PZTnyZN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421563; c=relaxed/simple;
	bh=kBeQkmntcoI2tYNYuNQFgwEHVjBle6fyGOJG8t7qlWw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dglRq1Q2BG+Em+G/fkumCOyxX36MiyFTT5MZmyABCoowHBkZG7tDBl7GT476AiR9DI73nJTW1JiAy9BBd4/4i1NYkHTnLXeV6DlEidpbR95juV/ag9IkYRUOIhLoxFDwTX4rgo26+67husQMNN9tbDSvUl9i0NCzoK1xRwfko/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MGOF054P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MGOF054P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4057C4CEE2;
	Wed, 23 Apr 2025 15:19:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421563;
	bh=kBeQkmntcoI2tYNYuNQFgwEHVjBle6fyGOJG8t7qlWw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MGOF054PdvUOiFdACgPEOppVaBmy4HTvSUO74qFK0YcyDaj1kvH32PjM50WZXvZkU
	 FWBNd8dBwTy1Z+TzcK6XIgZVi5S6u0EbuPfKI2clAoFEC1i2lIP8em1tfNkzJwq+4w
	 cvI+4EGgo6YQXm5RhR7N/jozQkNrKdPvPXG/kI9c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Uma Shankar <uma.shankar@intel.com>,
	Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 6.14 202/241] drm/i915: Fix scanline_offset for LNL+ and BMG+
Date: Wed, 23 Apr 2025 16:44:26 +0200
Message-ID: <20250423142628.778529760@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
References: <20250423142620.525425242@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

commit ed583d008edcb021c30ecad2e9d5c868d9ed5862 upstream.

Turns out LNL+ and BMG+ no longer have the weird extra scanline
offset for HDMI outputs. Fix intel_crtc_scanline_offset()
accordingly so that scanline evasion/etc. works correctly on
HDMI outputs on these new platforms.

Cc: stable@vger.kernel.org
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250207215406.19348-2-ville.syrjala@linux.intel.com
Reviewed-by: Uma Shankar <uma.shankar@intel.com>
(cherry picked from commit fede97b72b957b46260ca98fc924ba2b916e50d7)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_vblank.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/display/intel_vblank.c
+++ b/drivers/gpu/drm/i915/display/intel_vblank.c
@@ -222,7 +222,9 @@ int intel_crtc_scanline_offset(const str
 	 * However if queried just before the start of vblank we'll get an
 	 * answer that's slightly in the future.
 	 */
-	if (DISPLAY_VER(display) == 2)
+	if (DISPLAY_VER(display) >= 20 || display->platform.battlemage)
+		return 1;
+	else if (DISPLAY_VER(display) == 2)
 		return -1;
 	else if (HAS_DDI(display) && intel_crtc_has_type(crtc_state, INTEL_OUTPUT_HDMI))
 		return 2;


