Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AF4883CD9;
	Wed,  7 Aug 2024 15:05:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043122; cv=none; b=hg7UquNyqIBXEqH4cIfdJUBzNRPk/esB35otGTnFX0jRuLlM5DlqCogfDAo0VWAKxf+C5N5ftQIG+gAER21HAFv9Fg10cRoH2O0L7UUOPjh7ZczEMUPk4h4sMseOmspUJScNzLq3DFQG9ByPIuokxp0Wktc5oaGv9Li+P9jCGWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043122; c=relaxed/simple;
	bh=0ZMDucG3wYAKmvd87Zf4qfIpTZCc+9mj99SDwu2t2MU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iiff1BGFJXLdumcSIssCzQElfGDGjnlZZtNP3bo8SjteE684uXxBCpnrZVsbAWEjhFWYue63ZiEMrGyF7J1XEIc308Xp19811fmuJFvWkvB6/8DDF6syNDVrit5djzS7aqNoclGBOPVgw7NmYS8VofMNXavG0xx1QSsY2Z6NOdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kI15simX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kI15simX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F13EC32781;
	Wed,  7 Aug 2024 15:05:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043122;
	bh=0ZMDucG3wYAKmvd87Zf4qfIpTZCc+9mj99SDwu2t2MU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kI15simXG70bjp7eWxOoW3QkJCeSTfcmg53q5dE7wxx4ELEl1R5pyMZ0HOgbZo86d
	 zB2dgp9BIjHt8N+botfrlBOMNQG3CgVK3Wwy3XpUzIhJpIKVhzmNRlSNDjIGIursKS
	 AraVuhuGWrQTP3Txopu76w4IYd9DyKHJ78/Ca8eU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikita Zhandarovich <n.zhandarovich@fintech.ru>,
	Jani Nikula <jani.nikula@intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Subject: [PATCH 6.10 097/123] drm/i915: Fix possible int overflow in skl_ddi_calculate_wrpll()
Date: Wed,  7 Aug 2024 17:00:16 +0200
Message-ID: <20240807150023.971084132@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150020.790615758@linuxfoundation.org>
References: <20240807150020.790615758@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikita Zhandarovich <n.zhandarovich@fintech.ru>

commit 5b511572660190db1dc8ba412efd0be0d3781ab6 upstream.

On the off chance that clock value ends up being too high (by means
of skl_ddi_calculate_wrpll() having been called with big enough
value of crtc_state->port_clock * 1000), one possible consequence
may be that the result will not be able to fit into signed int.

Fix this issue by moving conversion of clock parameter from kHz to Hz
into the body of skl_ddi_calculate_wrpll(), as well as casting the
same parameter to u64 type while calculating the value for AFE clock.
This both mitigates the overflow problem and avoids possible erroneous
integer promotion mishaps.

Found by Linux Verification Center (linuxtesting.org) with static
analysis tool SVACE.

Fixes: 82d354370189 ("drm/i915/skl: Implementation of SKL DPLL programming")
Cc: stable@vger.kernel.org
Signed-off-by: Nikita Zhandarovich <n.zhandarovich@fintech.ru>
Reviewed-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240729174035.25727-1-n.zhandarovich@fintech.ru
(cherry picked from commit 833cf12846aa19adf9b76bc79c40747726f3c0c1)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_dpll_mgr.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/i915/display/intel_dpll_mgr.c
+++ b/drivers/gpu/drm/i915/display/intel_dpll_mgr.c
@@ -1658,7 +1658,7 @@ static void skl_wrpll_params_populate(st
 }
 
 static int
-skl_ddi_calculate_wrpll(int clock /* in Hz */,
+skl_ddi_calculate_wrpll(int clock,
 			int ref_clock,
 			struct skl_wrpll_params *wrpll_params)
 {
@@ -1683,7 +1683,7 @@ skl_ddi_calculate_wrpll(int clock /* in
 	};
 	unsigned int dco, d, i;
 	unsigned int p0, p1, p2;
-	u64 afe_clock = clock * 5; /* AFE Clock is 5x Pixel clock */
+	u64 afe_clock = (u64)clock * 1000 * 5; /* AFE Clock is 5x Pixel clock, in Hz */
 
 	for (d = 0; d < ARRAY_SIZE(dividers); d++) {
 		for (dco = 0; dco < ARRAY_SIZE(dco_central_freq); dco++) {
@@ -1808,7 +1808,7 @@ static int skl_ddi_hdmi_pll_dividers(str
 	struct skl_wrpll_params wrpll_params = {};
 	int ret;
 
-	ret = skl_ddi_calculate_wrpll(crtc_state->port_clock * 1000,
+	ret = skl_ddi_calculate_wrpll(crtc_state->port_clock,
 				      i915->display.dpll.ref_clks.nssc, &wrpll_params);
 	if (ret)
 		return ret;


