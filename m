Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79A7E18CBE1;
	Tue, 30 Sep 2025 14:55:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244147; cv=none; b=cTSlYuPQU6IrFf7rnGxDTMbaGr3LaPM8AnSssits1tu8ULnMyg7wGQNRuaWmP2eWxdspCyLIg/5CJPHwj2/VSoEXKTf+7dJO2djIod77OvoekTyMbcweRk8uaQ8xH5FIFX4lJhZBPBHNsi3m39aAVZ4FV1D30KAcYB6Edvpa2ts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244147; c=relaxed/simple;
	bh=dBPD0EalWTk4kLS9AA/aj6hqxsK2rDOmB9jymgu03jY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U+vH4uexLhenQBi30KXbH0dAMIQe7ZXaN/wFbT1lz4ES+MhBRp8Ob5aV0Ry0BRGd+FRVnaTaVdFfhOmWmR6fP5xPPaFxy4HwAIXS+A38k/29lvZy+5CFE7hGag4Z03INv42zkes0auQud0w/B3KwjKtemkrDSsdtPBNv4rysLV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EnRn9Guq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EnRn9Guq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2997C4CEF0;
	Tue, 30 Sep 2025 14:55:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244147;
	bh=dBPD0EalWTk4kLS9AA/aj6hqxsK2rDOmB9jymgu03jY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EnRn9GuqyFWF60ZIYG8v9mlULZhY1ac/O0nuCm36kXVW0wqTNL+QLPAyHXbhVonQz
	 KE4zYYlSpWn1aLruI8AYj1uHzzM3PLS8INSMI+bFWNBxHGascm3PMkohfVAWb2Segj
	 Hc8/GaHHPB9jcH6aDhABvcnE8YggQ9JC5+jdRp+g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephan Gerhold <stephan.gerhold@linaro.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.10 041/122] dmaengine: qcom: bam_dma: Fix DT error handling for num-channels/ees
Date: Tue, 30 Sep 2025 16:46:12 +0200
Message-ID: <20250930143824.682717724@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143822.939301999@linuxfoundation.org>
References: <20250930143822.939301999@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephan Gerhold <stephan.gerhold@linaro.org>

commit 5068b5254812433e841a40886e695633148d362d upstream.

When we don't have a clock specified in the device tree, we have no way to
ensure the BAM is on. This is often the case for remotely-controlled or
remotely-powered BAM instances. In this case, we need to read num-channels
from the DT to have all the necessary information to complete probing.

However, at the moment invalid device trees without clock and without
num-channels still continue probing, because the error handling is missing
return statements. The driver will then later try to read the number of
channels from the registers. This is unsafe, because it relies on boot
firmware and lucky timing to succeed. Unfortunately, the lack of proper
error handling here has been abused for several Qualcomm SoCs upstream,
causing early boot crashes in several situations [1, 2].

Avoid these early crashes by erroring out when any of the required DT
properties are missing. Note that this will break some of the existing DTs
upstream (mainly BAM instances related to the crypto engine). However,
clearly these DTs have never been tested properly, since the error in the
kernel log was just ignored. It's safer to disable the crypto engine for
these broken DTBs.

[1]: https://lore.kernel.org/r/CY01EKQVWE36.B9X5TDXAREPF@fairphone.com/
[2]: https://lore.kernel.org/r/20230626145959.646747-1-krzysztof.kozlowski@linaro.org/

Cc: stable@vger.kernel.org
Fixes: 48d163b1aa6e ("dmaengine: qcom: bam_dma: get num-channels and num-ees from dt")
Signed-off-by: Stephan Gerhold <stephan.gerhold@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250212-bam-dma-fixes-v1-8-f560889e65d8@linaro.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/qcom/bam_dma.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/dma/qcom/bam_dma.c
+++ b/drivers/dma/qcom/bam_dma.c
@@ -1265,13 +1265,17 @@ static int bam_dma_probe(struct platform
 	if (bdev->controlled_remotely) {
 		ret = of_property_read_u32(pdev->dev.of_node, "num-channels",
 					   &bdev->num_channels);
-		if (ret)
+		if (ret) {
 			dev_err(bdev->dev, "num-channels unspecified in dt\n");
+			return ret;
+		}
 
 		ret = of_property_read_u32(pdev->dev.of_node, "qcom,num-ees",
 					   &bdev->num_ees);
-		if (ret)
+		if (ret) {
 			dev_err(bdev->dev, "num-ees unspecified in dt\n");
+			return ret;
+		}
 	}
 
 	bdev->bamclk = devm_clk_get(bdev->dev, "bam_clk");


