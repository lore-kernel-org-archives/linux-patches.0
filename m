Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87DE54F391C;
	Thu, 17 Sep 2026 15:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660784; cv=none; b=paB/YqugkG/oeKj9D+qrnC4z4m+A2tMhoBVxrSR5ctGmywoledX712e0sRE8eYebmA5/KiP28CUvhKraqRVpfBRaBHrEbZop0YZeVLAy/AT+hhbsMyTG/xcfpSJMraUtbcPWIgpnBac67mVnfZinME1UB+meRd+4RUAm319yGHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660784; c=relaxed/simple;
	bh=ofrimhNj/RbyvyqvFAy7RVhKTKotvPDy3gbGqjlB9lQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lAN1tfNBKW1QP+MbmsKgMT1tXcKXuVaM7lisvdWxG3zcZi9vbO6u65jZIq1vMnqguYgZ8XiiKLaJRe+WFN267//zHGfJCw0a1mnuZHpZDLysL3lYDPJR3K83gUiodJrVD+W3muQZJOo4DGzTgaq3HoTeC4DuVlBAv5p9JeefvkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t585ebIU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t585ebIU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0EF31F000FF;
	Thu, 17 Sep 2026 15:59:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660783;
	bh=fo5+pxpqwoP95MToe4aj5+x/pq/4KGQHSPFm98i1WGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t585ebIUMgW/lX2BNdnNt5459Sg9GfUwAG7YfxWXOEUds4/OkLp/hCOmKidAp8NjH
	 yfFviksj8KJ4DwWZwKlR6YKwlpNMrE7V9kidg+SxqAToSYzFEH1tF+qwTWdwhzZiiQ
	 UIFNBe8OLQE9cUg4pVjD+Pltlk1Gw+cBa6cdqDUE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Suraj Kandpal <suraj.kandpal@intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 709/733] drm/i915/cdclk: Avoid spurious cdclk sanitization on PTL+
Date: Thu, 17 Sep 2026 16:16:57 +0100
Message-ID: <20260917151410.553108309@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

[ Upstream commit aad969968824e97ba8d70dd7a95691f750438ebd ]

Apparently PTL+ no longer has the cd2x pipe select field in
CDCLK_CTL. Take that into account during CDCLK sanitization.

This currently triggers a spurious CDCLK sanitization during
driver load on PTL+ which will causes a visible glitch on all
active displays.

Cc: stable@vger.kernel.org
Closes: https://gitlab.freedesktop.org/drm/xe/kernel/-/work_items/8550
Fixes: 2ee8dbd880b1 ("drm/i915/cdclk: Fix up CDCLK_FREQ_DECIMAL without a full PLL re-enable")
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patch.msgid.link/20260717155107.17801-1-ville.syrjala@linux.intel.com
Reviewed-by: Suraj Kandpal <suraj.kandpal@intel.com>
(cherry picked from commit 1786d26887817a779641d3a093c66ac91382113b)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
[ Replaced bxt_cdclk_cd2x_pipe_mask(display) with the equivalent bxt_cdclk_cd2x_pipe(display, INVALID_PIPE). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_cdclk.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/i915/display/intel_cdclk.c
+++ b/drivers/gpu/drm/i915/display/intel_cdclk.c
@@ -2366,8 +2366,10 @@ static void bxt_sanitize_cdclk(struct in
 	 * dividers both syncing to an active pipe, or asynchronously
 	 * (PIPE_NONE).
 	 */
-	cdctl &= ~bxt_cdclk_cd2x_pipe(display, INVALID_PIPE);
-	cdctl |= bxt_cdclk_cd2x_pipe(display, INVALID_PIPE);
+	if (DISPLAY_VER(display) < 30) {
+		cdctl &= ~bxt_cdclk_cd2x_pipe(display, INVALID_PIPE);
+		cdctl |= bxt_cdclk_cd2x_pipe(display, INVALID_PIPE);
+	}
 
 	if (cdctl != expected) {
 		if (DISPLAY_VER(display) < 20) {


