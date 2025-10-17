Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A24E32E12D;
	Fri, 17 Oct 2025 15:17:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714279; cv=none; b=tlrwrVI6qeKDiP3Ioib7YMGROC1rxgWmGSzuoUcE9L9eRnY5nTaUVqdeMXU5HA8CAyELKefJc0o/bfyZ8KkIjWNo6ozU2dZAfX3UX9efwYe5v3I+wsQSsHfYsDIwnZxCR2tN3rPu4nV8Otwp4FfiZgIV9qhEZzHbXssIDCggBrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714279; c=relaxed/simple;
	bh=EhoK69NpJJviJNdJPrnaz1bXPq9UtjF5kBpYKLSr5GY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y3zPahjgGJU5QUf1EFLrpHSoxRYFflO/RyeC1PlmMbLERdMVSNSnvMdQtSHokUZDULw0nxZF1D8jHGfMPplx0nyCOfQZHNMou9rOx2EhCWeTJ+P3eZ5OYYDw6ZY+MEpZMXFldo1HwK5GzTfGvJyxEAIhMEjztiJqN7x/5g5hOQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jKHr5es8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jKHr5es8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89391C4CEE7;
	Fri, 17 Oct 2025 15:17:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714278;
	bh=EhoK69NpJJviJNdJPrnaz1bXPq9UtjF5kBpYKLSr5GY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jKHr5es8PIdOsUJglRyqcpyUBot65UHIwTC6zIZnvfg1Q6IVEbx6Cv83L7c0kO7eB
	 2cE7DiP1Lb17H+hznDm68j77WmpYnA85IMXm4GHpGeH0ducf2iIsOXXGs570pIBeAW
	 BHDYPswADFomwAoQrbnSercwtWEl8eJcgz7mbakw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephan Gerhold <stephan.gerhold@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.12 089/277] arm64: dts: qcom: msm8939: Add missing MDSS reset
Date: Fri, 17 Oct 2025 16:51:36 +0200
Message-ID: <20251017145150.385283801@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephan Gerhold <stephan.gerhold@linaro.org>

commit f73c82c855e186e9b67125e3eee743960320e43c upstream.

On most MSM8939 devices, the bootloader already initializes the display to
show the boot splash screen. In this situation, MDSS is already configured
and left running when starting Linux. To avoid side effects from the
bootloader configuration, the MDSS reset can be specified in the device
tree to start again with a clean hardware state.

The reset for MDSS is currently missing in msm8939.dtsi, which causes
errors when the MDSS driver tries to re-initialize the registers:

 dsi_err_worker: status=6
 dsi_err_worker: status=6
 dsi_err_worker: status=6
 ...

It turns out that we have always indirectly worked around this by building
the MDSS driver as a module. Before v6.17, the power domain was temporarily
turned off until the module was loaded, long enough to clear the register
contents. In v6.17, power domains are not turned off during boot until
sync_state() happens, so this is no longer working. Even before v6.17 this
resulted in broken behavior, but notably only when the MDSS driver was
built-in instead of a module.

Cc: stable@vger.kernel.org
Fixes: 61550c6c156c ("arm64: dts: qcom: Add msm8939 SoC")
Signed-off-by: Stephan Gerhold <stephan.gerhold@linaro.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250915-msm8916-resets-v1-2-a5c705df0c45@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/msm8939.dtsi |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/arm64/boot/dts/qcom/msm8939.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8939.dtsi
@@ -1218,6 +1218,8 @@
 
 			power-domains = <&gcc MDSS_GDSC>;
 
+			resets = <&gcc GCC_MDSS_BCR>;
+
 			#address-cells = <1>;
 			#size-cells = <1>;
 			#interrupt-cells = <1>;


