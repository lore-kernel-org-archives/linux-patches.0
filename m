Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9719E15B109;
	Mon, 29 Jan 2024 17:14:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548472; cv=none; b=IGZMDteNk+LbSJRscgO5/h7Ca9q/TTChSQbn50rJC1bZV9meMt9r0Y+Y/oTY25U3x6UhgbYXAyEYuRhF/ZRpnVQmB4Z5SaYsuBzUfrq2YASQUPF/9mIy/3cHo0/WHq7Fax1z9LBkFguHm+b0JYyiUaKa8WnkKhH2Q94mv0t6+e0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548472; c=relaxed/simple;
	bh=9hOVxejzo4yyHFIevHm5qx/2sGe8YOLE4YLkDZfa3XA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hP0KZkMJrGf9/8L44VXGlKzd6pXDxEhu5itX/LQwlc1I6q1xDTQwuyRUyLV4wSt6K/2mwF4zvcq2ywwQViUcavbG6kjcHr9kbPLGj8V92lJmn/4cXtqqLT/WaogbGsQ+fB7EHsQRY0EjRKbZETmBAdiFskSrRWpLDVgynOHhGnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b/HhMfQ5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b/HhMfQ5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08775C43390;
	Mon, 29 Jan 2024 17:14:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548472;
	bh=9hOVxejzo4yyHFIevHm5qx/2sGe8YOLE4YLkDZfa3XA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b/HhMfQ57UkDCn8ZDtmH8fatA5Gkg0VaphP4RAhMbiPjiIy7o0Anm5So8TegzPCbR
	 vJCrsextix8VntsqYGpqLVwKo5flOK9W0RJUSwUlKG3LKRz0kTHDVQeLXXXcSwgPXP
	 HSDecJhnY7ocX+TYN+5lJSnvKQsD1tXxE23thcOk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephan Gerhold <stephan@gerhold.net>,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.6 081/331] arm64: dts: qcom: msm8939: Make blsp_dma controlled-remotely
Date: Mon, 29 Jan 2024 09:02:25 -0800
Message-ID: <20240129170017.297012526@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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

From: Stephan Gerhold <stephan@gerhold.net>

commit 4bbda9421f316efdaef5dbf642e24925ef7de130 upstream.

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

[1]: https://git.codelinaro.org/clo/la/kernel/msm-3.10/-/blob/LA.BR.1.2.9.1-02310-8x16.0/arch/arm/boot/dts/qcom/msm8939-common.dtsi#L866-872

Cc: stable@vger.kernel.org # 6.5
Fixes: 61550c6c156c ("arm64: dts: qcom: Add msm8939 SoC")
Signed-off-by: Stephan Gerhold <stephan@gerhold.net>
Reviewed-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Link: https://lore.kernel.org/r/20231204-msm8916-blsp-dma-remote-v1-2-3e49c8838c8d@gerhold.net
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/msm8939.dtsi |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm64/boot/dts/qcom/msm8939.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8939.dtsi
@@ -1661,6 +1661,7 @@
 			clock-names = "bam_clk";
 			#dma-cells = <1>;
 			qcom,ee = <0>;
+			qcom,controlled-remotely;
 		};
 
 		blsp_uart1: serial@78af000 {


