Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE7AA18A6D1;
	Tue, 10 Sep 2024 09:44:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961452; cv=none; b=UtWXKD5J6LmK8w1S4S5n2pWmcnqPpWBIAKcB2YDJywsfxnyMkLS5Y4CngwVYNEAd7sD9MHvizUCg50j1L+jJYyDcZ+vJGrB/wkpKDOm/Q6xHfyU+3g+0DzpKqq+xtRxARjNkPo1JlUID96p5jBGVMZaS30gIM+b1U6ZK+TqlXBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961452; c=relaxed/simple;
	bh=m2L3IDRpsIyEIlWzZCRFyR0RdNzhVqi2m1l72R+yDT0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=laIOV9EYttyNsfguj3d862WTqkhPBOf3ezn/JIewflRGw/B00wtvRvygsg0nUfvodVpHoDASDvG8/s8k7SeWHSGIy3uMejy/4Kx0utUp9Rkwt9Zw2Dwm40DXKG2IlOmSsFXOw/SvaevHJsS3QaKHz+mYYzyHOq/UiLT1kVuPPIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ahE32PNd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ahE32PNd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56A03C4CEC3;
	Tue, 10 Sep 2024 09:44:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961452;
	bh=m2L3IDRpsIyEIlWzZCRFyR0RdNzhVqi2m1l72R+yDT0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ahE32PNdqJ00fjB7ppqaX/UFeeaPappFlD3xKmOKwBzfQqA3US5auNiYI2gAkrJRq
	 GYjXMZFfmLilNG2zkuLz+uyypJTdeUXG6FbTVjzyERgF4TcRX8mS2qYTcC9+TYS83t
	 Jw/07WGP8cO1UzvcfKeaFgBYZgDSc0DB0E+5eSXY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Satya Priya Kakitapalli <quic_skakitap@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.10 048/375] clk: qcom: clk-alpha-pll: Fix the trion pll postdiv set rate API
Date: Tue, 10 Sep 2024 11:27:25 +0200
Message-ID: <20240910092623.857696696@linuxfoundation.org>
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

commit 4ad1ed6ef27cab94888bb3c740c14042d5c0dff2 upstream.

Correct the pll postdiv shift used in clk_trion_pll_postdiv_set_rate
API. The shift value is not same for different types of plls and
should be taken from the pll's .post_div_shift member.

Fixes: 548a909597d5 ("clk: qcom: clk-alpha-pll: Add support for Trion PLLs")
Cc: stable@vger.kernel.org
Signed-off-by: Satya Priya Kakitapalli <quic_skakitap@quicinc.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20240731062916.2680823-3-quic_skakitap@quicinc.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/qcom/clk-alpha-pll.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/clk/qcom/clk-alpha-pll.c
+++ b/drivers/clk/qcom/clk-alpha-pll.c
@@ -1505,8 +1505,8 @@ clk_trion_pll_postdiv_set_rate(struct cl
 	}
 
 	return regmap_update_bits(regmap, PLL_USER_CTL(pll),
-				  PLL_POST_DIV_MASK(pll) << PLL_POST_DIV_SHIFT,
-				  val << PLL_POST_DIV_SHIFT);
+				  PLL_POST_DIV_MASK(pll) << pll->post_div_shift,
+				  val << pll->post_div_shift);
 }
 
 const struct clk_ops clk_alpha_pll_postdiv_trion_ops = {


