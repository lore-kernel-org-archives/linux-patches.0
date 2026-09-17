Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92857501F26;
	Thu, 17 Sep 2026 15:33:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659232; cv=none; b=ZkB0wwA3VXOBRBBgwfH8vWBV5qE2U5Zzk7IckRvgU9S3CUqYj9nr5JU+CJUyY6j2wpR38Id8v7IA7uZBC9aXYnfruxZ4hqq5qV0jMxcm2V2BVkaDy5V/LFYBdfnM2bqlTeQkfpCqm3Ou/mxDsUd+MmSzFxDa2YJavW277vDTZe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659232; c=relaxed/simple;
	bh=EpSaHV4wGxoNpmcdbMU/gEiBHI1NqflRGamf0TzIluU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NguqjXx+v0/vHb0IFAXnm3BeQY+tgPwznWuc3ekcbQ8xIhjFNVO+I7hBC6Ukoq0dVMXe8oqUEIIMkH+CRFVcF9Z6qOdQq3fMWiUi/9SBVt4oGwgs6uktnVdaHgjp2Pt9wIpnAEeZP8DQ331ovnlg3yEIKOvUtfF9Bv1RG9onH+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r9dtLVrn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r9dtLVrn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82DF81F00893;
	Thu, 17 Sep 2026 15:33:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659224;
	bh=subYe020o3zMq2VMF9Yjbp7XxOLxhoCIAvfiefq/7Dc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r9dtLVrn5+I/Rr9IeOZHXtlx1E+hKmn4X4DowtaYvNz0gZOtVFketex+RUWmN6ZIt
	 e3iMq/u+3JPM9wrzC6KkXFrUaGKeoAjni7ByXxI4hXtOJI4YCiPTlLEkxUed8rFYpV
	 /opsh/FCmPEyzpkwNyEMTRc8Zz5gkbcfVX2aEbqw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 185/733] ASoC: ux500: Request the MSP MMIO resource
Date: Thu, 17 Sep 2026 16:08:13 +0100
Message-ID: <20260917151355.746854569@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Walleij <linusw@kernel.org>

[ Upstream commit 4fb67925f33ad789e9e00903a73306ed40f7ae32 ]

A bare devm_ioremap() neither reserves the register range nor preserves
the platform resource error. This permits another driver to claim the
same range and reports every mapping failure as an allocation failure.

Use the managed platform resource helper, retaining the resolved
resource only to derive the DMA register address.

Fixes: 3592b7f69a54 ("ASoC: Ux500: Add MSP I2S-driver")
Assisted-by: LLM
Signed-off-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260902-ux500-msp-fixes-v2-6-4b60b002d55a@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/ux500/ux500_msp_i2s.c | 18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)

diff --git a/sound/soc/ux500/ux500_msp_i2s.c b/sound/soc/ux500/ux500_msp_i2s.c
index bc77174e00707..43dc9b3aa4ef5 100644
--- a/sound/soc/ux500/ux500_msp_i2s.c
+++ b/sound/soc/ux500/ux500_msp_i2s.c
@@ -733,7 +733,7 @@ int ux500_msp_i2s_close(struct ux500_msp *msp, unsigned int dir)
 int ux500_msp_i2s_init_msp(struct platform_device *pdev,
 			struct ux500_msp **msp_p)
 {
-	struct resource *res = NULL;
+	struct resource *res;
 	struct ux500_msp *msp;
 
 	*msp_p = devm_kzalloc(&pdev->dev, sizeof(struct ux500_msp), GFP_KERNEL);
@@ -743,20 +743,10 @@ int ux500_msp_i2s_init_msp(struct platform_device *pdev,
 
 	msp->dev = &pdev->dev;
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (res == NULL) {
-		dev_err(&pdev->dev, "%s: ERROR: Unable to get resource!\n",
-			__func__);
-		return -ENOMEM;
-	}
-
+	msp->registers = devm_platform_get_and_ioremap_resource(pdev, 0, &res);
+	if (IS_ERR(msp->registers))
+		return PTR_ERR(msp->registers);
 	msp->tx_rx_addr = res->start + MSP_DR;
-	msp->registers = devm_ioremap(&pdev->dev, res->start,
-				      resource_size(res));
-	if (msp->registers == NULL) {
-		dev_err(&pdev->dev, "%s: ERROR: ioremap failed!\n", __func__);
-		return -ENOMEM;
-	}
 
 	msp->msp_state = MSP_STATE_IDLE;
 	msp->loopback_enable = 0;
-- 
2.53.0



