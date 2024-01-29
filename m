Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F08F915957B;
	Mon, 29 Jan 2024 17:14:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548493; cv=none; b=VAGJjcrY3h6hDOX0eX53DbTu3/nxCh5tAYus1YIAX5HQkH1XzqI2vaJZWkSaNdvtKWrXD56H6Mt/9Oxq3dApTCyfPDNZvRaOIKBX5NIgGBy8shEjc0iWFyV5x4VT1WRqBI7HVftlR6hm9StWrWNRyIY5m0svoOiXsve/y7UzUVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548493; c=relaxed/simple;
	bh=ukDf80FMInNqene05p/PxEWgIByHyjJzTjnuHGIVVM8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O5zWwCdDTcQGpU67hD1Pfq76Erl18zZ2wTGHJ3LRIAvwMDLDXoRQ92lV5iswA1Ph6p3RhnSZ3a8XObdyN/vv2crV+e2yGfhQPKXv3/ooalju/uqPBRnlaynlFHAoPBf/Hn14WYx+KR7hbcrvAsB7WfT0IZCTraSSQx4+xYvyUKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K7S3Tctl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K7S3Tctl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9544C43390;
	Mon, 29 Jan 2024 17:14:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548492;
	bh=ukDf80FMInNqene05p/PxEWgIByHyjJzTjnuHGIVVM8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K7S3TctlYcAj2IxMTd43cVU2fSuHdKzX6g4MyE3AQErVJqdNmpR8hVenSgtBxTmDF
	 7ppHYGgGPniBMYiyAyMf5dUQft0OeT9OK0EzhDN3ddqt3hWDL2mMCdfCdI5d+C5Rjg
	 rEkkuKz2rdcSkZJwi5NsE2Rk3EIs+/uXFOe5RvPA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephan Gerhold <stephan@gerhold.net>,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.6 080/331] arm64: dts: qcom: msm8916: Make blsp_dma controlled-remotely
Date: Mon, 29 Jan 2024 09:02:24 -0800
Message-ID: <20240129170017.264929466@linuxfoundation.org>
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
@@ -2085,6 +2085,7 @@
 			clock-names = "bam_clk";
 			#dma-cells = <1>;
 			qcom,ee = <0>;
+			qcom,controlled-remotely;
 		};
 
 		blsp_uart1: serial@78af000 {


