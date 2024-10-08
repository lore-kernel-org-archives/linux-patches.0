Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2891A1DF963;
	Tue,  8 Oct 2024 13:27:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728394028; cv=none; b=aZozWNTRvq0puiixOCzzrIpyRNz+rsYmrnjVdbki0h368JON7RbLItTeoOUrd41OxdEG8uvWQb3JXGv4jqp2smXX+tf2IrS2frg+LoVy6aMkxYm38LT0cQ8ohEXFG4em7sL3O42LxRiJDY9oJohPtEIJz8Ymb2/8OZTiy5FqPN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728394028; c=relaxed/simple;
	bh=15MCAFLhLtNyNn9c2G5bMZg7eV8mIybQtYXLKADkePU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MDji9j8v1eF5w85+vt5Piq4RfS2Y6W/xBLjS8IknqMX+KDMfZDu7bhwRYHouQz74nKYYLYrSnbnp7m5KO07Vcer53rwlQM6tWjDXauU1id3Z61uib35zdpoBDHdh4w2hFa4ZGUl8FnTvrvgzcm6x0GGlATekleiBMCFtu2jIS3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YTeTkyml; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YTeTkyml"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7B95C4CEC7;
	Tue,  8 Oct 2024 13:27:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728394028;
	bh=15MCAFLhLtNyNn9c2G5bMZg7eV8mIybQtYXLKADkePU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YTeTkymlY4Lcl/Njd0l302+7XiZVN5qo8+ZqDpLCufAD51b1C3kfgGe/CDBwPNkF8
	 acw1/bhTEzn2LXozVvKB92bqNr10vFrF9tg0cbIwbj1q3VjsJEeVLKXgYA/Llj3N8a
	 eeF4nJYrH0k+/xbUnNYKiU2P1zYAywHnpnwXiEKo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ajit Pandey <quic_ajipan@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.6 294/386] clk: qcom: clk-alpha-pll: Fix CAL_L_VAL override for LUCID EVO PLL
Date: Tue,  8 Oct 2024 14:08:59 +0200
Message-ID: <20241008115640.955776608@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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

From: Ajit Pandey <quic_ajipan@quicinc.com>

commit fff617979f97c773aaa9432c31cf62444b3bdbd4 upstream.

In LUCID EVO PLL CAL_L_VAL and L_VAL bitfields are part of single
PLL_L_VAL register. Update for L_VAL bitfield values in PLL_L_VAL
register using regmap_write() API in __alpha_pll_trion_set_rate
callback will override LUCID EVO PLL initial configuration related
to PLL_CAL_L_VAL bit fields in PLL_L_VAL register.

Observed random PLL lock failures during PLL enable due to such
override in PLL calibration value. Use regmap_update_bits() with
L_VAL bitfield mask instead of regmap_write() API to update only
PLL_L_VAL bitfields in __alpha_pll_trion_set_rate callback.

Fixes: 260e36606a03 ("clk: qcom: clk-alpha-pll: add Lucid EVO PLL configuration interfaces")
Cc: stable@vger.kernel.org
Signed-off-by: Ajit Pandey <quic_ajipan@quicinc.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Acked-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
Link: https://lore.kernel.org/r/20240611133752.2192401-2-quic_ajipan@quicinc.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/qcom/clk-alpha-pll.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/clk/qcom/clk-alpha-pll.c
+++ b/drivers/clk/qcom/clk-alpha-pll.c
@@ -1638,7 +1638,7 @@ static int __alpha_pll_trion_set_rate(st
 	if (ret < 0)
 		return ret;
 
-	regmap_write(pll->clkr.regmap, PLL_L_VAL(pll), l);
+	regmap_update_bits(pll->clkr.regmap, PLL_L_VAL(pll), LUCID_EVO_PLL_L_VAL_MASK,  l);
 	regmap_write(pll->clkr.regmap, PLL_ALPHA_VAL(pll), a);
 
 	/* Latch the PLL input */


