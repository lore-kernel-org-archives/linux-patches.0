Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5C2B18A6B9;
	Tue, 10 Sep 2024 09:44:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961458; cv=none; b=d3BcS8FpqZzsT9tDrqPHH5Gt+XQcLmoP+HpiCNTZxHdACL1rDR5OeYgCymgAD2vDPoiESDpHwNGy56sCR8UfOh+wbz0hkzECDJBhqdACkC2KNE5wc5RVremVc9diygeZagaYLpluSc7U70y9nA+4oVuSq46v1KSkT175iQovkwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961458; c=relaxed/simple;
	bh=gR4U9aMzMI9kDJ5z7x0zT2F9zfLNFNDEXzQOzxlhkd8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mSj2zY2QWypHHV4izCBLEB8J+VRolVfJA73b0wWgFnsUuyKxEPtrqAntnYG2UgJwKUFtZrgkkMBIgBf1mpx68ZogfygX6PJKF5LB2zA2yGA6/Hc/DuO99Ezq/es4xmGLAm5wS8yqN822mvb9MTf5toPxMD/NYlPFtZ6ImX+KamI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kHZMfQxh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kHZMfQxh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25CD6C4CEC3;
	Tue, 10 Sep 2024 09:44:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961458;
	bh=gR4U9aMzMI9kDJ5z7x0zT2F9zfLNFNDEXzQOzxlhkd8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kHZMfQxhDeiKk7AOOedcqRIrA9y+5MzXZRbVFP9oal7Gj5mxb6Coua6iH0ZCPjCr1
	 QdV+79f7cPCXWZX/q13y1VCiIcXb4ZAagVCT1uX89Vr/21rHe+58+YfE/JyyWrxycK
	 EVdcmFcce6gZjxlfsuIgcPHAHUymbUoFRc98KIkc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Satya Priya Kakitapalli <quic_skakitap@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.10 050/375] clk: qcom: clk-alpha-pll: Update set_rate for Zonda PLL
Date: Tue, 10 Sep 2024 11:27:27 +0200
Message-ID: <20240910092623.926733538@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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
@@ -2070,6 +2071,18 @@ static void clk_zonda_pll_disable(struct
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
@@ -2086,6 +2099,9 @@ static int clk_zonda_pll_set_rate(struct
 	if (ret < 0)
 		return ret;
 
+	if (a & PLL_ALPHA_MSB)
+		zonda_pll_adjust_l_val(rate, prate, &l);
+
 	regmap_write(pll->clkr.regmap, PLL_ALPHA_VAL(pll), a);
 	regmap_write(pll->clkr.regmap, PLL_L_VAL(pll), l);
 


