Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87551328B65;
	Wed,  3 Dec 2025 15:49:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776980; cv=none; b=XA6D0GRJ+f4sHDSSNYvaP/RMvFJQVitTO1zTrLguVNUah7TNrO5ohXZ/RQVLBwny3QUgQ9hGbFwEfovGyHtbnxj16A6QzhD/uLd/SxBOWBIR8jBQPZctIsCxsHYhu5aitHBk4lBK2bzsm3M0tE3R6zXVS6apYWDFzQIHxD6AisU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776980; c=relaxed/simple;
	bh=C45qZ0/cbNM3pVF68gs2PV1VR36mhXxVhsmD0EHUHgM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WujD7+DUQHXPgGDD41/+r1qStgNcAq8jmeLuHwQ2dNzanucLbQeHrYZNxwCYQh903OJbIsFiJShTFuAbPHlR1qop0jZ9ahDQ61vhFK0QTHnY/pbfad9WrtdIKrmhWRWfAgBbPAOpx16vgvYvYY8jC3x1rCWjI2Y9oZ2bawYeic4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y9BVN50H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y9BVN50H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97785C4CEF5;
	Wed,  3 Dec 2025 15:49:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776980;
	bh=C45qZ0/cbNM3pVF68gs2PV1VR36mhXxVhsmD0EHUHgM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y9BVN50HoNAlOyXtNC9LbkzS+FP/oIZQyXw0nBDwnVBngaR06LAlPD6hlTa24aJZ/
	 ifoc10lbtytXqLbe9NvStbcnDnC1X0VSFu5x+7onM8kzqljMydqGz++OMF+tomd70X
	 Vlg+XIDHZVECKoDN2pbl9iYeQCtQIw0XKecCDr/c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 046/146] spi: amlogic-spifc-a1: Handle devm_pm_runtime_enable() errors
Date: Wed,  3 Dec 2025 16:27:04 +0100
Message-ID: <20251203152348.159728939@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152346.456176474@linuxfoundation.org>
References: <20251203152346.456176474@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haotian Zhang <vulab@iscas.ac.cn>

[ Upstream commit a90903c2a3c38bce475f46ea3f93dbf6a9971553 ]

devm_pm_runtime_enable() can fail due to memory allocation. The current
code ignores its return value, potentially causing runtime PM operations
to fail silently after autosuspend configuration.

Check the return value of devm_pm_runtime_enable() and return on failure.

Fixes: 909fac05b926 ("spi: add support for Amlogic A1 SPI Flash Controller")
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
Link: https://patch.msgid.link/20251124015852.937-1-vulab@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-amlogic-spifc-a1.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-amlogic-spifc-a1.c b/drivers/spi/spi-amlogic-spifc-a1.c
index 18c9aa2cbc290..eb503790017b2 100644
--- a/drivers/spi/spi-amlogic-spifc-a1.c
+++ b/drivers/spi/spi-amlogic-spifc-a1.c
@@ -353,7 +353,9 @@ static int amlogic_spifc_a1_probe(struct platform_device *pdev)
 
 	pm_runtime_set_autosuspend_delay(spifc->dev, 500);
 	pm_runtime_use_autosuspend(spifc->dev);
-	devm_pm_runtime_enable(spifc->dev);
+	ret = devm_pm_runtime_enable(spifc->dev);
+	if (ret)
+		return ret;
 
 	ctrl->num_chipselect = 1;
 	ctrl->dev.of_node = pdev->dev.of_node;
-- 
2.51.0



