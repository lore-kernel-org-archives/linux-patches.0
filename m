Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CDC2266EFE;
	Tue,  8 Apr 2025 11:24:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111467; cv=none; b=WZ1l/v9hVyeTf/kFnV1zdrylwv/Mno126hTKAKld/Dqjg3kkXnORiIBZuJt4CuHHOkUuJVZvwTeGRt7i3XLeCEfDeFSs6Rv3UW6hzpHsXQCfnJK68aCmJKL1vH0mVYByXTie8/CQ+oF8vpNoWLqkh8mFTIidsLA/lo6FrDDHUd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111467; c=relaxed/simple;
	bh=T4AQ4HEQHS0A+wN+segErDketbql7wjW3cbvTU1uU7E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Z5iJJp6036M0vgscPVzyrTbfUS+qncZOIDOEvt7SMpt3jliaLLAmOeOx+8e1sj9ZCSh/Nn6cS6LK7QwAPDRPD+SUTtMfvk0EwIks4fzxmnaWGIintSgrfbPkpTpv1WkGonuv2ctvpV3/fg+YgmSZuKl1EZq4zeJw/DLaAryqucI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CfkLeDIM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CfkLeDIM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 915DCC4CEE5;
	Tue,  8 Apr 2025 11:24:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111466;
	bh=T4AQ4HEQHS0A+wN+segErDketbql7wjW3cbvTU1uU7E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CfkLeDIMax2oszS3krW+ArjLb4fgjkOxtVgFcLUyT6YHjk6qlrIIBjsmYslziyqwG
	 //1k9MZTjcr3ZzT+S8D8pMVp5WaBcwaqjr+FNvliYaLikttQyiSDD/o0uXL6jFAsV+
	 Lqxk81ciL90WC6RNR4qmW4+lYk73kcQF+7xJAfQw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manikanta Mylavarapu <quic_mmanikan@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 424/731] clk: qcom: ipq5424: fix software and hardware flow control error of UART
Date: Tue,  8 Apr 2025 12:45:21 +0200
Message-ID: <20250408104924.136455040@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Manikanta Mylavarapu <quic_mmanikan@quicinc.com>

[ Upstream commit 4b28beb882a0a1af0ce47a8a87e7877a3ae6ad36 ]

The UART’s software and hardware flow control are currently not
functioning correctly.

For software flow control, the following error is encountered:
qcom_geni_serial 1a80000.serial: Couldn't find suitable
clock rate for 56000000, 3500000, 2500000, 1152000, 921600, 19200

During hardware flow control testing, a “Retry 0: Got ZCAN error” is
observed.

To address these issues, update the UART frequency table to include all
supported frequencies according to the frequency plan.

Fixes: 21b5d5a4a311 ("clk: qcom: add Global Clock controller (GCC) driver for IPQ5424 SoC")
Signed-off-by: Manikanta Mylavarapu <quic_mmanikan@quicinc.com>
Link: https://lore.kernel.org/r/20250124060914.1564681-1-quic_mmanikan@quicinc.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-ipq5424.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/clk/qcom/gcc-ipq5424.c b/drivers/clk/qcom/gcc-ipq5424.c
index 107424395ef17..3d42f3d85c7a9 100644
--- a/drivers/clk/qcom/gcc-ipq5424.c
+++ b/drivers/clk/qcom/gcc-ipq5424.c
@@ -592,13 +592,19 @@ static struct clk_rcg2 gcc_qupv3_spi1_clk_src = {
 };
 
 static const struct freq_tbl ftbl_gcc_qupv3_uart0_clk_src[] = {
-	F(960000, P_XO, 10, 2, 5),
-	F(4800000, P_XO, 5, 0, 0),
-	F(9600000, P_XO, 2, 4, 5),
-	F(16000000, P_GPLL0_OUT_MAIN, 10, 1, 5),
+	F(3686400,  P_GCC_GPLL0_OUT_MAIN_DIV_CLK_SRC, 1, 144, 15625),
+	F(7372800,  P_GCC_GPLL0_OUT_MAIN_DIV_CLK_SRC, 1, 288, 15625),
+	F(14745600, P_GCC_GPLL0_OUT_MAIN_DIV_CLK_SRC, 1, 576, 15625),
 	F(24000000, P_XO, 1, 0, 0),
 	F(25000000, P_GPLL0_OUT_MAIN, 16, 1, 2),
-	F(50000000, P_GPLL0_OUT_MAIN, 16, 0, 0),
+	F(32000000, P_GPLL0_OUT_MAIN, 1, 1, 25),
+	F(40000000, P_GPLL0_OUT_MAIN, 1, 1, 20),
+	F(46400000, P_GPLL0_OUT_MAIN, 1, 29, 500),
+	F(48000000, P_GPLL0_OUT_MAIN, 1, 3, 50),
+	F(51200000, P_GPLL0_OUT_MAIN, 1, 8, 125),
+	F(56000000, P_GPLL0_OUT_MAIN, 1, 7, 100),
+	F(58982400, P_GPLL0_OUT_MAIN, 1, 1152, 15625),
+	F(60000000, P_GPLL0_OUT_MAIN, 1, 3, 40),
 	F(64000000, P_GPLL0_OUT_MAIN, 12.5, 0, 0),
 	{ }
 };
-- 
2.39.5



