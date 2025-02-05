Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D66C1509BD;
	Wed,  5 Feb 2025 14:01:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764087; cv=none; b=ohQywbVayrVuRK+TsVaKc5OPD7WCh1byy1LhiTuunCKMxt+x42Qtb84prEHFsufYd/TDPC3xXQnSyhzfLQMipFb3W9/oo7c52fAyi428P9lQy34E8c7hV0J3Z7i1LHpS8pSh4xe9GqNsbhr19lGcKDj+3WcEuWyfot3m0frqLNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764087; c=relaxed/simple;
	bh=he4t0Afv21ZEif7DCI9NVYkamlkAM61z8Vip2XECKGM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PrxTlWfP/RYgbfwL6Ldtt7tuk9AXeg2AUQgLmdQVY3dE0bt3plmneQdiFTxa1NKbsT3gbO8t4YYcqAkLvTr4yO+hwg+1vY0u7QhYoyuU1SErPMCyh8MHJE655HkWETZUZkDFYTgx/Mj9R0pVnPpF8fmfS2KbRkxk5o9UP9lpoJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ripBiHiN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ripBiHiN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA3FFC4CED1;
	Wed,  5 Feb 2025 14:01:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764086;
	bh=he4t0Afv21ZEif7DCI9NVYkamlkAM61z8Vip2XECKGM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ripBiHiNYzAGMM2TvAWeK60ZAbVUTFVpCyUajbEpQxVRCyxr4LMobK+hWnVNV/4ym
	 +lB1gBrF4dMB0TqRiLbzG81418Uu3TuJv2AVr5fci5Kx4V+O2AjfEqgEi/Uh/Iv9OJ
	 OPGg5srqEzOlKsX1aPOKihIB+4DBqgme4PfDCOH8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mingwei Zheng <zmw12306@gmail.com>,
	Jiasheng Jiang <jiashengjiangcool@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 088/590] spi: zynq-qspi: Add check for clk_enable()
Date: Wed,  5 Feb 2025 14:37:23 +0100
Message-ID: <20250205134458.618603589@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Mingwei Zheng <zmw12306@gmail.com>

[ Upstream commit 8332e667099712e05ec87ba2058af394b51ebdc9 ]

Add check for the return value of clk_enable() to catch the potential
error.

Fixes: c618a90dcaf3 ("spi: zynq-qspi: Drop GPIO header")
Signed-off-by: Mingwei Zheng <zmw12306@gmail.com>
Signed-off-by: Jiasheng Jiang <jiashengjiangcool@gmail.com>
Link: https://patch.msgid.link/20241207015206.3689364-1-zmw12306@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-zynq-qspi.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi-zynq-qspi.c b/drivers/spi/spi-zynq-qspi.c
index b67455bda972b..de4c182474329 100644
--- a/drivers/spi/spi-zynq-qspi.c
+++ b/drivers/spi/spi-zynq-qspi.c
@@ -379,12 +379,21 @@ static int zynq_qspi_setup_op(struct spi_device *spi)
 {
 	struct spi_controller *ctlr = spi->controller;
 	struct zynq_qspi *qspi = spi_controller_get_devdata(ctlr);
+	int ret;
 
 	if (ctlr->busy)
 		return -EBUSY;
 
-	clk_enable(qspi->refclk);
-	clk_enable(qspi->pclk);
+	ret = clk_enable(qspi->refclk);
+	if (ret)
+		return ret;
+
+	ret = clk_enable(qspi->pclk);
+	if (ret) {
+		clk_disable(qspi->refclk);
+		return ret;
+	}
+
 	zynq_qspi_write(qspi, ZYNQ_QSPI_ENABLE_OFFSET,
 			ZYNQ_QSPI_ENABLE_ENABLE_MASK);
 
-- 
2.39.5



