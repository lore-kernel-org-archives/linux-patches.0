Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8D63446AC;
	Mon,  1 Apr 2024 16:14:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711988053; cv=none; b=mf9EXjnRAyB2+pMCvGus6/bEc+gutz0nZxJdOCgqxpIvNwEe/u3B4XnrudEHwWaE084w3YEXBYgbZcI7gnfQKvTw4bewCtYeJPJMjHsD8SgnE1TwhAI/7EncWLvu3HWkGKJkFBT8EkNBHBeechNtJmCighYmd6IBYyo35XfonNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711988053; c=relaxed/simple;
	bh=LBq0FjvapeRGQGFKp7URBNtlKiirU+rnkVilAX3BLHE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NsQF90p8fFa5jeoNOhOldUyXjbyu2MKBrkyN59IEld8L3rer6NuVBM6HKo5WJTM4IFkwOVlBDN+WsZDA2A4I1p4clniLmCi/3P0v6AM5ZVWP5L9RyO1eeR/dP5ju/UYzadHW9VQwX8jS/Fb8Crt4aTzMSDyYHyCiqjB9Z8pDM+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D9tjC80W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D9tjC80W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 433F5C433C7;
	Mon,  1 Apr 2024 16:14:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711988053;
	bh=LBq0FjvapeRGQGFKp7URBNtlKiirU+rnkVilAX3BLHE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D9tjC80Ww1MFYhjb1lratLRzqP7iI33s7GATiXCnCWFUV3RgMeh9ClWB66vq9ua5b
	 IEIVENtV1rq1gNVyxlRQoQUHX1zPyNmHJ3S3qT3O2tEV9tzxnYQH0d0wKW+rSObROo
	 1bI58cTvu69xxv0HZJaSctwDFzzlzyavrneGTRtg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabor Juhos <j4g8y7@gmail.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 069/432] clk: qcom: gcc-ipq5018: fix terminating of frequency table arrays
Date: Mon,  1 Apr 2024 17:40:56 +0200
Message-ID: <20240401152555.182618752@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gabor Juhos <j4g8y7@gmail.com>

[ Upstream commit 90ad946fff70f312b8d23226afc38c13ddd88c4b ]

The frequency table arrays are supposed to be terminated with an
empty element. Add such entry to the end of the arrays where it
is missing in order to avoid possible out-of-bound access when
the table is traversed by functions like qcom_find_freq() or
qcom_find_freq_floor().

Fixes: e3fdbef1bab8 ("clk: qcom: Add Global Clock controller (GCC) driver for IPQ5018")
Signed-off-by: Gabor Juhos <j4g8y7@gmail.com>
Reviewed-by: Stephen Boyd <sboyd@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240229-freq-table-terminator-v1-1-074334f0905c@gmail.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-ipq5018.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/clk/qcom/gcc-ipq5018.c b/drivers/clk/qcom/gcc-ipq5018.c
index e2bd54826a4ce..c1732d70e3a23 100644
--- a/drivers/clk/qcom/gcc-ipq5018.c
+++ b/drivers/clk/qcom/gcc-ipq5018.c
@@ -857,6 +857,7 @@ static struct clk_rcg2 lpass_sway_clk_src = {
 
 static const struct freq_tbl ftbl_pcie0_aux_clk_src[] = {
 	F(2000000, P_XO, 12, 0, 0),
+	{ }
 };
 
 static struct clk_rcg2 pcie0_aux_clk_src = {
@@ -1099,6 +1100,7 @@ static const struct freq_tbl ftbl_qpic_io_macro_clk_src[] = {
 	F(100000000, P_GPLL0, 8, 0, 0),
 	F(200000000, P_GPLL0, 4, 0, 0),
 	F(320000000, P_GPLL0, 2.5, 0, 0),
+	{ }
 };
 
 static struct clk_rcg2 qpic_io_macro_clk_src = {
@@ -1194,6 +1196,7 @@ static struct clk_rcg2 ubi0_axi_clk_src = {
 static const struct freq_tbl ftbl_ubi0_core_clk_src[] = {
 	F(850000000, P_UBI32_PLL, 1, 0, 0),
 	F(1000000000, P_UBI32_PLL, 1, 0, 0),
+	{ }
 };
 
 static struct clk_rcg2 ubi0_core_clk_src = {
-- 
2.43.0



