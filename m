Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D446418595E;
	Tue, 10 Sep 2024 10:06:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962781; cv=none; b=UXQy8rA4LBucx2KYnXSJ6v36VsVpuxQUFmHaw1HshtzAOCVMWauY7XgQPMzeoAI0r7X1LHCZNWZyIR1QRxCgYFBzLCfbc7Bms17fcYvJwLRZKGGyUFyqHj4ziYVs6WBYHiBmz5LFrUAA3/UtB1OpuYesXy+2084Igfbo8D+i0go=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962781; c=relaxed/simple;
	bh=4pLxm3rbnIuy7KLT5mh0cXjjNdlF8+6VMsIDiQViKMs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R8/8N1EUfdWThxXVKHoz9Px16bApNGtv80bTfCD+P6sd5QNovnB8dNTtIw1qVT3vqFq9Z7RP0sDlqIml4CML7TzHS/PYS+yIJFxsganFSR1WM/hAw5GHp39u+lCz0JuSHXi0dcg5PKZ/SLELAx5Mc0njmXQa6pPYbmz3kt93THk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fA24eN31; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fA24eN31"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5402AC4CEC3;
	Tue, 10 Sep 2024 10:06:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962781;
	bh=4pLxm3rbnIuy7KLT5mh0cXjjNdlF8+6VMsIDiQViKMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fA24eN31tvZLWbEet21JC1CYH6bcRqN2SEkDD3RxK5+FPAEl6c8I5YAtllinfGseB
	 mBcKRrjl7gP5LbSMRRoOmZfG5Gtzf5Swe+2GyDHiD0JxFbI92/dvxbsdY2eTY5285t
	 OirxRkSGHtaO2JIWr0hS8Xdg8ZFYA6bRRrM5VOPk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Satya Priya Kakitapalli <quic_skakitap@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.1 028/192] clk: qcom: clk-alpha-pll: Fix zonda set_rate failure when PLL is disabled
Date: Tue, 10 Sep 2024 11:30:52 +0200
Message-ID: <20240910092559.111836389@linuxfoundation.org>
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
@@ -2005,6 +2005,9 @@ static int clk_zonda_pll_set_rate(struct
 	regmap_write(pll->clkr.regmap, PLL_ALPHA_VAL(pll), a);
 	regmap_write(pll->clkr.regmap, PLL_L_VAL(pll), l);
 
+	if (!clk_hw_is_enabled(hw))
+		return 0;
+
 	/* Wait before polling for the frequency latch */
 	udelay(5);
 


