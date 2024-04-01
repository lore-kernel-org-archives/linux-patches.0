Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B45B1CA8F;
	Mon,  1 Apr 2024 15:53:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711986838; cv=none; b=BEMzlNylaRJrI1zfl+OWiHp/ccA5iwLgWPH0Oh/Bi6tnIPgFThLxdfqWPDwjKjL2XrIrYXSMAFxSHzuI06nUgktdwNacM7qAoeTmjTM2IccpScXHZE90Jm6rpVxs2r2IpbXB7YERASH/w44szN3uD/Nes+spABe+cu266oPvt8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711986838; c=relaxed/simple;
	bh=5iQ5zy16s9uv2BUoYxGVJzwLdnw9091JzcVuPrFPLNk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WZkHUV0oW+LW1/RKtynIEerA3Ba5KsgkbAIaU4nCiCefACTuUdzPHmiHT9IrL1EpAyFSciPgdwbgPoP1WrLaGqmTzX61JKie+9Z2vw8xLutkAHG6V+2pxB7LbcMWleasaQ7IlGLqWPQ3L1huD5Ik5AmQyOtCYZ1/wCGKxGulphI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UnZdpxGh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UnZdpxGh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87980C433C7;
	Mon,  1 Apr 2024 15:53:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711986838;
	bh=5iQ5zy16s9uv2BUoYxGVJzwLdnw9091JzcVuPrFPLNk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UnZdpxGhZcdFs5SoVx9iT+D27MKgaAuu/zeHaocqU23cN9k555GKUGclsKkOJrMpj
	 WkQVTbE2KDQrzqNlxmibl4raop/K6dfmFBnt0/LvgeVM/ITXD9e+aovycxG+7nGvFT
	 RWtzLKDGBd7cBBh7W2yVeqtF1QpEYf1lJA1aReNA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabor Juhos <j4g8y7@gmail.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 071/399] clk: qcom: gcc-ipq6018: fix terminating of frequency table arrays
Date: Mon,  1 Apr 2024 17:40:37 +0200
Message-ID: <20240401152551.304798595@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index b366912cd6480..ef1e2ce4804d2 100644
--- a/drivers/clk/qcom/gcc-ipq6018.c
+++ b/drivers/clk/qcom/gcc-ipq6018.c
@@ -1554,6 +1554,7 @@ static struct clk_regmap_div nss_ubi0_div_clk_src = {
 
 static const struct freq_tbl ftbl_pcie_aux_clk_src[] = {
 	F(24000000, P_XO, 1, 0, 0),
+	{ }
 };
 
 static const struct clk_parent_data gcc_xo_gpll0_core_pi_sleep_clk[] = {
@@ -1734,6 +1735,7 @@ static const struct freq_tbl ftbl_sdcc_ice_core_clk_src[] = {
 	F(160000000, P_GPLL0, 5, 0, 0),
 	F(216000000, P_GPLL6, 5, 0, 0),
 	F(308570000, P_GPLL6, 3.5, 0, 0),
+	{ }
 };
 
 static const struct clk_parent_data gcc_xo_gpll0_gpll6_gpll0_div2[] = {
-- 
2.43.0



