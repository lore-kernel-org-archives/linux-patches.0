Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52F612192EC;
	Mon, 23 Jun 2025 22:24:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750717494; cv=none; b=ikl62HW/5mO7XBGSmOd9B1uPuKudmKWsT4Wm4U7eHsrH16TYS5Y/JPV4lbbzfZQFaOaIPZTtdar3aHMGn2L81zjASzAtQeH8xVarFMKEtome/5TEK1gh3FZMXkE+la8iDOh4+8bR1fx9u2yUMWcsY2cXBUy9Sh4q2nqW2dqRSbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750717494; c=relaxed/simple;
	bh=NAdYHWS/Tt9F5h7kqL/IYOWPIasEcj3PzORRB6cEyeY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rgh9w0TtYsU/NBQzkGc57NjHdnKR1ad36q2iYnrtDWZ8CywGm+W8FldcDiG19PmLhwZKAYlsJ79ssikzM7WeqHvJEcjs2t04jSbSOfFIeOGLie5F5rCpjheAeLXvdEeLg3DKiEamdy7VkrL5zJtt+Qp8u3bIiExnEQVnPQMcUyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cFOKPxzP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cFOKPxzP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4D2BC4CEEA;
	Mon, 23 Jun 2025 22:24:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750717494;
	bh=NAdYHWS/Tt9F5h7kqL/IYOWPIasEcj3PzORRB6cEyeY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cFOKPxzPnQLw8M9VwV99eiOuacrbBjsGGMSR6GO7WF8v9BTNDXc1l7odkr0Q1aJ87
	 UB1N72rV5qBlNG8R45h3E2jgdJCjd2kVYKF9gGSB+dlhQ7obst80z+hj4S3cmQ+ElR
	 Bke0ZK+sRCJsJrS7OdCphygGCgX5vJIr3rBbFkDc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 354/414] drm/msm/dsi/dsi_phy_10nm: Fix missing initial VCO rate
Date: Mon, 23 Jun 2025 15:08:11 +0200
Message-ID: <20250623130650.823022313@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit 8a48e35becb214743214f5504e726c3ec131cd6d ]

Driver unconditionally saves current state on first init in
dsi_pll_10nm_init(), but does not save the VCO rate, only some of the
divider registers.  The state is then restored during probe/enable via
msm_dsi_phy_enable() -> msm_dsi_phy_pll_restore_state() ->
dsi_10nm_pll_restore_state().

Restoring calls dsi_pll_10nm_vco_set_rate() with
pll_10nm->vco_current_rate=0, which basically overwrites existing rate of
VCO and messes with clock hierarchy, by setting frequency to 0 to clock
tree.  This makes anyway little sense - VCO rate was not saved, so
should not be restored.

If PLL was not configured configure it to minimum rate to avoid glitches
and configuring entire in clock hierarchy to 0 Hz.

Suggested-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/sz4kbwy5nwsebgf64ia7uq4ee7wbsa5uy3xmlqwcstsbntzcov@ew3dcyjdzmi2/
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Fixes: a4ccc37693a2 ("drm/msm/dsi_pll_10nm: restore VCO rate during
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/654796/
Link: https://lore.kernel.org/r/20250520111325.92352-2-krzysztof.kozlowski@linaro.org
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dsi/phy/dsi_phy_10nm.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/gpu/drm/msm/dsi/phy/dsi_phy_10nm.c b/drivers/gpu/drm/msm/dsi/phy/dsi_phy_10nm.c
index 677c625718119..28cc550e22a88 100644
--- a/drivers/gpu/drm/msm/dsi/phy/dsi_phy_10nm.c
+++ b/drivers/gpu/drm/msm/dsi/phy/dsi_phy_10nm.c
@@ -703,6 +703,13 @@ static int dsi_pll_10nm_init(struct msm_dsi_phy *phy)
 	/* TODO: Remove this when we have proper display handover support */
 	msm_dsi_phy_pll_save_state(phy);
 
+	/*
+	 * Store also proper vco_current_rate, because its value will be used in
+	 * dsi_10nm_pll_restore_state().
+	 */
+	if (!dsi_pll_10nm_vco_recalc_rate(&pll_10nm->clk_hw, VCO_REF_CLK_RATE))
+		pll_10nm->vco_current_rate = pll_10nm->phy->cfg->min_pll_rate;
+
 	return 0;
 }
 
-- 
2.39.5



