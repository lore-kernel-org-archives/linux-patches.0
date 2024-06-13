Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCA301448F2;
	Thu, 13 Jun 2024 12:08:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280485; cv=none; b=j+cZJK9TTAMwCgur9/OFlgNt+lL+Dl7qYq6nRNimw7oELkryFf0bH32lc40T2JJ+x7dz5yi6TjDs4gtPNwd+QeFGLGyqXopBDiZZLWd110Knpb2eSsXNff1YBKCa3pNrk26TnFaT1HX3dz0zPF4RrscFXOY1/HtPmiS4m93PHos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280485; c=relaxed/simple;
	bh=cy8tHtazjNtqC7bgbsr8zwtWZmigX+c7pcTpf20XTeE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R9XUe/UcZMiRzd03G4pOHMkudJVI4nnwM0MiRHDpKfke44tUbZAhGe7M9jzlLRYFvG4MW+w3+tAzGaKtj0kAyYhkUNop4ZRXi/3PgpEl8Hs3+3IDyoPG/s+yr/y4GXAdL+QjKhX0O6OmK7bBzLmeR4wQ/g6A0uu4fNdsAPZqyAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DCntVYuI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DCntVYuI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45295C4AF1D;
	Thu, 13 Jun 2024 12:08:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280485;
	bh=cy8tHtazjNtqC7bgbsr8zwtWZmigX+c7pcTpf20XTeE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DCntVYuIDCXJxRvnkJ+uMU4XOWDwDqvB+Ajud/ivONquQdovC61FhAc0eCSqzzWhe
	 uTDoAvqFHZ4EipBLKdhi4zHZ3EFSU+GhaFUER6orWdHw72//AKB9ixMGOROSs232Bw
	 k5RsEDa2nUJd9K5mVQvDikPf3oULV614+3aVHz/s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Gabor Juhos <j4g8y7@gmail.com>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.6 068/137] clk: qcom: clk-alpha-pll: fix rate setting for Stromer PLLs
Date: Thu, 13 Jun 2024 13:34:08 +0200
Message-ID: <20240613113225.935946081@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113223.281378087@linuxfoundation.org>
References: <20240613113223.281378087@linuxfoundation.org>
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

commit 3c5b3e17b8fd1f1add5a9477306c355fab126977 upstream.

The clk_alpha_pll_stromer_set_rate() function writes inproper
values into the ALPHA_VAL{,_U} registers which results in wrong
clock rates when the alpha value is used.

The broken behaviour can be seen on IPQ5018 for example, when
dynamic scaling sets the CPU frequency to 800000 KHz. In this
case the CPU cores are running only at 792031 KHz:

  # cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq
  800000
  # cat /sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_cur_freq
  792031

This happens because the function ignores the fact that the alpha
value calculated by the alpha_pll_round_rate() function is only
32 bits wide which must be extended to 40 bits if it is used on
a hardware which supports 40 bits wide values.

Extend the clk_alpha_pll_stromer_set_rate() function to convert
the alpha value to 40 bits before wrinting that into the registers
in order to ensure that the hardware really uses the requested rate.

After the change the CPU frequency is correct:

  # cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq
  800000
  # cat /sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_cur_freq
  800000

Cc: stable@vger.kernel.org
Fixes: e47a4f55f240 ("clk: qcom: clk-alpha-pll: Add support for Stromer PLLs")
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Gabor Juhos <j4g8y7@gmail.com>
Link: https://lore.kernel.org/r/20240328-alpha-pll-fix-stromer-set-rate-v3-1-1b79714c78bc@gmail.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/qcom/clk-alpha-pll.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/clk/qcom/clk-alpha-pll.c
+++ b/drivers/clk/qcom/clk-alpha-pll.c
@@ -2444,6 +2444,8 @@ static int clk_alpha_pll_stromer_set_rat
 	rate = alpha_pll_round_rate(rate, prate, &l, &a, ALPHA_REG_BITWIDTH);
 
 	regmap_write(pll->clkr.regmap, PLL_L_VAL(pll), l);
+
+	a <<= ALPHA_REG_BITWIDTH - ALPHA_BITWIDTH;
 	regmap_write(pll->clkr.regmap, PLL_ALPHA_VAL(pll), a);
 	regmap_write(pll->clkr.regmap, PLL_ALPHA_VAL_U(pll),
 		     a >> ALPHA_BITWIDTH);


