Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABB7021E0AA;
	Thu, 12 Dec 2024 15:34:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017699; cv=none; b=TEXPTJDVr/xgc0mPOhnVcJ40j8a3TROJ0F67NtWL1jmRiYC5RCiJAjQ9ryB+aFLkWgT8xUeJPk9fpGhfYVA8l9YjY7cmMefM/jlnhHoQbF3frNCO1OuI/yTv+T65L+/mA/mmcyXKYBie4N3TzlbuakFCtYwou5OyQZp+fMvc9NI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017699; c=relaxed/simple;
	bh=ugbCeKDnnJ+VuKZS7pK4HbcAFG+NSV1THlSwNyjpCnM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V6BO1dnWr3myC6hiYZ2HLMtDofenFMgdDJearSlSqTWA07GDm11wdScbdouF/t8VN7aIFUF4RiZFrcKX4U8qA/FUOg3q3lpPPb1zBynozj6Jn9dPd1z/uWDpC/RKX0wUPoafCcGfWfDU5C/llrCfl79T2e+c4kmpXYD6r391oGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zwSXejiC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zwSXejiC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19D8BC4CECE;
	Thu, 12 Dec 2024 15:34:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017699;
	bh=ugbCeKDnnJ+VuKZS7pK4HbcAFG+NSV1THlSwNyjpCnM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zwSXejiCe3rt+jh5eAGpHVi9x8BM9wkVizZeIredWakK6n3IAkeHnp5C5rs9qF8s3
	 WKzvNLTuue1GG0JrX4gbcX5wl3bjQ/MCpe7nO/R+TP8xrtJFIfryKn6594kauC3hGP
	 sJlcmZiawsSlmqUgC+BwCz04J3xe3N0oxqX6/NPs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy-ld Lu <andy-ld.lu@mediatek.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 086/356] mmc: mtk-sd: Fix MMC_CAP2_CRYPTO flag setting
Date: Thu, 12 Dec 2024 15:56:45 +0100
Message-ID: <20241212144248.019722528@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
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
index c5e96a2c079e5..1896bf6746071 100644
--- a/drivers/mmc/host/mtk-sd.c
+++ b/drivers/mmc/host/mtk-sd.c
@@ -2712,7 +2712,8 @@ static int msdc_drv_probe(struct platform_device *pdev)
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



