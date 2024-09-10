Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED0D218C02F;
	Tue, 10 Sep 2024 10:18:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963512; cv=none; b=jRevvoIa9erxQ89s/OmDEz2MukLd/sSzbFvVdFc1FmZm1lkwGPYWYUPCdmRnm94lEQ04buXIR/L4/LHRb8d79IUsylIDvaT3dnSLGg+SCR/KV69vq0MCb0N4Ioq0VCS7bcEWGlwRlYeseHkirJYiwVtDxQlu6pxaheEY1v3y9ow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963512; c=relaxed/simple;
	bh=0WeNvmhibQantKqmImZ3+/gD4UzxXii8pHrpmnv5C6g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=caUIx8WJc6n5rpWHGxz1mYYCDpVJW1P9SMGqVghfDNVFvx4PimrR6W7pdbeTpKFwYy+9qbzs/NJvrxxnq4hOoKcSt1gVUuxNCqYw+mi1cdeYkU9znne16q9f+AZ3ljOEYaSIu3kd034t6STOcSVv8ksHhHdEnnRYPFuo+3pQW5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SsfPem01; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SsfPem01"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76505C4CEC3;
	Tue, 10 Sep 2024 10:18:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963511;
	bh=0WeNvmhibQantKqmImZ3+/gD4UzxXii8pHrpmnv5C6g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SsfPem01nPdtQXhZ7V0R+eKNxhG/i+U0IqDdIrzUKrc0QQDFlDS+VblHxf37nQNvP
	 UVxrmDdQA/TNf+nZ293K4M+8lm5GH1eVON75yK8DUbGGqkwxQJVYJ5dRrems4veCdD
	 ur3eRv7PcWuCB8IIvGW7XvdTe/WjkwxY0ZArw1as=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Satya Priya Kakitapalli <quic_skakitap@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 5.15 082/214] clk: qcom: clk-alpha-pll: Fix zonda set_rate failure when PLL is disabled
Date: Tue, 10 Sep 2024 11:31:44 +0200
Message-ID: <20240910092602.086670574@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092558.714365667@linuxfoundation.org>
References: <20240910092558.714365667@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1932,6 +1932,9 @@ static int clk_zonda_pll_set_rate(struct
 	regmap_write(pll->clkr.regmap, PLL_ALPHA_VAL(pll), a);
 	regmap_write(pll->clkr.regmap, PLL_L_VAL(pll), l);
 
+	if (!clk_hw_is_enabled(hw))
+		return 0;
+
 	/* Wait before polling for the frequency latch */
 	udelay(5);
 


