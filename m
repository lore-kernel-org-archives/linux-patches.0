Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD4EF47A64;
	Mon,  1 Apr 2024 17:00:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990801; cv=none; b=ujLbzpT+G/mGNyFfj/B+FubkPYwF7nRjj+Fo7oiepHzlms7fMGsQZQEiNprTxm495W/aDsI3xl4InzfzomEXOL2FHtv7weQ26xVEDiWpNq/d69mteNxh6ipUrw1oZHQyIRbmFdLB7xoueqf9Cxks/tx0ddCRu0d370KaxuOdDG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990801; c=relaxed/simple;
	bh=wIYwedtcY17fK9rP8S0EXWkDCWhMxkIebqn7vK84cKs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ork6+CLiarOsvLHlbUUwT9VatYVnOJ2TGIC1Ti+ybQ4EGZbXzdUp12eWZMwX3Mwtcv+Fmp2tSsZ9dpCkStNhNyRadnkKxAfjtWo+6QnGA1walgmV4BapWOxpERZ/d8NbBp1ua572dWcSdO6QyXhDDaARbVr3n42cPLX9BqjokYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sZJh2kIv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sZJh2kIv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20A6AC433F1;
	Mon,  1 Apr 2024 17:00:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990801;
	bh=wIYwedtcY17fK9rP8S0EXWkDCWhMxkIebqn7vK84cKs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sZJh2kIvaw/oHBS9EVsUutGcx915B3rYC06BNZ5ql2Bmu8RZ+19/YXjcSMqqx4/pJ
	 NN+SJgsDB1OKXxUAJEXLTenO0WPOPjXU8y4ljH2RNb0nZFwRErVeSm8sGmAlRELti3
	 YzfYEutd53KYmax6zdWTUh16HMq8muX7FHjueoSg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabor Juhos <j4g8y7@gmail.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 053/272] clk: qcom: gcc-ipq6018: fix terminating of frequency table arrays
Date: Mon,  1 Apr 2024 17:44:03 +0200
Message-ID: <20240401152532.199257211@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152530.237785232@linuxfoundation.org>
References: <20240401152530.237785232@linuxfoundation.org>
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

From: Gabor Juhos <j4g8y7@gmail.com>

[ Upstream commit cdbc6e2d8108bc47895e5a901cfcaf799b00ca8d ]

The frequency table arrays are supposed to be terminated with an
empty element. Add such entry to the end of the arrays where it
is missing in order to avoid possible out-of-bound access when
the table is traversed by functions like qcom_find_freq() or
qcom_find_freq_floor().

Only compile tested.

Fixes: d9db07f088af ("clk: qcom: Add ipq6018 Global Clock Controller support")
Signed-off-by: Gabor Juhos <j4g8y7@gmail.com>
Reviewed-by: Stephen Boyd <sboyd@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240229-freq-table-terminator-v1-2-074334f0905c@gmail.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-ipq6018.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/clk/qcom/gcc-ipq6018.c b/drivers/clk/qcom/gcc-ipq6018.c
index 4c5c7a8f41d08..b9844e41cf99d 100644
--- a/drivers/clk/qcom/gcc-ipq6018.c
+++ b/drivers/clk/qcom/gcc-ipq6018.c
@@ -1557,6 +1557,7 @@ static struct clk_regmap_div nss_ubi0_div_clk_src = {
 
 static const struct freq_tbl ftbl_pcie_aux_clk_src[] = {
 	F(24000000, P_XO, 1, 0, 0),
+	{ }
 };
 
 static const struct clk_parent_data gcc_xo_gpll0_core_pi_sleep_clk[] = {
@@ -1737,6 +1738,7 @@ static const struct freq_tbl ftbl_sdcc_ice_core_clk_src[] = {
 	F(160000000, P_GPLL0, 5, 0, 0),
 	F(216000000, P_GPLL6, 5, 0, 0),
 	F(308570000, P_GPLL6, 3.5, 0, 0),
+	{ }
 };
 
 static const struct clk_parent_data gcc_xo_gpll0_gpll6_gpll0_div2[] = {
-- 
2.43.0



