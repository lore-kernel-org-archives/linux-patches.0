Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2E9218FDC5;
	Tue, 10 Sep 2024 09:44:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961455; cv=none; b=YVZ/sDg0qKC0CYuZY/ai2dzMCYIm9aUzPCKJhd02IUkSCSOo1QbWQXVErASWW/CAiMqP/VEtTcetY9kHEjxPlZ5iTVT6EAtrptXP2TmikYWmBuaLRQhBdaZ7OHvPT9FF8gOTyBxVNeCA3a1faUU7mPxDqxUw7uTKucs0iGt0gjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961455; c=relaxed/simple;
	bh=AL2wuD9D7hVX86Ndj82joG7po693I2Bb1wzhN0Rg3Ys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iWOZn5Lsdjrr7FRiqJPbeVV0YZ6zr1eWv8zFESv1etzB0TAGr2sjz08UTRbiM2VY+sCzTXYjnS3xgqkO3ddnEfLVuqumwsoS6CHf2V9LaPRd+d3nozG8G9QPE/D1c68cYGh0v2SShv3E4JUfmIcEjN+KfCyyKAhvBdRUF4BzdyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k+wn4BYd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k+wn4BYd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B95BC4CEC3;
	Tue, 10 Sep 2024 09:44:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961455;
	bh=AL2wuD9D7hVX86Ndj82joG7po693I2Bb1wzhN0Rg3Ys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k+wn4BYdBt9anJ7C8JerTzXEXk7zAwhUpA1dGqopAZBE9dWnJfebjevtW5Sp/JrDX
	 B9suAFCiwFqx0rUcmyz7KuAwyrzlRUWcDO31qAXwb7LNSHfvwSO0NXs/5t+ewAudDX
	 Iz7E+hxj1QqaaOOdB8OuOjGZbI63vq6iYsCCImiM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Satya Priya Kakitapalli <quic_skakitap@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.10 049/375] clk: qcom: clk-alpha-pll: Fix zonda set_rate failure when PLL is disabled
Date: Tue, 10 Sep 2024 11:27:26 +0200
Message-ID: <20240910092623.891664696@linuxfoundation.org>
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

commit 85e8ee59dfde1a7b847fbed0778391392cd985cb upstream.

Currently, clk_zonda_pll_set_rate polls for the PLL to lock even if the
PLL is disabled. However, if the PLL is disabled then LOCK_DET will
never assert and we'll return an error. There is no reason to poll
LOCK_DET if the PLL is already disabled, so skip polling in this case.

Fixes: f21b6bfecc27 ("clk: qcom: clk-alpha-pll: add support for zonda pll")
Cc: stable@vger.kernel.org
Signed-off-by: Satya Priya Kakitapalli <quic_skakitap@quicinc.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20240731062916.2680823-4-quic_skakitap@quicinc.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/qcom/clk-alpha-pll.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/clk/qcom/clk-alpha-pll.c
+++ b/drivers/clk/qcom/clk-alpha-pll.c
@@ -2089,6 +2089,9 @@ static int clk_zonda_pll_set_rate(struct
 	regmap_write(pll->clkr.regmap, PLL_ALPHA_VAL(pll), a);
 	regmap_write(pll->clkr.regmap, PLL_L_VAL(pll), l);
 
+	if (!clk_hw_is_enabled(hw))
+		return 0;
+
 	/* Wait before polling for the frequency latch */
 	udelay(5);
 


