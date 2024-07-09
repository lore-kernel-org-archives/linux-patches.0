Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D9A627713;
	Tue,  9 Jul 2024 11:26:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524403; cv=none; b=fmfXwsg1DxYevIuIoboHENWV1BscystTnQftFF6S4r7Mp5uuTgqzM8R6d3pNt32axTaiRx46FugbqelmAMKvjFem6sOaSQ3GI1HtasmuXEKu74Degs+xF9SCRAkJYILkPj6kFpa79exlL1XBdPbVVZjT37MI/10ULT26v8OPpJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524403; c=relaxed/simple;
	bh=FJADvsO/qheMq8ZV7tdyRTzXaZhkpR+hmEmir2LXwDY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sRrxhOucT/gs97MsIvSh7940TIuIAYaZ9uLq3vyPR7y8ky/dtvA1Nus8LkhsM69fzznVvLda3EIC2wFKudKy8v5k+N7aeDuKFKcd8YndgA+GvfzXlfH2eD/vNdf2Y3/QKzYGm09yN/RW4OZ069DvxYGEQjAlzMHnfGdFq3OvgHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ufZjCz1U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ufZjCz1U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12318C3277B;
	Tue,  9 Jul 2024 11:26:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524403;
	bh=FJADvsO/qheMq8ZV7tdyRTzXaZhkpR+hmEmir2LXwDY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ufZjCz1UT5MfYOGFcXdgZRKBTtoYidgfvWY7jVyfzguzs6A3nRxrVZsU5fXwy80CQ
	 96xmya10q9ReygC8PrPhqspk+VYrv1CKahoH8tKbRhwRr1rnLM/oltPPgbLwCf04Up
	 2TcXCKNwQpPMpK0OnSgruFxEdodRRO/0bvQJ1O1A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabor Juhos <j4g8y7@gmail.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 171/197] clk: qcom: clk-alpha-pll: set ALPHA_EN bit for Stromer Plus PLLs
Date: Tue,  9 Jul 2024 13:10:25 +0200
Message-ID: <20240709110715.568561061@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110708.903245467@linuxfoundation.org>
References: <20240709110708.903245467@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index be18ff983d35c..003308a288968 100644
--- a/drivers/clk/qcom/clk-alpha-pll.c
+++ b/drivers/clk/qcom/clk-alpha-pll.c
@@ -2555,6 +2555,9 @@ static int clk_alpha_pll_stromer_plus_set_rate(struct clk_hw *hw,
 	regmap_write(pll->clkr.regmap, PLL_ALPHA_VAL_U(pll),
 					a >> ALPHA_BITWIDTH);
 
+	regmap_update_bits(pll->clkr.regmap, PLL_USER_CTL(pll),
+			   PLL_ALPHA_EN, PLL_ALPHA_EN);
+
 	regmap_write(pll->clkr.regmap, PLL_MODE(pll), PLL_BYPASSNL);
 
 	/* Wait five micro seconds or more */
-- 
2.43.0



