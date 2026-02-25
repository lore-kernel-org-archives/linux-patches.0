Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E7DE2FFFBE;
	Wed, 25 Feb 2026 06:57:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002640; cv=none; b=QcYxC12fwy9l1rADuoUOb4w1oBeSwMbmT3MmVS0QF2OvWNyMwfmmA6z83VvxWWdVSo+E6TPbB6Tgtd9db1bJmoMPuRgaDnjwXiCaR5Pgb7awFDqhGDVnvvfHgNpNYFMaGhd9QF6srJSgG2161nYP4t920+Vf3kDEKBmon90R43c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002640; c=relaxed/simple;
	bh=F64gDmhycfLxl2rGA76ZyIc+GIU0OIpE2Q6YE+yHW2s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=naQ4Epbs1FFi+AptsBo5ppDYcHN2euwGNvJx46x5+7rNkPFKZXcpkd4brMri9T1GFJEC9/ajUP5O1qhHQlgMDBawaSSDpbfvIGTeUCEAosTdwbuMm/WP8FXCPJKzwCNJsiZVG8q0ZJzvy2hbkrJ4vi4kpl38qjpLkxArWHj5brQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=INnkvAlh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="INnkvAlh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F259DC116D0;
	Wed, 25 Feb 2026 06:57:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002640;
	bh=F64gDmhycfLxl2rGA76ZyIc+GIU0OIpE2Q6YE+yHW2s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=INnkvAlhM4FUSF1k24gS4RVYRRORqN1Xe1+ZR/kq7/UTllUiec16kMTfmpGJ2MrSA
	 +5UyiArLD1mUGm0mnbrDllMJ5TgWA7CCogF6SyGEWnGBSw32BWck9p23XWCa5M2ZQI
	 QoXtaxPxGXBpnlsg3mXiAhiyqgAqIow+TpVjNBIo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Taniya Das <taniya.das@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 406/641] clk: qcom: rcg2: compute 2d using duty fraction directly
Date: Tue, 24 Feb 2026 17:22:12 -0800
Message-ID: <20260225012358.402530673@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

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
index e18cb8807d735..2838d4cb2d58e 100644
--- a/drivers/clk/qcom/clk-rcg2.c
+++ b/drivers/clk/qcom/clk-rcg2.c
@@ -755,7 +755,7 @@ static int clk_rcg2_get_duty_cycle(struct clk_hw *hw, struct clk_duty *duty)
 static int clk_rcg2_set_duty_cycle(struct clk_hw *hw, struct clk_duty *duty)
 {
 	struct clk_rcg2 *rcg = to_clk_rcg2(hw);
-	u32 notn_m, n, m, d, not2d, mask, duty_per, cfg;
+	u32 notn_m, n, m, d, not2d, mask, cfg;
 	int ret;
 
 	/* Duty-cycle cannot be modified for non-MND RCGs */
@@ -774,10 +774,8 @@ static int clk_rcg2_set_duty_cycle(struct clk_hw *hw, struct clk_duty *duty)
 
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



