Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D9A01D0DE9;
	Wed,  2 Oct 2024 14:08:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878126; cv=none; b=stLLQsI2OKFBZwrvHZmH7Z6nz5qEACq4THlcoo/dL8DKFHkg+cowcEGz1qP9TjRjS3L8paNoKqcVlCaSrc/lk5n44KvVWtMQLpWAphPk9tL8+Hjx5RnYm07z17Fbdw6iz9oXdKcQ4nmPdnSsBZyOrfS548JE5RSSxEf822uka+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878126; c=relaxed/simple;
	bh=DphxnEGc/4vacRonEo+F1Y3OnAFg425ljvPHPYVChkg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WUmsDlbk1ELUUOynkcfSSpiJg0PXwEL8c/oApcX+mMoPKiDcZnmofxnXH42oCuImJYBa6tDjlQDJY6WTRXudmIToHjTWYnXsY4mOKAJRUUH/7r0w+LN/J8ygzZzuCTuK4ZiGiYyB+H2Nv5GUMTw5OmGv0aFYk7t//6p2Oe3CIRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lCHYtIFO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lCHYtIFO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07A0FC4CEC2;
	Wed,  2 Oct 2024 14:08:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878126;
	bh=DphxnEGc/4vacRonEo+F1Y3OnAFg425ljvPHPYVChkg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lCHYtIFOZR/EkNVHDuKi70Qufw9yRvK4g7T22FJ/17GdKCL+/e8kEKVPn5bTiSBhK
	 fZN3tLJuOJm4Od5Xwdd+VcgCedQdQOTsSj22hJ7uD0ORc0hl51wfymLT8H034pvOwH
	 5st2s0abHoutvSPotN3RHxC7/tPe0bleiwnp8BOs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacky Bai <ping.bai@nxp.com>,
	Peng Fan <peng.fan@nxp.com>,
	Chancel Liu <chancel.liu@nxp.com>,
	Abel Vesa <abel.vesa@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 311/634] clk: imx: composite-93: keep root clock on when mcore enabled
Date: Wed,  2 Oct 2024 14:56:51 +0200
Message-ID: <20241002125823.383031031@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

From: Jacky Bai <ping.bai@nxp.com>

[ Upstream commit d342df11726bfac9c3a9d2037afa508ac0e9e44e ]

Previously we assumed that the root clock slice is enabled
by default when kernel boot up. But the bootloader may disable
the clocks before jump into kernel. The gate ops should be registered
rather than NULL to make sure the disabled clock can be enabled
when kernel boot up.  Refine the code to skip disable the clock
if mcore booted.

Fixes: a740d7350ff7 ("clk: imx: imx93: add mcore_booted module paratemter")
Signed-off-by: Jacky Bai <ping.bai@nxp.com>
Reviewed-by: Peng Fan <peng.fan@nxp.com>
Tested-by: Chancel Liu <chancel.liu@nxp.com>
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Reviewed-by: Abel Vesa <abel.vesa@linaro.org>
Link: https://lore.kernel.org/r/20240607133347.3291040-3-peng.fan@oss.nxp.com
Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/imx/clk-composite-93.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/clk/imx/clk-composite-93.c b/drivers/clk/imx/clk-composite-93.c
index 81164bdcd6cc9..6c6c5a30f3282 100644
--- a/drivers/clk/imx/clk-composite-93.c
+++ b/drivers/clk/imx/clk-composite-93.c
@@ -76,6 +76,13 @@ static int imx93_clk_composite_gate_enable(struct clk_hw *hw)
 
 static void imx93_clk_composite_gate_disable(struct clk_hw *hw)
 {
+	/*
+	 * Skip disable the root clock gate if mcore enabled.
+	 * The root clock may be used by the mcore.
+	 */
+	if (mcore_booted)
+		return;
+
 	imx93_clk_composite_gate_endisable(hw, 0);
 }
 
@@ -222,7 +229,7 @@ struct clk_hw *imx93_clk_composite_flags(const char *name, const char * const *p
 		hw = clk_hw_register_composite(NULL, name, parent_names, num_parents,
 					       mux_hw, &clk_mux_ro_ops, div_hw,
 					       &clk_divider_ro_ops, NULL, NULL, flags);
-	} else if (!mcore_booted) {
+	} else {
 		gate = kzalloc(sizeof(*gate), GFP_KERNEL);
 		if (!gate)
 			goto fail;
@@ -238,12 +245,6 @@ struct clk_hw *imx93_clk_composite_flags(const char *name, const char * const *p
 					       &imx93_clk_composite_divider_ops, gate_hw,
 					       &imx93_clk_composite_gate_ops,
 					       flags | CLK_SET_RATE_NO_REPARENT);
-	} else {
-		hw = clk_hw_register_composite(NULL, name, parent_names, num_parents,
-					       mux_hw, &imx93_clk_composite_mux_ops, div_hw,
-					       &imx93_clk_composite_divider_ops, NULL,
-					       &imx93_clk_composite_gate_ops,
-					       flags | CLK_SET_RATE_NO_REPARENT);
 	}
 
 	if (IS_ERR(hw))
-- 
2.43.0



