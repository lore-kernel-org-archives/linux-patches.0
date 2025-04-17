Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CB66255E2B;
	Thu, 17 Apr 2025 18:03:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744912983; cv=none; b=GaEWAFOuFtZU5m9liCAUMHlfmeRG7KDswxrspphjWS86n/x/psfBWI8Vq+OrT7aceHDH1SRffaL12FmeOg1z5m9g9T4d5saW+OMrBqei7D/Y0VHAo14mFy6KRqikmwCDSojTYqABnhZe+OrHuJs0YJXKTyVNjrJXFG1jPeZ44gA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744912983; c=relaxed/simple;
	bh=IaCtLfsWojcIXANOKbMF8kjC/cEuBrybo+yPBbwhBuU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=I1eISoC+vQOhhjY5GXHlUcIdjKlahdu/ZI+xZe3EnCl8sirLC4S3Fvpkrgp665Xk2I0bwu6o1BIAzQSEKY0qnItRH82PmNqNpWrPFK8ZmdijKzMElFXjhbVYHJTOo+EqD4ZsXYw1lgJd4oq+/tO8z588mxrPHa55EnAGh88KogU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j9UHZeWM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j9UHZeWM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0005C4CEE4;
	Thu, 17 Apr 2025 18:03:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744912983;
	bh=IaCtLfsWojcIXANOKbMF8kjC/cEuBrybo+yPBbwhBuU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j9UHZeWM3iq5LMFj6j0TIaQEf5Z7vXBZHRGQZrR0xpXgK3s0SOdD9SWQUfK7o2qh+
	 OiTdBmd48//m+Pudx3MV/mhGp6pzr0fuBE8YjJW6NRiz3F8u69DpeDFDQtu8SRll48
	 XQ8zbpWA/Us6hjWqrB+XPdyBQHzHii0FIMAd4AA4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 188/449] pwm: mediatek: Prevent divide-by-zero in pwm_mediatek_config()
Date: Thu, 17 Apr 2025 19:47:56 +0200
Message-ID: <20250417175125.541462994@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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



