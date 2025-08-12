Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03F2F2FABF8;
	Tue, 12 Aug 2025 18:28:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023332; cv=none; b=aurdJL8v9j5Lokx7V0Rfa3lspxea/Qsx3DzKKbcWosFvah41Rup9UZRCkC84KaI/4boZbWGy8GeNKDN1rmd23iVlkwWQQS6AItShmbCJuHIIFp+4n+VC9MCYx114X1Z0Ojr/ctxuvJmFKaR4dvmflnjRLzcCrTYYnNtIXTowXDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023332; c=relaxed/simple;
	bh=PCoCXkKZUe1i45X37PD7Hbpn/sziJEQoOQcwi6NeD4U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=O1kpcZfstD4KCQRKk7/dkjhB5Z6dVYNiLBuuHDbgCdSh0roWOEMCWCIwx9/aSVSS2XLI4hCdkVs+9pf9SNZND/gJEt9dCFqYna5HJU+PCoMksrKFytSZV61VtNsgy55nJrDzCzIit4hoET+IgFkk5xTfaB57ZU5HG34bH+rkzys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O8V5BhFh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O8V5BhFh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C577C4CEF0;
	Tue, 12 Aug 2025 18:28:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023331;
	bh=PCoCXkKZUe1i45X37PD7Hbpn/sziJEQoOQcwi6NeD4U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O8V5BhFhJIa8IUuGwqITHaadHho3ayjMkGo1ZsBLLBGKAmMqZe3BrGbPQDxlPXYSf
	 lMM5vONpc5W1RWU5N0t9+sfLJbgVqRbgT9cZll0LFjSSrqncHlt/I5FfDd675qm4qW
	 eJjb//y4thSYbBW+8qaUdOspZ6YQqLx1wcu7uYfw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	=?UTF-8?q?Andr=C3=A9=20Apitzsch?= <git@apitzsch.eu>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 048/627] arm64: dts: qcom: msm8976: Make blsp_dma controlled-remotely
Date: Tue, 12 Aug 2025 19:25:43 +0200
Message-ID: <20250812173421.162167322@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index e2ac2fd6882f..2a3024638470 100644
--- a/arch/arm64/boot/dts/qcom/msm8976.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8976.dtsi
@@ -1331,6 +1331,7 @@ blsp1_dma: dma-controller@7884000 {
 			clock-names = "bam_clk";
 			#dma-cells = <1>;
 			qcom,ee = <0>;
+			qcom,controlled-remotely;
 		};
 
 		blsp1_uart1: serial@78af000 {
@@ -1451,6 +1452,7 @@ blsp2_dma: dma-controller@7ac4000 {
 			clock-names = "bam_clk";
 			#dma-cells = <1>;
 			qcom,ee = <0>;
+			qcom,controlled-remotely;
 		};
 
 		blsp2_uart2: serial@7af0000 {
-- 
2.39.5



