Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E562563FCF;
	Wed,  9 Sep 2026 14:20:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963660; cv=none; b=jhcIdHlsiAyxnI652o4RvFkyxf5s1FDFLwCrK2uX9SPK2XWT215kkGOq4joXUdA0lpHUueTsKOf8gNPFg521iX0ocNfgJVPuqpMw7fQvQJi0NiYesT1MWhQ8Yc3+6ASPjKUNxuTcMz/K0INRtk9W+HeCSyRro6Z7wyQjGsg0xZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963660; c=relaxed/simple;
	bh=bV1mjY87qpjmMao8EuXxaYSMgi/E5ZRUnlIxf3rK14w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uCEnx5KI4eyare1rzTNc6veIZRPqvmK9OyJCY4oVfUXB2wbfL2f1qh9yQRAiHgSgC1FmIgNjKjZVIidh6eTKsoNRFSLVHdbf94kxvxQF0kqlmqLJz6/y76lh8VMkkAFxG1wB5HAITJ0p5VUZiX5IZWi42hM6kxxuXzY3PmsnvwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m+YEBBX0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m+YEBBX0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69ABC1F00A3A;
	Wed,  9 Sep 2026 14:20:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963659;
	bh=tgGa0CPteUDGU+S/2QJ2+ByGSNbQMifI9Iw+OmunPTY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m+YEBBX0injYa2N2MJ7QbySgINVQPAbSS6ulMU9hgeQqwdZSXRdcMdZXsiDd+Tjmv
	 YoueQ6SAD34iMn4bJXSvzFMFHadXBW0GAJkmtpGsu6nPSRLKfbssifmDKUjTcZzE7F
	 fVWoRHQKIJgwOHkQbp9OieQklRLemxbCrATlMFK4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Stephan Gerhold <stephan@gerhold.net>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.18 154/583] clk: qcom: gcc-mdm9607: Fix enable_reg for gcc_blsp1_sleep_clk
Date: Wed,  9 Sep 2026 15:37:19 +0200
Message-ID: <20260909134243.532355461@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephan Gerhold <stephan@gerhold.net>

commit 944d0fb38cffe57a1d1ebf82c5c077bad82dcdbb upstream.

MDM9607 is similar to MSM8909, where the GCC_BLSP1_SLEEP_CBCR register is
read-only and only has the CLK_OFF bit to check if the clock is running.
This is a shared vote clock, the correct way to enable it is to vote for
BLSP1_SLEEP_CLK_ENA (BIT(9)) in GCC_APCS_CLOCK_BRANCH_ENA_VOTE (0x45004).

Cc: stable@vger.kernel.org
Fixes: 48b7253264ea ("clk: qcom: Add MDM9607 GCC driver")
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Stephan Gerhold <stephan@gerhold.net>
Link: https://lore.kernel.org/r/20260706-qcom-clk-mdm9607-fixes-v2-3-745565101869@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/qcom/gcc-mdm9607.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/clk/qcom/gcc-mdm9607.c
+++ b/drivers/clk/qcom/gcc-mdm9607.c
@@ -744,9 +744,10 @@ static struct clk_branch gcc_blsp1_ahb_c
 
 static struct clk_branch gcc_blsp1_sleep_clk = {
 	.halt_reg = 0x1004,
+	.halt_check = BRANCH_HALT_VOTED,
 	.clkr = {
-		.enable_reg = 0x1004,
-		.enable_mask = BIT(0),
+		.enable_reg = 0x45004,
+		.enable_mask = BIT(9),
 		.hw.init = &(struct clk_init_data){
 			.name = "gcc_blsp1_sleep_clk",
 			.parent_data = &(const struct clk_parent_data){


