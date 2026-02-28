Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C6D833A014
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:04:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301876; cv=none; b=VXe9xAUtFYKym/oCuSJjdrH3kamIAJE7abgYkOb7ypzf2RVEuOS0zwHkZxNTo1l7/iVDTeebF95ihytuvoH7knBaD2uLlsk8KvM6Sea9nM5Q23jE0AFyzTEl7eusddOwGYM3LzzJL/jhYJEHfWWYMueZNbtTk3OVxPogY9bOT64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301876; c=relaxed/simple;
	bh=2B/Mg6WpdU0mCJJfl4kw1JMqGbOc8fQ92plb1motZkc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PjRB30JiXIICy8YjTYTWRrRf2uULmbimvRue8B2y/ZGNLqsr1VtvUcOz6vk+tgiE0I6lqzhyET4W7i58/pzICGykdHvisQ0pjOwE5+NNVv+cL/63+Zt4+J8PrFy21BTjSmAQoGLlpjCLHxi09hed0oZSnY58L+L+meJVnrw/1Dw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jWrjINP+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jWrjINP+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A02CFC19423;
	Sat, 28 Feb 2026 18:04:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301876;
	bh=2B/Mg6WpdU0mCJJfl4kw1JMqGbOc8fQ92plb1motZkc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jWrjINP+6th6vIU30wkw3o9+HCWD8oTFbXjXX9XmbmVUYdHv6CRkJquD+6q0VkQ7D
	 PO34Yj2lk8zbAmVPloRprKTlBi9NpPWuWo5cUDqaRkQLVGyJdRlwdJmzOp1q3F1OXT
	 +jV/yQBIeviI4n4Otip23A9Dn/+83ojhbieZy21jgd/sCtH4UroJMzc+gFctqR9+dE
	 KPQqYvNWjvIQo2OKXtouvz65LKJBjhNmew0cRzXi9MBz8t+he/Sfg3XSoGmoTD1Al2
	 cozva2zC4ybEeyevVYOtOnwwutjbihapYX0bpExUXclmr2wEiv38Gb2UldfAXgqqou
	 NNT+alNIO6F9Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Taniya Das <taniya.das@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 301/385] clk: qcom: rcg2: compute 2d using duty fraction directly
Date: Sat, 28 Feb 2026 12:58:43 -0500
Message-ID: <20260228180011.1568201-301-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
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
index bf6406f5279a4..005c1da75dafc 100644
--- a/drivers/clk/qcom/clk-rcg2.c
+++ b/drivers/clk/qcom/clk-rcg2.c
@@ -587,7 +587,7 @@ static int clk_rcg2_get_duty_cycle(struct clk_hw *hw, struct clk_duty *duty)
 static int clk_rcg2_set_duty_cycle(struct clk_hw *hw, struct clk_duty *duty)
 {
 	struct clk_rcg2 *rcg = to_clk_rcg2(hw);
-	u32 notn_m, n, m, d, not2d, mask, duty_per, cfg;
+	u32 notn_m, n, m, d, not2d, mask, cfg;
 	int ret;
 
 	/* Duty-cycle cannot be modified for non-MND RCGs */
@@ -606,10 +606,8 @@ static int clk_rcg2_set_duty_cycle(struct clk_hw *hw, struct clk_duty *duty)
 
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

