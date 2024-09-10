Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72F36172BA8;
	Tue, 10 Sep 2024 10:28:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964082; cv=none; b=QXbY8bhFBs/siyM8qDzGirQLguMF1s47czrC/rOOb6U3CX+xxb62NirjFM20zg6a6uFXnbRWqAzggBjozoNkqu6CGq7bkjyVn+PW5zgTlDEqp9b/vfuvQXQSbYLPYRH9Hu2yjnFoiNO9gcQo5OZaoN3QYtcawlynOY0wmpyHXBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964082; c=relaxed/simple;
	bh=H4KfjQE56UPnfZqcGwTCAenadx0ZRJKKLTLByN3o57U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QmbqwG27pgz9YhE4ShgHQkBoL7ICmKF4X2GIgzFCS3E9v1OPoUQ3iBrELSK4x5Xev0FD8FQ9zK7o+YURZ0c6tjBGVXO+QlarOn8TAHzZozD6IDixqnn6JDyZGKJSI/vTlA9uji2Eathr9VVK9u+4Gr9GoSqmSKuGwgwBgj9Bddg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nPkkinD0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nPkkinD0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C152AC4CEC3;
	Tue, 10 Sep 2024 10:28:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964082;
	bh=H4KfjQE56UPnfZqcGwTCAenadx0ZRJKKLTLByN3o57U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nPkkinD0zidF1coIGHpIViWVuFi0wT1NAuhyXLsC/1cXQ0ppAbwmwoTXcs2yCodg9
	 T/YVdyd3mDS0MPpYuQAyRFzWsBdeDn7+6AQcnw2Txq/apbESnB+JUNbr0tEaPfvZAf
	 8Er/uTnRLZB7xyr8GpPfxAweTau7rgLNlRCrsF2s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Satya Priya Kakitapalli <quic_skakitap@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.6 035/269] clk: qcom: clk-alpha-pll: Fix zonda set_rate failure when PLL is disabled
Date: Tue, 10 Sep 2024 11:30:22 +0200
Message-ID: <20240910092609.498777014@linuxfoundation.org>
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
@@ -2062,6 +2062,9 @@ static int clk_zonda_pll_set_rate(struct
 	regmap_write(pll->clkr.regmap, PLL_ALPHA_VAL(pll), a);
 	regmap_write(pll->clkr.regmap, PLL_L_VAL(pll), l);
 
+	if (!clk_hw_is_enabled(hw))
+		return 0;
+
 	/* Wait before polling for the frequency latch */
 	udelay(5);
 


