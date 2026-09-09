Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3554D5678C1;
	Wed,  9 Sep 2026 13:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962336; cv=none; b=XTCIKBAJzl6YaqPooo/9Qs2vIOCwSxzHBdj4JaYeO2tewWZa6oxnj5A1J4q7Xo2v8c8Fklmzf9kWyyOwiqODru+udYHr1QdrTvHza8x9Y4VJ5T36oiI0HVB99dB9cNCB5uDSESD6JfLZEV0TrfeZi75zYHAf/Mga6AUa64XypA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962336; c=relaxed/simple;
	bh=B/u2YcK2xlSH8pt0DHwfJM+g4mw2Q1N8nhELiovDvxM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fIPyq9AqaLShNnU746EV3NZwQ6rTPx8xLR0ixijj4TVUGHZB/OpM8GXM/GTix+uxbs/jK/An1VrbbtcM9OCmffLEy2b9XSyjIkHRXeKkFHvlAeycnN2ih9TONxwM7YYdOhVu+KytT/cJmo1t3AoCQEePctNv3wQfoGpNz0zJhcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g3kMxEsa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g3kMxEsa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FBC01F00A3A;
	Wed,  9 Sep 2026 13:58:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962335;
	bh=dEqPhn3QMBwBRV6cPVWtEluU2vfssvntKVKP1QEk3DY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g3kMxEsasVzCOpainm2C2kub3JdWSTprUdFAy4C3/uFqnyR6Ma2hDv4EmQlPoLgjJ
	 G0EIiXf4Z9oU2m+6q2xm7SxunNmJm5U2QlqCIZr3MonatdM0DF1rrV6FdT+otTKLYB
	 HOIQEl+FsgyyAXWX796ES0WumA3NxanTqNb1jm4o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Stephan Gerhold <stephan@gerhold.net>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 7.2 216/556] clk: qcom: gcc-mdm9607: Fix enable_reg for gcc_blsp1_sleep_clk
Date: Wed,  9 Sep 2026 15:38:16 +0200
Message-ID: <20260909134237.997306180@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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


