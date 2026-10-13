Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA4383D5241;
	Tue, 13 Oct 2026 11:56:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892582; cv=none; b=c9OKSA2fVcguVZPUq9QtEIofHgbxmgTq0dNePBeCDrJrNEqLD/uQTnc7XJXyD6tPGkcyXqpvISAd1eA7zPZLmhAlGrBRbRBMt1mkyCqJF/GxU/cWpoAipzckVxmioxKUbbrNq4d101sVdygN7MMV17jwwlD1t/ov9C9V0cbi5FU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892582; c=relaxed/simple;
	bh=ObJCP5bjre/xy0jorAYx6wdaoSgR4Oos/keezXMeIj0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WV3s9LWWlDvBRY5EZsbLx4a347x/lTzrGg55lSHCdQQ0h7h5SBnVVfTqaJJtf3fYWKki8OZRlMdi4fn/wSy4QJHrBewFFW6Y7d6uDhC08NsQQxXXe77tysiGV+/0IZlWCOHQNgt5A0D5l45vwLjpDuibph+WBj7KeJHXb5L4zB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VpxXPVnJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VpxXPVnJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 393EA1F000FF;
	Tue, 13 Oct 2026 11:56:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892581;
	bh=3j/iQZqBZZKUFLNilWow3jW43tGOdbfF1kIhkDLPO10=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VpxXPVnJZ8kSOg0ijIB5txDBjQTFU0POFHa2Pq4Pqlaf4IyEkC+GZweZHeShQRDNx
	 1xVXUJdWihOYYxDNowRnS9TsSneDf0k4NMAFweFYXfaYiaazoUE8sM7WC1n5o3Ogde
	 d0LnwhI7Dw/gynhUuam9odgAtSQ2cfZAFM1z+rVE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Weiss <luca.weiss@fairphone.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 177/281] clk: qcom: gcc-kaanapali: Fix always-enabling PCIE_RSCC clocks
Date: Tue, 13 Oct 2026 13:38:13 +0200
Message-ID: <20261013112859.461162071@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luca Weiss <luca.weiss@fairphone.com>

[ Upstream commit 0bfb542fc3368371cefb4cf45ef21c3ba2d37c3f ]

The critical_cbrcrs array will get qcom_branch_set_clk_en() called on
each entry which will set BIT(0) to enable the clock. This is however
wrong for these two PCIE_RSCC clocks which need BIT(20) and BIT(21) set
respectively to enable them.

Fixes: d1919c375f21 ("clk: qcom: Add support for Global clock controller on Kaanapali")
Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
Link: https://lore.kernel.org/r/20260807-various-pcie-clk-fix-v1-3-5caf78a599d7@fairphone.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-kaanapali.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/qcom/gcc-kaanapali.c b/drivers/clk/qcom/gcc-kaanapali.c
index 842c1a70c6916..5bcbcd1786577 100644
--- a/drivers/clk/qcom/gcc-kaanapali.c
+++ b/drivers/clk/qcom/gcc-kaanapali.c
@@ -3464,8 +3464,6 @@ static const u32 gcc_kaanapali_critical_cbcrs[] = {
 	0x9f004, /* GCC_EVA_AHB_CLK */
 	0x9f024, /* GCC_EVA_XO_CLK */
 	0x71004, /* GCC_GPU_CFG_AHB_CLK */
-	0x52010, /* GCC_PCIE_RSCC_CFG_AHB_CLK */
-	0x52010, /* GCC_PCIE_RSCC_XO_CLK */
 	0x32004, /* GCC_VIDEO_AHB_CLK */
 	0x32040, /* GCC_VIDEO_XO_CLK */
 };
@@ -3480,6 +3478,10 @@ static const struct regmap_config gcc_kaanapali_regmap_config = {
 
 static void clk_kaanapali_regs_configure(struct device *dev, struct regmap *regmap)
 {
+	/* Keep clocks always enabled */
+	regmap_update_bits(regmap, 0x52010, BIT(20), BIT(20)); /* GCC_PCIE_RSCC_CFG_AHB_CLK */
+	regmap_update_bits(regmap, 0x52010, BIT(21), BIT(21)); /* GCC_PCIE_RSCC_XO_CLK */
+
 	/* FORCE_MEM_CORE_ON for ufs phy ice core clocks */
 	qcom_branch_set_force_mem_core(regmap, gcc_ufs_phy_ice_core_clk, true);
 }
-- 
2.53.0



