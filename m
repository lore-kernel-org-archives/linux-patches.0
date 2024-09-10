Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63815172BA8;
	Tue, 10 Sep 2024 10:28:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964085; cv=none; b=fqfDYURDZJ8+B4sbA0Wt0WrnECowbCygAfqwZ0n8iu/qLPeSAsB8Lx9Rn12v9PBR8bDV8M1srJSCDRXJt+8sHAGdH/VkiLI8Sr6AcyA3SAondFgtK2c9lAPDzzv+0q8opw0K7wh/1pgJIHHwQAYSE0CaPSrlDxxgFE9heyTHmuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964085; c=relaxed/simple;
	bh=LVEaEOZMBvkwjuCGvgl4RCUx6kn5SNDGxx3J5h70hX0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SzSyXtFcjz80ekRYRXfPr7RPZNkcoCNvG2pbZBwPZljo4JFUO3tAodTzI+0zPIqU7KFMd1pp2H2/lBA9D622/Sjmm6NWRp6Pq7+xWy4FaHB77HmxeVQjXx2iIlcuBXzSsQwvrTt5IUSdlBXfdWc30WI/0/srd/d4WF/i0hIJxFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sDvSTesY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sDvSTesY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE448C4CEC3;
	Tue, 10 Sep 2024 10:28:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964085;
	bh=LVEaEOZMBvkwjuCGvgl4RCUx6kn5SNDGxx3J5h70hX0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sDvSTesY0JUo6QRHZUUYOlrn6HyiGO1wI7pKaSksEH42bPLlKcuvZM/EN+XWx0HV8
	 zmD3tVFSbgVcojLEpCQ/Z9pB/Or6UbQnDePqJYb14h9Xdz9tss/ZeMKVODZ9bXD6na
	 tCi2317x4xt9yoIaoZ98qmwujmhTPDugQA3Agevw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Satya Priya Kakitapalli <quic_skakitap@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.6 036/269] clk: qcom: clk-alpha-pll: Update set_rate for Zonda PLL
Date: Tue, 10 Sep 2024 11:30:23 +0200
Message-ID: <20240910092609.535609233@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
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
@@ -2043,6 +2044,18 @@ static void clk_zonda_pll_disable(struct
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
@@ -2059,6 +2072,9 @@ static int clk_zonda_pll_set_rate(struct
 	if (ret < 0)
 		return ret;
 
+	if (a & PLL_ALPHA_MSB)
+		zonda_pll_adjust_l_val(rate, prate, &l);
+
 	regmap_write(pll->clkr.regmap, PLL_ALPHA_VAL(pll), a);
 	regmap_write(pll->clkr.regmap, PLL_L_VAL(pll), l);
 


