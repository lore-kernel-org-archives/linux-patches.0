Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDD3126B080;
	Thu, 13 Feb 2025 15:06:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459215; cv=none; b=jLZYOx578zRosYmYSd2Fp0+DuLe/5myrffFC3P/eAttIjL8wbSXjFQDqnFZCjxggpQeoRqMCpdDQqA5Ro2fdqS9ZFA8OIZTmrJZizLRJkcp8GVhnNLwYFs4l0yy9ZU0M8GCxNJxEv728ciQzCP86v5td/940DxaDJRfKrQC95Ck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459215; c=relaxed/simple;
	bh=HQUrCYN8Y3iTS6AvqkxGCzWD337T7oUK6eNL6qrf/t4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TdP2srInDwEzgAzQrCpeS9NotYnnWSGBQkDX/d3y1P/61PUnTLW8yXMjdptjXT/7cqo8dpUHhS6Hm/o9g9gGtfmgyrXtMBk1kMY8eUVY6MQ9vcZo1YFp61hB1SRR5ZxoDLfH5mRQeygAWHMYBmSSDFnxQkdDp3pyfy+MnnjFMi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OZ9AiCr4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OZ9AiCr4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CFF5C4CED1;
	Thu, 13 Feb 2025 15:06:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459214;
	bh=HQUrCYN8Y3iTS6AvqkxGCzWD337T7oUK6eNL6qrf/t4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OZ9AiCr4ajLzKR4OsP5BFYnze/KrFFGysABC3hXWdF8GSxmxAiNiq5V1kn+ryRLPC
	 OD57f/9AXRZ1iCNw/EjlmRUxK6Mf6EstIJJ8No7hxTKiHqLSRbaJr1BYXcOIcW8rqm
	 ge5ZXPmlzKMvAND3mXzetEXzzcpHGuNs3mqNzyNA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.13 198/443] clk: qcom: gcc-sm8550: Do not turn off PCIe GDSCs during gdsc_disable()
Date: Thu, 13 Feb 2025 15:26:03 +0100
Message-ID: <20250213142448.252889909@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

commit 967e011013eda287dbec9e8bd3a19ebe730b8a08 upstream.

With PWRSTS_OFF_ON, PCIe GDSCs are turned off during gdsc_disable(). This
can happen during scenarios such as system suspend and breaks the resume
of PCIe controllers from suspend.

So use PWRSTS_RET_ON to indicate the GDSC driver to not turn off the GDSCs
during gdsc_disable() and allow the hardware to transition the GDSCs to
retention when the parent domain enters low power state during system
suspend.

Cc: stable@vger.kernel.org # 6.2
Fixes: 955f2ea3b9e9 ("clk: qcom: Add GCC driver for SM8550")
Reported-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Tested-by: Neil Armstrong <neil.armstrong@linaro.org> # on QRD8550
Link: https://lore.kernel.org/r/20241219170011.70140-1-manivannan.sadhasivam@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/qcom/gcc-sm8550.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/clk/qcom/gcc-sm8550.c
+++ b/drivers/clk/qcom/gcc-sm8550.c
@@ -3003,7 +3003,7 @@ static struct gdsc pcie_0_gdsc = {
 	.pd = {
 		.name = "pcie_0_gdsc",
 	},
-	.pwrsts = PWRSTS_OFF_ON,
+	.pwrsts = PWRSTS_RET_ON,
 	.flags = VOTABLE | POLL_CFG_GDSCR | RETAIN_FF_ENABLE,
 };
 
@@ -3014,7 +3014,7 @@ static struct gdsc pcie_0_phy_gdsc = {
 	.pd = {
 		.name = "pcie_0_phy_gdsc",
 	},
-	.pwrsts = PWRSTS_OFF_ON,
+	.pwrsts = PWRSTS_RET_ON,
 	.flags = VOTABLE | POLL_CFG_GDSCR | RETAIN_FF_ENABLE,
 };
 
@@ -3025,7 +3025,7 @@ static struct gdsc pcie_1_gdsc = {
 	.pd = {
 		.name = "pcie_1_gdsc",
 	},
-	.pwrsts = PWRSTS_OFF_ON,
+	.pwrsts = PWRSTS_RET_ON,
 	.flags = VOTABLE | POLL_CFG_GDSCR | RETAIN_FF_ENABLE,
 };
 
@@ -3036,7 +3036,7 @@ static struct gdsc pcie_1_phy_gdsc = {
 	.pd = {
 		.name = "pcie_1_phy_gdsc",
 	},
-	.pwrsts = PWRSTS_OFF_ON,
+	.pwrsts = PWRSTS_RET_ON,
 	.flags = VOTABLE | POLL_CFG_GDSCR | RETAIN_FF_ENABLE,
 };
 


