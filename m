Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3930E612D7;
	Tue, 20 Feb 2024 21:07:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463233; cv=none; b=ga5FtEjdvBuJjv3t1HJLrqpNzU+F+c+bB91gjkh5t4UlPZIngBOXn6KX/bGmRlHIvQ0wLoxyuUutbHV1DiqMzKmNGZmgk6Vg91PL6FBmjzp8WKZl5Cx0ZMiq1n8xvavtDZYPXrVwkBIRu+q4CLpaSY4W1ussBdfKOBtY2DeH3yQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463233; c=relaxed/simple;
	bh=kRqCC62qTEMMvxCMtuLXxVnlBOLtSnuC2LHBoLFah0A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=loHKVl0EhGlWPOE+qSIPuPJgg9eddMU4swLf8wsg3azyJlf82jyXiRy5KElHj9Ho2gjgZov0bBycj5nmhXaX09O16UO20Fncs9LWWPQtQPGYEJfJ4ym1CTO6xgaMamE5MpdYNIDGc8qs0GoQkveLTBtw0DX5rkL/UrFqHjV3UXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2Bww/UUZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2Bww/UUZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B995DC433F1;
	Tue, 20 Feb 2024 21:07:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463233;
	bh=kRqCC62qTEMMvxCMtuLXxVnlBOLtSnuC2LHBoLFah0A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2Bww/UUZhoNdzs9xikUYI/T7DZgWG1APbnDY2s4M7WZCTLhM5jBwX7wAFK9AqJOSh
	 fc3OlFwk5jifc12eHmBaF9KLeVoS+PIpVDXiUTxidNe82HGE4SoWZAN2ClweXni0Da
	 v9qcadwMXidBF6+LdCpcW9X9P98TNvVdCK9XGXRI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephan Gerhold <stephan@gerhold.net>,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 178/197] arm64: dts: qcom: msm8916: Make blsp_dma controlled-remotely
Date: Tue, 20 Feb 2024 21:52:17 +0100
Message-ID: <20240220204846.394417256@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220204841.073267068@linuxfoundation.org>
References: <20240220204841.073267068@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephan Gerhold <stephan@gerhold.net>

[ Upstream commit 7c45b6ddbcff01f9934d11802010cfeb0879e693 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/msm8916.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/qcom/msm8916.dtsi b/arch/arm64/boot/dts/qcom/msm8916.dtsi
index f0d097ade84c..987cebbda057 100644
--- a/arch/arm64/boot/dts/qcom/msm8916.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8916.dtsi
@@ -1522,6 +1522,7 @@ blsp_dma: dma-controller@7884000 {
 			clock-names = "bam_clk";
 			#dma-cells = <1>;
 			qcom,ee = <0>;
+			qcom,controlled-remotely;
 		};
 
 		blsp1_uart1: serial@78af000 {
-- 
2.43.0



