Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CB7E53365;
	Thu, 12 Dec 2024 17:12:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023570; cv=none; b=cue+4laCzX3AmcTsUl9FGQDk6TPiKs8UW+SOy3JRJ9nDfh6j4xjvGcIc62VQf38GfcPOVCxxmJZBO9BXTnPC0VZeVwNLKPWHaLpmcX4vnSlYYgPitz5WoKtZ0RhhSUj6ZCgjORbIfQlWxYjdRnnakynn7gdBJqHtHnlWufMrMFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023570; c=relaxed/simple;
	bh=mfnPpnXtmIk8m5pzELfmVXPCRs32XYZmi1vgKL76J+o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g2nTzsK8hBzqS4U+wYGqVeTrIIEnoKNsjKvQA5DTWdYW2v+iEpfHNKmfpqssfGNqjbQAgo+4yIVc5vG/mR+Uov27fiCEDvzsIpEFjm15kgbCtSBDdeszUg40yR6Po3LY16MiFIXGncjOUfPO8XfEffHrU2uN6XrOf5iWST0KVfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XofZ2E6F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XofZ2E6F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B287C4CED0;
	Thu, 12 Dec 2024 17:12:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023569;
	bh=mfnPpnXtmIk8m5pzELfmVXPCRs32XYZmi1vgKL76J+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XofZ2E6FDGTHrEoHmz/D3PBqHHVgnPtNSN2/dUjfhYB2wSjIXK8qrN9vzGjkWNno8
	 6rvgmjNJV+b/q4oUNRFy5KLxUuMn6FivFPyA+wIQFlyOyyI4p2OuGKzIz3GSHv5oe3
	 i/YO2FShVwe6/Y7xTmfGZk6wbxC4Mt+s6SSVd/5w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabor Juhos <j4g8y7@gmail.com>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 5.10 011/459] clk: qcom: gcc-qcs404: fix initial rate of GPLL3
Date: Thu, 12 Dec 2024 15:55:49 +0100
Message-ID: <20241212144253.972933200@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gabor Juhos <j4g8y7@gmail.com>

commit 36d202241d234fa4ac50743510d098ad52bd193a upstream.

The comment before the config of the GPLL3 PLL says that the
PLL should run at 930 MHz. In contrary to this, calculating
the frequency from the current configuration values by using
19.2 MHz as input frequency defined in 'qcs404.dtsi', it gives
921.6 MHz:

  $ xo=19200000; l=48; alpha=0x0; alpha_hi=0x0
  $ echo "$xo * ($((l)) + $(((alpha_hi << 32 | alpha) >> 8)) / 2^32)" | bc -l
  921600000.00000000000000000000

Set 'alpha_hi' in the configuration to a value used in downstream
kernels [1][2] in order to get the correct output rate:

  $ xo=19200000; l=48; alpha=0x0; alpha_hi=0x70
  $ echo "$xo * ($((l)) + $(((alpha_hi << 32 | alpha) >> 8)) / 2^32)" | bc -l
  930000000.00000000000000000000

The change is based on static code analysis, compile tested only.

[1] https://git.codelinaro.org/clo/la/kernel/msm-5.4/-/blob/kernel.lnx.5.4.r56-rel/drivers/clk/qcom/gcc-qcs404.c?ref_type=heads#L335
[2} https://git.codelinaro.org/clo/la/kernel/msm-5.15/-/blob/kernel.lnx.5.15.r49-rel/drivers/clk/qcom/gcc-qcs404.c?ref_type=heads#L127

Cc: stable@vger.kernel.org
Fixes: 652f1813c113 ("clk: qcom: gcc: Add global clock controller driver for QCS404")
Signed-off-by: Gabor Juhos <j4g8y7@gmail.com>
Link: https://lore.kernel.org/r/20241022-fix-gcc-qcs404-gpll3-v1-1-c4d30d634d19@gmail.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/qcom/gcc-qcs404.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/clk/qcom/gcc-qcs404.c
+++ b/drivers/clk/qcom/gcc-qcs404.c
@@ -337,6 +337,7 @@ static struct clk_alpha_pll gpll1_out_ma
 /* 930MHz configuration */
 static const struct alpha_pll_config gpll3_config = {
 	.l = 48,
+	.alpha_hi = 0x70,
 	.alpha = 0x0,
 	.alpha_en_mask = BIT(24),
 	.post_div_mask = 0xf << 8,


