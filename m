Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D06D3330B1E;
	Fri, 17 Oct 2025 15:52:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760716373; cv=none; b=HybGe97u3IYWzS1Kh8U+OwLTPWjh07h1JrZMRfxquIPF98BOIhG40uxrPXdIzeHzx/2DHMmOrNNo4R2844A6lRpdMyQaf+dG0r3WcBEDPDgpwUQv+vGby+0nIi2aVftisX9b1wIwlCGIrwpYu1vWVFB3ltFk+oPcHf8vBesESoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760716373; c=relaxed/simple;
	bh=XgyWRNJh9auOCK4Zbt6LmF4ge3zgWk/Mj/grOimsb9k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VtKFakgFQwXLPkqdw7//oiZ7/YkbAUIck2SI7S+qH6N41tQBP6LEbS0QpQlRA0zY/+kCeqcN5BD3iTbPWjjhrm1ykoHb9Z8UC7+uvLmSm+tMzTKzk2D9W2f3BAa32gr4l616Ek9aphAuO6BmnOq9O9GvloIytXD45LdFxnUcl5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SFttum0v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SFttum0v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B87DC4CEE7;
	Fri, 17 Oct 2025 15:52:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760716373;
	bh=XgyWRNJh9auOCK4Zbt6LmF4ge3zgWk/Mj/grOimsb9k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SFttum0vgBiLNmUAb2RODHXN87IortDBRg+FHerZjDyEVLmW0HPNdAbdLsTt0akjA
	 XOSV0cPXo2T/TUqV+HP7jwFp80yDT041MK/+ESaki+VfuDPxVIM56bxdxx/AS+hDMB
	 DCjLpY2GMBt0rIPCvgI56DVtTfV5hqX5wf8wbEMw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephan Gerhold <stephan.gerhold@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 5.15 168/276] arm64: dts: qcom: msm8916: Add missing MDSS reset
Date: Fri, 17 Oct 2025 16:54:21 +0200
Message-ID: <20251017145148.606285524@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145142.382145055@linuxfoundation.org>
References: <20251017145142.382145055@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephan Gerhold <stephan.gerhold@linaro.org>

commit 99b78773c2ae55dcc01025f94eae8ce9700ae985 upstream.

On most MSM8916 devices (aside from the DragonBoard 410c), the bootloader
already initializes the display to show the boot splash screen. In this
situation, MDSS is already configured and left running when starting Linux.
To avoid side effects from the bootloader configuration, the MDSS reset can
be specified in the device tree to start again with a clean hardware state.

The reset for MDSS is currently missing in msm8916.dtsi, which causes
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
Fixes: 305410ffd1b2 ("arm64: dts: msm8916: Add display support")
Signed-off-by: Stephan Gerhold <stephan.gerhold@linaro.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250915-msm8916-resets-v1-1-a5c705df0c45@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/msm8916.dtsi |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/arm64/boot/dts/qcom/msm8916.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8916.dtsi
@@ -957,6 +957,8 @@
 
 			interrupts = <GIC_SPI 72 IRQ_TYPE_LEVEL_HIGH>;
 
+			resets = <&gcc GCC_MDSS_BCR>;
+
 			interrupt-controller;
 			#interrupt-cells = <1>;
 


