Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF3B718595E;
	Tue, 10 Sep 2024 10:06:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962784; cv=none; b=e0GftjfAoqKd+iXPUnwX0p75ZY7hAEOnvu0+81GnigKsDflUDHjPmmpBXsIFFC4Bk85qDN+QE66TDAdAQN/N3zBrO4WFw/a29E4W+JnYUYmou2jMEh/0ZIFlmCNSMXAmDFRUp77dal/JetYCsrgj+bax2+nNdKkREZFpmt37AGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962784; c=relaxed/simple;
	bh=vz7dtBm3I0GxSE4AhoUvlasf4suJFGmyVKrwaT0bWyE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m5T8DRKFfFpt0ojbtL/fvGQRQJ9p2+Nh0aOdIChJpwG5D+AkDH2uVvMHJERbI8eUJXHUO6IzHY4Hv4HuPBnYtnTD3rVQSjhjxWpWZ7dO84b9qoShsDcej81vE9RuRQjzkhR5BwEFxG6ytNJLibjyXXZnEz+r01WSua1Rsk/OxYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ravHgq8U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ravHgq8U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AF50C4CEC3;
	Tue, 10 Sep 2024 10:06:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962784;
	bh=vz7dtBm3I0GxSE4AhoUvlasf4suJFGmyVKrwaT0bWyE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ravHgq8UZcygvP5RFT0vJ1UgaqP5EzI9XneNUsQLryFZexhhrnOiXG/Ujx9qlbWOB
	 yJWA1VEwo6f7PhG3Ya9cJfPOpa41CGBZR2XDByx+o7ZNDSoxdjQmdSO+GP5pz1xCql
	 8XvuP8p+2WYmGQkc27k4/4ycNBlFX6YAJFRuTEkY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Satya Priya Kakitapalli <quic_skakitap@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.1 029/192] clk: qcom: clk-alpha-pll: Update set_rate for Zonda PLL
Date: Tue, 10 Sep 2024 11:30:53 +0200
Message-ID: <20240910092559.146663434@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092557.876094467@linuxfoundation.org>
References: <20240910092557.876094467@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Satya Priya Kakitapalli <quic_skakitap@quicinc.com>

commit f4973130d255dd4811006f5822d4fa4d0de9d712 upstream.

The Zonda PLL has a 16 bit signed alpha and in the cases where the alpha
value is greater than 0.5, the L value needs to be adjusted accordingly.
Thus update the logic to handle the signed alpha val.

Fixes: f21b6bfecc27 ("clk: qcom: clk-alpha-pll: add support for zonda pll")
Cc: stable@vger.kernel.org
Signed-off-by: Satya Priya Kakitapalli <quic_skakitap@quicinc.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20240731062916.2680823-5-quic_skakitap@quicinc.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/qcom/clk-alpha-pll.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

--- a/drivers/clk/qcom/clk-alpha-pll.c
+++ b/drivers/clk/qcom/clk-alpha-pll.c
@@ -41,6 +41,7 @@
 #define PLL_USER_CTL(p)		((p)->offset + (p)->regs[PLL_OFF_USER_CTL])
 # define PLL_POST_DIV_SHIFT	8
 # define PLL_POST_DIV_MASK(p)	GENMASK((p)->width - 1, 0)
+# define PLL_ALPHA_MSB		BIT(15)
 # define PLL_ALPHA_EN		BIT(24)
 # define PLL_ALPHA_MODE		BIT(25)
 # define PLL_VCO_SHIFT		20
@@ -1986,6 +1987,18 @@ static void clk_zonda_pll_disable(struct
 	regmap_write(regmap, PLL_OPMODE(pll), 0x0);
 }
 
+static void zonda_pll_adjust_l_val(unsigned long rate, unsigned long prate, u32 *l)
+{
+	u64 remainder, quotient;
+
+	quotient = rate;
+	remainder = do_div(quotient, prate);
+	*l = quotient;
+
+	if ((remainder * 2) / prate)
+		*l = *l + 1;
+}
+
 static int clk_zonda_pll_set_rate(struct clk_hw *hw, unsigned long rate,
 				  unsigned long prate)
 {
@@ -2002,6 +2015,9 @@ static int clk_zonda_pll_set_rate(struct
 	if (ret < 0)
 		return ret;
 
+	if (a & PLL_ALPHA_MSB)
+		zonda_pll_adjust_l_val(rate, prate, &l);
+
 	regmap_write(pll->clkr.regmap, PLL_ALPHA_VAL(pll), a);
 	regmap_write(pll->clkr.regmap, PLL_L_VAL(pll), l);
 


