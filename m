Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ED8236C9D2
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:10:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302208; cv=none; b=sQyu2BotrNL4njfX6U0ZXnsy2wsvVDTP+0ii+z9MqReYdHPtbozPAgFa12iDoUUL4sV2KbyQYMlKNcTUIZBALW9BZjy2i4xRnDh5wT62A4fWFIr6xuoNsq4c3wOHfYVONJpUnpcJUFvL4Hpt/Z0iLAM5pWnqr9vjQY0p9fEZyKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302208; c=relaxed/simple;
	bh=EYZsd6zmLSGisQ/GNH6zj5iIUpORF0C0pwELmW9QNNk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UkkfcYPTCeC6F3V6HHyMSwTDtP9AN3dJL1ILCYyE1+it2dOVuuVQ4iWs4oEyp+TdIMHPUOkczmopiRS4o1ugzOrGogrFz7WI56NPBPXXZQ3JZl3pKiud1Sy7WPONo6Ds+KdTLuZ+lxF6M4OpCpn4bT8W5oL4OkFeCHgpPYNbm1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k+Rsx8+8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k+Rsx8+8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2900C19423;
	Sat, 28 Feb 2026 18:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302208;
	bh=EYZsd6zmLSGisQ/GNH6zj5iIUpORF0C0pwELmW9QNNk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k+Rsx8+8V1lrtLhtRPV9JtGe5oqPzCwG0tFszwtE6W3Rnfwu87PLmHLV+ylrRu7Lh
	 bLRh9rOVBybFWnO0+obdS+sDIuurgEWc70IACWOaOkoRDuEN6Nd0Ak+6IflpN9rHUE
	 wqyu1Uw9iq4TR/bUmQGhAJmVdtVAOqbMCaFr60TlWwJ9Ave92U85yExF7w4ALJATY3
	 Z2xvTRjEehxqW23eecALSHAu6691NHaM5/XRJCRmllMdh5hplrUhAVtURDu4a9Vgu/
	 21ysVcQcpUeK9X9mxMRehBbXeYpO5k7VgVYe4s9HIZHiI2lS/6OvxuXFn1/D128QCW
	 88SrFXA+BrqPw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Taniya Das <taniya.das@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 214/283] clk: qcom: rcg2: compute 2d using duty fraction directly
Date: Sat, 28 Feb 2026 13:05:56 -0500
Message-ID: <20260228180709.1583486-214-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
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
index fae1c07982aba..658d2ee7aacff 100644
--- a/drivers/clk/qcom/clk-rcg2.c
+++ b/drivers/clk/qcom/clk-rcg2.c
@@ -434,7 +434,7 @@ static int clk_rcg2_get_duty_cycle(struct clk_hw *hw, struct clk_duty *duty)
 static int clk_rcg2_set_duty_cycle(struct clk_hw *hw, struct clk_duty *duty)
 {
 	struct clk_rcg2 *rcg = to_clk_rcg2(hw);
-	u32 notn_m, n, m, d, not2d, mask, duty_per, cfg;
+	u32 notn_m, n, m, d, not2d, mask, cfg;
 	int ret;
 
 	/* Duty-cycle cannot be modified for non-MND RCGs */
@@ -453,10 +453,8 @@ static int clk_rcg2_set_duty_cycle(struct clk_hw *hw, struct clk_duty *duty)
 
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

