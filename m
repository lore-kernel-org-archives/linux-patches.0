Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 808271798C;
	Mon, 14 Oct 2024 15:22:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919348; cv=none; b=GFNvMsT9ztRAWSJiVpFqKuSMjXRTGlAx98DO1mjO4AixnLSwo0koBNiT+AvMp8SK40eQJmY278afX880JaiwCfv8xESnrFVhCKKt1doA7oX9nRs4QEgKaCIkk0AZ/MWDzsUzAw7GrGxrvRfFyTf12zG1mx35QkPSmiTlhSSb07g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919348; c=relaxed/simple;
	bh=niXv30vTWzr78bhbVUhlUhCg1ICshR93yZecoNvRHCg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fo9i9rrtMGOTNiN8pfwvxDbimV/U0c2qvEVAtg8hy+T8am54Ik4SpTAENfRKyYt4Qz2EWymqv2aj686u8NFyFw0SM7blAIg0Tjmrtb8gfgTDIDfs5XQchhABgfUvUPRxKflYAe0JOKdYKWMjJSqRqzghGoWj025Gz/H6UHJAlDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ojsXpTLH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ojsXpTLH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E545DC4CEC3;
	Mon, 14 Oct 2024 15:22:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919348;
	bh=niXv30vTWzr78bhbVUhlUhCg1ICshR93yZecoNvRHCg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ojsXpTLHArC0nKMGpIdeFDMvMbORbLoqBjvAWSPlAiK5wE3XoZPf301LzBA6brEYL
	 35InAKQAEPIFwpN2zaKt+B5qyXpTH9s2Ed3q9R5F44pWkfAanjyMkHa3eP0JzmVUHB
	 DGLEdwHsYltYtkkk+8DeDyNQIwXS1RTLMewTCCXo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.1 584/798] clk: qcom: gcc-sm8450: Do not turn off PCIe GDSCs during gdsc_disable()
Date: Mon, 14 Oct 2024 16:18:58 +0200
Message-ID: <20241014141240.946210658@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

commit 889e1332310656961855c0dcedbb4dbe78e39d22 upstream.

With PWRSTS_OFF_ON, PCIe GDSCs are turned off during gdsc_disable(). This
can happen during scenarios such as system suspend and breaks the resume
of PCIe controllers from suspend.

So use PWRSTS_RET_ON to indicate the GDSC driver to not turn off the GDSCs
during gdsc_disable() and allow the hardware to transition the GDSCs to
retention when the parent domain enters low power state during system
suspend.

Cc: stable@vger.kernel.org # 5.17
Fixes: db0c944ee92b ("clk: qcom: Add clock driver for SM8450")
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Link: https://lore.kernel.org/r/20240722105733.13040-1-manivannan.sadhasivam@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/qcom/gcc-sm8450.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/clk/qcom/gcc-sm8450.c
+++ b/drivers/clk/qcom/gcc-sm8450.c
@@ -2934,7 +2934,7 @@ static struct gdsc pcie_0_gdsc = {
 	.pd = {
 		.name = "pcie_0_gdsc",
 	},
-	.pwrsts = PWRSTS_OFF_ON,
+	.pwrsts = PWRSTS_RET_ON,
 };
 
 static struct gdsc pcie_1_gdsc = {
@@ -2942,7 +2942,7 @@ static struct gdsc pcie_1_gdsc = {
 	.pd = {
 		.name = "pcie_1_gdsc",
 	},
-	.pwrsts = PWRSTS_OFF_ON,
+	.pwrsts = PWRSTS_RET_ON,
 };
 
 static struct gdsc ufs_phy_gdsc = {


