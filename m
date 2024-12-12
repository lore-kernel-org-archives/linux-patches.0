Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9013021661F;
	Thu, 12 Dec 2024 15:06:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734015975; cv=none; b=MSAPQf0YnlUcgKLUVn6l7tjXiv5oox3l0OG9DVd/juX0pwEcdjRGjHzT+tsnazhPKT49mHl6ueMkzEOTZpHZ1h66X32lUBaxP8r8fBQ+RqPp5eK/kVbG1Nqg0gL9QlNCWb6wuG2vleTNMa4CggPuOAKVE06uLowUUOVuStQrN6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734015975; c=relaxed/simple;
	bh=MbBdvq8er5b7n1eblyOcbGPACkmNoAgKEwQ/9nE7j2Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jLljB/B4VtEZlHn6fIzQlctHg4BrDNrJOwooMFAQa+SAG1rC2WzLIdkoIULtYrknMH4eJCXR2wku2PaDDufSGlaaDLVm93eREj7FrIh2wpksmqkeIWIapNyNxHPpfIi0OKt1j5ImQMzVhxfpsq/w0e8ByWmrxcDbVF5kQobjATM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I1eiZJf+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I1eiZJf+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7990C4CED0;
	Thu, 12 Dec 2024 15:06:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734015975;
	bh=MbBdvq8er5b7n1eblyOcbGPACkmNoAgKEwQ/9nE7j2Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I1eiZJf+p8hEDAAizhDYdy4chhATB0al4H/h+thawbp/AmRysL9bsxf0GPoaBtAVb
	 lwJhS8zzmWxhHJTbilpcGjv1LMBsf/QY+mLI/Kgcbz0YUA6sGl2DymmNDat+GQtAgv
	 SQpZJnf5fiPWEGIIBxOLdSsJyN0ht0hau3X9SlQg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy-ld Lu <andy-ld.lu@mediatek.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 066/466] mmc: mtk-sd: Fix MMC_CAP2_CRYPTO flag setting
Date: Thu, 12 Dec 2024 15:53:55 +0100
Message-ID: <20241212144309.424843616@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy-ld Lu <andy-ld.lu@mediatek.com>

[ Upstream commit 2508925fb346661bad9f50b497d7ac7d0b6085d0 ]

Currently, the MMC_CAP2_CRYPTO flag is set by default for eMMC hosts.
However, this flag should not be set for hosts that do not support inline
encryption.

The 'crypto' clock, as described in the documentation, is used for data
encryption and decryption. Therefore, only hosts that are configured with
this 'crypto' clock should have the MMC_CAP2_CRYPTO flag set.

Fixes: 7b438d0377fb ("mmc: mtk-sd: add Inline Crypto Engine clock control")
Fixes: ed299eda8fbb ("mmc: mtk-sd: fix devm_clk_get_optional usage")
Signed-off-by: Andy-ld Lu <andy-ld.lu@mediatek.com>
Cc: stable@vger.kernel.org
Message-ID: <20241111085039.26527-1-andy-ld.lu@mediatek.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/mtk-sd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/mmc/host/mtk-sd.c b/drivers/mmc/host/mtk-sd.c
index 83e7291481861..813bc20cfb5a6 100644
--- a/drivers/mmc/host/mtk-sd.c
+++ b/drivers/mmc/host/mtk-sd.c
@@ -2774,7 +2774,8 @@ static int msdc_drv_probe(struct platform_device *pdev)
 		host->crypto_clk = devm_clk_get_optional(&pdev->dev, "crypto");
 		if (IS_ERR(host->crypto_clk))
 			return PTR_ERR(host->crypto_clk);
-		mmc->caps2 |= MMC_CAP2_CRYPTO;
+		else if (host->crypto_clk)
+			mmc->caps2 |= MMC_CAP2_CRYPTO;
 	}
 
 	host->irq = platform_get_irq(pdev, 0);
-- 
2.43.0



