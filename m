Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0289D1C1AAA;
	Tue, 12 Aug 2025 19:04:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025500; cv=none; b=ODW4VkFqsYdUK8n+KIKvnqVO6JZGbAukZ4SWa5mkGhDmqy5yJW/ki2gBCgLntfwQBrWMajULWvS2O1BLytbW8DrV/XqPOUoMBFyl7titOARw4/hws1i9IhEUh17s3Xy/PGGd2iIpqLUpLk/enFoRJJVKOO9EXlyd26AlfocP1u8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025500; c=relaxed/simple;
	bh=DwyPN5oNkL9C5bUG1hYAFQfghhzWM1Wvw7akX0M1RgE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=u1GTRQiC0OXW3M1yBVIKvuyiU1OPAt+t707ktXd1jQsggjoznxREvIClN0tId5i6DwLlWdpO5OR4dVzgZUYqUjjcedICKcqDgzCU4eFM+uKNR8oUZxtRUqqMtvU7IrI2r50JfmHcKvJab2by9YqBlXMuCZDxa0reNnhy0ElCFdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2sOGDtkz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2sOGDtkz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2361CC4CEF0;
	Tue, 12 Aug 2025 19:04:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025499;
	bh=DwyPN5oNkL9C5bUG1hYAFQfghhzWM1Wvw7akX0M1RgE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2sOGDtkzi+eS73E67NYl3n/mp8GCz3ImVHt4CbMQcoOKz9OHtlUF1ytokqRVRZQ7U
	 Q0pHzgxdJMt7rDsb+twy5aER/XbPn0TrVT6Q4uFAiWcJ7sBKCfmTk4EcjJU7Ksn4FC
	 Kts2LIaZoJT4SF+Rac1ATSMIdgSJIHAuoqB9mG90=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	=?UTF-8?q?Andr=C3=A9=20Apitzsch?= <git@apitzsch.eu>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 042/480] arm64: dts: qcom: msm8976: Make blsp_dma controlled-remotely
Date: Tue, 12 Aug 2025 19:44:10 +0200
Message-ID: <20250812174359.139636731@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: André Apitzsch <git@apitzsch.eu>

[ Upstream commit 76270a18dbdf0bb50615f1b29d2cae8d683da01e ]

The blsp_dma controller is shared between the different subsystems,
which is why it is already initialized by the firmware. We should not
reinitialize it from Linux to avoid potential other users of the DMA
engine to misbehave.

In mainline this can be described using the "qcom,controlled-remotely"
property. In the downstream/vendor kernel from Qualcomm there is an
opposite "qcom,managed-locally" property. This property is *not* set
for the qcom,sps-dma@7884000 and qcom,sps-dma@7ac4000 [1] so adding
"qcom,controlled-remotely" upstream matches the behavior of the
downstream/vendor kernel.

Adding this fixes booting Longcheer L9360.

[1]: https://git.codelinaro.org/clo/la/kernel/msm-3.10/-/blob/LA.BR.1.3.7.c26/arch/arm/boot/dts/qcom/msm8976.dtsi#L1149-1163

Fixes: 0484d3ce0902 ("arm64: dts: qcom: Add DTS for MSM8976 and MSM8956 SoCs")
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: André Apitzsch <git@apitzsch.eu>
Link: https://lore.kernel.org/r/20250615-bqx5plus-v2-1-72b45c84237d@apitzsch.eu
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/msm8976.dtsi | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/msm8976.dtsi b/arch/arm64/boot/dts/qcom/msm8976.dtsi
index d036f31dfdca..963996f7c927 100644
--- a/arch/arm64/boot/dts/qcom/msm8976.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8976.dtsi
@@ -1330,6 +1330,7 @@ blsp1_dma: dma-controller@7884000 {
 			clock-names = "bam_clk";
 			#dma-cells = <1>;
 			qcom,ee = <0>;
+			qcom,controlled-remotely;
 		};
 
 		blsp1_uart1: serial@78af000 {
@@ -1450,6 +1451,7 @@ blsp2_dma: dma-controller@7ac4000 {
 			clock-names = "bam_clk";
 			#dma-cells = <1>;
 			qcom,ee = <0>;
+			qcom,controlled-remotely;
 		};
 
 		blsp2_uart2: serial@7af0000 {
-- 
2.39.5



