Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E703293B7C;
	Wed, 23 Apr 2025 15:20:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421653; cv=none; b=b+zwZq/epF7aVz5NI9sNHkqGrIJt27nIzIDXEkUEWZbp17hkOEyu7eunMT4zF3lcQTReEnK5bv6dCNM0ZyrqvBbROtnzYxtipXriTClOE2RBFbmozYHkq0ceHGDiyo8SBLBWsVoZmaTPnmuwmfo3/D+7qoLeJ46Q1kL8qA1+8b4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421653; c=relaxed/simple;
	bh=utvS4QWKDf/Z/RyuAu6RXolrlzYufeV9htX67rwNKC0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P7oT37NyyG9vBx1VuEnpyQeQyOQoRbVxKsNz2riO5ypoE47rC1z5T0Dcj8zO4jQz6LyjbBeqU1hR6LAQ6yp1hlCU/BMN7Hrv0EwliSks0fnJN0oOk/QJyOwz6dVYssJPWpZ0RKtc3gc7a4vzJKvWbeaEyAPizsO6eL/hhUOHITQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gtzMklYG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gtzMklYG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 172A2C4CEE2;
	Wed, 23 Apr 2025 15:20:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421652;
	bh=utvS4QWKDf/Z/RyuAu6RXolrlzYufeV9htX67rwNKC0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gtzMklYGKUiXiRYM3Lelj5qi8KWVCjvZaLirw+F1TZzeMcpohr6eSQN5lpSvWkyzO
	 +8OSd4Cd2nFv88HUxeQOKJS1E0JDG/ODrCcr9ZIilOOyUYNUnP3mgqs7dH3Ug0zuLT
	 FQSK7l0oWxNXLBvbJLr4tObERKOzSIzby+OBMKj4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ajit Pandey <quic_ajipan@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.6 204/393] clk: qcom: clk-branch: Fix invert halt status bit check for votable clocks
Date: Wed, 23 Apr 2025 16:41:40 +0200
Message-ID: <20250423142651.813881712@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
User-Agent: quilt/0.68
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

commit 5eac348182d2b5ed1066459abedb7bc6b5466f81 upstream.

BRANCH_HALT_ENABLE and BRANCH_HALT_ENABLE_VOTED flags are used to check
halt status of branch clocks, which have an inverted logic for the halt
bit in CBCR register. However, the current logic in the _check_halt()
method only compares the BRANCH_HALT_ENABLE flags, ignoring the votable
branch clocks.

Update the logic to correctly handle the invert logic for votable clocks
using the BRANCH_HALT_ENABLE_VOTED flags.

Fixes: 9092d1083a62 ("clk: qcom: branch: Extend the invert logic for branch2 clocks")
Cc: stable@vger.kernel.org
Signed-off-by: Ajit Pandey <quic_ajipan@quicinc.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20250128-push_fix-v1-1-fafec6747881@quicinc.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/qcom/clk-branch.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/clk/qcom/clk-branch.c
+++ b/drivers/clk/qcom/clk-branch.c
@@ -27,7 +27,7 @@ static bool clk_branch_in_hwcg_mode(cons
 
 static bool clk_branch_check_halt(const struct clk_branch *br, bool enabling)
 {
-	bool invert = (br->halt_check == BRANCH_HALT_ENABLE);
+	bool invert = (br->halt_check & BRANCH_HALT_ENABLE);
 	u32 val;
 
 	regmap_read(br->clkr.regmap, br->halt_reg, &val);
@@ -43,7 +43,7 @@ static bool clk_branch2_check_halt(const
 {
 	u32 val;
 	u32 mask;
-	bool invert = (br->halt_check == BRANCH_HALT_ENABLE);
+	bool invert = (br->halt_check & BRANCH_HALT_ENABLE);
 
 	mask = CBCR_NOC_FSM_STATUS;
 	mask |= CBCR_CLK_OFF;


