Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFF3F2E337A;
	Tue,  8 Jul 2025 16:45:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993111; cv=none; b=WONflk9lC1ryDQB4PsOVZPhk0NOer+HTLpdDmLIr8Jl3g7yqThsWdhBqrsyafz0sYL/SVa3IkhGquJybKI/b4l6jZt/wNZCYhFHB8JTRD5nykMIqi9eefuOTVKUbRuqwlT0WC1/u/wQR1l3Gf/eBJY2oT6u61wBcDIvgFeLiBG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993111; c=relaxed/simple;
	bh=lD70CuOubs17uYSKRXCkmGLMHlS/359o0AdpVY+scYU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qYKL84ihHnK9PqIT/VylCVBSGJMcvqhPFI8xmmTxyFTo/W9L+ErHLG9yomBF++uXScrevz8iYlPq6kugRnYDEjXB1nK1C/xOdGWEOt7TFfKYoEUpQBRvDY3tgeldlTvi3egxP5stWC+KDTdT152g3JX6d25z2FC7U2ytJi5VfBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tidmuHIY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tidmuHIY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57E4FC4CEED;
	Tue,  8 Jul 2025 16:45:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993111;
	bh=lD70CuOubs17uYSKRXCkmGLMHlS/359o0AdpVY+scYU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tidmuHIYWYJznPzlnF/DzY1XGzj3A3qjzfjmPYivhI5RTQ1Z0/niYZ/p468w+XUxC
	 PpI8LrbcaqiTT04FvMUN4NqaCNDNJZKATgGG7bBuEmh2Rn6vcbE3HDOd5xSuVjt/x+
	 9sla9rmNFwWIgZe4hA8KJGafKXV2U6bV8jpCXKq4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Imre Deak <imre.deak@intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 164/232] drm/i915/dp_mst: Work around Thunderbolt sink disconnect after SINK_COUNT_ESI read
Date: Tue,  8 Jul 2025 18:22:40 +0200
Message-ID: <20250708162245.728587400@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162241.426806072@linuxfoundation.org>
References: <20250708162241.426806072@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Imre Deak <imre.deak@intel.com>

[ Upstream commit 9cb15478916e849d62a6ec44b10c593b9663328c ]

Due to a problem in the iTBT DP-in adapter's firmware the sink on a TBT
link may get disconnected inadvertently if the SINK_COUNT_ESI and the
DP_LINK_SERVICE_IRQ_VECTOR_ESI0 registers are read in a single AUX
transaction. Work around the issue by reading these registers in
separate transactions.

The issue affects MTL+ platforms and will be fixed in the DP-in adapter
firmware, however releasing that firmware fix may take some time and is
not guaranteed to be available for all systems. Based on this apply the
workaround on affected platforms.

See HSD #13013007775.

v2: Cc'ing Mika Westerberg.

Closes: https://gitlab.freedesktop.org/drm/i915/kernel/-/issues/13760
Closes: https://gitlab.freedesktop.org/drm/i915/kernel/-/issues/14147
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: stable@vger.kernel.org
Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Imre Deak <imre.deak@intel.com>
Link: https://lore.kernel.org/r/20250519133417.1469181-1-imre.deak@intel.com
(cherry picked from commit c3a48363cf1f76147088b1adb518136ac5df86a0)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_dp.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/gpu/drm/i915/display/intel_dp.c b/drivers/gpu/drm/i915/display/intel_dp.c
index 45cca965c11b4..ca9e0c730013d 100644
--- a/drivers/gpu/drm/i915/display/intel_dp.c
+++ b/drivers/gpu/drm/i915/display/intel_dp.c
@@ -4300,6 +4300,24 @@ intel_dp_mst_disconnect(struct intel_dp *intel_dp)
 static bool
 intel_dp_get_sink_irq_esi(struct intel_dp *intel_dp, u8 *esi)
 {
+	struct intel_display *display = to_intel_display(intel_dp);
+	struct drm_i915_private *i915 = dp_to_i915(intel_dp);
+
+	/*
+	 * Display WA for HSD #13013007775: mtl/arl/lnl
+	 * Read the sink count and link service IRQ registers in separate
+	 * transactions to prevent disconnecting the sink on a TBT link
+	 * inadvertently.
+	 */
+	if (IS_DISPLAY_VER(display, 14, 20) && !IS_BATTLEMAGE(i915)) {
+		if (drm_dp_dpcd_read(&intel_dp->aux, DP_SINK_COUNT_ESI, esi, 3) != 3)
+			return false;
+
+		/* DP_SINK_COUNT_ESI + 3 == DP_LINK_SERVICE_IRQ_VECTOR_ESI0 */
+		return drm_dp_dpcd_readb(&intel_dp->aux, DP_LINK_SERVICE_IRQ_VECTOR_ESI0,
+					 &esi[3]) == 1;
+	}
+
 	return drm_dp_dpcd_read(&intel_dp->aux, DP_SINK_COUNT_ESI, esi, 4) == 4;
 }
 
-- 
2.39.5



