Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 705B239B970
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:16:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302611; cv=none; b=tpYXssZJI7vzwZ6vVKwE0uLD25buLTUaRjwCFLuDyRsZAzmCLYhMyX3cC9Qgu7PoLHR8WUOuf21dCI9ata27O38/0z8AEetflTnJxidqFa5RnDR2v8GjSUOaYJqrOeLc77pcFfQfKe/QtiRfV0PX86FdorTHkWtvHYKhKRWxbUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302611; c=relaxed/simple;
	bh=Gnni3G4LGNXaG40nKX3l8bKCD7ylqeTs03XpiWBojes=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZReKLEe/bLDJJnHFLjFxj+b8nQRJTGFiWfcXof5yT2bccjCxHHeQsIrskbXDHiRPEOdLlvT3ktGKZPFzJ0NkYjBjgelb81BRwrO0XjdPMoxa0YZz+O36HhX3R9jCQ09xC2nEltktugh7tSy8+uFA18dqsGRdLaoJSUS6XM2OUZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qTzwAIAN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qTzwAIAN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB30CC116D0;
	Sat, 28 Feb 2026 18:16:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302611;
	bh=Gnni3G4LGNXaG40nKX3l8bKCD7ylqeTs03XpiWBojes=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qTzwAIAN2dKQLufPKOniBnrJHtCwJxDCb3hFnEjgvO1eCLaF0MihDuYQLKbtoNASb
	 lXJmGBLevKdY+6EKTyzL263ochmRG4qygwUBb5aUbS8HSFYxjj/K161vOnm+oXR8aF
	 EVdfEVawH5hjJM0r0hez+gfXKMD9pulO1lzKL3vVaav+1aSyp84BLJKzGkir3l9DB+
	 +VRbOb8jrh0PYtk1bSb+kqrzRLmFQAOOXbh8rscbSlcrgBZyz+ar3m5u/7OmKn3vB9
	 j1ddSC5qvN+vjVJIJDJTQDMZn3d0BXNGTIBcfbrCqfIsvCLoc0qJt83wwjfF67elta
	 kCExWOpvRgYNQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Taniya Das <taniya.das@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 127/164] clk: qcom: rcg2: compute 2d using duty fraction directly
Date: Sat, 28 Feb 2026 13:14:26 -0500
Message-ID: <20260228181505.1600663-127-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181505.1600663-1-sashal@kernel.org>
References: <20260228181505.1600663-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Taniya Das <taniya.das@oss.qualcomm.com>

[ Upstream commit d6205a1878dd4cc9664c4b4829b68a29c0426efc ]

The duty-cycle calculation in clk_rcg2_set_duty_cycle() currently
derives an intermediate percentage `duty_per = (num * 100) / den` and
then computes:

    d = DIV_ROUND_CLOSEST(n * duty_per * 2, 100);

This introduces integer truncation at the percentage step (division by
`den`) and a redundant scaling by 100, which can reduce precision for
large `den` and skew the final rounding.

Compute `2d` directly from the duty fraction to preserve precision and
avoid the unnecessary scaling:

    d = DIV_ROUND_CLOSEST(n * duty->num * 2, duty->den);

This keeps the intended formula `d ≈ n * 2 * (num/den)` while performing
a single, final rounded division, improving accuracy especially for small
duty cycles or large denominators. It also removes the unused `duty_per`
variable, simplifying the code.

There is no functional changes beyond improved numerical accuracy.

Fixes: 7f891faf596ed ("clk: qcom: clk-rcg2: Add support for duty-cycle for RCG")
Signed-off-by: Taniya Das <taniya.das@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260105-duty_cycle_precision-v2-1-d1d466a6330a@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/clk-rcg2.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/clk/qcom/clk-rcg2.c b/drivers/clk/qcom/clk-rcg2.c
index f3c225ed57377..05aa831ac7a44 100644
--- a/drivers/clk/qcom/clk-rcg2.c
+++ b/drivers/clk/qcom/clk-rcg2.c
@@ -400,7 +400,7 @@ static int clk_rcg2_get_duty_cycle(struct clk_hw *hw, struct clk_duty *duty)
 static int clk_rcg2_set_duty_cycle(struct clk_hw *hw, struct clk_duty *duty)
 {
 	struct clk_rcg2 *rcg = to_clk_rcg2(hw);
-	u32 notn_m, n, m, d, not2d, mask, duty_per, cfg;
+	u32 notn_m, n, m, d, not2d, mask, cfg;
 	int ret;
 
 	/* Duty-cycle cannot be modified for non-MND RCGs */
@@ -419,10 +419,8 @@ static int clk_rcg2_set_duty_cycle(struct clk_hw *hw, struct clk_duty *duty)
 
 	n = (~(notn_m) + m) & mask;
 
-	duty_per = (duty->num * 100) / duty->den;
-
 	/* Calculate 2d value */
-	d = DIV_ROUND_CLOSEST(n * duty_per * 2, 100);
+	d = DIV_ROUND_CLOSEST(n * duty->num * 2, duty->den);
 
 	/*
 	 * Check bit widths of 2d. If D is too big reduce duty cycle.
-- 
2.51.0

