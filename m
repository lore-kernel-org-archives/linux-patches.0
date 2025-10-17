Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D41432C94E;
	Fri, 17 Oct 2025 15:07:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713625; cv=none; b=huPsa1EMDsZ+Hf1ZtKSl1m2SE+MA52amApM6WuZLK7O2kJjKzKBYg4W4i9RmaPraVSH0Gzdi3GX7R9fvwBCZtP7k+DzJzNC3s7tZcnzkRS+3gS7mm94M6JNgTo6RC7JgMgtY9hd9sm7V/0W43kGUtrYSU3LBtds1IGIwxO4dDew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713625; c=relaxed/simple;
	bh=u+4WUIgxpRf/yqXiYvsfYDXC3G6mQb9AVLNTWnjd9PY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RygEmG8HbB3hwgI6e2b4h9SBM8Ziw/aIu/fmoXZcQ9ibQQ6d6VNsdB3DYOFIGLNqotFpOXiGXYrXA+EnsldyQnF6HLYCeOrLXDn6CcSKZlypNnGav3ddLPaeCTCLtSw4wdrsbXhSLmd/2xbO0Eim1AxF9ZushpQAcTxwGYzEB8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2CN1+GIT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2CN1+GIT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59873C4CEE7;
	Fri, 17 Oct 2025 15:07:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713624;
	bh=u+4WUIgxpRf/yqXiYvsfYDXC3G6mQb9AVLNTWnjd9PY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2CN1+GITphLkf8qvXmDYjge/Ecv337I9D6Fn/44TM9jQReaAfcaL+3htiSIDE22ZD
	 BljWNKEtXvjAsxXto43UPqTGRPnx9xLmloOkjZk5ClT6Mj46X1es0fvFC7OQM2S3qx
	 Z2h4nakgQUZgeOqaI/hpGucVUO387vOBoNE5zH1c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephan Gerhold <stephan.gerhold@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.6 062/201] arm64: dts: qcom: msm8939: Add missing MDSS reset
Date: Fri, 17 Oct 2025 16:52:03 +0200
Message-ID: <20251017145137.028755710@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145134.710337454@linuxfoundation.org>
References: <20251017145134.710337454@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1210,6 +1210,8 @@
 
 			power-domains = <&gcc MDSS_GDSC>;
 
+			resets = <&gcc GCC_MDSS_BCR>;
+
 			#address-cells = <1>;
 			#size-cells = <1>;
 			#interrupt-cells = <1>;


