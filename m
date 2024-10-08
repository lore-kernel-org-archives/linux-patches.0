Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81FA81DF256;
	Tue,  8 Oct 2024 13:27:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728394047; cv=none; b=l5zSG9WwFHQ8oD5ETzNJprtmRO/t57N7uUX9CuMz5xbeUhepyF5iBkLmE1DwureETFgQZupaxZ9DJSRugZOtgGx+ok+ouU2HmG9PxaRSv0ZmmjUb33mWmrhwHeLPGeZtk3vl2N+YgnHEHu2engJVyegMJtu+w2YRywTN2N90wCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728394047; c=relaxed/simple;
	bh=XbbrajIq+Luz7orv+UoHn+xTq0v9SCCTWUs5vZyeRNQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gU5VvTY2GTBm525FFgA4hg9kOlC+DowncQjOYJUtZVohQkvldrvt9fD49O1ioFf8djbEDm+CEX0AT8yGKHSh1Odd2uWfpQhQkmv/mTFTE2lRcxRMEWx8HwH2aQhHwSWWzJcMnMFnRgCcZxZp3wy+O2vM81A/xA12TlOVZhHchQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yxll0E2p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yxll0E2p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0996EC4CEC7;
	Tue,  8 Oct 2024 13:27:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728394047;
	bh=XbbrajIq+Luz7orv+UoHn+xTq0v9SCCTWUs5vZyeRNQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yxll0E2pKV5am4ZlSFAogZqoSiYJbHM/jhEoZ/JL8NgCsIRHKCqSex9zz3R6Qiho2
	 kx32MxePQ1Qmcm5rifUMOg3F/iHbojwASOFqkm17FxPjgddAI8+XpGLiEZIaYMOc+G
	 HHIoODxSS0RhXux7n83KQjqU34wVnHftbAmXoYWE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.6 290/386] clk: qcom: gcc-sm8250: Do not turn off PCIe GDSCs during gdsc_disable()
Date: Tue,  8 Oct 2024 14:08:55 +0200
Message-ID: <20241008115640.797971338@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

commit ade508b545c969c72cd68479f275a5dd640fd8b9 upstream.

With PWRSTS_OFF_ON, PCIe GDSCs are turned off during gdsc_disable(). This
can happen during scenarios such as system suspend and breaks the resume
of PCIe controllers from suspend.

So use PWRSTS_RET_ON to indicate the GDSC driver to not turn off the GDSCs
during gdsc_disable() and allow the hardware to transition the GDSCs to
retention when the parent domain enters low power state during system
suspend.

Cc: stable@vger.kernel.org # 5.7
Fixes: 3e5770921a88 ("clk: qcom: gcc: Add global clock controller driver for SM8250")
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Link: https://lore.kernel.org/r/20240719134238.312191-1-manivannan.sadhasivam@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/qcom/gcc-sm8250.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/clk/qcom/gcc-sm8250.c
+++ b/drivers/clk/qcom/gcc-sm8250.c
@@ -3226,7 +3226,7 @@ static struct gdsc pcie_0_gdsc = {
 	.pd = {
 		.name = "pcie_0_gdsc",
 	},
-	.pwrsts = PWRSTS_OFF_ON,
+	.pwrsts = PWRSTS_RET_ON,
 };
 
 static struct gdsc pcie_1_gdsc = {
@@ -3234,7 +3234,7 @@ static struct gdsc pcie_1_gdsc = {
 	.pd = {
 		.name = "pcie_1_gdsc",
 	},
-	.pwrsts = PWRSTS_OFF_ON,
+	.pwrsts = PWRSTS_RET_ON,
 };
 
 static struct gdsc pcie_2_gdsc = {
@@ -3242,7 +3242,7 @@ static struct gdsc pcie_2_gdsc = {
 	.pd = {
 		.name = "pcie_2_gdsc",
 	},
-	.pwrsts = PWRSTS_OFF_ON,
+	.pwrsts = PWRSTS_RET_ON,
 };
 
 static struct gdsc ufs_card_gdsc = {


