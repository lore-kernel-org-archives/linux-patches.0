Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55FB0132C2E;
	Tue, 23 Jan 2024 00:18:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969123; cv=none; b=OUI4KYtMYq9FiIGmVGpi6wDPXUrWm752JRPCLUhw1lMJHQphaN6eARW7ews91mX17ug2qsd0vfzhoiJrT+ncBeesnSzFeTYKtZ6l+BvTT+aXpcfWw3qgzHDz/RHRCnx8fwmUGsdK5CY51ul4kBBDt/eopqE3wzmopHnSdBBVtfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969123; c=relaxed/simple;
	bh=LzzhqjPC3S7bdbe65xfMI0/1AUJcoETRzQpPtdRPIVw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SaIkF8soDU3pD/7UkebwwFCYL/2qUtUneYezW+UCU6fIiD2bgmwukaMVpkcpwiCS35RFgh49YGhMFqrrlMF4eQMCgtAoNyjjjdkGiD/HSJ+95WZu1p/ZCh0jiETdHna2t76yao+M7zjsWjEIeTqTJExcI2hKN2s/S2TuefuPpEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ug6G/GTd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ug6G/GTd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACBEDC433F1;
	Tue, 23 Jan 2024 00:18:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969123;
	bh=LzzhqjPC3S7bdbe65xfMI0/1AUJcoETRzQpPtdRPIVw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ug6G/GTdUshIAH4FypPF+GyeNZcnYU5BFjWOFp5jGYM8H3lXVVohmaA1buLnW12UY
	 T73yfSfi+aCcmg7dok/JN2XI/kHyp83Q+JKSUD0zp8eRsBFaha/AjHQrqLDf7wM+En
	 5oLlKvS9VdwSVTeo7KIveshFcbRaGFFK3zl3Ex7M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 027/641] spi: cadence-quadspi: add missing clk_disable_unprepare() in cqspi_probe()
Date: Mon, 22 Jan 2024 15:48:51 -0800
Message-ID: <20240122235818.943594629@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 5cb475174cce1bfedf1025b6e235e2c43d81144f ]

cqspi_jh7110_clk_init() is called after clk_prepare_enable(cqspi->clk),
if it fails, it should goto label 'probe_reset_failed' to disable
cqspi->clk.

In the error path after calling cqspi_jh7110_clk_init(),
cqspi_jh7110_disable_clk() need be called.

Fixes: 33f1ef6d4eb6 ("spi: cadence-quadspi: Add clock configuration for StarFive JH7110 QSPI")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20231129081147.628004-1-yangyingliang@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-cadence-quadspi.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-cadence-quadspi.c b/drivers/spi/spi-cadence-quadspi.c
index 3d7bf62da11c..f94e0d370d46 100644
--- a/drivers/spi/spi-cadence-quadspi.c
+++ b/drivers/spi/spi-cadence-quadspi.c
@@ -1840,7 +1840,7 @@ static int cqspi_probe(struct platform_device *pdev)
 		if (ddata->jh7110_clk_init) {
 			ret = cqspi_jh7110_clk_init(pdev, cqspi);
 			if (ret)
-				goto probe_clk_failed;
+				goto probe_reset_failed;
 		}
 
 		if (of_device_is_compatible(pdev->dev.of_node,
@@ -1901,6 +1901,8 @@ static int cqspi_probe(struct platform_device *pdev)
 probe_setup_failed:
 	cqspi_controller_enable(cqspi, 0);
 probe_reset_failed:
+	if (cqspi->is_jh7110)
+		cqspi_jh7110_disable_clk(pdev, cqspi);
 	clk_disable_unprepare(cqspi->clk);
 probe_clk_failed:
 	return ret;
-- 
2.43.0



