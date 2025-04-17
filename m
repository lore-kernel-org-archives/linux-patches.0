Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 810714502F;
	Thu, 17 Apr 2025 18:47:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915631; cv=none; b=gsN5J/hu1RraFTFGHDNOFfX9UCjGQlEZ3jQU78jE4l/VYwE468fmWd1Q6bImoHDu9jPn9C+xAP6kHv9o/2Qlleq9c4zcVLxKpYT6vkqKrZ2NypfzfLB3vk72nX7lAPyw2kgxm/LmF4DhIY3FKi3FKzvgi4aHEsftwdlvJoJhP3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915631; c=relaxed/simple;
	bh=lS+WRHj9UZUXF9WLy4USpRlUxYq+iMTGCOCFBbrqlqw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=H3uJPaX/CWirDzwvoSKLTk5/pvK+wqoXkCxv5VVqvE+i1Fy1eRRmgxdgLKVBiDUU/KAl1XTy22FVvtvP3Y1nRvFpdKf8IqCkeaQeIQ1ypRoJgEx0DLjGxGHM0dWKqYAggRkVgrkkr0iTNd3WWoaGP71OFDo7xLRpRn3iVK1ILkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SBW0/rn/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SBW0/rn/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08F26C4CEE7;
	Thu, 17 Apr 2025 18:47:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915631;
	bh=lS+WRHj9UZUXF9WLy4USpRlUxYq+iMTGCOCFBbrqlqw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SBW0/rn/qoOGy7MwExwmm1ZDFLtgkkTL5mcbQiLE2aTZOyVRZcpKOKu4iZaJ17bNy
	 uZ0m900Puty9QhAt5EmNbkJFDFGuJoH8frNHQVhXTC4SpeEXQqeHHUEqhfSZSvcUTR
	 39dDTn2/KnCTTSiYOzpqHqu/sGnNNV5CpXTumZ3I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 159/393] pwm: mediatek: Prevent divide-by-zero in pwm_mediatek_config()
Date: Thu, 17 Apr 2025 19:49:28 +0200
Message-ID: <20250417175113.978148101@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josh Poimboeuf <jpoimboe@kernel.org>

[ Upstream commit 7ca59947b5fcf94e7ea4029d1bd0f7c41500a161 ]

With CONFIG_COMPILE_TEST && !CONFIG_HAVE_CLK, pwm_mediatek_config() has a
divide-by-zero in the following line:

	do_div(resolution, clk_get_rate(pc->clk_pwms[pwm->hwpwm]));

due to the fact that the !CONFIG_HAVE_CLK version of clk_get_rate()
returns zero.

This is presumably just a theoretical problem: COMPILE_TEST overrides
the dependency on RALINK which would select COMMON_CLK.  Regardless it's
a good idea to check for the error explicitly to avoid divide-by-zero.

Fixes the following warning:

  drivers/pwm/pwm-mediatek.o: warning: objtool: .text: unexpected end of section

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Link: https://lore.kernel.org/r/fb56444939325cc173e752ba199abd7aeae3bf12.1742852847.git.jpoimboe@kernel.org
[ukleinek: s/CONFIG_CLK/CONFIG_HAVE_CLK/]
Fixes: caf065f8fd58 ("pwm: Add MediaTek PWM support")
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@baylibre.com>
Link: https://lore.kernel.org/r/9e78a0796acba3435553ed7db1c7965dcffa6215.1743501688.git.u.kleine-koenig@baylibre.com
Signed-off-by: Uwe Kleine-König <ukleinek@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm-mediatek.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/pwm/pwm-mediatek.c b/drivers/pwm/pwm-mediatek.c
index 01dfa0fab80a4..7eaab58314995 100644
--- a/drivers/pwm/pwm-mediatek.c
+++ b/drivers/pwm/pwm-mediatek.c
@@ -121,21 +121,25 @@ static int pwm_mediatek_config(struct pwm_chip *chip, struct pwm_device *pwm,
 	struct pwm_mediatek_chip *pc = to_pwm_mediatek_chip(chip);
 	u32 clkdiv = 0, cnt_period, cnt_duty, reg_width = PWMDWIDTH,
 	    reg_thres = PWMTHRES;
+	unsigned long clk_rate;
 	u64 resolution;
 	int ret;
 
 	ret = pwm_mediatek_clk_enable(chip, pwm);
-
 	if (ret < 0)
 		return ret;
 
+	clk_rate = clk_get_rate(pc->clk_pwms[pwm->hwpwm]);
+	if (!clk_rate)
+		return -EINVAL;
+
 	/* Make sure we use the bus clock and not the 26MHz clock */
 	if (pc->soc->has_ck_26m_sel)
 		writel(0, pc->regs + PWM_CK_26M_SEL);
 
 	/* Using resolution in picosecond gets accuracy higher */
 	resolution = (u64)NSEC_PER_SEC * 1000;
-	do_div(resolution, clk_get_rate(pc->clk_pwms[pwm->hwpwm]));
+	do_div(resolution, clk_rate);
 
 	cnt_period = DIV_ROUND_CLOSEST_ULL((u64)period_ns * 1000, resolution);
 	while (cnt_period > 8191) {
-- 
2.39.5



