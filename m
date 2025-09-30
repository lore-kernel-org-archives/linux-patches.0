Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAEDD302755;
	Tue, 30 Sep 2025 14:51:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759243880; cv=none; b=kEW8r/zgRPZ+cFYls3agrsEkdRQ8sfREHT4Fx8QTxdyzOEww7xNDTOgJIQmP8FQYbOVHe3XklrC8OHv7c6+sI1Kpha8LP8ob7IbxkokBNQQMrvmDiJ3kOAubdELa7Y80VFtJlWSYVFpJb7EKSJorj3SiV4K8aAASc/gJD/9TI7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759243880; c=relaxed/simple;
	bh=+pyOVF8Ec2c32KXNx9bOGXHV0KC6+7eKAil3visVhcM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=saL15Hu4kpvVbdW+OV4Pf09QYHd4lxuAb4YpZk2wemDkhu8avF1pBYHjstJqj3uAI0fQZzjygdq5KNSb5S3vEjgZqd1rt+bzKdI8r4ApBdQ8xoDfhK21dCaf5I88NZqHG2FamTCtyvkgl3Olw1K4+LouSQ9ug/zS8EgJ2EpHGOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cLKH8tf6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cLKH8tf6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C300C4CEF0;
	Tue, 30 Sep 2025 14:51:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759243880;
	bh=+pyOVF8Ec2c32KXNx9bOGXHV0KC6+7eKAil3visVhcM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cLKH8tf6V5l628+HfNZgB/xxCcNxrdTN/e2iPIBUUZ9cSRfTge03Qn6G1FE5+83/E
	 tVJgLKl+wO2LWtJVjUZXuhn7nDcBfWJGfA0UupOya+DPEBdx9KsodZ88oPko636Y74
	 YEd20NUR5/483hzb8onwgxr/Fp61hHIJvrGY1aCM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephan Gerhold <stephan.gerhold@linaro.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.4 27/81] dmaengine: qcom: bam_dma: Fix DT error handling for num-channels/ees
Date: Tue, 30 Sep 2025 16:46:29 +0200
Message-ID: <20250930143820.799313847@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143819.654157320@linuxfoundation.org>
References: <20250930143819.654157320@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1266,13 +1266,17 @@ static int bam_dma_probe(struct platform
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


