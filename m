Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD97A158219;
	Tue,  9 Jul 2024 11:18:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720523897; cv=none; b=hD/A2pjh0NMt+++ayXokBcjaD+CzCSfMYgdPuSPtgtDo+6AzEjKBGnY2uMdfG/IKTFLCs9jvWSz9JvhGwbHxqiWWzfAlHkDdVgfqpWFmHdP/fuEUYH3Ss32jESoAEWmsgndhw1MMAytoHI3XFe6hZbTyz7OmwaA5q7kx+GHokwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720523897; c=relaxed/simple;
	bh=jEBkeyDUBYGQpQRIOk4MtS9Qnon83NXLuL2xf6aO7NY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D7J0knSwUAeneryGTdcq8IPa/i+fL7TRO/RArQ+8t85+m40u6mJEi9L0FiNEfeT+t2MobO962TWODsxlM+1yOzvDTIxOX12W9Mw1e3rs8XJyb3su5s+4W1fIfezTvS1e4lpl9YkLXJNuwAQ9ydUK2B/N4OSMP/M0f8RvlO4JXOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=blDy4bzB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="blDy4bzB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EB1AC3277B;
	Tue,  9 Jul 2024 11:18:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720523897;
	bh=jEBkeyDUBYGQpQRIOk4MtS9Qnon83NXLuL2xf6aO7NY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=blDy4bzBpa5S52vEVyufuUaRlzlP+4HLjC+nsugUiVpFM2j6Bfm4Tgsaiq9e1CwfD
	 6Fb39GJ1L40b9G6U1mbUncIXxVtw6waxWVKmKlNVUchhlJ649wCkUKA5k9Cjuiahi8
	 OZ30+MRgeS97vP2LvXJjT82fnnqOoesd6C/2/l54=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabor Juhos <j4g8y7@gmail.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 119/139] clk: qcom: clk-alpha-pll: set ALPHA_EN bit for Stromer Plus PLLs
Date: Tue,  9 Jul 2024 13:10:19 +0200
Message-ID: <20240709110702.772163026@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110658.146853929@linuxfoundation.org>
References: <20240709110658.146853929@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gabor Juhos <j4g8y7@gmail.com>

[ Upstream commit 5a33a64524e6381c399e5e42571d9363ffc0bed4 ]

The clk_alpha_pll_stromer_plus_set_rate() function does not
sets the ALPHA_EN bit in the USER_CTL register, so setting
rates which requires using alpha mode works only if the bit
gets set already prior calling the function.

Extend the function to set the ALPHA_EN bit in order to allow
using fractional rates regardless whether the bit gets set
previously or not.

Fixes: 84da48921a97 ("clk: qcom: clk-alpha-pll: introduce stromer plus ops")
Signed-off-by: Gabor Juhos <j4g8y7@gmail.com>
Link: https://lore.kernel.org/r/20240508-stromer-plus-alpha-en-v1-1-6639ce01ca5b@gmail.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/clk-alpha-pll.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/clk/qcom/clk-alpha-pll.c b/drivers/clk/qcom/clk-alpha-pll.c
index 5cf862b0bb62a..85aa089650eaa 100644
--- a/drivers/clk/qcom/clk-alpha-pll.c
+++ b/drivers/clk/qcom/clk-alpha-pll.c
@@ -2510,6 +2510,9 @@ static int clk_alpha_pll_stromer_plus_set_rate(struct clk_hw *hw,
 	regmap_write(pll->clkr.regmap, PLL_ALPHA_VAL_U(pll),
 					a >> ALPHA_BITWIDTH);
 
+	regmap_update_bits(pll->clkr.regmap, PLL_USER_CTL(pll),
+			   PLL_ALPHA_EN, PLL_ALPHA_EN);
+
 	regmap_write(pll->clkr.regmap, PLL_MODE(pll), PLL_BYPASSNL);
 
 	/* Wait five micro seconds or more */
-- 
2.43.0



