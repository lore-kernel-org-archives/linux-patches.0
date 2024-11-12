Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E44B419E992;
	Tue, 12 Nov 2024 10:48:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731408514; cv=none; b=E/uBGKHF6JF+4Vkvi3U3TB7rUPcBv4cWVq+XVnqNQHx8//37SVj2di4Wty45oeDcQ5bIhihKmEOTleofgkTACXKqyvVYFVCLg8qRS8CaK5LIJgJZdrtzVF+aB3qw8LREB0NItFWbxWPNq8jIIxFHAyNLGNxdsGBYYQ/C7t+fAf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731408514; c=relaxed/simple;
	bh=Kcll9nRJS5MCSDL/eJGFa02clpK7Qett7lbyjKxp9IY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HdLL472mHO0AgQMRtdfJNUppkyy1w/kykJfaIiSPUKyXVPYypxXGxZN9Dk09KxWagZmDlfGEXa2DV1WZiOcTOKLWvmmDQkZ5En7uX7OZYNotZxUHl+Hpyo8DgA01I4bkBIYQC6N1aI/gy/Wc+Ibks7w3MWIOJhJ1hTh0se1cpO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HUDgLstK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HUDgLstK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B292C4CECD;
	Tue, 12 Nov 2024 10:48:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731408513;
	bh=Kcll9nRJS5MCSDL/eJGFa02clpK7Qett7lbyjKxp9IY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HUDgLstK7dTLB7Vy97y1XUusv9aMcac8yw6GjmJv2MjabF9uuPCj5KsfRkL8yIkaO
	 PgAt2EDGONuEnSSoaCe/P1dW0vvLe/uDEwKxbdjg/6vGja3LKweLIiZLSPgfl+D84d
	 lFTwrF928VaQDmVnJGFR1mIHHzwZgawbwLKGBdBI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Tipton <quic_mdtipton@quicinc.com>,
	Qiang Yu <quic_qianyu@quicinc.com>,
	Konrad Dybcio <konradybcio@kernel.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.11 165/184] clk: qcom: gcc-x1e80100: Fix halt_check for pipediv2 clocks
Date: Tue, 12 Nov 2024 11:22:03 +0100
Message-ID: <20241112101907.200628689@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101900.865487674@linuxfoundation.org>
References: <20241112101900.865487674@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qiang Yu <quic_qianyu@quicinc.com>

commit bf0a800415a7397617765fe5f5278a645195c75a upstream.

The pipediv2_clk's source from the same mux as pipe clock. So they have
same limitation, which is that the PHY sequence requires to enable these
local CBCs before the PHY is actually outputting a clock to them. This
means the clock won't actually turn on when we vote them. Hence, let's
skip the halt bit check of the pipediv2_clk, otherwise pipediv2_clk may
stuck at off state during bootup.

Cc: stable@vger.kernel.org
Fixes: 161b7c401f4b ("clk: qcom: Add Global Clock controller (GCC) driver for X1E80100")
Suggested-by: Mike Tipton <quic_mdtipton@quicinc.com>
Signed-off-by: Qiang Yu <quic_qianyu@quicinc.com>
Reviewed-by: Konrad Dybcio <konradybcio@kernel.org>
Reviewed-by: Johan Hovold <johan+linaro@kernel.org>
Link: https://lore.kernel.org/r/20241011104142.1181773-6-quic_qianyu@quicinc.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/qcom/gcc-x1e80100.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/clk/qcom/gcc-x1e80100.c b/drivers/clk/qcom/gcc-x1e80100.c
index 0f578771071f..81ba5ceab342 100644
--- a/drivers/clk/qcom/gcc-x1e80100.c
+++ b/drivers/clk/qcom/gcc-x1e80100.c
@@ -3123,7 +3123,7 @@ static struct clk_branch gcc_pcie_3_pipe_clk = {
 
 static struct clk_branch gcc_pcie_3_pipediv2_clk = {
 	.halt_reg = 0x58060,
-	.halt_check = BRANCH_HALT_VOTED,
+	.halt_check = BRANCH_HALT_SKIP,
 	.clkr = {
 		.enable_reg = 0x52020,
 		.enable_mask = BIT(5),
@@ -3248,7 +3248,7 @@ static struct clk_branch gcc_pcie_4_pipe_clk = {
 
 static struct clk_branch gcc_pcie_4_pipediv2_clk = {
 	.halt_reg = 0x6b054,
-	.halt_check = BRANCH_HALT_VOTED,
+	.halt_check = BRANCH_HALT_SKIP,
 	.clkr = {
 		.enable_reg = 0x52010,
 		.enable_mask = BIT(27),
@@ -3373,7 +3373,7 @@ static struct clk_branch gcc_pcie_5_pipe_clk = {
 
 static struct clk_branch gcc_pcie_5_pipediv2_clk = {
 	.halt_reg = 0x2f054,
-	.halt_check = BRANCH_HALT_VOTED,
+	.halt_check = BRANCH_HALT_SKIP,
 	.clkr = {
 		.enable_reg = 0x52018,
 		.enable_mask = BIT(19),
@@ -3511,7 +3511,7 @@ static struct clk_branch gcc_pcie_6a_pipe_clk = {
 
 static struct clk_branch gcc_pcie_6a_pipediv2_clk = {
 	.halt_reg = 0x31060,
-	.halt_check = BRANCH_HALT_VOTED,
+	.halt_check = BRANCH_HALT_SKIP,
 	.clkr = {
 		.enable_reg = 0x52018,
 		.enable_mask = BIT(28),
@@ -3649,7 +3649,7 @@ static struct clk_branch gcc_pcie_6b_pipe_clk = {
 
 static struct clk_branch gcc_pcie_6b_pipediv2_clk = {
 	.halt_reg = 0x8d060,
-	.halt_check = BRANCH_HALT_VOTED,
+	.halt_check = BRANCH_HALT_SKIP,
 	.clkr = {
 		.enable_reg = 0x52010,
 		.enable_mask = BIT(28),
-- 
2.47.0



