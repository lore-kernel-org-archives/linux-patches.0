Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA49D15A4B7;
	Mon, 29 Jan 2024 17:07:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548066; cv=none; b=dliVA17loUGk/PQNtFR5rMAXjtINW0A0j6+RlTJ/t/2/vLUUbmK4lYaL3m7DfhmsjwrMqEzMBhbeV8UojRrNNvtvg8ZwpG22ES5yvK7rtnTaOBHMtN2fOyA6wZ4FC8S26TYtw1KtS9rbibg2xzfps5GJW4ek7knhu81xsFJ3mls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548066; c=relaxed/simple;
	bh=JM1hNNLJ2CXa6MjbsH7dnrWAzioIQaIzZmx6QfxyWfs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kXZWZuol4nqu102i2qvBLMJvVgu0yOWSZ3iE82rg9qhPxbKMggsbitbm1OsULnzoWg7NGKJAmCN8RQPrLsOjCjLLbjhDD9l0T0hKCRvDGZ2FPtS4LW4vX2s2gG5PliYLL+LxutI5IzX5Kj/KJ7EblK+yrNoCyzfQHPICPRT82Kg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JMRSTXHP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JMRSTXHP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2F2CC433F1;
	Mon, 29 Jan 2024 17:07:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548065;
	bh=JM1hNNLJ2CXa6MjbsH7dnrWAzioIQaIzZmx6QfxyWfs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JMRSTXHPVYIJQoo4IXxFVQRy6f2ONDlXGUhbyZJjuA63yE3/0LV7EYiN5/Qyhfgn0
	 CiPZx4HLMznlDeSt6zwsI+3e364czeLzQNuBZ/GzshN2cepD7Qr6O7rHY59rIRptJA
	 iCcjXFI9oGt01HLPghiBRQKIiWMaFGjd71B8a88g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephan Gerhold <stephan@gerhold.net>,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.7 073/346] arm64: dts: qcom: msm8916: Make blsp_dma controlled-remotely
Date: Mon, 29 Jan 2024 09:01:44 -0800
Message-ID: <20240129170018.535591952@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephan Gerhold <stephan@gerhold.net>

commit 7c45b6ddbcff01f9934d11802010cfeb0879e693 upstream.

The blsp_dma controller is shared between the different subsystems,
which is why it is already initialized by the firmware. We should not
reinitialize it from Linux to avoid potential other users of the DMA
engine to misbehave.

In mainline this can be described using the "qcom,controlled-remotely"
property. In the downstream/vendor kernel from Qualcomm there is an
opposite "qcom,managed-locally" property. This property is *not* set
for the qcom,sps-dma@7884000 [1] so adding "qcom,controlled-remotely"
upstream matches the behavior of the downstream/vendor kernel.

Adding this seems to fix some weird issues with UART where both
input/output becomes garbled with certain obscure firmware versions on
some devices.

[1]: https://git.codelinaro.org/clo/la/kernel/msm-3.10/-/blob/LA.BR.1.2.9.1-02310-8x16.0/arch/arm/boot/dts/qcom/msm8916.dtsi#L1466-1472

Cc: stable@vger.kernel.org # 6.5
Fixes: a0e5fb103150 ("arm64: dts: qcom: Add msm8916 BLSP device nodes")
Signed-off-by: Stephan Gerhold <stephan@gerhold.net>
Reviewed-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Link: https://lore.kernel.org/r/20231204-msm8916-blsp-dma-remote-v1-1-3e49c8838c8d@gerhold.net
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/msm8916.dtsi |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm64/boot/dts/qcom/msm8916.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8916.dtsi
@@ -2106,6 +2106,7 @@
 			clock-names = "bam_clk";
 			#dma-cells = <1>;
 			qcom,ee = <0>;
+			qcom,controlled-remotely;
 		};
 
 		blsp_uart1: serial@78af000 {


