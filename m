Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 494EB359A97
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:14:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302440; cv=none; b=uqPvZA9iDQIi0qNbMoKPcziDTlWyj++MkY35RWO+Ri+JjAeudaAFMZXx7667CoYRT5BFkCu1AUIOnAAuDCiCJPfu46dTeSN5EI8j+/RI+jBxmhZbgAnGqYCUzLFVTcDlvAvrUEG7/SirWY5rdrPVEJ8vijjeW0iDQ/wurds8YI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302440; c=relaxed/simple;
	bh=qgsm1e5vqpjTLRz3WAAGCPvcCpq+T5U6Fc2s0mHJFio=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=S3oy6T9DjVe4cwqj0oNRdMyxb1c5AK8OLIaatP2vhB56I1PlPsGWSomMl0j4TBAQdKPytAneNBGgP0bZs2pgYD8ZlR3SeZW5ddPQuRjTMxV1AI5AE6UpmAHW7OfPAFyYejW/X1HzT3may3TvroQDwdQBWwusF6x4CVD36GRfT28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KjkRvhWv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KjkRvhWv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1BEEC19425;
	Sat, 28 Feb 2026 18:13:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302440;
	bh=qgsm1e5vqpjTLRz3WAAGCPvcCpq+T5U6Fc2s0mHJFio=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KjkRvhWvwR5U9a4hp74aYQE5bEgLNh5bA4+v/x4GMosMh4MNVvSqDCNv+LrG66Snl
	 l+RovYOTVxsaSvZoYOQv/Vek9AYyajUFlBha4tz36RrpklVhjbvnKf0ZMhnreYlBaa
	 lJ8oY+md4XiZPk7Lz+dGf3r45dTu2zNvKVUg2p1PIumuV4QyU9wDXaCGtQDpfZuNyd
	 V5ARg+rlnJrTmpStR0WKERAttZn9+CEtp4S91JQwe8P21IijZdVBckRLY/mzmKcbpV
	 X5tsLWjVfj5a+B07UTVqfSxtjSyVyBBw2t8TBE0MacEyPhjsG086QI22YHoYdf5c+M
	 oa2U11aRTVVwA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Taniya Das <taniya.das@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 178/232] clk: qcom: rcg2: compute 2d using duty fraction directly
Date: Sat, 28 Feb 2026 13:10:31 -0500
Message-ID: <20260228181127.1592657-178-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
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
index e46bb60dcda41..0e26f4f0bdbae 100644
--- a/drivers/clk/qcom/clk-rcg2.c
+++ b/drivers/clk/qcom/clk-rcg2.c
@@ -432,7 +432,7 @@ static int clk_rcg2_get_duty_cycle(struct clk_hw *hw, struct clk_duty *duty)
 static int clk_rcg2_set_duty_cycle(struct clk_hw *hw, struct clk_duty *duty)
 {
 	struct clk_rcg2 *rcg = to_clk_rcg2(hw);
-	u32 notn_m, n, m, d, not2d, mask, duty_per, cfg;
+	u32 notn_m, n, m, d, not2d, mask, cfg;
 	int ret;
 
 	/* Duty-cycle cannot be modified for non-MND RCGs */
@@ -451,10 +451,8 @@ static int clk_rcg2_set_duty_cycle(struct clk_hw *hw, struct clk_duty *duty)
 
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

