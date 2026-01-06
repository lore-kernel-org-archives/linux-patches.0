Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78EA33644AD;
	Tue,  6 Jan 2026 17:53:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767722011; cv=none; b=QKbDzM5sDMaKsCDkBgK6T3fuKOXtpUtW2zb5MOja0gQ9b8m8SazdJ1VPKAL1QnkcuIBWKTr/Bqwpc58mX7SIa51M31qoiOJ7Bvq3VlEgAfAArE3tbXKkhA1z1hYSkzxs4N6OncUTvooNDIN+KndsD5Nuj0TDlOb/b58Wk4RG0c8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767722011; c=relaxed/simple;
	bh=AxGiPyJg10AcZns44Utoku0frjkckQ8FiVy0Y4KkC9Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Us06elWUnR2HpPqoXsEBbMe3O/gu+fyxjEeU9O310yRZ0FmI04UyLdZ3MeDQ0coEIvw0BDfdgVPEE++CHJiMIpJBRRz7e4DPl6KZqIDoM6Tdxz7uNQTjuJ3mO6qt57ytWjLrF7uZbDH6tiKeS0Pvt1G5Y+1NnRXPMefSAeqdncc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cLpuVHcb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cLpuVHcb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2B02C16AAE;
	Tue,  6 Jan 2026 17:53:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767722011;
	bh=AxGiPyJg10AcZns44Utoku0frjkckQ8FiVy0Y4KkC9Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cLpuVHcbjQQG2KV9nhet750hHKwqWq+MrXVGKfTuG+P/MMdSZx2hxlVEAXiVk2VCC
	 TxDWWE7SFLWh+BS2xh0Xyn82RVwi+0F+LGxl3XgHdv1rsAzPE/2g7FPpEPUdo4EEuQ
	 Jm+FqPamIXGviAJOY2CHyyLXbY20NojrE/2G+730=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Imran Shaik <imran.shaik@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.18 139/312] clk: qcom: Fix dependencies of QCS_{DISP,GPU,VIDEO}CC_615
Date: Tue,  6 Jan 2026 18:03:33 +0100
Message-ID: <20260106170552.870977524@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

From: Nathan Chancellor <nathan@kernel.org>

commit 7ec1ba01ae37897f0ecf6ab0c980378cb8a2f388 upstream.

It is possible to select CONFIG_QCS_{DISP,GPU,VIDEO}CC_615 when
targeting ARCH=arm, causing a Kconfig warning when selecting
CONFIG_QCS_GCC_615 without its dependencies, CONFIG_ARM64 or
CONFIG_COMPILE_TEST.

  WARNING: unmet direct dependencies detected for QCS_GCC_615
    Depends on [n]: COMMON_CLK [=y] && COMMON_CLK_QCOM [=m] && (ARM64 || COMPILE_TEST [=n])
    Selected by [m]:
    - QCS_DISPCC_615 [=m] && COMMON_CLK [=y] && COMMON_CLK_QCOM [=m]
    - QCS_GPUCC_615 [=m] && COMMON_CLK [=y] && COMMON_CLK_QCOM [=m]
    - QCS_VIDEOCC_615 [=m] && COMMON_CLK [=y] && COMMON_CLK_QCOM [=m]

Add the same dependency to these configurations to clear up the
warnings.

Cc: stable@vger.kernel.org
Fixes: 9b47105f5434 ("clk: qcom: dispcc-qcs615: Add QCS615 display clock controller driver")
Fixes: f4b5b40805ab ("clk: qcom: gpucc-qcs615: Add QCS615 graphics clock controller driver")
Fixes: f6a8abe0cc16 ("clk: qcom: videocc-qcs615: Add QCS615 video clock controller driver")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Imran Shaik <imran.shaik@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250930-clk-qcom-kconfig-fixes-arm-v1-2-15ae1ae9ec9f@kernel.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/qcom/Kconfig | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/clk/qcom/Kconfig b/drivers/clk/qcom/Kconfig
index ec7d1a9b578e..6fef0bfc1773 100644
--- a/drivers/clk/qcom/Kconfig
+++ b/drivers/clk/qcom/Kconfig
@@ -531,6 +531,7 @@ config QCM_DISPCC_2290
 
 config QCS_DISPCC_615
 	tristate "QCS615 Display Clock Controller"
+	depends on ARM64 || COMPILE_TEST
 	select QCS_GCC_615
 	help
 	  Support for the display clock controller on Qualcomm Technologies, Inc
@@ -586,6 +587,7 @@ config QCS_GCC_615
 
 config QCS_GPUCC_615
 	tristate "QCS615 Graphics clock controller"
+	depends on ARM64 || COMPILE_TEST
 	select QCS_GCC_615
 	help
 	  Support for the graphics clock controller on QCS615 devices.
@@ -594,6 +596,7 @@ config QCS_GPUCC_615
 
 config QCS_VIDEOCC_615
 	tristate "QCS615 Video Clock Controller"
+	depends on ARM64 || COMPILE_TEST
 	select QCS_GCC_615
 	help
 	  Support for the video clock controller on QCS615 devices.
-- 
2.52.0



